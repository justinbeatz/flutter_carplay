//
//  FCPBarButton.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 25.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPBarButton {
  private(set) var _super: CPBarButton?
  private(set) var elementId: String
  private var title: String
  private var button: CPBarButton

  init(obj: [String : Any]) {
    print("FCPBarButton: Initializing with obj=\(obj)")
    self.elementId = obj["_elementId"] as! String
    self.title = obj["title"] as! String
    let systemIcon = obj["systemIcon"] as? String
    let buttonId = self.elementId

    if let icon = systemIcon, !icon.isEmpty {
      print("FCPBarButton: Creating image button with systemIcon=\(icon)")
      if let image = UIImage(systemName: icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)) {
        self.button = CPBarButton(image: image) { _ in
          DispatchQueue.main.async {
            print("FCPBarButton: Button pressed, elementId=\(buttonId)")
            FCPStreamHandlerPlugin.sendEvent(type: FCPChannelTypes.onBarButtonPressed, data: ["elementId": buttonId])
          }
        }
      } else {
        print("FCPBarButton: Failed to load systemIcon=\(icon), falling back to text")
        self.button = CPBarButton(type: .text) { _ in
          DispatchQueue.main.async {
            print("FCPBarButton: Button pressed, elementId=\(buttonId)")
            FCPStreamHandlerPlugin.sendEvent(type: FCPChannelTypes.onBarButtonPressed, data: ["elementId": buttonId])
          }
        }
        self.button.title = title
      }
    } else {
      print("FCPBarButton: Creating text button with title=\(title)")
      self.button = CPBarButton(type: .text) { _ in
        DispatchQueue.main.async {
          print("FCPBarButton: Button pressed, elementId=\(buttonId)")
          FCPStreamHandlerPlugin.sendEvent(type: FCPChannelTypes.onBarButtonPressed, data: ["elementId": buttonId])
        }
      }
      self.button.title = title
    }

    self._super = self.button
  }

  var get: CPBarButton {
    return button
  }
}