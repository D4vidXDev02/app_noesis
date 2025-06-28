import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  AudioPlayer? _backgroundPlayer;
  bool _isMusicEnabled = true;
  bool _isPlaying = false;
  bool _isInitialized = false;

  // Getter para verificar si la música está habilitada
  bool get isMusicEnabled => _isMusicEnabled;
  bool get isPlaying => _isPlaying;

  // Inicializar el reproductor
  Future<void> init() async {
    if (_isInitialized) return;

    _backgroundPlayer = AudioPlayer();

    // Configurar el player para que se repita automáticamente
    await _backgroundPlayer?.setReleaseMode(ReleaseMode.loop);

    // Listener para detectar cuando termina la reproducción
    _backgroundPlayer?.onPlayerStateChanged.listen((PlayerState state) {
      _isPlaying = state == PlayerState.playing;
    });

    _isInitialized = true;
  }

  // Reproducir música de fondo (MEJORADO - actualiza estados inmediatamente)
  Future<void> playBackgroundMusic() async {
    if (!_isMusicEnabled || _backgroundPlayer == null) return;

    try {
      // Establecer estados antes de reproducir para UI inmediata
      _isMusicEnabled = true;
      _isPlaying = true;

      // Solo reproducir desde assets si no está ya cargado
      if (_backgroundPlayer?.state != PlayerState.paused) {
        await _backgroundPlayer?.play(AssetSource('audios/music_game.mp3'));
      } else {
        // Si está pausado, solo reanudar
        await _backgroundPlayer?.resume();
      }

      // Ajustar volumen (0.0 a 1.0)
      await _backgroundPlayer?.setVolume(0.3);

      print('🎵 Música de fondo iniciada');
    } catch (e) {
      print('Error al reproducir música de fondo: $e');
      // En caso de error, revertir estados
      _isPlaying = false;
    }
  }

  // Detener música de fondo completamente
  Future<void> stopBackgroundMusic() async {
    try {
      await _backgroundPlayer?.stop();
      _isPlaying = false;
      print('Música de fondo detenida completamente');
    } catch (e) {
      print('Error al detener música de fondo: $e');
    }
  }

  // Pausar música de fondo
  Future<void> pauseBackgroundMusic() async {
    try {
      await _backgroundPlayer?.pause();
      _isPlaying = false;
      print('Música de fondo pausada');
    } catch (e) {
      print('Error al pausar música de fondo: $e');
    }
  }

  // Reanudar música de fondo
  Future<void> resumeBackgroundMusic() async {
    if (!_isMusicEnabled) return;

    try {
      await _backgroundPlayer?.resume();
      _isPlaying = true;
      print('Música de fondo reanudada');
    } catch (e) {
      print('Error al reanudar música de fondo: $e');
    }
  }

  // Ajustar volumen
  Future<void> setVolume(double volume) async {
    await _backgroundPlayer?.setVolume(volume.clamp(0.0, 1.0));
  }

  // Habilitar/deshabilitar música
  void toggleMusic() {
    _isMusicEnabled = !_isMusicEnabled;

    if (_isMusicEnabled) {
      resumeBackgroundMusic();
    } else {
      pauseBackgroundMusic();
    }
  }

  // Metodo específico para controlar música desde el botón UI
  Future<void> toggleMusicFromButton() async {
    if (_isMusicEnabled && _isPlaying) {
      // Si está habilitada y reproduciéndose, pausar
      await pauseBackgroundMusic();
      _isMusicEnabled = false;
    } else if (!_isMusicEnabled || !_isPlaying) {
      // Si está deshabilitada o no se está reproduciendo, habilitar y reanudar
      _isMusicEnabled = true;

      // Si nunca se ha reproducido o está detenida completamente, reproducir desde el inicio
      if (_backgroundPlayer?.state == PlayerState.stopped ||
          _backgroundPlayer?.state == PlayerState.completed) {
        await playBackgroundMusic();
      } else {
        // Si solo está pausada, reanudar rápidamente
        await resumeBackgroundMusic();
      }
    }
  }

  // Liberar recursos
  Future<void> dispose() async {
    await _backgroundPlayer?.dispose();
    _backgroundPlayer = null;
    _isPlaying = false;
    _isInitialized = false;
  }
}