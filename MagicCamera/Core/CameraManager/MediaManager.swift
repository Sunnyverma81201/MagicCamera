//
//  MediaManager.swift
//  MagicCamera
//
//  Created by Apoorv Verma on 12/3/24.
//

import AVKit
import Photos

final class MediaManager: NSObject, @preconcurrency AVCapturePhotoCaptureDelegate {
    static let shared = MediaManager()
    var photoData: Data? = nil
    
    private override init() {
        super.init()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    }
    
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            photoData = photo.fileDataRepresentation()
        }
    }
    
    @MainActor func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let photoData = photoData else {
            print("Error capturing photo")
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    let options = PHAssetResourceCreationOptions()
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: photoData, options: options)
                    
                }, completionHandler: { _, error in
                    if let error = error {
                        print("Error occurred while saving photo to photo library: \(error)")
                    }
                })
            }
        }
    }
    
}
