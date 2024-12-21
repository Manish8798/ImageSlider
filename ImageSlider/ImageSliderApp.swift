//
//  ImageSliderApp.swift
//  ImageSlider
//
//  Created by Manish kumar on 19/12/24.
//

import SwiftUI

@main
struct ImageSliderApp: App {
    @StateObject var viewModel = ImageViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
