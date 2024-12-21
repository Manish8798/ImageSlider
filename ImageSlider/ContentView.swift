//
//  ContentView.swift
//  ImageSlider
//
//  Created by Manish kumar on 19/12/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel : ImageViewModel
    
    var body: some View {
        VStack {
            StackedSlider(journals: viewModel.photoModelResponse ?? [], initialIndex: 0)
        }
        .padding()
        .onAppear{
            Task {
                await viewModel.getPhotos()
            }
        }
    }
}

#Preview {
    ContentView()
}
