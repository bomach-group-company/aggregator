// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class MyDisabledOutlinedElevatedButton extends StatelessWidget {
  final double circularBorderRadius;
  final double minimumSizeWidth;
  final double minimumSizeHeight;
  final double maximumSizeWidth;
  final double maximumSizeHeight;
  final String buttonTitle;
  final double titleFontSize;

  const MyDisabledOutlinedElevatedButton({
    super.key,
    required this.circularBorderRadius,
    required this.minimumSizeWidth,
    required this.minimumSizeHeight,
    required this.maximumSizeWidth,
    required this.maximumSizeHeight,
    required this.buttonTitle,
    required this.titleFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        elevation: 10.0,
        disabledBackgroundColor: kPrimaryColor,
        enableFeedback: false,
        disabledForegroundColor: kLightGreyColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: kLightGreyColor),
          borderRadius: BorderRadius.circular(circularBorderRadius),
        ),
        minimumSize: Size(
          minimumSizeWidth,
          minimumSizeHeight,
        ),
        maximumSize: Size(
          maximumSizeWidth,
          maximumSizeHeight,
        ),
      ),
      child: Text(
        buttonTitle,
        style: TextStyle(
          color: kTextGreyColor,
          fontSize: titleFontSize,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
