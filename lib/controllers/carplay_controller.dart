import 'package:flutter/services.dart';
import 'package:flutter_carplay/flutter_carplay.dart';
import 'package:flutter_carplay/helpers/carplay_helper.dart';
import 'package:flutter_carplay/constants/private_constants.dart';
import 'package:flutter_carplay/models/button/now_playing_button.dart';
import 'package:flutter_carplay/models/cp_template.dart';

/// [FlutterCarPlayController] is an root object in order to control and communication
/// system with the Apple CarPlay and native functions.
class FlutterCarPlayController {
  static final FlutterCarplayHelper _carplayHelper = FlutterCarplayHelper();
  static final MethodChannel _methodChannel = MethodChannel(
    _carplayHelper.makeFCPChannelId(),
  );
  static final EventChannel _eventChannel = EventChannel(
    _carplayHelper.makeFCPChannelId(
      event: "/event",
    ),
  );

  /// [CPTabBarTemplate], [CPGridTemplate], [CPListTemplate], [CPIInformationTemplate], [CPPointOfInterestTemplate] in a List
  static List<CPNavigableTemplate> templateHistory = [];

  /// [CPNowPlayingButton] in a List
  static List<CPNowPlayingButton> nowPlayingButtons = [];

  /// [CPTabBarTemplate], [CPGsridTemplate], [CPListTemplate], [CPIInformationTemplate], [CPPointOfInterestTemplate]
  static CPNavigableTemplate? currentRootTemplate;

  /// [CPAlertTemplate], [CPActionSheetTemplate]
  static CPModalTemplate? currentPresentTemplate;

  VoidCallback? _onNowPlayingUpNextPressed;

  MethodChannel get methodChannel {
    return _methodChannel;
  }

  EventChannel get eventChannel {
    return _eventChannel;
  }

  Future<bool> reactToNativeModule(FCPChannelTypes type, dynamic data) async {
    final value = await _methodChannel.invokeMethod(
      CPEnumUtils.stringFromEnum(type.toString()),
      data,
    );
    return value;
  }

  static void updateCPListItem(CPListItem updatedListItem) {
    _methodChannel.invokeMethod(
      'updateListItem',
      <String, dynamic>{...updatedListItem.toJson()},
    ).then((value) {
      if (value) {
        l1:
        for (var h in templateHistory) {
          switch (h.runtimeType) {
            case CPTabBarTemplate:
              for (var t in (h as CPTabBarTemplate).templates) {
                for (var s in t.sections) {
                  for (var i in s.items) {
                    if (i.uniqueId == updatedListItem.uniqueId) {
                      final template = currentRootTemplate as CPTabBarTemplate;
                      template
                          .templates[template.templates.indexOf(t)]
                          .sections[t.sections.indexOf(s)]
                          .items[s.items.indexOf(i)] = updatedListItem;
                      currentRootTemplate = template;
                      break l1;
                    }
                  }
                }
              }
              break;
            case CPListTemplate:
              for (var s in (h as CPListTemplate).sections) {
                for (var i in s.items) {
                  if (i.uniqueId == updatedListItem.uniqueId &&
                      currentRootTemplate is! CPTabBarTemplate) {
                    final template = currentRootTemplate as CPListTemplate;
                    template.sections[template.sections.indexOf(s)]
                        .items[s.items.indexOf(i)] = updatedListItem;
                    currentRootTemplate = template;
                    break l1;
                  }
                }
              }
              break;
            default:
          }
        }
      }
    });
  }

  static void updateCPListTemplateSections(CPListTemplate updatedListTemplate) {
    _methodChannel.invokeMethod(
      'updateListTemplateSections',
      <String, dynamic>{...updatedListTemplate.toJson()},
    ).then((value) {
      if (value) {
        l1:
        for (var h in templateHistory) {
          switch (h.runtimeType) {
            case CPTabBarTemplate:
              for (var t in (h as CPTabBarTemplate).templates) {
                if (t.uniqueId == updatedListTemplate.uniqueId) {
                  final template = currentRootTemplate as CPTabBarTemplate;
                  template.templates[template.templates.indexOf(t)] =
                      updatedListTemplate;
                  currentRootTemplate = template;
                  break l1;
                }
              }
              break;
            default:
          }
        }
      }
    });
  }

  void addTemplateToHistory(dynamic template) {
    if (template is CPNavigableTemplate) {
      templateHistory.add(template);
    } else {
      throw TypeError();
    }
  }

  void setOnNowPlayingUpNextPressed(VoidCallback? callback) {
    _onNowPlayingUpNextPressed = callback;
  }

  void processNowPlayingUpNextPressed() {
    if (_onNowPlayingUpNextPressed != null) {
      _onNowPlayingUpNextPressed!();
    }
  }

  void processFCPListItemSelectedChannel(String elementId) {
    CPListItem? listItem = _carplayHelper.findCPListItem(
      templates: templateHistory,
      elementId: elementId,
    );
    if (listItem != null) {
      listItem.onPress!(
        () => reactToNativeModule(
          FCPChannelTypes.onFCPListItemSelectedComplete,
          listItem.uniqueId,
        ),
        listItem,
      );
    }
  }

  void processFCPAlertActionPressed(String elementId) {
    final template = currentPresentTemplate;
    if (template is! CPAlertTemplate) return;
    CPAlertAction selectedAlertAction = template.actions.firstWhere(
      (e) => e.uniqueId == elementId,
    );
    selectedAlertAction.onPress();
  }

  void processFCPAlertTemplateCompleted(bool completed) {
    final template = currentPresentTemplate;
    if (template is! CPAlertTemplate) return;
    if (template.onPresent != null) {
      template.onPresent!(completed);
    }
  }

  void processFCPGridButtonPressed(String elementId) {
    CPGridButton? gridButton;
    l1:
    for (var t in templateHistory) {
      if (t is CPGridTemplate) {
        for (var b in t.buttons) {
          if (b.uniqueId == elementId) {
            gridButton = b;
            break l1;
          }
        }
      }
    }
    if (gridButton != null) gridButton.onPress();
  }

  void processFCPBarButtonPressed(String elementId) {
    CPBarButton? barButton;
    l1:
    for (var t in templateHistory) {
      if (t is CPListTemplate) {
        barButton = t.backButton;
        break l1;
      }
    }
    if (barButton != null) barButton.onPress();
  }

  void processFCPTextButtonPressed(String elementId) {
    l1:
    for (var t in templateHistory) {
      if (t is CPPointOfInterestTemplate) {
        for (CPPointOfInterest p in t.poi) {
          if (p.primaryButton != null &&
              p.primaryButton!.uniqueId == elementId) {
            p.primaryButton!.onPress();
            break l1;
          }
          if (p.secondaryButton != null &&
              p.secondaryButton!.uniqueId == elementId) {
            p.secondaryButton!.onPress();
            break l1;
          }
        }
      } else {
        if (t is CPInformationTemplate) {
          l2:
          for (CPTextButton b in t.actions) {
            if (b.uniqueId == elementId) {
              b.onPress();
              break l2;
            }
          }
        }
      }
    }
  }

  void processFCPNowPlayingButtonPressed(String elementId) {
    for (var b in nowPlayingButtons) {
      if (b.uniqueId == elementId) {
        b.onPress?.call(b);
        break;
      }
    }
  }
}
