import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;
const String themeKey = "isDarkMode";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  final isDark = sharedPreferences.getBool(themeKey) ?? false;

  runApp(MyApp(isDarkMode: isDark));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;
  const MyApp({super.key, required this.isDarkMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
      sharedPreferences.setBool(themeKey, isDarkMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CubitCounter(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: MyHomeScreen(
          isDarkMode: isDarkMode,
          onToggleTheme: toggleTheme,
        ),
      ),
    );
  }
}

class MyHomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const MyHomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1E2A38) : const Color(0xFFC2DCF2);
    final circleColor = isDark ? const Color(0xFF2F3E55) : const Color(0xFFA8C8FF);
    final textColor = isDark ? Colors.white : const Color(0xFF06268F);
    final iconColor = isDark ? Colors.grey[300] : IslamColors.stoneGrey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF2F3E55) : const Color(0xFFA5C6E1),
        title: Center(
          child: Text(
            "فَذَكِّرْ فَإِنَّ الذِّكْرَىٰ تَنفَعُ الْمُؤْمِنِينَ",
            style: TextStyle(
              color: IslamColors.royalBlue,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          const Icon(Icons.more_horiz_outlined),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: BlocBuilder<CubitCounter, int>(
            builder: (_, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَاللَّهُ أَكْبَرُ",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$state',
                      style: TextStyle(
                        fontSize: 49,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CubitCounter>().increment();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.lightBlueAccent : Colors.blueAccent,
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "🌿 تسبيحة",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => context.read<CubitCounter>().reset(),
                    style: TextButton.styleFrom(
                      foregroundColor: iconColor,
                    ),
                    child: const Icon(Icons.refresh, size: 24),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CubitCounter extends Cubit<int> {
  CubitCounter() : super(sharedPreferences.getInt("counter_key") ?? 0);

  void increment() {
    sharedPreferences.setInt("counter_key", state + 1);
    emit(state + 1);
  }

  void reset() {
    sharedPreferences.setInt("counter_key", 0);
    emit(0);
  }
}

class IslamColors {
  static Color periwinkleBlue = const Color(0xFFB4C4FE);
  static Color softYellow = const Color(0xFFFFF580);
  static Color mintGreen = const Color(0xFFD0F4EA);
  static Color pinkBlush = const Color(0xFFFFC0F5);
  static Color iceBlue = const Color(0xFFF4F7FF);
  static Color royalBlue = const Color(0xFF3B6BB9);
  static Color snowWhite = const Color(0xFFFAFCFC);
  static Color stoneGrey = const Color(0xFF91949B);
  static Color transparent = const Color(0x00000000);
}
