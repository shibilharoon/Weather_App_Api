import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_final/services/location_provider.dart';
import 'package:weather_final/services/weather_service_provider.dart';
import 'package:weather_final/view/home_page.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(
          create: (context) => WeatherServiceProvider(),
        )
      ],
      child: MaterialApp(
        title: "weather app",
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        )),
      ),
    );
  }
}
