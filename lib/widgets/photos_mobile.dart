import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PhotosMobile extends StatefulWidget {
  final List<String> images;
  const PhotosMobile({Key? key, required this.images}) : super(key: key);

  @override
  _PhotosMobileState createState() => _PhotosMobileState();
}

class _PhotosMobileState extends State<PhotosMobile> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<Widget> imagesContainers =
        widget.images.map((img) {
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                base64Decode(img),
                width: width,
                height: width,
                fit: BoxFit.cover,
              ),
            ),
          );
        }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(top: 5, bottom: 15),
          child: CarouselSlider(
            items: imagesContainers,
            options: CarouselOptions(
              height: width,
              enlargeCenterPage: true,
              viewportFraction: 0.95,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              widget.images.asMap().entries.map((entry) {
                int idx = entry.key;
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == idx ? Colors.blueAccent : Colors.grey,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
