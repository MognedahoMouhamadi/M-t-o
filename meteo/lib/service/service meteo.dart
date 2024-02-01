import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../Modele/Modele_meteo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceMeteo {

  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;


  ServiceMeteo(this.apiKey);
  Future<Meteo> getMeteo(String Ville) async {
    final reponse = await http.get(Uri.parse('$BASE_URL?q=$Ville&appid=$apiKey&units=metric'));

    if (reponse.statusCode ==200) {
      return Meteo.fromJson(jsonDecode(reponse.body));

    }else{

      throw Exception('impossible de charger les données Météo!');

    }
  }
  
  Future<String> getVille() async{
    //obtenir la permission de l'utilisateur
    LocationPermission permission = await Geolocator.checkPermission();
    if( permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    
    //La localisation actuelle
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
    
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);

    //extraction de la ville
    String? Ville = placemark[0].locality;
    return Ville ?? "";
    
  }
}