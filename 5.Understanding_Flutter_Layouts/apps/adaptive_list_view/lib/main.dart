import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const AdaptiveListViewApp());
}

class AdaptiveListViewApp extends StatelessWidget {
  const AdaptiveListViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Adaptive List/Grid View")),
        body: LayoutBuilder(
          builder: (context, Constraints) {
            final screenWidth = MediaQuery.of(context).size.width;

            final items = List.generate(10, (index) => "Item ${index + 1}");

            if (screenWidth < 600) {
              // малък екран - ListView (1 колона)
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(title: Text(items[index])),
                  );
                },
              );
            } else {
              // голям екран - GridView (2 колони)
              return GridView.count(
                crossAxisCount: 2,
                children: List.generate(items.length, (index) {
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        items[index],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }),
              );
            }
          },
        ),
      ),
    );
  }
}
