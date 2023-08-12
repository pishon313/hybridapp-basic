//
//  CameraPermission.swift
//  hybridapp-basic
//
//  Created by Sarah Jeong on 2023/07/30.
//

import Foundation
import AVFoundation

class CameraPermissionManager {
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            self.openCamera()
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                }
            }
            
        case .denied: // The user has previously denied access.
            return
            
        case .restricted: // The user can't grant access due to restrictions.
            return
            
        @unknown default:
            return
        }
    }
    
    func openCamera() {
        
    }
    
}
