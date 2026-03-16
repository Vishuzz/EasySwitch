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
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(ConversionType.allCases) { type in
                        ConversionCard(type: type)
                            .onTapGesture {
                                viewModel.selectConversion(type)
                                showFilePicker = true
                            }
                    }
                }
                .padding()
            }
            
            if viewModel.isConverting{
                ProgressView("Converting...")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
            }
            if let fileURL = viewModel.convertedFileURL{
                VStack{
                    Spacer()
                    
                    Text("Conversion Complete!")
                        .font(.headline)
                    Text(fileURL.lastPathComponent)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
            
            .navigationTitle("EasySwitch")
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

struct ConversionCard: View {
    let type: ConversionType
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: type.iconName)
                .font(.system(size: 30))
            
            Text(type.rawValue)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(radius: 3)
    }
}

#Preview {
    HomeView()
}
