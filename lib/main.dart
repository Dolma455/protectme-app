import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/app/app.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}



// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:url_launcher/url_launcher.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() {
//   runApp(const MyApp());
// }j

// class MyApp extends StatelessWidget {jj
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ProtectMe',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'ProtectMe Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late stt.SpeechToText _speechToText;
//   bool _speechEnabled = false;
//   String _lastWords = '';

//   @override
//   void initState() {
//     super.initState();
//     requestPermissions().then((_) {
//       _initializeSpeech();
//     });
//   }

//   Future<void> requestPermissions() async {
//     var microphoneStatus = await Permission.microphone.request();
//     var phoneStatus = await Permission.phone.request();

//     if (microphoneStatus.isGranted && phoneStatus.isGranted) {
//       print('Permissions granted');
//     } else {
//       print('Permissions not granted');
//     }
//   }

//   void _initializeSpeech() async {
//     _speechToText = stt.SpeechToText();
//     _speechEnabled = await _speechToText.initialize(
//       onStatus: (status) => print('onStatus: $status'),
//       onError: (error) => print('onError: $error'),
//     );
//     if (!_speechEnabled) {
//       print('Speech recognition initialization failed.');
//     } else {
//       print('Speech recognition initialized successfully.');
//     }
//     setState(() {});
//   }

//   void _startListening() async {
//     if (_speechEnabled) {
//       await _speechToText.listen(
//         onResult: (result) {
//           setState(() {
//             _lastWords = result.recognizedWords;
//             print('Recognized words: $_lastWords');
//             if (_lastWords.toLowerCase() == 'hello') {
//               _makePhoneCall('9818853110'); // Replace with your emergency contact number
//             }
//           });
//         },
//         listenFor: Duration(seconds: 10),
//         pauseFor: Duration(seconds: 5),
//         partialResults: false,
//         localeId: 'en_US',
//         onSoundLevelChange: (level) => print('Sound level: $level'),
//         cancelOnError: true,
//         listenMode: stt.ListenMode.confirmation,
//       );
//     } else {
//       print('Speech recognition is not enabled.');
//     }
//   }

//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {});
//   }

//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );
//     try {
//       if (await canLaunch(launchUri.toString())) {
//         await launch(launchUri.toString());
//       } else {
//         throw 'Could not launch dialer';
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               _lastWords,
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 _speechToText.isListening
//                     ? '$_lastWords'
//                     : _speechEnabled
//                         ? 'Tap the microphone to start listening...'
//                         : 'Speech not available',
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed:
//             // If not yet listening for speech start, otherwise stop
//             _speechToText.isNotListening ? _startListening : _stopListening,
//         tooltip: 'Listen',
//         child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
//       ),
//     );
//   }
// }