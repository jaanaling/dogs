import 'package:gap/gap.dart';
import 'package:happy_dog_house/main.dart';
import 'package:happy_dog_house/routes/go_router_config.dart';
import 'package:happy_dog_house/routes/route_value.dart';
import 'package:happy_dog_house/src/core/utils/app_icon.dart';
import 'package:happy_dog_house/src/core/utils/icon_provider.dart';
import 'package:happy_dog_house/src/core/utils/size_utils.dart';
import 'package:happy_dog_house/src/core/utils/text_with_border.dart';
import 'package:happy_dog_house/src/feature/rituals/bloc/user_bloc.dart';
import 'package:happy_dog_house/ui_kit/add_button.dart';
import 'package:happy_dog_house/ui_kit/animated_button.dart';
import 'package:happy_dog_house/ui_kit/app_card.dart';
import 'package:happy_dog_house/ui_kit/mask_widhget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is! UserLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120, top: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.dogs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: AppCard(
                          child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 36),
                        child: Center(child: TextWithBorder("No dog yet")),
                      )),
                    )
                  else
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: state.dogs.length, // к примеру
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final dog = state.dogs[index];
                        return AnimatedButton(
                          onPressed: () {
                            {
                              context.push(
                                "${RouteValue.home.path}/${RouteValue.detailed.path}",
                                extra: state.dogs[index],
                              );
                            }
                          },
                          child: AppCard(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(IconProvider
                                                .mainPlane
                                                .buildImageUrl()),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: Container(
                                          height:
                                              getWidth(context, percent: 0.2),
                                          width:
                                              getWidth(context, percent: 0.2),
                                         
                                          child: AppIcon(
                                              asset: dog.photo,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      Gap(16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextWithBorder(dog.name),
                                            TextWithBorder(
                                                "Size: " + dog.size.toString()),
                                            TextWithBorder("Weight: " +
                                                dog.weight.toString()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      AppIcon(
                                          asset: IconProvider.error
                                              .buildImageUrl(),
                                              width: 60,
                                          fit: BoxFit.cover),
                                      TextWithBorder(
                                          '${dog.tasks.length} Tasks waiting\n ${dog.tasks.where((task) => task.isOverdue).length} Tasks overdue'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              child: AddButton(
                onPressed: () {
                  context.push(
                      "${RouteValue.home.path}/${RouteValue.create.path}");
                },
              ),
            ),
            if (!isHome)
              MaskWidhget(
                screen: Screen.Home,
                setState: () => setState(
                  () {
                    isHome = true;
                  },
                ),
              )
          ],
        );
      },
    );
  }
}
