import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:happy_dog_house/src/core/utils/app_icon.dart';
import 'package:happy_dog_house/src/core/utils/icon_provider.dart';
import 'package:happy_dog_house/src/core/utils/size_utils.dart';
import 'package:happy_dog_house/src/core/utils/text_with_border.dart';
import 'package:happy_dog_house/src/feature/rituals/bloc/user_bloc.dart';
import 'package:happy_dog_house/src/feature/rituals/model/dog.dart';
import 'package:happy_dog_house/src/feature/rituals/model/vaccination.dart';
import 'package:happy_dog_house/src/feature/rituals/presentation/create_screen.dart';
import 'package:happy_dog_house/ui_kit/add_button.dart';
import 'package:happy_dog_house/ui_kit/app_app_bar.dart';
import 'package:happy_dog_house/ui_kit/app_button.dart';
import 'package:happy_dog_house/ui_kit/app_card.dart';

class VactinationScreen extends StatelessWidget {
  final Dog dog;

  const VactinationScreen({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is! UserLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final item = state.dogs.firstWhere((dog) => dog.id == dog.id);
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Column(
              children: [
                const AppAppBar(title: 'Vactination'),
                Expanded(
                  child: ListView.separated(
                    itemCount: item.vaccinations.length, // Пример
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final task = item.vaccinations[index];
                      return Stack(
                        children: [
                          AppCard(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWithBorder(task.name),
                                  TextWithBorder(task.description),
                                  TextWithBorder(
                                    '${DateTime.now().difference(DateTime.parse(task.date)).inDays} Days ago',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 20,
                            child: AppButton(
                              color: BColor.red,
                              fontSize: 20,
                              width: getWidth(context, percent: 0.3),
                              onPressed: () {
                                {
                                  context.read<UserBloc>().add(UpdateDogEvent(
                                          dogToUpdate: item.copyWith(
                                        vaccinations: item.vaccinations
                                            .where((element) =>
                                                element.name != task.name)
                                            .toList(),
                                      )));
                                }
                              },
                              text: 'Delete',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              child: AddButton(
                onPressed: () {
                  _showAlertDialog(context, dog);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

void _showAlertDialog(
  BuildContext context,
  Dog dog,
) {
  String errorText = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context).removeViewInsets(removeBottom: true),
        child: Dialog(
          child: StatefulBuilder(
            builder: (context, StateSetter setState) => Container(
              height: getHeight(context, percent: 0.85),
              width: double.infinity,
              decoration: ShapeDecoration(
                gradient: const RadialGradient(
                  center: Alignment(0, 1),
                  radius: 0,
                  colors: [Colors.white, Color(0xFFFFF0D4)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36),
                ),
                shadows: [
                  const BoxShadow(
                    color: Color(0x7F000000),
                    blurRadius: 0,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      controller: nameController,
                      title: 'Enter title',
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: descController,
                      title: 'description',
                    ),
                    if (errorText.isNotEmpty)
                      Row(
                        children: [
                          AppIcon(
                            asset: IconProvider.error.buildImageUrl(),
                            width: 40,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorText,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppButton(
                          width: getWidth(context, percent: 0.3),
                          color: BColor.green,
                          onPressed: () {
                            errorText = '';
                            if (nameController.text.isEmpty) {
                              errorText = 'Need add title!';
                            }
                            setState(() {});
                            if (errorText.isEmpty) {
                              context.read<UserBloc>().add(UpdateDogEvent(
                                      dogToUpdate: dog.copyWith(
                                    vaccinations: [
                                      ...dog.vaccinations,
                                      Vaccination(
                                        name: nameController.text,
                                        description: descController.text,
                                        date: DateTime.now().toString(),
                                      ),
                                    ],
                                  )));

                              context.pop();
                            }
                          },
                          text: 'Save',
                        ),
                        AppButton(
                            width: getWidth(context, percent: 0.3),
                            color: BColor.red,
                            onPressed: () {
                              context.pop();
                            },
                            text: "Close")
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
