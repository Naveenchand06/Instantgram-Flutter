import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/auth/providers/auth_state_provider.dart';
import 'package:instantgram/views/components/constants/strings.dart';
import 'package:instantgram/views/components/dialogs/alert_dialog_model.dart';
import 'package:instantgram/views/components/dialogs/logout_dialog.dart';
import 'package:instantgram/views/tabs/user_posts/user_posts_view.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.appName),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.film),
            ),
            IconButton(
              onPressed: () {},
              icon: const FaIcon(Icons.add_photo_alternate_outlined),
            ),
            IconButton(
              onPressed: () async {
                final shouldLogout = await const LogoutDialog()
                    .present(context)
                    .then((value) => value ?? false);
                log('POP up -> $shouldLogout');
                if (shouldLogout) {
                  await ref.read(authStateProvider.notifier).logOut();
                }
              },
              icon: const FaIcon(Icons.logout),
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.search),
              ),
              Tab(
                icon: Icon(Icons.home),
              )
            ],
          ),
        ),
        body: const TabBarView(children: [
          UserPostsView(),
          UserPostsView(),
          UserPostsView(),
        ]),
      ),
    );
  }
}
