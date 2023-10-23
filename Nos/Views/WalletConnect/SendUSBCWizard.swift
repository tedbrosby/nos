//
//  SendUSBCWizard.swift
//  Nos
//
//  Created by Matthew Lorentz on 10/18/23.
//

import SwiftUI

struct SendUSBCWizard: View {
    
    @StateObject var controller: SendUSBCController
    
    private let borderWidth: CGFloat = 6
    private let cornerRadius: CGFloat = 8
    private let inDrawer = true
    
    var body: some View {
        ZStack {
            
            // Gradient border
            LinearGradient.diagonalAccent
            
            // Background color
            Color.menuBorderColor
                .cornerRadius(cornerRadius, corners: inDrawer ? [.topLeft, .topRight] : [.allCorners])
                .padding(.top, borderWidth)
                .padding(.horizontal, borderWidth)
                .padding(.bottom, inDrawer ? 0 : borderWidth)
            
            // Content
            VStack {
                switch controller.state {
                case .loading:
                    FullscreenProgressView(isPresented: .constant(true))
                case .pair:
                    WalletConnectPairingView(viewModel: controller)
                case .amount:
                    WalletConnectSendView(controller: controller)
                case .error(let error):
                    Text("Error")
                    Text(error.localizedDescription)
                case .success:
                    Text("Success")
                }
            }
            .background(Color.appBg)
            .padding(.top, borderWidth)
            .padding(.horizontal, borderWidth)
            .padding(.bottom, inDrawer ? 0 : borderWidth)
            .clipShape(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
        }
        .edgesIgnoringSafeArea(.bottom)
        .frame(idealWidth: 320, idealHeight: 480)
        .presentationDetents([.medium])
    }
}

#Preview {
    var previewData = PreviewData()
    var controller = SendUSBCController(
        state: .amount, 
        destinationAddress: "0x12389749827", 
        destinationAuthor: previewData.unsAuthor
    ) 
    
    return VStack {}
        .sheet(isPresented: .constant(true)) {
            SendUSBCWizard(controller: controller)
        }
}
