//
//  FCPNowPlayingImageButton.swift
//  flutter_carplay
//
//  Created by Michał Wyczarski on 08/12/2022.
//

import CarPlay

@available(iOS 14.0, *)
class FCPNowPlayingButton {
  private(set) var _super: CPNowPlayingButton?
  private(set) var elementId: String
  private(set) var type: FCPNowPlayingButtonType
  private var image: String?
  
  init(obj: [String : Any]) {
    self.elementId = obj["_elementId"] as! String
    self.type = FCPNowPlayingButtonType(rawValue: obj["type"] as! String) ?? FCPNowPlayingButtonType.shuffle
    self.image = obj["image"] as? String
  }
  
  var get: CPNowPlayingButton {
      var button : CPNowPlayingButton
      let handler : ((CPNowPlayingButton) -> Void) = { _ in
          DispatchQueue.main.async {
              FCPStreamHandlerPlugin.sendEvent(type: FCPChannelTypes.onNowPlayingButtonPressed, data: ["elementId": self.elementId])
          }
      }
      
      switch type {
      case .shuffle: button = CPNowPlayingShuffleButton(handler: handler)
      case .repeatTrack: button = CPNowPlayingRepeatButton(handler: handler)
      case .addToLibrary: button = CPNowPlayingAddToLibraryButton(handler: handler)
      case .more: button = CPNowPlayingMoreButton(handler: handler)
      case .playbackRate: button = CPNowPlayingPlaybackRateButton(handler: handler)
      case .image:
          let uiImage = UIImage(systemName: image ?? "square")?.resizeImageTo(size: CPNowPlayingButtonMaximumImageSize)
          if (image != nil) {
              button = CPNowPlayingImageButton(image: uiImage!, handler: handler)
          } else {
              button = CPNowPlayingImageButton(handler: handler)
          }
          
      }
      
      self._super = button
      return button
  }
}
