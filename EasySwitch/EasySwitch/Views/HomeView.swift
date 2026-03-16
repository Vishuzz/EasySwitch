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
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(Array(ConversionType.allCases.enumerated()), id: \.element) { index, type in
                            let cardColor = Theme.cardColors[index % Theme.cardColors.count]
                            
                            Button(action: {
                                viewModel.selectConversion(type)
                                showFilePicker = true
                            }) {
                                ConversionCard(type: type, color: cardColor)
                            }
                            .buttonStyle(NeoBrutalButtonStyle(backgroundColor: cardColor, cornerRadius: 0))
                        }
                    }
                    .padding()
                }
                
                if viewModel.isConverting{
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding(.bottom, 8)
                        Text("Converting...")
                            .font(.system(.headline, design: .monospaced).weight(.black))
                    }
                    .padding(24)
                    .neoBrutalism(backgroundColor: .white, cornerRadius: 0)
                }
                if let fileURL = viewModel.convertedFileURL{
                    VStack(alignment: .leading, spacing: 12) {
                        Text("CONVERSION COMPLETE!")
                            .font(.system(.title3, design: .monospaced).weight(.black))
                        
                        Text(fileURL.lastPathComponent)
                            .font(.system(.body, design: .monospaced).weight(.bold))
                            .lineLimit(1)
                            .truncationMode(.middle)
                        
                        Button(action: {
                            // Optionally add share action later
                        }) {
                            Text("OK")
                                .font(.system(.headline, design: .monospaced).weight(.black))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(NeoBrutalButtonStyle(backgroundColor: Theme.nbYellow, cornerRadius: 0))
                        .padding(.top, 8)
                    }
                    .padding(20)
                    .frame(maxWidth: 300)
                    .neoBrutalism(backgroundColor: .white, cornerRadius: 0)
                    .padding()
                }
            }
            .navigationTitle("EASYSWITCH")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    (Text("EASY") + Text("SWITCH").foregroundColor(.red))
                        .tracking(3)
                        .font(.system(.title, design: .monospaced).weight(.black))
                }
            }
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
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: type.iconName)
                .font(.system(size: 34, weight: .black))
                .foregroundColor(.black)
            
            Text(type.rawValue.uppercased())
                .font(.system(.headline, design: .monospaced).weight(.black))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        // Background and border are handled by the button style
    }
}

#Preview {
    HomeView()
}
