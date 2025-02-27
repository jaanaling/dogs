import 'package:flutter/material.dart';
import 'package:happy_dog_house/src/core/utils/icon_provider.dart';

import '../src/core/utils/size_utils.dart';

class AppCard extends StatelessWidget {
  final Widget? child;
  const AppCard({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: getWidth(context, baseSize: 8)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(IconProvider.mainPlane.buildImageUrl()),
            fit: BoxFit.fill,
          ),
      
        ),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: getWidth(context, baseSize: 12), vertical: 16),
          child: child,
        ),
      ),
    );
  }
}
