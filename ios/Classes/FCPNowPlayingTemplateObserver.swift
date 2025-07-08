//
//  FCPNowPlayingTemplateObserver.swift
//  flutter_carplay
//
//  Created by Michał Wyczarski on 08/12/2022.
//

import CarPlay

class FCPNowPlayingTemplateObserver: NSObject, CPNowPlayingTemplateObserver {
    static let sharedInstance = FCPNowPlayingTemplateObserver()

    override
    private init() {
        super.init()
    }

    func nowPlayingTemplateUpNextButtonTapped(_ nowPlayingTemplate: CPNowPlayingTemplate) {
        DispatchQueue.main.async {
            FCPStreamHandlerPlugin.sendEvent(type: FCPChannelTypes.onNowPlayingUpNextPressed,
                                             data: [:])
        }

    }

    func nowPlayingTemplateAlbumArtistButtonTapped(_ nowPlayingTemplate: CPNowPlayingTemplate) {

    }
}
