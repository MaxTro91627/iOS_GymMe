//
//  AuthView.swift
//  GymMe
//
//  Created by Максим Троицкий on 28.03.2024.
//

import SwiftUI
import Firebase

//class FirebaseManager: NSObject {
//
//    let auth: Auth
//    let storage: Storage
//
//    static let shared = FirebaseManager()
//
//    override init() {
//        FirebaseApp.configure()
//
//        self.auth = Auth.auth()
//        self.storage = Storage.storage()
//
//        super.init()
//    }
//
//}

struct AuthView: View {
    @StateObject var authController: AuthController
    @State var isRegistrationMode: Bool = false
    var body: some View {
        NavigationView {
            if authController.clientCode == "" && !authController.isRegistrationMode {
                VerifyPhoneNumberView(authController: authController)
                    .navigationBarBackButtonHidden()
            } else if authController.isRegistrationMode {
                RegisterUserView(authController: authController)
                    .navigationBarBackButtonHidden()
            } else {
                VerifyCodeView(authController: authController)
                    .navigationBarBackButtonHidden()
            }
            
        }
        
        
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }
}

struct RegisterUserView: View {
    @StateObject var authController: AuthController
    @State private var shouldShowImagePicker = false
    @State var image: UIImage?
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            
            Button {
                shouldShowImagePicker.toggle()
            } label: {
                
                VStack {
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 128, height: 128)
                            .cornerRadius(64)
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 64))
                            .padding()
                            .foregroundStyle(.secondary)
                            .opacity(0.4)
                    }
                }
                .overlay(RoundedRectangle(cornerRadius: 128)
                    .stroke(AppConstants.accentBlueColor, lineWidth: 3)
                )
                
            }
            .foregroundStyle(.primary)
            
//            Image(systemName: "person")
//                .resizable()
//                .opacity(0.3)
//                .frame(maxWidth: 60, maxHeight: 60)
//                .padding()
//                .background(content: {
//                    Circle()
//                        .stroke(AppConstants.accentOrangeColor, lineWidth: 3)
//                })
            
            
            HStack (alignment: .center) {
                TextField("Enter your name", text: $authController.nickname)
                    .padding()
                    .background(content: {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppConstants.accentOrangeColor, lineWidth: 3)
                    })
                    .padding()
            }
            Spacer()
            HStack (alignment: .center, spacing: 10) {
                Button (action: {
                    authController.isRegistrationMode = false
                }, label: {
                    Text("Back")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .padding(.horizontal)
                        .bold()
                        .foregroundStyle(.white)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppConstants.accentOrangeColor)
                        })
                })
                Spacer()
                Button (action: {
//                    authController.isRegistrationMode = false
                    authController.image = self.image
                    authController.getOTPCode()
                }, label: {
                    Text("Create")
                        .frame(maxWidth: .infinity)

                        .padding()
                        .padding(.horizontal)
                        .bold()
                        .foregroundStyle(.white)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppConstants.accentBlueColor)
                        })
                })
            }
            .padding(.horizontal)
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
    }
}

struct VerifyPhoneNumberView: View {
    @StateObject var authController: AuthController
    var contentType: UITextContentType = .telephoneNumber
    var body: some View {
        VStack(spacing: 16) {
            Group {
                Spacer()
                Text("Enter your phone number for authorization")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                TextField("Phone Number", text: $authController.phoneNumber)
                    .keyboardType(.namePhonePad)
                    .textContentType(contentType)
                    .autocapitalization(.none)
                    .padding()
                    .background(content: {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.background)
                            .stroke(AppConstants.accentBlueColor, lineWidth: 3)
                    })
                Spacer()
            }
            .bold()
            
            Button(action: authController.checkPhoneNumber, label: {
                HStack {
                    Spacer()
                    Text("Next")
                        .foregroundColor(.white)
                        .frame(width: 250, height: 40)
                        .bold()
                        .font(.title3)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppConstants.accentOrangeColor)
                        })
                    Spacer()
                }
            })
        }
        .padding()

    }
}

struct VerifyCodeView: View {
    @StateObject var authController: AuthController
    var contentType: UITextContentType = .telephoneNumber
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Group {
                    Spacer()
                    Text("We sent you a verification code Enter it to start using app")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    TextField("Verification code", text: $authController.otpCode)
                        .keyboardType(.namePhonePad)
                        .textContentType(contentType)
                        .autocapitalization(.none)
                        .padding()
                        .background(content: {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.background)
                                .stroke(AppConstants.accentBlueColor, lineWidth: 3)
                        })
                    Spacer()
                }
                .bold()
                Button(action: {
                    authController.verifyOTPCode()
                }, label: {
                    HStack {
                        Spacer()
                        Text("Next")
                            .foregroundColor(.white)
                            .frame(width: 250, height: 40)
                            .bold()
                            .font(.title3)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppConstants.accentOrangeColor)
                            })
                        Spacer()
                    }
                })
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action:{
                        authController.clientCode = ""
                        authController.otpCode = ""
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(AppConstants.accentOrangeColor)
                        
                    })
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}


#Preview {
    RegisterUserView(authController: .init())
//    AuthView()
}


// Model
// View
// ViewModel
