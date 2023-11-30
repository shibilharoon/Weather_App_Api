import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_final/models/weather_response_model.dart';
import 'package:weather_final/services/location_provider.dart';
import 'package:weather_final/services/weather_service_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determinePosition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var city = locationProvider.currentLocationName!.locality;
        if (city != null) {
          Provider.of<WeatherServiceProvider>(context, listen: false)
              .fetchWeatherDataByCity(city);
        }
      }
    });
  }

  TextEditingController cityController = TextEditingController();
  //var city;
  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final weatherProvider =
        Provider.of<WeatherServiceProvider>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    int sunriseTimestamp = weatherProvider.weather?.sys?.sunrise ?? 0;
    int sunsetTimestamp = weatherProvider.weather?.sys?.sunset ?? 0;

    DateTime sunriseDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000);
    DateTime sunsetDateTime =
        DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000);

    String formattedSunrise = DateFormat.Hm().format(sunriseDateTime);
    String formattedSunset = DateFormat.Hm().format(sunsetDateTime);

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
                child: TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(
                      labelText: "Search",
                      labelStyle:
                          TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            weatherProvider
                                .fetchWeatherDataByCity(cityController.text);
                          },
                          icon: Icon(Icons.search)),
                      // prefixIcon: Icon(Icons.search),
                      // prefixIconColor: const Color.fromARGB(255, 0, 0, 0),
                      filled: true,
                      fillColor: Color.fromARGB(181, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                ),
              ),
              Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) {
                String? locationCity;
                if (locationProvider.currentLocationName != null) {
                  locationCity =
                      locationProvider.currentLocationName!.locality ??
                          'no data';
                } else {
                  locationCity = "Unknown Location";
                }
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 80, top: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                ),
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      locationCity!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 70,
                                ),
                                // IconButton(
                                //   onPressed: () {},
                                //   icon: Icon(Icons.search),
                                //   iconSize: 30,
                                // )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                  ),
                  Container(
                    height: 160,
                    child: Image.asset(
                      "assets/images/sun5.png",
                      height: 160,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment(-.001, 0),
                child: Container(
                  height: 150,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(85, 191, 191, 191),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "  ${weatherProvider.weather?.main?.temp?.toStringAsFixed(0) ?? "N/A"}\u00B0C",
                        style: TextStyle(
                            color: Color.fromARGB(255, 22, 22, 22),
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        weatherProvider.weather?.name ?? "N/A",
                        style: TextStyle(
                            color: Color.fromARGB(255, 22, 22, 22),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        weatherProvider.weather?.weather?[0].main ?? "N/A",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat("hh:mm a").format(DateTime.now()),
                        style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Color.fromARGB(79, 0, 0, 0),
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 65,
                        ),
                        Image.asset(
                          "assets/images/thermmax.png",
                          height: 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Temp Max",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "${weatherProvider.weather?.main?.tempMax?.toStringAsFixed(0) ?? "N/A"}\u00B0 C",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Image.asset(
                          "assets/images/thermin.png",
                          height: 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Temp Min",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "${weatherProvider.weather?.main?.tempMin?.toStringAsFixed(0) ?? "N/A"}\u00B0 C",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      endIndent: 70,
                      indent: 60,
                      thickness: .8,
                      color: Colors.white,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 70,
                        ),
                        Image.asset(
                          "assets/images/sunlogo.png",
                          height: 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sunrise",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              formattedSunrise,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          "assets/images/mooon.png",
                          height: 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sunset",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              formattedSunset,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
