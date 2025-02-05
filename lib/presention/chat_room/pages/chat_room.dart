import 'package:chatbudy/core/theme/app_colors.dart';
import 'package:chatbudy/core/usecase/MessageUseCase.dart';
import 'package:chatbudy/domain/auth/entity/entity.dart';
import 'package:chatbudy/domain/usecases/send_message_usecase.dart';
import 'package:chatbudy/main.dart';
import 'package:chatbudy/presention/chat_room/bloc/getmessages_cubit.dart';
import 'package:chatbudy/presention/chat_room/bloc/getmessages_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/search_chat/models/chat_room_model.dart';
import '../../../data/search_chat/models/message_model.dart';
class ChatRoom extends StatelessWidget {
  final UserEntity targetUser;
  final UserEntity currentUser;
  final ChatRoomModel chatRoomModel;
  ChatRoom({super.key,
    required this.targetUser,
    required this.currentUser,
    required this.chatRoomModel
  });
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondBackground,
        automaticallyImplyLeading: true,
        title:Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             CircleAvatar(
              backgroundImage: (targetUser.profileImageUri == " " ||
                  targetUser.profileImageUri.isEmpty)
                  ? AssetImage("assets/images/default_user_profile_image.png") as ImageProvider
                  : NetworkImage(targetUser.profileImageUri) as ImageProvider,),
            const SizedBox(width: 10),
            Text(targetUser.name),
          ],
        ),

      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocProvider(
                create: (context) => GetMessagesCubit()..subscribeToMessages(chatRoomModel.chatRoomId),
                child: BlocBuilder<GetMessagesCubit,GetMessagesState>(
                  builder: (context,state){
                    if(state is MessagesLoading){
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary,));
                    }else if(state is MessagesLoadingFaild){
                      return Center(child: Text(state.errorMessage));
                    }else if(state is MessagesLoaded) {
                      return ListView.separated(
                        padding: EdgeInsets.all(12.0),
                        separatorBuilder: (context , index){
                          return const SizedBox(height: 8);
                        },
                          itemCount: state.messagesSnapshots.length,
                          itemBuilder: (context, index) {
                            final message = state.messagesSnapshots[index];
                            return Column(

                              crossAxisAlignment: (message.sender == currentUser.name? CrossAxisAlignment.end :
                              CrossAxisAlignment.start),
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  vertical: 10
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (message.sender == currentUser.name? AppColors.primary : AppColors.secondBackground)
                                  ),
                                  child: Text(message.text!),
                                ),
                              ],
                            );
                          });
                    }else{
                      return const Center(child:  Text("Say hii"));
                    }
                    }

                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 12
              ),
              child:  Row(
                children: [
                  Flexible(
                      child: TextField(
                        controller: messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Enter Message'
                        ),
                      ),
                  ),
                  IconButton(onPressed: (){
                    MessageModel newMessage = MessageModel(
                      text: messageController.text,
                      createdon: DateTime.now(),
                      messageid: uuid.v1(),
                      sender: currentUser.name,
                      seen: false,
                    );
                    sendMessage(chatRoomModel.chatRoomId, newMessage);
                    messageController.clear();
                  }, icon: const  Icon(Icons.send))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  void sendMessage(String chatroomId, MessageModel newMessage){
    MessageUseCase useCase = SendMessageUseCase();
    useCase.call(params: chatroomId,params1: newMessage);
  }
}
