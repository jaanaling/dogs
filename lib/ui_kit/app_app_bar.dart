import 'package:happy_dog_house/src/core/utils/app_icon.dart';
import 'package:happy_dog_house/src/core/utils/icon_provider.dart';
import 'package:happy_dog_house/src/core/utils/size_utils.dart';
import 'package:happy_dog_house/src/core/utils/text_with_border.dart';
import 'package:happy_dog_house/ui_kit/animated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppAppBar extends StatelessWidget {
  final String title;

  const AppAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          AnimatedButton(
            onPressed: () {
              context.pop();
            },
            child: Container(
              height: getWidth(context, percent: 0.2),
              width: getWidth(context, percent: 0.2),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(IconProvider.roundPlane.buildImageUrl()),
                  fit: BoxFit.fill,
                ),
              ),
              child: Padding(
                padding:  EdgeInsets.all(getWidth(context,baseSize: 16)),
                child: AppIcon(
                  asset: IconProvider.back.buildImageUrl(),
                  width:  getWidth(context, baseSize: 40),
                ),
              ),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(IconProvider.topPlane.buildImageUrl()),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: getWidth(context, baseSize: 60), vertical: 16),
              child: TextWithBorder(
                title,
              ),
            ),
          ),
          Spacer(
            flex: 2,
          )
        ],
      ),
    );
  }
}
