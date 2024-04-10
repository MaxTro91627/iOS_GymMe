//
//  RegistrationView.swift
//  GymMe
//
//  Created by Максим Троицкий on 29.03.2024.
//

import SwiftUI

struct RegistrationView: View {
    @AppStorage("log_status") var log_status: Bool = false
    var body: some View {
        VStack {
            Button(action: {
                try? FirebaseManager.shared.auth.signOut()
                log_status.toggle()
            }, label: {
                VStack {
                    Text("register")
                }
            })
        }
        .navigationTitle("IT IS A REGISTRATION VIEW")
    }
}

#Preview {
    RegistrationView()
}
