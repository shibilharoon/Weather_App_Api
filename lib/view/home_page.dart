import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_final/services/location_provider.dart';
import 'package:weather_final/services/weather_service_provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determinePOsition().then((_) {
      if (locationProvider.currentLocationName != null) {
        var city = locationProvider.currentLocationName!.locality;
        if (city != null) {
          Provider.of<WeatherServiceProvider>(context, listen: false)
              .fetchWeatherDataByCity(city);
        }
      }
    });

    super.initState();
  }

  TextEditingController cityController = TextEditingController();
  var city;
  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherServiceProvider>(context);
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
      child: Container(
          height: size.height,
          width: size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/bg.jpg'))),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 0, 0),
              child: Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) {
                String? locationCity;
                if (locationProvider.currentLocationName != null) {
                  locationCity = locationProvider.currentLocationName!.locality;
                } else {
                  locationCity = "Unknown Location";
                }
                return Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width * 0.8, // Adjust the width as needed
                        child: TextFormField(
                          controller: cityController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20), // Adjust horizontal padding
                            hintText: "Search",
                            hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0)),

                            filled: true,
                            fillColor: Color.fromARGB(255, 222, 222, 222),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(170, 0, 0, 0),
                            borderRadius: BorderRadius.circular(20)),
                        child: IconButton(
                          onPressed: () {
                            weatherProvider
                                .fetchWeatherDataByCity(cityController.text);
                          },
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locationCity!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 130,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    "assets/images/sun.png",
                    width: 190,
                    height: 170,
                  ),
                  SizedBox(
                    height: 130,
                    width: 180,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${weatherProvider.weather?.main?.temp?.toStringAsFixed(0) ?? 'N/A'}\u00B0C",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                          Text(weatherProvider.weather?.name ?? "N/A",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20)),
                          Text(
                              weatherProvider.weather?.weather?[0].main ??
                                  "N/A",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20)),
                          Text(
                            DateFormat("hh:mm a").format(DateTime.now()),
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      height: 180,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(223, 0, 0, 0).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/images/hightemp.png",
                                          height: 40),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Temp Max",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "${weatherProvider.weather?.main?.tempMax?.toStringAsFixed(0) ?? 'N/A'}\u00B0 C",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ])
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/images/lowtemp.png",
                                            height: 40),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Temp Min",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                "${weatherProvider.weather?.main?.tempMin?.toStringAsFixed(0) ?? 'N/A'}\u00B0 C",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ])
                                      ])
                                ]),
                            SizedBox(
                              height: 10,
                            ),
                            const Divider(
                                indent: 60,
                                endIndent: 60,
                                color: Colors.white,
                                thickness: 1),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/images/sunlogo.png",
                                            height: 40),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Sun Rise",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                formattedSunrise,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ])
                                      ]),
                                  const SizedBox(width: 20),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/images/mooon.png",
                                            height: 40),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Sun Set",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                formattedSunset,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ])
                                      ])
                                ])
                          ])),
                ]);
              }))),
    ));
  }
}
