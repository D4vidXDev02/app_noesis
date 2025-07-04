import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'MenuScreen.dart';
import 'ProfileScreen.dart';
import 'FavoritesScreen.dart';

class VerboToBeScreen extends StatefulWidget {
  @override
  _VerboToBeScreenState createState() => _VerboToBeScreenState();
}

class _VerboToBeScreenState extends State<VerboToBeScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentlyPlaying = '';

  int currentBottomNavIndex = 0;

  Future<void> playAudio(String audioFile) async {
    try {
      debugPrint("Attempting to play: assets/audios/$audioFile");

      if (isPlaying) {
        await audioPlayer.stop();
        setState(() {
          isPlaying = false;
          currentlyPlaying = '';
        });
      }

      if (currentlyPlaying != audioFile) {
        setState(() {
          isPlaying = true;
          currentlyPlaying = audioFile;
        });

        await audioPlayer.play(AssetSource('audios/$audioFile'));

        audioPlayer.onPlayerComplete.listen((event) {
          setState(() {
            isPlaying = false;
            currentlyPlaying = '';
          });
        });
      }
    } catch (e) {
      debugPrint("Error playing audio: $e");
      setState(() {
        isPlaying = false;
        currentlyPlaying = '';
      });
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Widget _buildAudioExample(
      String englishText,
      String spanishText,
      String audioFile,
      ) {
    bool isThisPlaying = isPlaying && currentlyPlaying == audioFile;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  englishText,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  spanishText,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: IconButton(
              icon: Icon(
                isThisPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.black,
              ),
              onPressed: () => playAudio(audioFile),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Image.asset('assets/logo_noesis.png', height: 40)],
        ),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/verbo_to_be_pizarra.png', width: 300),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white),
              child: Text(
                'El verbo "to be" en inglés es fundamental, ya que puede traducirse como \'ser\' o \'estar\'. Se utiliza para describir estados, cualidades, características o ubicaciones de personas, animales o cosas. Por ejemplo, "Ella es ingeniera" se traduce como "She is an engineer", y "Estamos cansados" se traduce como "We are tired".',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Image.asset('assets/verbo_to_be_tabla.png', width: 300),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 16),
                    child: Center(
                      child: Text(
                        'VERBO TO BE – Ejemplos',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: Color(0xFFFA0000),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildAudioExample(
                    'She is a doctor.',
                    '(Ella es médica.)',
                    'She_is_a_doctor.mp3',
                  ),
                  Divider(),
                  _buildAudioExample(
                    'The sky is blue.',
                    '(El cielo es azul.)',
                    'The_sky_is_blue.mp3',
                  ),
                  Divider(),
                  _buildAudioExample(
                    'I am happy today.',
                    '(Estoy feliz hoy.)',
                    'I_am_happy_today.mp3',
                  ),
                  Divider(),
                  _buildAudioExample(
                    'It is raining outside.',
                    '(Está lloviendo afuera.)',
                    'It_is_raining_outsid.mp3',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: currentBottomNavIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        onTap: (index) {
          setState(() {
            currentBottomNavIndex = index;
          });

          // Navegación basada en el índice seleccionado
          switch (index) {
            case 0:
            // Home
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
              break;
            case 2:
            // Perfil
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}
