import 'package:flutter/material.dart';
import 'Modele/Modele_meteo.dart';
import 'service/service meteo.dart';
import 'package:lottie/lottie.dart';
import 'package:meteo/Bouton.dart';

class PageMeteo extends StatefulWidget {
  const PageMeteo({Key? key}) : super(key: key);

  @override
  State<PageMeteo> createState() => _PageMeteoState();
}

class _PageMeteoState extends State<PageMeteo> {
  final _ServiceMeteo = ServiceMeteo('c9488b55c11530376fbb215ccc69166c');
  Meteo? _meteo;
  String MaVille = '';

  // Recherche de la condition météo
  Future<void> _rechercheMeteo() async {
    String ville = await _ServiceMeteo.getVille();

    try {
      final meteo = await _ServiceMeteo.getMeteo(ville);
      setState(() {
        _meteo = meteo;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _rechercheMeteoB(String? maVille) async {
    if (maVille != null && maVille.isNotEmpty) {
      try {
        final meteo = await _ServiceMeteo.getMeteo(maVille);
        setState(() {
          _meteo = meteo;
        });
      } catch (e) {
        print(e);
      }
    } else {
      // Si maVille est null ou vide, effectuez la recherche par défaut
      await _rechercheMeteo();
    }
  }

  // Animation météo
  String getLottieAnimationForWeather() {
    if (_meteo == null || _meteo!.Maincondition == null) {
      return 'animations/default.json'; // s'il ne trouve pas de conditions météo
    }

    switch (_meteo!.Maincondition.toLowerCase()) {
      case 'clear':
        return 'animations/sunny.json'; // dégagé
      case 'clouds':
        return 'animations/cloudy.json'; // nuageux
      case 'rain':
        return 'animations/rainy.json'; // pluvieux
      case 'snow':
        return 'animations/snowy.json'; // neigeux
      default:
        return 'animations/default.json'; // Animation par défaut
    }
  }

  @override
  void initState() {
    super.initState();
    // Démarrage de la requête avec la valeur par défaut
    _rechercheMeteoB(MaVille);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Quel temps fait-il ici ? (Ville)",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    MaVille = value;
                  });
                },
              ),
            ),
            Bouton(
              text: "Rechercher",
              onPressed: () {
                _rechercheMeteoB(MaVille);
              },
            ),
            Text(_meteo?.Ville ?? "chargement de la ville"),
            Text('${_meteo?.Temperature.round()}°C'),
            Lottie.asset(
              getLottieAnimationForWeather(),
              width: 200,
              height: 200,
              repeat: true,
              reverse: false,
            ),
            Bouton(
              text: "Ma position",
              onPressed: () {
                _rechercheMeteoB("");
              },
            ),





          ],
        ),
      ),
    );
  }
}
