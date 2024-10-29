import 'package:flutter/material.dart';

class CarouselIndicator extends StatelessWidget {
  const CarouselIndicator({
    super.key,
    required this.imageList,
    required int currentSlide,
  }) : _currentSlide = currentSlide;

  final List<String> imageList;
  final int _currentSlide;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: imageList.map((imagePath) {
        int index = imageList.indexOf(imagePath);
        return Padding(
          padding: const EdgeInsets.only(
            right: 5.0,
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(
                  0xffC7DAC6,
                ),
              ),
              color: _currentSlide == index
                  ? const Color(0xffC7DAC6)
                  : Colors.grey.withOpacity(0),
            ),
          ),
        );
      }).toList(),
    );
  }
}
