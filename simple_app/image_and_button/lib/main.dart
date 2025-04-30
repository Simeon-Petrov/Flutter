import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Image Switcher'), // App bar title
          centerTitle: true,
        ),
        body: const Center(
          child: ImageSwitcher(), // Display image with button
        ),
      ),
    );
  }
}

class ImageSwitcher extends StatefulWidget {
  const ImageSwitcher({super.key});

  @override
  State<ImageSwitcher> createState() => _ImageSwitcherState();
}

class _ImageSwitcherState extends State<ImageSwitcher> {
  final List<String> _images = [
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=10',
    'https://picsum.photos/250?image=11',
  ];

  int _currentIndex = 0;

  void _changeImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _images.length;
    });
  }

  @override
  Widget build(BuildContext contex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(_images[_currentIndex], width: 250, height: 250),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _changeImage,
          child: const Text("Change Image"),
        ),
      ],
    );
  }
}
