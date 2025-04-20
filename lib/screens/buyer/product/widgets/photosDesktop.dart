import 'package:flutter/material.dart';

class Photosdesktop extends StatefulWidget {
  final List images;
  const Photosdesktop({super.key, required this.images});

  @override
  State<Photosdesktop> createState() => _PhotosdesktopState();
}

class _PhotosdesktopState extends State<Photosdesktop> {
  late Iterable<InkWell> imagesButtons;
  late int indexSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children:
              widget.images.asMap().entries.map((entry) {
                int index = entry.key;
                String image = entry.value;
                return InkWell(
                  child: Image.network(image, width: 50, height: 50),
                  onTap: () {
                    setState(() {
                      indexSelected = index;
                    });
                  },
                );
              }).toList(),
        ),
        SizedBox(width: 5),
        Image.network(widget.images[indexSelected], height: 550, width: 550),
      ],
    );
  }
}
