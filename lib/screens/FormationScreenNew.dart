import 'package:flutter/material.dart';

class FormationScreenNew extends StatefulWidget {
  const FormationScreenNew({Key? key}) : super(key: key);
  @override
  _FormationScreenNewState createState() => _FormationScreenNewState();
}

class _FormationScreenNewState extends State<FormationScreenNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Aufstellung"),
        ),
        body: Column(
          children: <Widget>[
            createFirstRow(context),
            createRow(context),
            createRow(context)
          ],
        ));
  }

  Widget createRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        createRowPosition(context, Colors.green),
        createRowPosition(context, Colors.red),
        createRowPosition(context, Colors.blue)
      ],
    );
  }

  Widget createFirstRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Spacer(),
        createRowPosition(context, Colors.red),
        Spacer()
      ],
    );
  }

  Widget createRowPosition(BuildContext context, Color color) {
    return GestureDetector(
      onTap: () {
        showBottomSheet(context, color, "Test");
      },
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width: 2.0,
          ),
        ),
      ),
    );
  }

  // A function that shows a bottom sheet with a given color and text
  void showBottomSheet(BuildContext context, Color color, String text) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImageSelector(); // Return an ImageSelector widget
      },
    );
  }
}

// A StatefulWidget that allows the user to select images on the bottom sheet
class ImageSelector extends StatefulWidget {
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  // A list of image URLs to display on the grid view
  List<String> imageUrls = [
    'https://i.imgur.com/4Zg0Z1E.png',
    'https://i.imgur.com/9QXy1xG.png',
    'https://i.imgur.com/8xY4w6f.png',
    'https://i.imgur.com/3g0w2oL.png',
  ];

  // A set of selected image indexes
  Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          // A grid view that displays the images
          Expanded(
            child: GridView.builder(
              itemCount: imageUrls.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      // Toggle the selection of the image
                      if (selectedIndexes.contains(index)) {
                        selectedIndexes.remove(index);
                      } else {
                        selectedIndexes.add(index);
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      // Display the image
                      Image.network(imageUrls[index]),
                      // Display a check icon if the image is selected
                      if (selectedIndexes.contains(index))
                        Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 32,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          // A button that prints the selected images
          ElevatedButton(
            onPressed: () {
              print(
                  'Selected images: ${selectedIndexes.map((i) => imageUrls[i]).toList()}');
            },
            child: Text('Print selected images'),
          ),
        ],
      ),
    );
  }
}
