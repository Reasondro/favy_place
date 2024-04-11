import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  //* the final image itself

  //! dont forget to add the extra configs for iOS ! ios/Runner/Info.plist
  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    //* could use camera/gallery ⬆️ . just add more buttons in my UI

    if (pickedImage == null) {
      return;
    }
    // print(pickedImage.path);
    setState(() {
      //? SET STATE IS CRUCIAL TO TELL THE UI TO BE UPDATED
      _selectedImage = File(pickedImage
          .path); //*IMPORTANT to set the image path from the picked image
    });
    widget.onPickImage(_selectedImage!); //! needed for passing the image into the parent(not so parent) widget class PlacesScreen
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: () {
          _takePicture();
        },
        icon: const Icon(Icons.camera_alt),
        label: const Text("Take Picture"));

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: () {
          _takePicture();
        },
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
        decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
        height: 250,
        width: double.infinity,
        alignment: Alignment.center,
        child: content);
  }
}
