import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioService {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  String? _currentRecordingPath;
  bool _isRecording = false;
  bool _isPlaying = false;

  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;

  Future<String> _getAudioDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${appDir.path}/audio');
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    return audioDir.path;
  }

  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  Future<String?> startRecording() async {
    if (_isRecording) return null;

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) return null;

    final audioDir = await _getAudioDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _currentRecordingPath = '$audioDir/audio_$timestamp.m4a';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: _currentRecordingPath!,
    );

    _isRecording = true;
    return _currentRecordingPath;
  }

  Future<String?> stopRecording() async {
    if (!_isRecording) return null;

    final path = await _recorder.stop();
    _isRecording = false;
    return path;
  }

  Future<void> cancelRecording() async {
    if (_isRecording) {
      await _recorder.stop();
      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }
    _isRecording = false;
    _currentRecordingPath = null;
  }

  Future<void> playAudio(String path) async {
    if (_isPlaying) {
      await stopPlayback();
    }
    await _player.setFilePath(path);
    await _player.play();
    _isPlaying = true;
  }

  Future<void> stopPlayback() async {
    await _player.stop();
    _isPlaying = false;
  }

  Future<void> pausePlayback() async {
    await _player.pause();
    _isPlaying = false;
  }

  Future<void> resumePlayback() async {
    await _player.play();
    _isPlaying = true;
  }

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Future<Duration?> getAudioDuration(String path) async {
    final player = AudioPlayer();
    await player.setFilePath(path);
    final duration = player.duration;
    await player.dispose();
    return duration;
  }

  Future<void> deleteAudioFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  void dispose() {
    _recorder.dispose();
    _player.dispose();
  }
}
