import 'package:happy_dog_house/src/core/utils/app_icon.dart';
import 'package:happy_dog_house/src/core/utils/icon_provider.dart';
import 'package:happy_dog_house/src/core/utils/size_utils.dart';
import 'package:happy_dog_house/ui_kit/animated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onPressed: onPressed,
      child: Container(
         width: getWidth(context, baseSize: 109),
         height: getWidth(context, baseSize: 109),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(IconProvider.roundPlane.buildImageUrl()),
          
          ),
        
        
        ),
        child: Padding(
          padding:  EdgeInsets.all(getWidth(context, baseSize: 24)),
          child: AppIcon(
            asset: IconProvider.plus.buildImageUrl(),
            width: getWidth(context, baseSize: 60),
            height: getWidth(context, baseSize: 60),
          ),
        ),
      ),
    );
  }
}
