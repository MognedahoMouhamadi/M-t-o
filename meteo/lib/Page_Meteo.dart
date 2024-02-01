import 'package:flutter/material.dart';
import 'Modele/Modele_meteo.dart';
import 'service/service meteo.dart';
import 'package:lottie/lottie.dart';
import 'package:meteo/Bouton.dart';


class PageMeteo extends StatefulWidget {
  const PageMeteo({super.key});
  @override
  State<PageMeteo> createState() => _PageMeteoState();
}

class _PageMeteoState extends State<PageMeteo> {

//api key
final _ServiceMeteo = ServiceMeteo('c9488b55c11530376fbb215ccc69166c');
Meteo? _meteo;


// recherche de la condition météo
  _rechercheMeteo() async {
  String Ville = await _ServiceMeteo.getVille();

  // obtenir le temps de la ville
  try {
    final Meteo = await _ServiceMeteo.getMeteo(Ville);
    setState(() {
      _meteo = Meteo;
    });
  }
  //les erreurs
    catch (e){
      print(e);
    }
  }


// animation météos
  String getLottieAnimationForWeather() {
    if (_meteo == null || _meteo?.Maincondition == null) {
      return 'animations/default.json'; // s'il ne trouve pas de conditions météo
    }

    // Utilisez un bloc switch pour déterminer le nom du fichier Lottie en fonction de la condition météo
    switch (_meteo?.Maincondition.toLowerCase()) {
      case 'clear':
        return 'animations/sunny.json'; //  dégagé
      case 'clouds':
        return 'animations/cloudy.json'; // nuageux
      case 'rain':
        return 'animations/rainy.json'; //  pluvieux
      case 'snow':
        return 'animations/snowy.json'; //  neigeux
    // Ajoutez d'autres cas selon les conditions météorologiques que vous prenez en charge
      default:
        return 'animations/default.json'; // Animation par défaut
    }
  }

    void initState() {
  super.initState();
  //demarrage de la requête
  _rechercheMeteo();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // écran de chargement
            Text(_meteo?.Ville?? "chargement de la ville"),
            Text('${_meteo?.Temperature.round()}°C'),

            //animation des images json
            Lottie.asset(
              getLottieAnimationForWeather(),
              width: 200, // largeur  de l'animation
              height: 200, // hauteur  de l'animation
              repeat: true, // répéter l'animation
              reverse: false, //inverser l'animation
            ),

      ]
      ),
    ),
    );
}
}


