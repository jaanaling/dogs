import 'package:happy_dog_house/src/core/utils/app_icon.dart';
import 'package:happy_dog_house/src/core/utils/icon_provider.dart';
import 'package:happy_dog_house/src/core/utils/size_utils.dart';
import 'package:happy_dog_house/ui_kit/app_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaskWidhget extends StatelessWidget {
  final Screen screen;
  final VoidCallback setState;
  const MaskWidhget({super.key, required this.screen, required this.setState});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Container(
        color: Colors.black.withOpacity(0.7799999833106995),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
      ),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              Gap(
                MediaQuery.of(context).size.height * 0.147 -
                    MediaQuery.of(context).padding.top,
              ),
              Gap(10),
              Text(
                screen.text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: -(MediaQuery.of(context).size.height * 0.108),
        left: screen == Screen.Create ? 0 : null,
        right: screen == Screen.Detailed ? 0 : null,
        child: AppIcon(
          asset: screen == Screen.Home
              ? IconProvider.dog1.buildImageUrl()
              : screen == Screen.Create
                  ? IconProvider.dog2.buildImageUrl()
                  : screen == Screen.Detailed
                      ? IconProvider.dog3.buildImageUrl()
                      : IconProvider.dog1.buildImageUrl(),
          height: MediaQuery.of(context).size.height * 0.73,
        ),
      ),
      Positioned(
        bottom: 0,
        child: Padding(
          padding: EdgeInsets.only(bottom: 40),
          child: AppButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool(screen.code, true);
              setState();
            },
            width: getWidth(context, percent: 0.4),
            color: BColor.green,
            text: "Let's go!",
          ),
        ),
      ),
    ]);
  }
}

enum Screen {
  Chicken(
      "Woof woof! Here you’ll find all my furry friends. But hey, where’s my buddy? Tap the plus button to bring in a new doggo!",
      "isChicken"),
  Create(
      "Time to add a new pup. Give them a name, pick their size, and don’t forget a cute photo. Oh, and make sure to let everyone know who the best doggo is (hint: it’s me)!",
      "isCreate"),
  Detailed(
      "This is where you see all my important details—like how amazing I am! Keep up with my needs, complete tasks, and I’ll reward you with tail wags and happy barks!",
      "isDetailed"),
  Home(
      "Welcome to the doghouse! Woof woof! Here you’ll find all my furry friends. But hey, where’s my buddy? Tap the plus button to bring in a new doggo!",
      "isHome"),
  Task(
      "Time to get things done! Mark tasks as complete so I know when it’s walk time, snack time, or belly rub time. Switch tabs to see what’s next!",
      "isTask");

  final String text;
  final String code;
  const Screen(this.text, this.code);
}
