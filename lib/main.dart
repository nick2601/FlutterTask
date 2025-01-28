import 'package:assignment/presentation/views/user_list_page.dart';
import 'package:flutter/material.dart';
import 'di/injection.dart' as di;



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initServiceLocator();  // your DI setup
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserListPage(),
    );
  }
}
