import AutoSelfieLibChallenge
import SwiftUI

struct AutoSelfieWrapperView: UIViewRepresentable {
    
    let wrappedView = AutoSelfieSessionView()
    
    typealias UIViewType = AutoSelfieSessionView
    
    func makeUIView(context: Context) -> AutoSelfieSessionView {
        wrappedView
    }
    
    func updateUIView(_ uiView: AutoSelfieSessionView, context: Context) { }
    
}
