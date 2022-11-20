import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/auth/providers/is_logged_in_provider.dart';
import 'package:instantgram/state/providers/is_loading_provider.dart';
import 'package:instantgram/views/components/constants/loading/loading_screen.dart';
import 'package:instantgram/views/login/login_view.dart';
import 'package:instantgram/views/main/main_view.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instantgram',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey,
      ),
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Consumer(
        builder: (_, ref, child) {
          // Displaying loading screen
          ref.listen<bool>(
            isLoadingProvider,
            (previous, isLoading) {
              if (isLoading == true) {
                LoadingScreen.instance().show(context: _);
              } else {
                LoadingScreen.instance().hide();
              }
            },
          );

          final isLoggedIn = ref.watch(isLoggedInProvider);
          if (isLoggedIn) {
            return const MainView();
          } else {
            LoadingScreen.instance().show(context: context);

            return const LoginView();
          }
        },
      ),
    );
  }
}
