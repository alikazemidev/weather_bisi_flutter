import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:weather_bisi_flutter/models/7days_weather.dart';
import 'package:weather_bisi_flutter/models/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          headline2: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
          bodyText1: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          bodyText2: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Weather>? futureweather;
  StreamController<List<DaysWeather>>? StreamWeather;

  TextEditingController cityNameCotroller = TextEditingController();
  var cityName = 'tehran';
  var lat;
  var long;

  void sendRequest7DaysWeather(lat, long) async {
    List<DaysWeather> list = [];
    var apiKey = 'c81a25b60360ffd19ce90d5a4b7bff53';

    try {
      var response = await Dio().get(
        'https://api.openweathermap.org/data/2.5/onecall',
        queryParameters: {
          'lat': lat,
          'lon': long,
          'exclude': 'minutely,hourly',
          'appid': apiKey,
          'units': 'metric',
        },
      );
      final formatter = DateFormat.MMMd();

      for (int i = 0; i < 8; i++) {
        var model = response.data['daily'][i];
        var dt = formatter.format(
          DateTime.fromMillisecondsSinceEpoch(
            model['dt'] * 1000,
            isUtc: false,
          ),
        );

        DaysWeather daysWeather = DaysWeather(
          dataTime: dt,
          temp: model['temp']['day'],
          description: model['weather'][0]['description'],
          main: model['weather'][0]['main'],
        );

        list.add(daysWeather);
      }

      StreamWeather!.add(list);
    } on DioError catch (e) {
      print(e.response!.statusCode);
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('there is an error'),
        ),
      );
    }
  }

  Future<Weather> sendRequestCurrentWeather(String cityName) async {
    var apiKey = 'c81a25b60360ffd19ce90d5a4b7bff53';
    var response = await Dio().get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': cityName.toLowerCase(),
        'appid': apiKey,
        'units': 'metric',
      },
    );

    lat = response.data["coord"]["lat"];
    long = response.data["coord"]["lon"];

    print(response.statusCode);

    var dataModel = Weather(
      cityName: response.data["name"],
      country: response.data["sys"]["country"],
      lat: response.data["coord"]["lat"],
      long: response.data["coord"]["lon"],
      main: response.data["weather"][0]["main"],
      description: response.data["weather"][0]["description"],
      humidity: response.data["main"]["humidity"],
      pressure: response.data["main"]["pressure"],
      tempMax: response.data["main"]["temp_max"],
      tempMin: response.data["main"]["temp_min"],
      sunrise: response.data["sys"]["sunrise"],
      sunset: response.data["sys"]["sunset"],
      dateTime: response.data["timezone"],
      windSpeed: response.data["wind"]["speed"],
      temp: response.data["main"]["temp"],
    );
    return dataModel;
  }

  Image setIconForMain(model) {
    var description = model.main;

    if (description == "clear sky") {
      return Image(image: AssetImage('images/icons8-sun-96.png'));
    } else if (description == "few clouds") {
      return Image(image: AssetImage('images/icons8-partly-cloudy-day-80.png'));
    } else if (description.contains("clouds")) {
      return Image(image: AssetImage('images/icons8-clouds-80.png'));
    } else if (description.contains("thunderstorm")) {
      return Image(image: AssetImage('images/icons8-storm-80.png'));
    } else if (description.contains("drizzle")) {
      return Image(image: AssetImage('images/icons8-rain-cloud-80.png'));
    } else if (description.contains("rain")) {
      return Image(image: AssetImage('images/icons8-heavy-rain-80.png'));
    } else if (description.contains("snow")) {
      return Image(image: AssetImage('images/icons8-snow-80.png'));
    } else {
      return Image(image: AssetImage('images/icons8-windy-weather-80.png'));
    }
  }

  @override
  void initState() {
    super.initState();
    futureweather = sendRequestCurrentWeather(cityName);
    StreamWeather = StreamController<List<DaysWeather>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(),
      body: SafeArea(
        child: FutureBuilder<Weather>(
          future: futureweather,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final formatter = DateFormat.jm();
              var sunrise = formatter.format(
                new DateTime.fromMillisecondsSinceEpoch(
                  snapshot.data!.sunrise * 1000,
                  isUtc: false,
                ),
              );
              var sunset = formatter.format(
                new DateTime.fromMillisecondsSinceEpoch(
                  snapshot.data!.sunset * 1000,
                  isUtc: false,
                ),
              );
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('images/1.jpg'),
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 8,
                    sigmaY: 8,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        // *search bar
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(149, 163, 163, 163),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: TextField(
                                    controller: cityNameCotroller,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      border: InputBorder.none,
                                      labelText: 'Enter City Name',
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(50, 50),
                                  primary: Colors.green,
                                  shape: CircleBorder(),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Find',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //* top section
                        Text(
                          snapshot.data!.cityName,
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          snapshot.data!.main,
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        setIconForMain(snapshot.data),

                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${snapshot.data!.temp}\u00b0',
                          style: TextStyle(
                            fontSize: 60,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // *temp min/max
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Max',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${snapshot.data!.tempMax}\u00b0',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              width: 2,
                              height: 45,
                              color: Colors.white,
                            ),
                            Column(
                              children: [
                                Text(
                                  'Min',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${snapshot.data!.tempMin}\u00b0',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // *middle section
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        // *list view weather
                        Container(
                          width: double.infinity,
                          height: 120,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Fri 8PM',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Icon(Icons.cloud, color: Colors.white),
                                    SizedBox(height: 5),
                                    Text('14 \u00b0')
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        // * extera info weather row
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'wind speed',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '${snapshot.data!.windSpeed} m/s',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: 1,
                                height: 50,
                                color: Colors.white,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'sunrise',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    sunrise,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: 1,
                                height: 50,
                                color: Colors.white,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'sunset',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    sunset,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: 1,
                                height: 50,
                                color: Colors.white,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'humidity',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    '${snapshot.data!.humidity}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: JumpingDotsProgressIndicator(
                  color: Colors.black,
                  fontSize: 60,
                  dotSpacing: 2,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
