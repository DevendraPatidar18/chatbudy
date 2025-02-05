import 'package:chatbudy/comman/bloc/button/button_state.dart';
import 'package:chatbudy/comman/bloc/button/button_state_cubit.dart';
import 'package:chatbudy/comman/helper/navigator/app_navigator.dart';
import 'package:chatbudy/comman/widgets/appbar/app_bar.dart';
import 'package:chatbudy/comman/widgets/button/basic_reactive_button.dart';
import 'package:chatbudy/core/theme/app_colors.dart';
import 'package:chatbudy/domain/auth/entity/entity.dart';
import 'package:chatbudy/presention/chat_room/bloc/chatroom_state.dart';
import 'package:chatbudy/presention/chat_room/bloc/chatroom_state_cubit.dart';
import 'package:chatbudy/presention/chat_room/pages/chat_room.dart';
import 'package:chatbudy/presention/home/bloc/user_info_diaplay_state.dart';
import 'package:chatbudy/presention/home/bloc/user_info_display_cubit.dart';
import 'package:chatbudy/presention/search/bloc/Search_State_cubit.dart';
import 'package:chatbudy/presention/search/bloc/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/search_chat/models/chat_room_model.dart';
class SearchChat extends StatelessWidget {
  SearchChat({super.key});
  ChatRoomModel? chatRoomModel;
  UserEntity? currentUser;
  final TextEditingController searchTextCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BasicAppbar(
          title: Text('Search'),
        ),
        body: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => ButtonStateCubit()),
              BlocProvider(create: (context) => SearchStateCubit()),
              BlocProvider(create: (context) => UserInfoDisplayCubit()..displayUserInfo()),
              BlocProvider(create: (context) => ChatRoomStateCubit())
            ],
            child: Builder(
              builder: (context) =>
                  BlocListener<ButtonStateCubit, ButtonStates>(
                listener: (context, state) {
                  if (state is ButtonFailureState) {
                    var snackbar = SnackBar(
                      content: Text(state.errorMessage),
                      behavior: SnackBarBehavior.floating,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                },
                child: Builder(
                  builder: (context) =>
                      BlocListener<UserInfoDisplayCubit, UserInfoDisplayState>(
                    listener: (context, state) {
                      if (state is UserInfoLoaded) {
                        currentUser = state.userEntity!;
                      }
                    },
                    child: Builder(
                      builder: (context) => BlocListener<ChatRoomStateCubit,
                          ChatRoomStates>(
                        listener: (context, state) {
                          if(state is ChatRoomLoadFailed){
                            var snackbar = SnackBar(content: Text("Chatroom Model LoadFailed"));
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          }
                          if (state is ChatRoomLoaded) {
                            chatRoomModel = state.chatRoom;
                          }
                        },
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            child: Column(
                              children: [
                                _searchField(context),
                                const SizedBox(height: 40),
                                _searchButton(context),
                                const SizedBox(height: 40),
                                BlocBuilder<SearchStateCubit, SearchState>(
                                  builder: (context, state) {
                                    if (state is SearchStateLoading) {
                                      return const Center(
                                        child: Text('Search Result'),
                                      );
                                    }
                                    if (state is SearchStateLoadedSuccessfull) {
                                      context.read<ChatRoomStateCubit>().getData(state.userEntity.email);
                                      return ListTile(
                                        onTap: () {
                                          AppNavigator.push(
                                              context,
                                              ChatRoom(
                                                currentUser: currentUser!,
                                                targetUser: state.userEntity,
                                                chatRoomModel: chatRoomModel!,
                                              ));
                                        },
                                        leading: CircleAvatar(
                                          backgroundColor: AppColors.primary,
                                          child: Icon(Icons.account_circle),
                                        ),
                                        title: Text(state.userEntity.name??
                                            ''),
                                        subtitle: Text(state.userEntity.email ?? ''),
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }

  Widget _searchField(BuildContext context) {
    return TextField(
      controller: searchTextCon,
      decoration: const InputDecoration(
        hintText: 'Search by email',
      ),
    );
  }

  Widget _searchButton(BuildContext context) {
    return Builder(
      builder: (context) {
        return BasicReactiveButton(
          onPressed: () {
            var searchText = searchTextCon.text;
            context.read<SearchStateCubit>().searchUser(searchText);
          },
          title: 'Continue',
        );
      },
    );
  }
}
