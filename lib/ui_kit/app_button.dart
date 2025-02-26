import 'package:happy_dog_house/src/core/utils/icon_provider.dart';
import 'package:happy_dog_house/src/core/utils/text_with_border.dart';
import 'package:happy_dog_house/ui_kit/animated_button.dart';
import 'package:flutter/cupertino.dart';

class AppButton extends StatelessWidget {
  final BColor color;
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double? fontSize;

  const AppButton({
    super.key,
    required this.color,
    required this.onPressed,
    required this.text,
    this.width,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onPressed: onPressed,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              color == BColor.blue
                  ? IconProvider.blue.buildImageUrl()
                  : color == BColor.green
                      ? IconProvider.green.buildImageUrl()
                      : color == BColor.purple
                          ? IconProvider.purple.buildImageUrl()
                          : color == BColor.brown
                              ? IconProvider.brown.buildImageUrl()
                              : IconProvider.red.buildImageUrl(),
            ),
          ),
         
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: TextWithBorder(
              text,
              fontSize: fontSize ?? 30,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

enum BColor {
  green(),
  red(),
  brown(),
  purple(),
  blue();
}
