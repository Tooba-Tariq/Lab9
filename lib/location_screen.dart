import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Lab9 extends StatefulWidget {
  Lab9(this.position, this.weather);
  Position position;
  var weather;
  @override
  State<Lab9> createState() => _Lab9State();
}

class _Lab9State extends State<Lab9> {
  Position? position;
  String cityName = '';
  String temp = '';
  String cityIcon = '';
  @override
  initState() {
    super.initState();
    position = widget.position;
    print(widget.weather);
    cityName = widget.weather['name'];
    temp = widget.weather['main']['temp'].toString();
    cityIcon = getWeatherIcon(widget.weather['weather'][0]['id']);
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Geo Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(position != null ? position.toString() : 'Null',
                style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 50,
            ),
            Text(" City Name = $cityName", style: TextStyle(fontSize: 20)),
            Text(" Temperature = $temp", style: TextStyle(fontSize: 20)),
            Text(" City Icon = $cityIcon", style: TextStyle(fontSize: 20)),
            Padding(
              padding: const EdgeInsets.only(top: 400.0),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() async {
                    await getLocation();
                    http.Response response = await http.get(Uri.parse(
                        "https://api.openweathermap.org/data/2.5/weather?lat=${position!.latitude.toString()}&lon=${position!.longitude.toString()}&appid=e5d01b82a8c423d054a246b149730e4a"));
                    var json = jsonDecode(response.body);
                    temp = json['main']['temp'].toString();

                    cityIcon = json['weather'][0]['icon'];
                    cityName = json['name'];
                  });
                },
                child: Text(
                  'Get Current Location',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
