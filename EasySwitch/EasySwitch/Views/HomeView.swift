//  ContentView.swift
//  EasySwitch
//
//  Created by vishek on 16/03/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {
    
    @StateObject private var viewModel = ConverterViewModel()
    
    @State private var showFilePicker = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Theme.background.ignoresSafeArea()
                DotGridPattern()
                
                VStack(spacing: 0) {
                    
                    // Custom Header area to support subtitle
                    VStack(spacing: 6) {
                        (Text("EASY").font(.system(size: 32, weight: .black, design: .default)).italic().foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.2))) +
                        (Text("SWITCH").font(.system(size: 32, weight: .black, design: .default)).italic().foregroundColor(Color(red: 1.0, green: 0.3, blue: 0.4)))
                        
                        Text("Simple. Fast. Secure.")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundColor(Color(red: 0.4, green: 0.5, blue: 0.5))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(Array(ConversionType.allCases.enumerated()), id: \.element) { index, type in
                                let cardColor = Theme.cardColors[index % Theme.cardColors.count]
                                let isSelected = viewModel.selectedConversion == type
                                
                                Button(action: {
                                    viewModel.selectConversion(type)
                                }) {
                                    ConversionCard(type: type, color: cardColor)
                                }
                                .buttonStyle(NeoBrutalButtonStyle(
                                    backgroundColor: cardColor,
                                    cornerRadius: 24,
                                    isSelected: isSelected
                                ))
                            }
                        }
                        .padding(.horizontal, 20)
                        // Add extra padding at the bottom so the FAB doesn't cover content
                        .padding(.bottom, 100)
                    }
                }
                
                // Converting Overlay
                if viewModel.isConverting{
                    Color.black.opacity(0.2).ignoresSafeArea()
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding(.bottom, 8)
                        Text("Converting...")
                            .font(.system(.headline, design: .rounded).weight(.bold))
                            .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.2))
                    }
                    .padding(32)
                    .neoBrutalism(backgroundColor: .white, cornerRadius: 24)
                }
                
                // Success Overlay
                if let fileURL = viewModel.convertedFileURL{
                    Color.black.opacity(0.2).ignoresSafeArea()
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Conversion Complete!")
                            .font(.system(.title3, design: .rounded).weight(.bold))
                            .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.2))
                        
                        Text(fileURL.lastPathComponent)
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        
                        Button(action: {
                            // Optionally add share action later
                            viewModel.convertedFileURL = nil
                        }) {
                            Text("OK")
                                .font(.system(.headline, design: .rounded).weight(.bold))
                                .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.2))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                        .buttonStyle(NeoBrutalButtonStyle(backgroundColor: Theme.nbYellow, cornerRadius: 16))
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .frame(maxWidth: 320)
                    .neoBrutalism(backgroundColor: .white, cornerRadius: 24)
                    .padding()
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    Button(action: {
                        showFilePicker = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 32, weight: .light))
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(red: 1.0, green: 0.25, blue: 0.4))
                            .clipShape(Circle())
                            .shadow(color: Color(red: 1.0, green: 0.25, blue: 0.4).opacity(0.4), radius: 10, x: 0, y: 8)
                    }
                    .disabled(viewModel.selectedConversion == nil)
                    .opacity(viewModel.selectedConversion == nil ? 0.5 : 1.0)
                    .padding(.bottom, 0)
                }
                .ignoresSafeArea(.all, edges: .bottom)
            }
            .navigationBarHidden(true)
            .fileImporter(
                isPresented: $showFilePicker,
                allowedContentTypes: [.item]
            ) { result in
                switch result {
                case .success(let url):
                    viewModel.setFile(url: url)
                    viewModel.startConversion()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ConversionCard: View {
    let type: ConversionType
    let color: Color
    
    // Determine the icon color based on the icon for variety, drawing from our Theme
    var specificIconColor: Color {
        switch type {
        case .pdfToWord: return Color(red: 0.8, green: 0.5, blue: 0.1) // Orange/Brownish
        case .wordToPDF: return Color(red: 0.9, green: 0.2, blue: 0.4) // Pinkish Red
        case .imageToPDF: return Color(red: 0.2, green: 0.5, blue: 0.8) // Blue
        case .pdfToImage: return Color(red: 0.1, green: 0.6, blue: 0.4) // Green
        case .textToPDF: return Color(red: 0.5, green: 0.3, blue: 0.8) // Purple
        case .pdfToText: return Color(red: 0.8, green: 0.4, blue: 0.1) // Orange
        case .pagesToPDF: return Color(red: 0.8, green: 0.5, blue: 0.1) // Orange/Brownish
        case .pdfToPages: return Color(red: 0.9, green: 0.2, blue: 0.4) // Pinkish Red
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            // White rounded box around icon
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 60, height: 60)
                
                Image(systemName: type.iconName)
                    .font(.system(size: 26, weight: .regular))
                    .foregroundColor(specificIconColor)
            }
            
            Text(type.rawValue.uppercased())
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.2))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140)
    }
}

#Preview {
    HomeView()
}
