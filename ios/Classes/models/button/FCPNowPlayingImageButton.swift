//
//  FCPNowPlayingImageButton.swift
//  flutter_carplay
//
//  Created by Michał Wyczarski on 08/12/2022.
//

import CarPlay

@available(iOS 14.0, *)
class FCPNowPlayingImageButton {
  private(set) var _super: CPNowPlayingImageButton?
  private(set) var elementId: String
  private var image: String
  
  init(obj: [String : Any]) {
    self.elementId = obj["_elementId"] as! String
    self.image = obj["image"] as! String
  }
  
  var get: CPNowPlayingImageButton {
      let uiImage = UIImage().fromCorrectSource(name: self.image)
      let nowPlayingImageButton = CPNowPlayingImageButton(image: uiImage, handler: { _ in
          DispatchQueue.main.async {
              FCPStreamHandlerPlugin.sendEvent(type: FCPChannelTypes.onNowPlayingButtonPressed, data: ["elementId": self.elementId])
          }
      })
      
      self._super = nowPlayingImageButton
      return nowPlayingImageButton
  }
}
