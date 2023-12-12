import 'package:flutter/material.dart';
import 'package:gif_searcher/gif_search/presentation/search_page.dart';
import 'package:gif_searcher/shared/presentation/repository_manager_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repositoryManager = await RepositoryManagerInitializer.initialize(
    const MyApp(),
  );

  runApp(
    repositoryManager,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SearchPage(),
    );
  }
}
