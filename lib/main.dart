import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:record/record.dart';
import 'package:sleepyer/methods/functionz.dart';
import 'package:flutter_audio_visualizer/flutter_audio_visualizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: recordPage(),
    );
  }
}

class recordPage extends StatefulWidget {
  recordPage({super.key});

  @override
  State<recordPage> createState() => _recordPageState();
}

class _recordPageState extends State<recordPage> {
  // Visualization parameters
  double _barWidth = 4.0;

  final RecordFunctionz recordFunctionz = RecordFunctionz();
  RecordState _recordState = RecordState.stop;
  double _amplitude = 0.0;
  Duration _elapsed = Duration.zero;
  late final Stream<RecordState> _stateStream;
  // final AudioSource _source = AudioSource();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stateStream = recordFunctionz.onStateChanged;

    // Listen to state changes to update UI
    _stateStream.listen((state) {
      setState(() {
        _recordState = state;
      });
    });

    recordFunctionz.onAmplitudeChanged.listen((amp) {
      setState(() => _amplitude = amp.current);
    });
  }

  void showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> startRecording() async {
    final hasPermission = await recordFunctionz.hasPermission();
    if(!hasPermission) {
      showSnackBar("Microphone permission denied");
    }

    setState(() => _elapsed = Duration.zero);
    await recordFunctionz.startRecord();
    startTimer();
  }

  Future<void> stopRecording() async {
    final path = await recordFunctionz.stopRecord();
    if (path != null) {
      stopTimer();
      showSnackBar("Saved to : $path");
    }
  }

  Future<void> togglePause() async {
    // Note: The 'record' package uses pause/resume which updates the state stream
    // recordFunctionz should handle the platform calls
    if(_recordState == RecordState.record) {
      await recordFunctionz.pauseRecord();
    } else if(_recordState == RecordState.pause) {
      await recordFunctionz.resumeRecord();
    }
  }

  bool timerRunning = false;

  void startTimer() {
    timerRunning = true;
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if(!timerRunning) return false;
      if(_recordState == RecordState.record) {
        setState(() {
          _elapsed = _elapsed + Duration(seconds: 1);
        });
      }
      return timerRunning;
    });
  }

  void stopTimer() {
    timerRunning = false;
  }

  String get formattedTime {
    final m = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m : $s";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    recordFunctionz.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = _recordState == RecordState.record;
    final isPaused = _recordState == RecordState.pause;

    String recordButtonText = isRecording ? "STOP" : "START";

    return Scaffold(
      appBar: AppBar(
        title: Text('Sleepyer Voice Recorder'),
      ),
      body: Center(
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              width: 100 + (_amplitude + 60) * 2,
              height: 100 + (_amplitude + 60) * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRecording
                    ? Colors.red.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                border: Border.all(
                  color: isRecording ? Colors.red : Colors.grey,
                  width: 3,
                )
              ),
              child: Icon(
                isRecording ? Icons.mic : Icons.mic_none,
                size: 50,
                color: isRecording ? Colors.red : Colors.grey,
              ),
            ),
            SizedBox(height: 20.0,),
            Text(formattedTime),
            SizedBox(height: 20.0,),
            Text(
              isRecording ? "Recording" : isPaused ? "Paused" : "Ready",
              style: TextStyle(
                color: isRecording ? Colors.red : Colors.grey,
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 100,
              width: double.infinity,
              child: (isRecording || isPaused)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      /*child: AudioVisualizer(
                        // Map the single amplitude to a list for the visualizer
                        waveData: [_amplitude],
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.red,
                        gap: 2,
                      ),*/
                // child: AudioVisualizer(
                //   audioSource: AudioSource,
                // ),
                    )
                  : Center(
                      child: Container(
                        height: 2,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: null, // Logic for previous
                    child: Text("Previous")
                ),
                ElevatedButton(
                    onPressed: () {
                      if(isRecording) {
                        stopRecording();
                      } else {
                        startRecording();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRecording ? Colors.red : null,
                    ),
                    child: Text(recordButtonText)
                ),
                ElevatedButton(
                    onPressed: null, // Logic for next
                    child: Text("Next")
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          recordFunctionz.openList();
        },
        child: Icon(Icons.list_rounded),
      ),
    );
  }
}

