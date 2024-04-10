//
//  AuthController.swift
//  GymMe
//
//  Created by Максим Троицкий on 28.03.2024.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI

class AuthController: ObservableObject {
    
    @Published var phoneNumber: String = ""
    @Published var otpCode: String = ""
    @Published var nickname: String = ""
    @Published var image: UIImage?
    
    @Published var clientCode: String = ""
    
    
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var isRegistrationMode: Bool = false
    
    @AppStorage("log_status") var log_status: Bool = false
    
    func checkPhoneNumber() {
        Task {
            do {
                if try await FirebaseManager.shared.firestore.collection("users").whereField("phoneNumber", isEqualTo: phoneNumber).getDocuments().count == 0 {
                    await MainActor.run(body: {
                        isRegistrationMode = true
                    })
                } else {
                    getOTPCode()
                }
                
            } catch {
                await handleError(error: error)
            }
        }
    }
    
    func getOTPCode(){
        Task {
            await UIApplication.shared.closeKeyboard()
            do {
                // MARK: for testing with simulator, disable for testing with real device
                FirebaseManager.shared.auth.settings?.isAppVerificationDisabledForTesting = true
                
                let code = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
                await MainActor.run(body: {
                    clientCode = code
                    isRegistrationMode = false
                })
            } catch {
                await handleError(error: error)
            }
        }
    }
    
    func verifyOTPCode() {
        Task {
            await UIApplication.shared.closeKeyboard()
            do {
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: clientCode, verificationCode: otpCode)
                
                try await FirebaseManager.shared.auth.signIn(with: credential)
                print("Successfully loged in")
                guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
                let ref = FirebaseManager.shared.firestore.collection("users").document(uid)
                
                
                ref.getDocument { (document, error) in
                    if let document = document, document.exists {
                        print("Document data: \(String(describing: document.data()))")
                    } else {
                        print("Document does not exist")
                        if self.image != nil {
                            self.persistImageToStorage()
                        } else {
                            self.storeUserInfo(imageUrl: nil)
                        }
                    }
                    
                }
                await MainActor.run(body: {
                    withAnimation(.easeInOut) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // 1 sec delay
                            self.log_status = true
                            self.otpCode = ""
                            self.clientCode = ""
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 60) { // 1 sec delay
                            self.phoneNumber = ""
                            self.nickname = ""
                        }
                        
                    }
                })
            } catch {
                await handleError(error: error)
            }           
        }
    }
    
    func storeUserInfo(imageUrl: URL?) {
//        Task {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            let imageUrlString: String = imageUrl?.absoluteString ?? ""
        let userData = [
            "nickname": self.nickname,
            "phoneNumber": self.phoneNumber,
            "photoUrl": imageUrlString,
            "lovedEvents": [],
            "trainings": [],
            "organizedEvents": [],
            "friendsId": [],
            "impressions": []
        ] as [String : Any]
            FirebaseManager.shared.firestore.collection("users").document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    return
                }
                print("Success")
            }
            
//        }
    }
    
    func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to push image to Storage: \(err)")
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    print("Failed to retrieve downloadURL: \(err)")
                    return
                }
                
                print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                print(url?.absoluteString ?? "")
                
                guard let url = url else { return }
                
                self.storeUserInfo(imageUrl: url)
            }
        }
    }
    
    func handleError(error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
