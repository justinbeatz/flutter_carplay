import 'package:uuid/uuid.dart';

class CPNowPlayingButton {
  /// Unique id of the object.
  final String _elementId = const Uuid().v4();

  final CPNowPlayingButtonType type;

  /// Displayed inside the button with a big padding
  /// I recommend using square png icons
  final String? image;

  /// Fired when the user taps the button.
  final Function(Function() complete, CPNowPlayingButton self)? onPress;

  CPNowPlayingButton({
    required this.type,
    required this.onPress,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      '_elementId': _elementId,
      'type': type.name,
      if (image != null) 'image': image,
    };
  }

  String get uniqueId {
    return _elementId;
  }
}

enum CPNowPlayingButtonType {
  image,
  shuffle,
  addToLibrary,
  more,
  playbackRate,
  repeatTrack,
}
