import 'package:flutter_carplay/controllers/carplay_controller.dart';
import 'package:uuid/uuid.dart';

class CPNowPlayingButton {
  /// Unique id of the object.
  final String _elementId = const Uuid().v4();

  final CPNowPlayingButtonType type;

  /// SF Symbol
  String? icon;

  /// Fired when the user taps the button.
  final Function(CPNowPlayingButton self)? onPress;

  CPNowPlayingButton({
    required this.type,
    required this.onPress,
    this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      '_elementId': _elementId,
      'type': type.name,
      if (icon != null) 'image': icon,
    };
  }

  String get uniqueId {
    return _elementId;
  }

  void updateIcon(String icon) {
    this.icon = icon;
    FlutterCarPlayController.updateCPNowPlayingButton(this);
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
