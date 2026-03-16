import Foundation
import Combine

final class ConverterViewModel: ObservableObject {
    
    @Published var selectedConversion: ConversionType?
    @Published var selectedFile: DocumentFile?
    @Published var isConverting = false
    @Published var convertedFileURL: URL?
    
    private let converterService = FileConverterService()
    
    func selectConversion(_ type: ConversionType) {
        selectedConversion = type
    }
    
    func setFile(url: URL) {
        guard let conversion = selectedConversion else { return }
        
        selectedFile = DocumentFile(
            fileName: url.lastPathComponent,
            fileURL: url,
            conversionType: conversion
        )
    }
    
    func startConversion() {
        guard let file = selectedFile else { return }
        
        isConverting = true
        
        converterService.convert(document: file) { [weak self] resultURL in
            DispatchQueue.main.async {
                self?.convertedFileURL = resultURL
                self?.isConverting = false
            }
        }
    }
}
