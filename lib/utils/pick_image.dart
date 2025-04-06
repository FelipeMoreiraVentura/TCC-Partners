import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

Future<Uint8List?> pickImage() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );
  if (result != null) {
    return result.files.single.bytes!;
  } else {
    return null;
  }
}
