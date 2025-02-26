import 'package:happy_dog_house/main.dart';
import 'package:happy_dog_house/routes/route_value.dart';
import 'package:happy_dog_house/src/core/utils/app_icon.dart';
import 'package:happy_dog_house/src/core/utils/icon_provider.dart';
import 'package:happy_dog_house/src/core/utils/size_utils.dart';
import 'package:happy_dog_house/src/core/utils/text_with_border.dart';
import 'package:happy_dog_house/src/feature/rituals/bloc/user_bloc.dart';
import 'package:happy_dog_house/src/feature/rituals/model/dog.dart';
import 'package:happy_dog_house/ui_kit/app_app_bar.dart';
import 'package:happy_dog_house/ui_kit/app_button.dart';
import 'package:happy_dog_house/ui_kit/mask_widhget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DetailedScreen extends StatefulWidget {
  final Dog dog;
  const DetailedScreen({super.key, required this.dog});

  @override
  State<DetailedScreen> createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is! UserLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final item = state.dogs.firstWhere((dog) => dog.id == dog.id);
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 140, 16, 180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: getWidth(context, percent: 0.4),
                                  width: getWidth(context, percent: 0.4),
                                  margin: const EdgeInsets.only(right: 8),
                                  child: AppIcon(
                                      asset: item.photo, fit: BoxFit.cover),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: getWidth(context, percent: 0.4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: getWidth(context, percent: 0.31),
                                        child: TextWithBorder(
                                          item.name,
                                          fontSize: 30,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      AppIcon(
                                          asset: item.gender == 'male'
                                              ? IconProvider.male
                                                  .buildImageUrl()
                                              : IconProvider.female
                                                  .buildImageUrl(),
                                          width: 36,
                                          fit: BoxFit.cover),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: getWidth(context, percent: 0.4),
                                    child: TextWithBorder(
                                      'age: ${item.age}',
                                      fontSize: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: getWidth(context, percent: 0.4),
                                    child: TextWithBorder(
                                      'size: ${item.size} cm',
                                      fontSize: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: getWidth(context, percent: 0.4),
                                    child: TextWithBorder(
                                      'weight: ${item.weight} kg',
                                      fontSize: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: getWidth(context, percent: 0.4),
                                    child: TextWithBorder(
                                      '${item.tasks.length} tasks waiting',
                                      fontSize: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          child: Center(
                            child: TextWithBorder(
                              'Breed: ' + item.breed,
                              fontSize: 30,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AppIcon(
                                  asset: IconProvider.error.buildImageUrl(),
                                  width: 30,
                                ),
                                SizedBox(width: 4),
                                TextWithBorder(
                                  'Need Complete ${item.tasks.where((task) => task.isOverdue).length} tasks',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: const AppAppBar(title: 'Detailed')),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.black.withOpacity(0.3700000047683716),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 36),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppButton(
                            width: getWidth(context, baseSize: 105),
                            fontSize: 24,
                            color: BColor.red,
                            onPressed: () {
                              context.read<UserBloc>().add(
                                    RemoveDogEvent(
                                      dogToRemove: widget.dog,
                                    ),
                                  );
                              context.pop();
                            },
                            text: 'Delete',
                          ),
                          AppButton(
                            width: getWidth(context, baseSize: 105),
                            color: BColor.purple,
                            fontSize: 24,
                            onPressed: () {
                              {
                                context.push(
                                  '${RouteValue.home.path}/${RouteValue.detailed.path}/${RouteValue.create.path}',
                                  extra: item,
                                );
                              }
                            },
                            text: 'Edit',
                          ),
                          AppButton(
                            width: getWidth(context, baseSize: 105),
                            color: BColor.brown,
                            fontSize: 24,
                            onPressed: () {
                              {
                                context.push(
                                  '${RouteValue.home.path}/${RouteValue.detailed.path}/${RouteValue.gallery.path}',
                                  extra: item,
                                );
                              }
                            },
                            text: 'Gallery',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButton(
                            width: getWidth(context, percent: 0.4),
                            color: BColor.green,
                            fontSize: 24,
                            onPressed: () {
                              {
                                context.push(
                                  '${RouteValue.home.path}/${RouteValue.detailed.path}/${RouteValue.task.path}',
                                  extra: item,
                                );
                              }
                            },
                            text: 'Tasks',
                          ),
                          const SizedBox(width: 8),
                          AppButton(
                            width: getWidth(context, percent: 0.4),
                            color: BColor.blue,
                            fontSize: 24,
                            onPressed: () {
                              {
                                context.push(
                                  '${RouteValue.home.path}/${RouteValue.detailed.path}/${RouteValue.vactination.path}',
                                  extra: item,
                                );
                              }
                            },
                            text: 'Vaccinate',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!isDetailed)
              MaskWidhget(
                screen: Screen.Detailed,
                setState: () => setState(
                  () {
                    isDetailed = true;
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
