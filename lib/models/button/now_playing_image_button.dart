import 'package:uuid/uuid.dart';

class CPNowPlayingImageButton {
  /// Unique id of the object.
  final String _elementId = const Uuid().v4();

  final Function() onPress;

  final String image;

  CPNowPlayingImageButton({required this.onPress, required this.image});

  Map<String, dynamic> toJson() => {
        "_elementId": _elementId,
        "image": image,
      };

  String get uniqueId {
    return _elementId;
  }
}
