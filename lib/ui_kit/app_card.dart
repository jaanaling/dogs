import 'package:flutter/material.dart';
import 'package:happy_dog_house/src/core/utils/icon_provider.dart';

class AppCard extends StatelessWidget {
  final Widget? child;
  const AppCard({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(IconProvider.mainPlane.buildImageUrl()),
            fit: BoxFit.fill,
          ),
      
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: child,
        ),
      ),
    );
  }
}
