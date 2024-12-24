//
//  StackedSlider.swift
//  ImageSlider
//
//  Created by Manish kumar on 21/12/24.
//

import SwiftUI
import Kingfisher
import UIKit

struct StackedSlider: View {
    let journals: PhotoModel
    let initialIndex: Int
    
    @State private var currentIndex: Int
    @State private var translation: CGFloat = 0
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel : ImageViewModel
    @State private var backgroundColor: Color = Color.black.opacity(0.8)
    
    // Add initializer
    init(journals: PhotoModel, initialIndex: Int = 0) {
        self.journals = journals
        self.initialIndex = initialIndex
        // Initialize the @State variable
        _currentIndex = State(initialValue: initialIndex)
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
//                Color(.black).opacity(0.8)
//                    .ignoresSafeArea(.all)
                
                backgroundColor  // Use the @State variable instead of static Color
                        .ignoresSafeArea(.all)
                
                VStack {
                    
//                    Button(action: {
//                        dismiss()
//                    }, label: {
//                        Circle()
//                            .fill(Color.gray.opacity(0.25))
//                            .frame(width: 32, height: 32)
//                            .overlay {
//                                Image(systemName: "xmark")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 12, height: 12)
//                                    .foregroundColor(.primary)
//                            }
//                    }).frame(maxWidth: .infinity, alignment: .trailing)
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 10)
                    
                    stackedJournalView(in: geometry)
                    
                    // Buttons row
                    HStack(spacing: 56) {
                        Button(action: {
                            // First button action
                            debugPrint("Left button tapped for journal")
//                            shareScreenshot()
                        }) {
                            Circle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(width: 46, height: 46)
                                .overlay {
                                    Image(systemName: "paperplane.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 24)
                                        .foregroundColor(.primary)
                                }
                        }
                        
                        Button(action: {
                            // Second button action
                            debugPrint("Right button tapped for journal")
                            dismiss()
                            
                        }) {
                            Circle()
                                .fill(Color.gray.opacity(0.25))
                                .frame(width: 46, height: 46)
                                .overlay {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 24)
                                        .foregroundColor(.primary)
                                }
                        }
                    }
                    .padding(.vertical, 30) // Add some bottom padding
                }
            }
        }
    }
    
    private func stackedJournalView(in geometry: GeometryProxy) -> some View {
        HStack {
            Spacer()
            
            ZStack {
                ForEach(max(0, currentIndex - 2)..<min(journals.count, currentIndex + 3), id: \.self) { index in
                    KFImage(URL(string: journals[index].urls.regular ?? "https://images.unsplash.com/photo-1734366965512-0f7ec347ab36?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODgyNzN8MHwxfGFsbHwxMHx8fHx8fHx8MTczNDc5Mjc2M3w&ixlib=rb-4.0.3&q=80&w=1080"))
                        .setProcessor(DownsamplingImageProcessor(size: CGSize(width: UIScreen.main.bounds.width * 0.80,
                                                                            height: UIScreen.main.bounds.height * 0.70)))
                        .placeholder {
                            // Placeholder while loading
                            ProgressView()
                        }
                        .loadDiskFileSynchronously()
                        .cacheMemoryOnly()
                        .fade(duration: 0.25)
                        .resizable()
                        .cornerRadius(12)
                        .frame(minHeight: UIScreen.main.bounds.height * 0.60)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width * 0.80,
                               height: UIScreen.main.bounds.height * 0.70)
                        .offset(x: calculateCardOffset(for: index, in: geometry))
                        .scaleEffect(calculateCardScale(for: index))
                        .rotation3DEffect(
                            calculateTopTiltRotation(for: index),
                            axis: (x: 1.0, y: 0.0, z: 0.0),
                            anchor: .top
                        )
                        .zIndex(calculateZIndex(for: index))
                        .animation(index == currentIndex ?
                            .spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0) :
                            .spring(),
                        value: currentIndex)
                }
            }
            
//            ZStack {
//                ForEach(max(0, currentIndex - 2)..<min(journals.count, currentIndex + 3), id: \.self) { index in
//                    AsyncImage(url: URL(string: journals[index].urls.regular ?? "https://images.unsplash.com/photo-1734366965512-0f7ec347ab36?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2ODgyNzN8MHwxfGFsbHwxMHx8fHx8fHx8MTczNDc5Mjc2M3w&ixlib=rb-4.0.3&q=80&w=1080")) {image in
//                        image.image?.resizable()
//                            .cornerRadius(12)
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: UIScreen.main.bounds.width * 0.80,
//                                   height: UIScreen.main.bounds.height * 0.70)
//                    }
//                        .offset(x: calculateCardOffset(for: index, in: geometry))
//                        .scaleEffect(calculateCardScale(for: index))
//                        .rotation3DEffect(
//                            calculateTopTiltRotation(for: index),
//                            axis: (x: 1.0, y: 0.0, z: 0.0),
//                            anchor: .top
//                        )
//                        .zIndex(calculateZIndex(for: index))
//                        .animation(index == currentIndex ?
//                            .spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0) :
//                            .spring(),
//                        value: currentIndex)
//                }
//            }
            
            Spacer()
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    translation = value.translation.width
                }
                .onEnded { value in
                    let threshold: CGFloat = 50
                    
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)) {
                        if value.translation.width < -threshold && currentIndex < journals.count - 1 {
                            currentIndex += 1
                        } else if value.translation.width > threshold && currentIndex > 0 {
                            currentIndex -= 1
                        }
                        translation = 0
                    }
                }
        )
    }
    
    
//    func shareScreenshot() {
//        let cardView = JournalCard(
//            historyItem: .constant(journals[currentIndex]),
//            day: journals[currentIndex].getDates(type: "day", createdAtDate: journals[currentIndex].createdAt),
//            month: journals[currentIndex].getDates(type: "month", createdAtDate: journals[currentIndex].createdAt),
//            year: journals[currentIndex].getDates(type: "year", createdAtDate: journals[currentIndex].createdAt),
//            userName: userProfile.userName
//        )
//        .environment(\.colorScheme, colorScheme)
//        .frame(width: UIScreen.main.bounds.width * 0.85)
//        
//        // Create UIView from SwiftUI View
//        let controller = UIHostingController(rootView: cardView)
//        let view = controller.view!
//        
//        // Set the size of the view
//        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.85, height: 526)
//        
//        // Set background color based on color scheme
//        view.backgroundColor = colorScheme == .light ? UIColor(hexString: "EEE9DD") : UIColor(hexString: "111111")
//        
//        // Ensure view is laid out
//        view.layoutIfNeeded()
//        
//        // Render view to image
//        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
//        let image = renderer.image { ctx in
//            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//        }
//        
//        let shareMessage = "Hey, I want to share my journal entry on Evolve with you! https://apps.apple.com/in/app/evolve-daily-self-care-habits/id1515433542"
//        
//        let activityViewController = UIActivityViewController(
//            activityItems: [image, shareMessage],
//            applicationActivities: nil
//        )
//        
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
//              var topController = keyWindow.rootViewController else {
//            return
//        }
//        
//        while let presentedViewController = topController.presentedViewController {
//            topController = presentedViewController
//        }
//        
//        if let popoverController = activityViewController.popoverPresentationController {
//            popoverController.sourceView = topController.view
//            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
//            popoverController.permittedArrowDirections = []
//        }
//        
//        topController.present(activityViewController, animated: true)
//    }
    
    
    private func calculateTopTiltRotation(for index: Int) -> Angle {
        let indexDiff = index - currentIndex
        
        // No tilt for current card
        if indexDiff == 0 {
            return .degrees(0)
        }
        
        // Calculate tilt based on position
        // Background cards tilt back more
        let baseTilt = -5.0 // Negative for tilting backwards
        let tiltAmount = Double(abs(indexDiff)) * baseTilt
        
        return .degrees(tiltAmount)
    }
    
    private func calculateZIndex(for index: Int) -> Double {
        return Double(journals.count - abs(index - currentIndex))
    }
    
    private func calculateCardOpacity(for index: Int) -> Double {
        let indexDiff = abs(index - currentIndex)
        return indexDiff > 2 ? 0 : (1.0 - (Double(indexDiff) * 0.3))
    }
    
    // Add new function to calculate rotation
    private func calculateRotation(for index: Int) -> Angle {
        let indexDiff = index - currentIndex
        
        // Only rotate background cards
        if indexDiff == 0 {
            return .degrees(0) // No rotation for current card
        }
        
        // Calculate rotation based on position
        let baseRotation = indexDiff < 0 ? 5.0 : -5.0 // Tilt left cards clockwise, right cards counter-clockwise
        let rotationAmount = Double(abs(indexDiff)) * baseRotation
        
        return .degrees(rotationAmount)
    }
    
    private func calculateCardOffset(for index: Int, in geometry: GeometryProxy) -> CGFloat {
        let baseOffset = geometry.size.width * 0.08
        let indexDiff = CGFloat(index - currentIndex)
        
        // Only apply drag translation to current card
        if index == currentIndex {
            return translation
        }
        
        // Static positions for background cards
        return indexDiff * baseOffset * 0.8
    }

    // Adjust scale for better tilt effect
    private func calculateCardScale(for index: Int) -> CGFloat {
        let baseScale: CGFloat = 1.0
        let indexDiff = abs(index - currentIndex)
        let scaleReduction = CGFloat(indexDiff) * 0.08 // Slightly reduced from 0.1
        return max(baseScale - scaleReduction, 0.85)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIImage {
    func dominantColor() -> UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                  y: inputImage.extent.origin.y,
                                  z: inputImage.extent.size.width,
                                  w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage",
                                  parameters: [kCIInputImageKey: inputImage,
                                             kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage,
                      toBitmap: &bitmap,
                      rowBytes: 4,
                      bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                      format: .RGBA8,
                      colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255,
                      green: CGFloat(bitmap[1]) / 255,
                      blue: CGFloat(bitmap[2]) / 255,
                      alpha: CGFloat(bitmap[3]) / 255)
    }
}

