import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/auth/providers/auth_state_provider.dart';
import 'package:instantgram/state/auth/providers/is_logged_in_provider.dart';
import 'package:instantgram/views/components/constants/loading/loading_screen.dart';
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
          final isLoggedIn = ref.watch(isLoggedInProvider);
          if (isLoggedIn) {
            return const MainView();
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LoadingScreen.instance().show(context: context, text: 'Hello World');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Main'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            await ref.read(authStateProvider.notifier).logOut();
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              await ref.read(authStateProvider.notifier).loginWithGoogle();
            },
            child: const Text('Sign in with Google'),
          )
        ],
      ),
    );
  }
}
