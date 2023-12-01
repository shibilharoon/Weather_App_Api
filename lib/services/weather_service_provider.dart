import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_final/models/weather_response_model.dart';
import 'package:weather_final/secrets/api.dart';

class WeatherServiceProvider extends ChangeNotifier {
  WeatherModel? weather;

  bool isloading = false;

  String error = "";

  //https://api.openweathermap.org/data/2.5/weather?q=dubai&appid=126bd36cccd70a186becc6a7367fe968&units=metric

  Future<void> fetchWeatherDataByCity(String? city) async {
    isloading = true;
    error = "";

    try {
      final apiUrl =
          "${APIEndPoints().cityUrl}${city}&appid=${APIEndPoints().apikey}${APIEndPoints().unit}";
      print(apiUrl);
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print(data);
        weather = WeatherModel.fromJson(data);
        print(weather!.name);

        notifyListeners();
      } else {
        error = "Failed to load data";
      }
    } catch (e) {
      error = "Failed to load data $e";
    } finally {
      isloading = false;
      notifyListeners();
    }
    notifyListeners();
  }
}
