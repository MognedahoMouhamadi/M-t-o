class Meteo {
  //les données d'entrée
  final String Ville;
  final double Temperature;
  final String Maincondition;

  Meteo({
    required this.Ville,
    required this.Temperature,
    required this.Maincondition,
  });
//
  factory Meteo.fromJson(Map<String, dynamic> json) {
    return Meteo(
      Ville: json['name'],
      Temperature: json['main']['temp'].toDouble(),
      Maincondition: json['weather'][0]['main'],
      //attention au format de la donnée
    );
  }
}

