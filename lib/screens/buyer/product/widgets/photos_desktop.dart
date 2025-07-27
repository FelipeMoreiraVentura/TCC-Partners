import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market_partners/utils/style.dart';

class Photosdesktop extends StatefulWidget {
  final List images;
  const Photosdesktop({super.key, required this.images});

  @override
  State<Photosdesktop> createState() => _PhotosdesktopState();
}

class _PhotosdesktopState extends State<Photosdesktop> {
  late Iterable<InkWell> imagesButtons;
  int indexSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children:
                  widget.images.asMap().entries.map((entry) {
                    int index = entry.key;
                    String image = entry.value;
                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                index == indexSelected
                                    ? AppColors.blue
                                    : Colors.grey,
                            width: index == indexSelected ? 2.5 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Image.memory(
                          base64Decode(image),
                          width: 70,
                          height: 70,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          indexSelected = index;
                        });
                      },
                    );
                  }).toList(),
            ),
          ),
        ),
        SizedBox(width: 5),
        Image.memory(
          base64Decode(widget.images[indexSelected]),
          height: 500,
          width: 500,
        ),
      ],
    );
  }
}
