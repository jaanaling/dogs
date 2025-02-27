import 'package:happy_dog_house/main.dart';
import 'package:happy_dog_house/src/core/utils/app_icon.dart';
import 'package:happy_dog_house/src/core/utils/icon_provider.dart';
import 'package:happy_dog_house/src/core/utils/size_utils.dart';
import 'package:happy_dog_house/src/core/utils/text_with_border.dart';
import 'package:happy_dog_house/src/feature/rituals/bloc/user_bloc.dart';
import 'package:happy_dog_house/src/feature/rituals/model/dog.dart';

import 'package:happy_dog_house/ui_kit/animated_button.dart';
import 'package:happy_dog_house/ui_kit/app_button.dart';
import 'package:happy_dog_house/ui_kit/mask_widhget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateScreen extends StatefulWidget {
  final Dog? dog;
  const CreateScreen({super.key, this.dog});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  TextEditingController nameControllerForm = TextEditingController();
  TextEditingController sizeControllerForm = TextEditingController();
  TextEditingController widthControllerForm = TextEditingController();
  TextEditingController ageControllerForm = TextEditingController();
  TextEditingController breedControllerForm = TextEditingController();

  String gender = 'male';
  String? imageForm;
  String errorText = '';

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    isEdit = widget.dog != null;

    if (isEdit) {
      nameControllerForm.text = widget.dog!.name;
      sizeControllerForm.text = widget.dog!.size.toString();
      widthControllerForm.text = widget.dog!.weight.toString();
      ageControllerForm.text = widget.dog!.age.toString();
      breedControllerForm.text = widget.dog!.breed;
      gender = widget.dog!.gender;
      imageForm = widget.dog?.photo;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageForm = pickedFile?.path;
    });
  }

  void saveDog(BuildContext context) {
    final bloc = context.read<UserBloc>();
    final newDog = Dog(
      id: isEdit ? widget.dog!.id : DateTime.now().toString(),
      photo: imageForm!,
      name: nameControllerForm.text,
      size: double.parse(sizeControllerForm.text),
      weight: double.parse(widthControllerForm.text),
      age: int.parse(ageControllerForm.text),
      breed: breedControllerForm.text,
      gender: gender,
      tasks: widget.dog?.tasks ?? [],
      taskHistory: widget.dog?.taskHistory ?? [],
      gallery: widget.dog?.gallery ?? [],
      vaccinations: widget.dog?.vaccinations ?? [],
    );
    if (isEdit) {
      bloc.add(UpdateDogEvent(dogToUpdate: newDog));
    } else {
      bloc.add(CreateDogEvent(newDog: newDog));
    }

    clear();
  }

  void clear() {
    nameControllerForm.clear();
    sizeControllerForm.clear();
    widthControllerForm.clear();
    ageControllerForm.clear();
    breedControllerForm.clear();

    imageForm = null;

    context.pop();
    if (isEdit) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is! UserLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedButton(
                        onPressed: pickImage,
                        child: Container(
                          height: getWidth(context, percent: 0.3),
                          width: getWidth(context, percent: 0.3),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  IconProvider.mainPlane.buildImageUrl()),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.all(imageForm == null ?  getWidth(context, baseSize: 18.0)  : 0),
                            child: AppIcon(
                              asset: imageForm ??
                                  IconProvider.photo.buildImageUrl(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      TextWithBorder(
                        "Upload photo",
                        textAlign: TextAlign.center,
                        
                          fontSize: 32,
                     
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: getWidth(context, percent: 0.7),
                        child: TextFieldWithDropdown(
                          controller: breedControllerForm,
                        ),
                      ),
                      AnimatedButton(
                        onPressed: () {
                          setState(() {
                            gender = gender == 'male' ? 'female' : 'male';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  IconProvider.mainPlane.buildImageUrl()),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Padding(
                            padding:  EdgeInsets.all(getWidth(context,baseSize: 18)),
                            child: AppIcon(
                              asset: gender == 'male'
                                  ? IconProvider.male.buildImageUrl()
                                  : IconProvider.female.buildImageUrl(),
                              fit: BoxFit.cover,
                              width: getWidth(context,baseSize: 40),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: nameControllerForm,
                    title: 'Name',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: getWidth(context, percent: 0.3),
                        child: AppTextField(
                          controller: sizeControllerForm,
                          keyboardType: TextInputType.number,
                          title: 'cm',
                        ),
                      ),
                      SizedBox(
                        width: getWidth(context, percent: 0.3),
                        child: AppTextField(
                          controller: widthControllerForm,
                          keyboardType: TextInputType.number,
                          title: 'kg',
                        ),
                      ),
                      SizedBox(
                        width: getWidth(context, percent: 0.3),
                        child: AppTextField(
                          controller: ageControllerForm,
                          keyboardType: TextInputType.number,
                          title: 'age',
                        ),
                      ),
                    ],
                  ),
                  if (errorText.isNotEmpty)
                    Row(
                      children: [
                        AppIcon(
                          asset: IconProvider.error.buildImageUrl(),
                          width: 40,
                        ),
                        TextWithBorder(
                          errorText,
                          fontSize: 20,
                        ),
                      ],
                    ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppButton(
                          color: BColor.green,
                          onPressed: () {
                            {
                              errorText = '';
                              if (nameControllerForm.text.isEmpty) {
                                errorText = 'Need add name!';
                              }
                              if (sizeControllerForm.text.isEmpty) {
                                errorText = 'Need add size!';
                              }
                              if (widthControllerForm.text.isEmpty) {
                                errorText = 'Need add weight!';
                              }
                              if (ageControllerForm.text.isEmpty) {
                                errorText = 'Need add age!';
                              }
                              if (breedControllerForm.text.isEmpty) {
                                errorText = 'Need add breed!';
                              }
                              if (imageForm == null) {
                                errorText = 'Need add photo!';
                              }

                              setState(() {});
                              if (errorText.isEmpty) saveDog(context);
                            }
                          },
                          width: getWidth(context, percent: 0.3),
                          text: 'Save',
                        ),
                        const SizedBox(height: 8),
                        AppButton(
                          width: getWidth(context, percent: 0.3),
                          color: BColor.red,
                          onPressed: () {
                            {
                              clear();
                            }
                          },
                          text: 'Close',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!isCreate)
              MaskWidhget(
                screen: Screen.Create,
                setState: () => setState(
                  () {
                    isCreate = true;
                  },
                ),
              )
          ],
        );
      },
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.title,
    this.focusNode,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String title;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextWithBorder(
          title,
          textAlign: TextAlign.center,
          fontSize: getWidth(context,baseSize: 30),
        ),
        const SizedBox(height: 8),
        CupertinoTextField(
          focusNode: focusNode,
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 24, fontFamily: "Bur", color: const Color.fromARGB(255, 63, 58, 16)),
          textAlign: TextAlign.center,
          padding: EdgeInsets.symmetric(vertical:getWidth(context,baseSize: 18)),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(keyboardType == TextInputType.number
                  ? IconProvider.subField.buildImageUrl(): IconProvider.mainField.buildImageUrl()),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}

class TextFieldWithDropdown extends StatefulWidget {
  final TextEditingController controller;
  const TextFieldWithDropdown({super.key, required this.controller});

  @override
  _TextFieldWithDropdownState createState() => _TextFieldWithDropdownState();
}

class _TextFieldWithDropdownState extends State<TextFieldWithDropdown> {
  List<String> _filteredItems = [];
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
    widget.controller.addListener(_filterItems);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  void _filterItems() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, size.height + 5),
          child: Positioned(
            left: renderBox.localToGlobal(Offset.zero).dx,
            top: renderBox.localToGlobal(Offset(0, size.height + 5)).dy,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(IconProvider.mainPlane.buildImageUrl()),
                  fit: BoxFit.fill,
                ),
              ),
              constraints: BoxConstraints(maxHeight: 190),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return Center(
                    child: AnimatedButton(
                        onPressed: () {
                          widget.controller.text = _filteredItems[index];
                          _focusNode.unfocus();
                          _removeOverlay();
                        },
                        child: TextWithBorder(
                          _filteredItems[index],
                          textAlign: TextAlign.center,
                          fontSize: 24,
                        )),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.removeListener(_filterItems);
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: AppTextField(
        controller: widget.controller,
        focusNode: _focusNode,
        title: "breed",
      ),
    );
  }
}

List<String> _allItems = [
  "Affenpinscher",
  "Afghan Hound",
  "Airedale Terrier",
  "Akita",
  "Alaskan Malamute",
  "American Bulldog",
  "American Cocker Spaniel",
  "American Eskimo Dog",
  "American Foxhound",
  "American Staffordshire Terrier",
  "American Water Spaniel",
  "Anatolian Shepherd Dog",
  "Australian Cattle Dog",
  "Australian Shepherd",
  "Australian Terrier",
  "Basenji",
  "Basset Hound",
  "Beagle",
  "Bearded Collie",
  "Beauceron",
  "Bedlington Terrier",
  "Belgian Malinois",
  "Belgian Sheepdog",
  "Belgian Tervuren",
  "Bernese Mountain Dog",
  "Bichon Frise",
  "Black and Tan Coonhound",
  "Black Russian Terrier",
  "Bloodhound",
  "Border Collie",
  "Border Terrier",
  "Borzoi",
  "Boston Terrier",
  "Bouvier des Flandres",
  "Boxer",
  "Boykin Spaniel",
  "Bracco Italiano",
  "Briard",
  "Brittany",
  "Bulldog",
  "Bull Terrier",
  "Cairn Terrier",
  "Canaan Dog",
  "Cavalier King Charles Spaniel",
  "Chihuahua",
  "Chinese Crested",
  "Chow Chow",
  "Clumber Spaniel",
  "Cockapoo",
  "Cocker Spaniel",
  "Collie",
  "Coonhound",
  "Corgi",
  "Cotton de Tulear",
  "Curly-Coated Retriever",
  "Dachshund",
  "Dalmatian",
  "Dandie Dinmont Terrier",
  "Doberman Pinscher",
  "Dogo Argentino",
  "Dutch Shepherd",
  "English Bulldog",
  "English Cocker Spaniel",
  "English Setter",
  "English Springer Spaniel",
  "Entlebucher Mountain Dog",
  "Field Spaniel",
  "Finnish Lapphund",
  "Finnish Spitz",
  "Flat-Coated Retriever",
  "French Bulldog",
  "German Pinscher",
  "German Shepherd",
  "Giant Schnauzer",
  "Glen of Imaal Terrier",
  "Goldador",
  "Golden Retriever",
  "Goldendoodle",
  "Gordon Setter",
  "Great Dane",
  "Great Pyrenees",
  "Greater Swiss Mountain Dog",
  "Greyhound",
  "Havanese",
  "Irish Setter",
  "Irish Terrier",
  "Irish Water Spaniel",
  "Italian Greyhound",
  "Jack Russell Terrier",
  "Japanese Chin",
  "Keeshond",
  "Kerry Blue Terrier",
  "King Charles Spaniel",
  "Klee Kai",
  "Labrador Retriever",
  "Lakeland Terrier",
  "Lhasa Apso",
  "Louisiana Catahoula Leopard Dog",
  "Maltese",
  "Manchester Terrier",
  "Maremma Sheepdog",
  "Mastiff",
  "Miniature Bull Terrier",
  "Miniature Pinscher",
  "Miniature Schnauzer",
  "Neapolitan Mastiff",
  "Newfoundland",
  "Norfolk Terrier",
  "Norwegian Elkhound",
  "Norwegian Lundehund",
  "Old English Sheepdog",
  "Otterhound",
  "Papillon",
  "Parson Russell Terrier",
  "Pekingese",
  "Pembroke Welsh Corgi",
  "Petit Basset Griffon Vendéen",
  "Pharaoh Hound",
  "Plott",
  "Pointer",
  "Polish Lowland Sheepdog",
  "Pomeranian",
  "Portuguese Water Dog",
  "Pugs",
  "Puli",
  "Pumi",
  "Rat Terrier",
  "Redbone Coonhound",
  "Rhodesian Ridgeback",
  "Rottweiler",
  "Saint Bernard",
  "Saluki",
  "Samoyed",
  "Schipperke",
  "Schnauzer",
  "Scottish Terrier",
  "Sealyham Terrier",
  "Setter",
  "Shiba Inu",
  "Shih Tzu",
  "Siberian Husky",
  "Silky Terrier",
  "Skye Terrier",
  "Sloughi",
  "Spaniel",
  "Spanish Water Dog",
  "Spinone Italiano",
  "Staffordshire Bull Terrier",
  "Standard Schnauzer",
  "Sussex Spaniel",
  "Swedish Vallhund",
  "Tibetan Mastiff",
  "Tibetan Spaniel",
  "Toy Fox Terrier",
  "Toy Poodle",
  "Vizsla",
  "Weimaraner",
  "Welsh Springer Spaniel",
  "West Highland White Terrier",
  "Whippet",
  "Wire Fox Terrier",
  "Wirehaired Pointing Griffon",
  "Xoloitzcuintli",
  "Yorkshire Terrier",
  "Zuchon",
  "Azawakh",
  "Catahoula Leopard Dog",
  "Bolognese",
  "Chinook",
  "German Shorthaired Pointer",
  "Japanese Spitz",
  "Hound",
  "Basset Fauve de Bretagne",
  "American Hairless Terrier",
  "Belgian Laekenois",
  "Italian Spinone",
  "Australian Kelpie",
  "Alaskan Klee Kai",
  "Briquet Griffon Vendéen",
  "American Akita",
  "Chesapeake Bay Retriever",
  "American Wirehair",
  "Anatolian Shepherd",
  "Beckoning Spaniel",
  "Bergamasco Sheepdog",
  "Biewer Terrier",
  "Brittany Spaniel",
  "American Bull Terrier",
  "Brussels Griffon",
  "Shiba Inu"
];
