import 'dart:io';

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
import 'package:happy_dog_house/src/feature/rituals/model/gallery.dart';
import 'package:happy_dog_house/src/feature/rituals/presentation/create_screen.dart';
import 'package:happy_dog_house/ui_kit/add_button.dart';
import 'package:happy_dog_house/ui_kit/animated_button.dart';
import 'package:happy_dog_house/ui_kit/app_app_bar.dart';
import 'package:happy_dog_house/ui_kit/app_button.dart';
import 'package:image_picker/image_picker.dart';

class GalleryScreen extends StatelessWidget {
  final Dog dog;
  const GalleryScreen({super.key, required this.dog});

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
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 140),
                    itemCount: item.gallery.length + 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Количество столбцов
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      return index == item.gallery.length ||
                              item.gallery.length == 0
                          ? AddButton(
                              onPressed: () => _showAlertDialog(context, item),
                            )
                          : Column(children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        AppIcon(
                                          asset: item.gallery[index].image,
                                          fit: BoxFit.cover,
                                          width: getWidth(context, percent: 0.3),
                                          height: getWidth(context, percent: 0.3),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: AppButton(
                                            color: BColor.red,
                                            fontSize: 16,
                                            width:
                                                getWidth(context, percent: 0.1),
                                            onPressed: () {
                                              {
                                                context.read<UserBloc>().add(
                                                        UpdateDogEvent(
                                                            dogToUpdate:
                                                                item.copyWith(
                                                      gallery: item.gallery
                                                          .where((element) =>
                                                              element !=
                                                              item.gallery[
                                                                  index])
                                                          .toList(),
                                                    )));
                                              }
                                            },
                                            text: 'X',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextWithBorder(item.gallery[index].name)
                            ]);
                    },
                  ),
                ),
              ],
            ),
            const AppAppBar(title: 'Gallery'),
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
  String? image;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    image = pickedFile?.path;
  }

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
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Stack(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: AnimatedButton(
                                  onPressed: () async {
                                    await pickImage();
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: getWidth(context, percent: 0.3),
                                    width: getWidth(context, percent: 0.3),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(IconProvider.mainPlane
                                            .buildImageUrl()),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          image == null ? 18.0 : 0),
                                      child: AppIcon(
                                        asset: image ??
                                            IconProvider.photo.buildImageUrl(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    AppTextField(
                      controller: nameController,
                      title: 'Enter title',
                    ),
                    const SizedBox(height: 8),
                 
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
                            if (image == null) {
                              errorText = 'Need add image!';
                            }
                            setState(() {});
                            if (errorText.isEmpty) {
                              context.read<UserBloc>().add(UpdateDogEvent(
                                      dogToUpdate: dog.copyWith(
                                    gallery: [
                                      ...dog.gallery,
                                      Gallery(
                                          image: image!,
                                          name: nameController.text,
                                          description: descController.text)
                                    ],
                                  )));
                              ;

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
