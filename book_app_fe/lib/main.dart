import 'package:dart_pdf_reader/dart_pdf_reader.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

Future<String> readText() async {
  return await rootBundle.loadString('assets/my_text.txt');
}

void main() => runApp(const DefaultTextStyleApp());

class DefaultTextStyleApp extends StatelessWidget {
  const DefaultTextStyleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.purple,
      ),
      home: const DefaultTextStyleExample(),
    );
  }
}

class DefaultTextStyleExample extends StatelessWidget {
  const DefaultTextStyleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Reader Example")),
      body: Center(
        child: FutureBuilder<String>(
          future: readText(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Container(
                width: 300,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all()),
                child: Text(
                  snapshot.data ?? 'No Data',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
