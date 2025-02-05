import 'package:chatbudy/data/auth/models/chatboard_model.dart';
import 'package:chatbudy/presention/chatbot/bloc/get_response_cubit.dart';
import 'package:chatbudy/presention/chatbot/bloc/get_response_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../chat_room/bloc/getmessages_cubit.dart';
import '../../chat_room/bloc/getmessages_state.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen();

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<ChatBoardModel> chatList = [];
    BuildContext c = context;
    var response;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondBackground,
        automaticallyImplyLeading: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(
                "assets/images/chatbot_avatar.png",
              ) as ImageProvider,
            ),
            const SizedBox(width: 10),
            Text('Assistant'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<GetResponseCubit, GptResponseState>(
                builder: (context, state) {
                  if (state is ResponseLoading) {
                    return const Center(
                        child: Text('Hello, 🙋‍♂️ How Can I Help You',style: TextStyle(color: Colors.white,fontSize: 18),));
                  } else if (state is ResponseFailed) {
                    return Center(child: Text('Error:}'));
                  } else if (state is ResponseLoaded) {
                    final message = state.responseList;
                    chatList.addAll(message.map((e) => e));
                    return ListView.separated(
                      itemCount: chatList.length,
                      padding: EdgeInsets.all(12.0),
                      itemBuilder: (context, index) {

                        return  Column(
                          crossAxisAlignment: (chatList[index].role == 'user'? CrossAxisAlignment.end :
                          CrossAxisAlignment.start),
                          children: [
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (chatList[index].role == 'user'? AppColors.primary : AppColors.secondBackground),
                                ),
                                child: Text(chatList[index].Content.replaceAll('**', ':- ')),
                              ),
                          ],
                        );
                      },
                        separatorBuilder: (context , index){
                      return const SizedBox(height: 8);

                      },
                    );
                  }
                  return Center(child: Text('Say Hi 🙋'));
                },
              ),
              /*FutureBuilder<ChatBoardModel>(
                    future: chatMessageList.last,
                    builder: (context,snapshot){
                      print(snapshot.data);
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary,));
                  }else if(snapshot.hasError){
                    return Center(child: Text('error occur'));
                  }else if(snapshot.hasData){
                    return ListView.separated(
                        padding: EdgeInsets.all(12.0),
                        separatorBuilder: (context , index){
                          return const SizedBox(height: 8);
                        },
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          final message = snapshot.data;
                          print(('Response $message'));
                          return Container(

                            //mainAxisAlignment: (message.sender == currentUser.name? MainAxisAlignment.end :
                            //MainAxisAlignment.start),

                            child:  Container(
                              width: 80,
                              margin:  const EdgeInsets.symmetric(vertical: 2),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                //color: (message.sender == currentUser.name? AppColors.primary : AppColors.secondBackground)
                              ),
                              child: Text(message!.Content.replaceAll("**", ':- ')),
                            ),

                          );
                        });

                  }
                  return Center(child: Text('Say Hii 🙋 '),);
                    }),*/
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      decoration:
                          const InputDecoration(hintText: 'Enter Message'),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        ChatBoardModel message =  await ChatBoardModel(
                            Content: messageController.text.trim(),
                            role: 'user');
                        messageController.clear();
                        response = await context.read<GetResponseCubit>()
                          ..getResponse(message);
                        print(response);
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
