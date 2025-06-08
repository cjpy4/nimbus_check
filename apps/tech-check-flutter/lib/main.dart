import 'package:nimbus_check/pages/search_page.dart';
import 'package:nimbus_check/pages/login_page.dart';
import 'package:nimbus_check/pages/results_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nimbus_check/utils/util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    // Wrap the entire app with ProviderScope to enable Riverpod
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieves the brightness of the platform
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Nunito Sans", "Nunito");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'SCW Tech Check',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const MyHomePage(title: 'Nimbus Check'),
      routes: {
        '/results': (context) => ResultsPage(),
        '/search': (context) => SearchPage(),
      },
    );
  }
}

// Simple provider to expose the auth state
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return Scaffold(
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
        data: (user) => user != null ? const SearchPage() : const LoginScreen(),
      ),
      floatingActionButton: authState.maybeWhen(
        data: (user) => user != null
            ? FloatingActionButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                tooltip: 'Logout',
                child: const Icon(Icons.logout),
              )
            : null,
        orElse: () => null,
      ),
    );
  }
}