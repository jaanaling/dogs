enum IconProvider {
   error(imageName: 'error.png'),
  back(imageName: 'back.png'),
  background(imageName: 'background.png'),
  blue(imageName: 'blue.png'),
  brown(imageName: 'brown.png'),
  dog1(imageName: 'dog1.png'),
  dog2(imageName: 'dog2.png'),
  dog3(imageName: 'dog3.png'),
  female(imageName: 'female.png'),
  frame(imageName: 'frame.png'),
  green(imageName: 'green.png'),
  mainField(imageName: 'main_field.png'),
  mainPlane(imageName: 'main_plane.png'),
  male(imageName: 'male.png'),
  noPhoto(imageName: 'no_photo.png'),
  photo(imageName: 'photo.png'),
  plus(imageName: 'plus.png'),
  purple(imageName: 'purple.png'),
  red(imageName: 'red.png'),
  roundPlane(imageName: 'round_plane.png'),
  splash(imageName: 'splash.png'),
  subField(imageName: 'sub_field.png'),
  topPlane(imageName: 'top_plane.png'),

  unknown(imageName: '');

  const IconProvider({
    required this.imageName,
  });

  final String imageName;
  static const _imageFolderPath = 'assets/images';

  String buildImageUrl() => '$_imageFolderPath/$imageName';
  static String buildImageByName(String name) => '$_imageFolderPath/$name';
}
