import 'package:uuid/uuid.dart';

class CPNowPlayingImageButton {
  /// Unique id of the object.
  final String _elementId = const Uuid().v4();

  /// Fired when the user taps the button.
  final Function() onPress;

  /// Displayed inside the button with a big padding
  /// I recommend using square png icons
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
