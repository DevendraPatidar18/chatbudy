import 'package:chatbudy/data/auth/models/chatboard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ChatRoomService {
  Future<Either<String, ChatRoomModel>> getChatRoom(String targetUserEmail);
  Future<Either> sendMessages(String chatroomId, MessageModel messageModel);
  Stream<List<MessageModel>> getMessages(String chatRoomId);
  Stream<List<ChatRoomModel>> getRecentChatroom();
  Future<Either> fetchChatGPTResponse(ChatBoardModel userMessage);
}

class ChatRoomServiceImp extends ChatRoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<Either<String, ChatRoomModel>> getChatRoom(
      String targetUserEmail) async {
    try {
      var firebaseUser = _auth.currentUser?.uid;
      if (firebaseUser == null) {
        return left('User not logged in');
      }

      // Fetch target user by email
      var targetUserSnapshot = await _firestore
          .collection('Users')
          .where('email', isEqualTo: targetUserEmail)
          .limit(1)
          .get();

      if (targetUserSnapshot.docs.isEmpty) {
        return left('No target user found');
      }

      var targetUser = targetUserSnapshot.docs.first.id;

      // Check if the chatroom collection exists
      var chatroomCollectionSnapshot =
          await _firestore.collection('chatroom').get();

      if (chatroomCollectionSnapshot.docs.isEmpty) {
        ChatRoomModel chatRoomModel = ChatRoomModel(
          chatRoomId: uuid.v1(),
          participants: {
            firebaseUser: true,
            targetUser: true,
          },
        );

        await _firestore
            .collection('chatroom')
            .doc(chatRoomModel.chatRoomId)
            .set({
          'chatRoomId': chatRoomModel.chatRoomId,
          'participants': chatRoomModel.participants,
        });

        return right(chatRoomModel);
      }

      // Fetch user's chatrooms
      var userChatRooms = await _firestore
          .collection('chatroom')
          .where(
            'participants.${firebaseUser}',
            isEqualTo: true,
          )
          .get();

      if ((userChatRooms.docs.isEmpty)) {
        // No matching chatroom exists
        ChatRoomModel chatRoomModel = ChatRoomModel(
          chatRoomId: uuid.v1(),
          participants: {
            firebaseUser: true,
            targetUser: true,
          },
        );

        await _firestore
            .collection('chatroom')
            .doc(chatRoomModel.chatRoomId)
            .set({
          'chatRoomId': chatRoomModel.chatRoomId,
          'participants': chatRoomModel.participants,
        });

        return right(chatRoomModel);
      }

      // Look for an existing chatroom with both participants

      var returnedData = userChatRooms.docs
          .where(
            (doc) => doc['participants'][targetUser] == true,
          )
          .toList(); // Return null if no match is found



      if (returnedData.isNotEmpty) {
        var chatRoomData = returnedData.first.data();
        ChatRoomModel existingChatRoom = ChatRoomModel.fromMap(chatRoomData);
        return right(existingChatRoom);
      } else {
        // No matching chatroom, create a new one
        ChatRoomModel chatRoomModel = ChatRoomModel(
          chatRoomId: uuid.v1(),
          participants: {
            firebaseUser: true,
            targetUser: true,
          },
        );

        await _firestore
            .collection('chatroom')
            .doc(chatRoomModel.chatRoomId)
            .set({
          'chatRoomId': chatRoomModel.chatRoomId,
          'participants': chatRoomModel.participants,
        });

        return right(chatRoomModel);
      }
    } catch (e) {
      return left('Please try again');
    }
  }

  final Uuid uuid = const Uuid();
  @override
  Future<Either> sendMessages(
      String chatroomId, MessageModel messageModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(chatroomId)
          .collection('messages')
          .doc(messageModel.messageid)
          .set(
            messageModel.toMap(),
          );

      return right('Message send Succesful');
    } catch (e) {
      return left('Some error occurred');
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    var data = _firestore
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('createdon')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data()))
            .toList());
    return data;
  }

  Stream<List<ChatRoomModel>> getRecentChatroom() {
    var data = _firestore
        .collection('chatroom')
        .where('participants.${_auth.currentUser!.uid}', isEqualTo: true)
        .snapshots()
        .map((event) => event.docs
            .map((doc) => ChatRoomModel.fromMap(doc.data()))
            .toList());
    return data;

  }

  Future<Either<String, ChatBoardModel>> fetchChatGPTResponse(
      ChatBoardModel userMessage) async {

    try {
      print(dotenv.env['GEMINI_API_KEY']);
      final api_Key = dotenv.env['GEMINI_API_KEY'];
      const api_Url =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";
      final response = await http.post(
        Uri.parse("$api_Url?key=$api_Key"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": userMessage.Content}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        var mydata = data["candidates"][0]["content"]["parts"][0]["text"] ??
            "No response";
        ChatBoardModel responseData =
            ChatBoardModel(Content: mydata, role: 'bot');
        return right(responseData);
      } else {
        ChatBoardModel errorData = ChatBoardModel(
            Content: 'Error While fetching Response', role: 'bot');
        return right(errorData);
      }
    } catch (e) {
      return left('error while fetching response $e');
    }
  }
}
