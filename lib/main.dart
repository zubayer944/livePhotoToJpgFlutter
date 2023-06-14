

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Photo to JPG',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Live Photo to JPG'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //String inputFilePath = 'path/to/your/file.HEIC';
  PlatformFile file = PlatformFile(name: 'image', size: 200);

  File? _convertedJpg;

  Future<void> _convertToJpg() async {

      final appDir = await getApplicationDocumentsDirectory();
      final outputPath = "${appDir.path}/converted${DateTime.now().microsecond}.jpg";

      final flutterFFmpeg = FlutterFFmpeg();
      final command = "-i ${file.path} -vframes 1 $outputPath";

      final int result = await flutterFFmpeg.execute(command);

      if (result == 0) {
        setState(() {
          _convertedJpg = File(outputPath);
          print('_MyHomePageState._convertToJpg---->>> ${_convertedJpg!.path}');
        });
      }

  }


  Future<void> _onCameraBtnPressed() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
    );
    if (result != null) {
      file = result.files.first;

      print('_MyHomePageState._onCameraBtnPressed--> ${file.path}');

      _convertToJpg();
    } else {
      // User canceled the picker
      print('_MyHomePageState._onCameraBtnPressed--<>><><<>><><><><><><><><><<>');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_convertedJpg != null) Image.file(_convertedJpg!)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCameraBtnPressed,
        tooltip: 'Camera',
        child: const Icon(Icons.camera_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
