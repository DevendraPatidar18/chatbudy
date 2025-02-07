import 'dart:async';

import 'package:chatbudy/comman/helper/navigator/app_navigator.dart';
import 'package:chatbudy/data/search_chat/models/chat_room_model.dart';
import 'package:chatbudy/domain/auth/entity/entity.dart';
import 'package:chatbudy/presention/chat_room/pages/chat_room.dart';
import 'package:chatbudy/presention/home/bloc/Get_recent_chat_cubit.dart';
import 'package:chatbudy/presention/home/bloc/Get_recent_chat_state.dart';
import 'package:chatbudy/presention/home/bloc/user_info_diaplay_state.dart';
import 'package:chatbudy/presention/home/bloc/user_info_display_cubit.dart';
import 'package:chatbudy/presention/search/bloc/Search_State_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatList extends StatelessWidget {
  ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetRecentChatCubit()..getTargetUserData(),
        ),
        BlocProvider(
          create: (context) => UserInfoDisplayCubit()..displayUserInfo(),
        ),
        BlocProvider(
          create: (context) => SearchStateCubit(),
        )
      ],
      child: BlocBuilder<GetRecentChatCubit, GetRecentChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ChatLoadedFaild) {
            return Center(child: Text("Some Error Occurred"));
          }
          if (state is Chatloaded) {
            print(state.listOfChatRooms);
            return ChatListView(chatRooms: state.listOfChatRooms);
          } else {
            return Center(child: Text('Error'));
          }
        },
      ),
    );
  }
}

class ChatListView extends StatelessWidget {
  final List<ChatRoomModel> chatRooms;
  ChatListView({required this.chatRooms});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoDisplayCubit, UserInfoDisplayState>(
      builder: (context, userInfoState) {
        if (userInfoState is UserInfoLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (userInfoState is UserInfoLoaded) {
          final currentUserId = userInfoState.userEntity.uid;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.separated(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                final participants = chatRooms[index].participants;
                final participantKeys =
                    ((participants.keys.toList()..remove(currentUserId)));
                String targetUserId = participantKeys.first;

                return FutureBuilder<UserEntity?>(
                    future: _getParticipants(context, targetUserId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                          leading: CircularProgressIndicator(),
                          title: Text("Loading..."),
                        );
                      } else if (snapshot.hasError ) {

                        return ListTile(
                          leading: Icon(Icons.error, color: Colors.red),
                          title: Text('error'),
                        );

                      } else if (snapshot.hasData) {
                        final user = snapshot.data!;
                        return ListTile(
                          onTap: () {
                            AppNavigator.push(
                                context,
                                ChatRoom(
                                  chatRoomModel: chatRooms[index],
                                  currentUser: userInfoState.userEntity,
                                  targetUser: user,
                                ));
                          },
                          leading: CircleAvatar(
                            backgroundImage: (user.profileImageUri == " " ||
                                user.profileImageUri.isEmpty)
                                ? AssetImage("assets/images/default_user_profile_image.png") as ImageProvider
                                : NetworkImage(user.profileImageUri) as ImageProvider,),
                          title: Text(user.name),
                        );
                      } else {
                        return ListTile(
                          title: Text("No data"),
                        );
                      }
                    });
              },
              separatorBuilder: (context, index) =>
                  Divider(thickness: 1, height: 4),
            ),
          );
        }
        if (userInfoState is LoadUserInfoFailure) {
          return Center(child: Text('Failed to load user info'));
        }
        return Center(child: Text('Unexpected Error'));
      },
    );
  }

  Future<UserEntity?> _getParticipants(
      BuildContext context, String participantKeys) async {
    var data =
        await context.read<SearchStateCubit>().searchUserByUid(participantKeys);
    print(data.name);
    return data;
  }
}
