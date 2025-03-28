import 'package:device_check/home_page.dart';
import 'package:device_check/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_check/util.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Retrieves the brightness of the platform
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Nunito Sans", "Nunito");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'SCW Tech Check',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const MyHomePage(title: 'SCW Tech-Check'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return Scaffold(
          body:
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : snapshot.hasData
                  ? HomePage()
                  : const LoginScreen(),
          floatingActionButton:
              snapshot.hasData
                  ? FloatingActionButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    tooltip: 'Logout',
                    child: const Icon(Icons.logout),
                  )
                  : null,
        );
      },
    );
  }
}
