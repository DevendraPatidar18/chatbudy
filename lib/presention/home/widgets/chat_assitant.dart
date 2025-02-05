import 'package:chatbudy/comman/helper/navigator/app_navigator.dart';
import 'package:chatbudy/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chatbot/bloc/get_response_cubit.dart';
import '../../chatbot/pages/chat_screeen.dart';

class ChatAssistant extends StatelessWidget {
  const ChatAssistant();

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.only(top: 30,left: 4,right: 4,),
      child: Card(
        elevation: 8,
        color: Colors.deepPurple[200],
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => GetResponseCubit(),
                  child: ChatScreen(),
                ),
              ),
            );
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 14),
          leading: CircleAvatar(
            radius: 22,
              backgroundImage:  AssetImage("assets/images/chatbot_avatar.png",) as ImageProvider,),
            title: Text("Assistant"),
        ),
      ),

    );
  }
}
