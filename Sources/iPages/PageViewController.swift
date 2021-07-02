//
//  PageViewController.swift
//  
//
//  Created by Benjamin Sage on 10/23/20.
//

import SwiftUI
#if os(iOS)
import UIKit
#else
import AppKit
#endif

struct PageViewController: ControllerRepresentable {
    var controllers: [ViewController]
    @Binding var currentPage: Int
    
    #if os(iOS)
    private var animated: Bool
    var wraps: Bool
    var navigationOrientation: UIPageViewController.NavigationOrientation
    var bounce: Bool
    private var interPageSpacing: CGFloat = 0
    
    // delegate
    var willTransitionTo: (_ pageViewController: UIPageViewController,
                           _ pendingViewControllers: [UIViewController]) -> Void
    var didFinishAnimating: (_ pageViewController: UIPageViewController,
                             _ didFinishAnimating: Bool,
                             _ previousViewControllers: [UIViewController],
                             _ transitionCompleted: Bool) -> Void
    #endif
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, willTransitionTo: willTransitionTo, didFinishAnimating: didFinishAnimating)
    }
    
    #if os(iOS)
    init(controllers: [ViewController],
         currentPage: Binding<Int>,
         wraps: Bool,
         navigationOrientation: UIPageViewController.NavigationOrientation,
         bounce: Bool,
         interPageSpacing: CGFloat,
         animated: Bool,
         willTransitionTo: @escaping (_ pageViewController: UIPageViewController,
                                      _ pendingViewControllers: [UIViewController]) -> Void = {_,_ in },
         didFinishAnimating: @escaping (_ pageViewController: UIPageViewController,
                                        _ didFinishAnimating: Bool,
                                        _ previousViewControllers: [UIViewController],
                                        _ transitionCompleted: Bool) -> Void = {_,_,_,_ in })
    {
        self.controllers = controllers
        self._currentPage = currentPage
        self.wraps = wraps
        self.navigationOrientation = navigationOrientation
        self.bounce = bounce
        self.interPageSpacing = interPageSpacing
        self.animated = animated
        self.willTransitionTo = willTransitionTo
        self.didFinishAnimating = didFinishAnimating
    }
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let options: [UIPageViewController.OptionsKey : Any] = [
            .interPageSpacing : interPageSpacing
        ]
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: navigationOrientation,
            options: options)
        
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        pageViewController.view.backgroundColor = .clear
        
        for view in pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = context.coordinator
                break
            }
        }
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        let previousPage = context.coordinator.parent.currentPage
        context.coordinator.parent = self
        
        pageViewController.setViewControllers(
            [controllers[currentPage]],
            direction: currentPage > previousPage ? .forward : .reverse,
            animated: animated)
    }
    #else
    init(controllers: [ViewController],
         currentPage: Binding<Int>) {
        self.controllers = controllers
        self._currentPage = currentPage
    }
    
    func makeNSViewController(context: Context) -> NSPageController {
        let nsPageController = NSPageController()
        nsPageController.view = NSView()
        
        nsPageController.arrangedObjects = Array(0..<controllers.count)
        nsPageController.navigateForward(nil)
        nsPageController.selectedIndex = currentPage
        nsPageController.transitionStyle = .horizontalStrip
        
        nsPageController.delegate = context.coordinator
        
        return nsPageController
    }
    
    func updateNSViewController(_ nsPageController: NSPageController, context: Context) {
        context.coordinator.parent = self
        
        NSAnimationContext.runAnimationGroup({ NSAnimationContext in
            nsPageController.animator().selectedIndex = currentPage
        }, completionHandler: {
            nsPageController.completeTransition()
        })
    }
    #endif
}
