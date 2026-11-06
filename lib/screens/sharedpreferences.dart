import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


 class MyApp extends StatefulWidget {
  const MyApp({
    super.key
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool tungiRejim = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  // Saqlangan rejimni o'qish
  Future<void> loadTheme() async {
    final holat = await SharedPreferences.getInstance();

    setState(() {
      tungiRejim = holat.getBool('darkMode') ?? false;
    });
  }

  // Rejimni almashtirish va saqlash
  Future<void> rejimAlmashtir() async {
    final prefs = await SharedPreferences.getInstance();

    final newMode = !tungiRejim;

    await prefs.setBool('darkMode', newMode);

    setState(() {
      tungiRejim = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),

      themeMode:
          tungiRejim ? ThemeMode.dark : ThemeMode.light,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mavzu sozlamasi'),
        ),
        body: Center(
          child: ElevatedButton.icon(
            onPressed: rejimAlmashtir,
            icon: Icon(
              tungiRejim
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            label: Text(
              tungiRejim
                  ? 'Light Mode'
                  : 'Dark Mode',
            ),
          ),
        ),
      ),
    );
  }
}