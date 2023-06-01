import 'package:uuid/uuid.dart';

/// A grid button object displayed on a grid template.
class CPGridButton {
  /// Unique id of the object.
  final String _elementId = const Uuid().v4();

  /// An array of title variants for the button.
  /// When the system displays the button, it selects the title that best fits the available
  /// screen space, so arrange the titles from most to least preferred when creating a grid button.
  /// Also, localize each title for display to the user, and **be sure to include at least
  /// one title in the array.**
  final List<String> titleVariants;

  /// Image file path, URL or XCode asset path
  final String image;

  /// Fired after the user taps the button.
  final Function() onPress;

  CPGridButton({
    required this.titleVariants,
    required this.image,
    required this.onPress,
  });

  Map<String, dynamic> toJson() => {
        "_elementId": _elementId,
        "titleVariants": titleVariants,
        "image": image,
      };

  String get uniqueId {
    return _elementId;
  }
}
