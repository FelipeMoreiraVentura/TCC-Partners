import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';

Future<Uint8List?> pickImage() async {
  const XTypeGroup typeGroup = XTypeGroup(
    label: 'images',
    extensions: <String>['jpg', 'jpeg', 'png'],
  );

  final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);

  if (file != null) {
    return await file.readAsBytes();
  } else {
    return null;
  }
}
