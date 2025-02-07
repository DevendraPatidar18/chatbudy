import 'package:chatbudy/comman/helper/navigator/app_navigator.dart';
import 'package:chatbudy/core/theme/app_colors.dart';
import 'package:chatbudy/presention/home/widgets/chat_assitant.dart';
import 'package:chatbudy/presention/home/widgets/chat_list.dart';
import 'package:chatbudy/presention/home/widgets/header.dart';
import 'package:chatbudy/presention/search/pages/search_chat.dart';
import 'package:flutter/material.dart';
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton:  FloatingActionButton(
        onPressed: (){
          AppNavigator.push(context, SearchChat());
        },
        child: Icon(Icons.search),
        backgroundColor: AppColors.primary,),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            ChatAssistant(),
            ChatList()
        
        
          ],
        ),
      )
    );
  }
}
