import AutoSelfieLibChallenge
import SwiftUI

struct AutoSelfieWrapperView: UIViewRepresentable {
    
    typealias UIViewType = AutoSelfieSessionView
    
    func makeUIView(context: Context) -> AutoSelfieSessionView {
        AutoSelfieSessionView()
    }
    
    func updateUIView(_ uiView: AutoSelfieSessionView, context: Context) { }
    
}
