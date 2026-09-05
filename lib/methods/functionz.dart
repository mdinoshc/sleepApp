import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordFunctionz {

  final AudioRecorder recorder = AudioRecorder();

  Future<bool> hasPermission() async {
    return await recorder.hasPermission();
  }

  final recordConfig = RecordConfig(
    encoder: AudioEncoder.pcm16bits,
    sampleRate: 24000,
    numChannels: 2,
    autoGain: true,
    echoCancel: true,
    noiseSuppress: true
  );

  Future<String> startRecord() async {
    final dir =  await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await recorder.start(recordConfig, path: filePath);
    print("record started");
    return filePath;
  }

  Future<String?> stopRecord() async {
    print("record stopped");
    return await recorder.stop();
  }

  Future<void> pauseRecord() async {
    await recorder.pause();
  }

  Future<void> resumeRecord() async {
    await recorder.resume();
  }

  Future<bool> isRecording() async {
    return await recorder.isRecording();
  }

  Future<bool> isPaused() async {
    return await recorder.isPaused();
  }

  void dispose() {
    recorder.dispose();
  }

  Stream<RecordState> get onStateChanged => recorder.onStateChanged();

  Stream<Amplitude> get onAmplitudeChanged => recorder.onAmplitudeChanged(Duration(milliseconds: 200));

  saveToList() {
    print("record saved to list");
  }

  openList() {
    print("record list opened");
  }
}
