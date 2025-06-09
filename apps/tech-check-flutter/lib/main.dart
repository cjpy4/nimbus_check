import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
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
    const ProviderScope(child: MyApp()),
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
      title: 'Nimbus Check',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: MyHomePage(title: 'Nimbus Check'),
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
  MyHomePage({super.key, required this.title});
  final _advancedDrawerController = AdvancedDrawerController();
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(top: 24.0, bottom: 64.0),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/flutter_logo.png'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text('Profile'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.favorite),
                  title: Text('Favourites'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Terms of Service | Privacy Policy'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        body: authState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, stackTrace) =>
                  Center(child: Text('Error: ${error.toString()}')),
          data:
              (user) => user != null ? const SearchPage() : const LoginScreen(),
        ),
        appBar: AppBar(
            leading:
              IconButton(
                onPressed: _handleMenuButtonPressed,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (_, value, __) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      child: Semantics(
                        label: 'Menu',
                        onTapHint: 'expand drawer',
                        child: Icon(
                          value.visible ? Icons.clear : Icons.menu,
                          key: ValueKey<bool>(value.visible),
                        ),
                      ),
                    );
                  },
                ),
              ),
        ),
        floatingActionButton: authState.maybeWhen(
          data:
              (user) =>
                  user != null
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
        // Optional: Position the FAB properly with the bottom app bar
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
   void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
