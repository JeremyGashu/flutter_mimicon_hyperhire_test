import 'dart:io';
import 'dart:math' as math;

import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

Future savePictureToFile(WidgetsToImageController imageController) async {
  final bytes = await imageController.capture();
  if (bytes != null) {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = await File(
            '${directory.path}/mimicon_${math.Random().nextDouble()}.png')
        .create();
    await imagePath.writeAsBytes(bytes);
    if (Platform.isAndroid) {
      Gal.putImage(imagePath.path);
    } else {
      await Share.shareXFiles([XFile(imagePath.path)]);
    }
  }
}
