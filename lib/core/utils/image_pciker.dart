import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pcikImage(ImageSource source) async {
  try {
    final image = await ImagePicker().pickImage(source: source);

    if (image == null) {
      return null;
    }
    return File(image.path);
  } catch (e) {
    return null;
  }
}
