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
    print('present in chatroom service');
    print(targetUserEmail);
    try {
      print('in try block');
      var firebaseUser = _auth.currentUser?.uid;
      if (firebaseUser == null) {
        print('user is null');
        return left('User not logged in');
      }

      // Fetch target user by email
      var targetUserSnapshot = await _firestore
          .collection('Users')
          .where('email', isEqualTo: targetUserEmail)
          .limit(1)
          .get();

      if (targetUserSnapshot.docs.isEmpty) {
        print('No target user found');
        return left('No target user found');
      }

      var targetUser = targetUserSnapshot.docs.first.id;
      print('target user id $targetUser');

      // Check if the chatroom collection exists
      var chatroomCollectionSnapshot =
          await _firestore.collection('chatroom').get();
      print('all chatRooms ${chatroomCollectionSnapshot.docs.length}');

      if (chatroomCollectionSnapshot.docs.isEmpty) {
        print('No chatrooms exist, so create a new one');
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
      print('chatRooms where user present ${userChatRooms.docs.length}');

      if ((userChatRooms.docs.isEmpty)) {
        // No matching chatroom exists
        ChatRoomModel chatRoomModel = ChatRoomModel(
          chatRoomId: uuid.v1(),
          participants: {
            firebaseUser: true,
            targetUser: true,
          },
        );
        print('creating chatrome $chatRoomModel');
        await _firestore
            .collection('chatroom')
            .doc(chatRoomModel.chatRoomId)
            .set({
          'chatRoomId': chatRoomModel.chatRoomId,
          'participants': chatRoomModel.participants,
        });

        return right(chatRoomModel);
      }
      print('Now move forward');
      // Look for an existing chatroom with both participants
      /*var returnedData = userChatRooms.docs.firstWhere(
            (doc) => doc['participants'][targetUser] == true);

*/
      var returnedData = userChatRooms.docs
          .where(
            (doc) => doc['participants'][targetUser] == true,
          )
          .toList(); // Return null if no match is found

      print('pass from the returned data');

      if (returnedData.isNotEmpty) {
        print('Chatroom already exists');
        var chatRoomData = returnedData.first.data();
        ChatRoomModel existingChatRoom = ChatRoomModel.fromMap(chatRoomData);
        return right(existingChatRoom);
      } else {
        // No matching chatroom, create a new one
        print('No chat found');
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
    //List<ChatRoomModel> chatroomList = [];
    /*var chatroomListSnapshot =  _firestore.collection('chatroom').where('participants.${_auth.currentUser!.uid}', isEqualTo: true)
        .get();*/
    var data = _firestore
        .collection('chatroom')
        .where('participants.${_auth.currentUser!.uid}', isEqualTo: true)
        .snapshots()
        .map((event) => event.docs
            .map((doc) => ChatRoomModel.fromMap(doc.data()))
            .toList());
    return data;
    /*var listOfChtaroom = chatroomListSnapshot.then((value) => value.docs.map((e) => e.data()));
    //var listOfChtaroom = chatroomListSnapshot.docs.map((e) => e.data());//then((value) => value.docs.map((e) => e.data()));

    for(Map<String,dynamic>e in listOfChtaroom){
      chatroomList.add(ChatRoomModel.fromMap(e));
      print('ppppppppppppppppppppppppppppppppppppppppppppppppppppppppp');

    }

    print(*/ /*chatroomList[0].chatRoomId*/ /*'');*/
  }

  Future<Either<String, ChatBoardModel>> fetchChatGPTResponse(
      ChatBoardModel userMessage) async {
    print(userMessage);
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
        print('mydata $mydata');
        ChatBoardModel responseData =
            ChatBoardModel(Content: mydata, role: 'bot');
        return right(responseData);
      } else {
        ChatBoardModel errorData = ChatBoardModel(
            Content: 'Error While fetching Response', role: 'bot');
        return right(errorData);
      }
    } catch (e) {
      print('Some error occure');
      return left('error while fetching response $e');
    }
  }
}
