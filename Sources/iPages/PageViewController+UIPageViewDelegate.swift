//
//  PageViewController+UIPageViewControllerDelegate.swift
//  
//
//  Created by Benjamin Leonardo Sage on 11/19/20.
//

#if os(iOS)

import UIKit

extension PageViewController {
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var willTransitionTo: (_ pageViewController: UIPageViewController,
                               _ pendingViewControllers: [UIViewController]) -> Void
        var didFinishAnimating: (_ pageViewController: UIPageViewController,
                                 _ didFinishAnimating: Bool,
                                 _ previousViewControllers: [UIViewController],
                                 _ transitionCompleted: Bool) -> Void
        
        init(_ pageViewController: PageViewController,
             willTransitionTo: @escaping (_ pageViewController: UIPageViewController,
                                          _ pendingViewControllers: [UIViewController]) -> Void,
             didFinishAnimating: @escaping (_ pageViewController: UIPageViewController,
                                            _ didFinishAnimating: Bool,
                                            _ previousViewControllers: [UIViewController],
                                            _ transitionCompleted: Bool) -> Void) {
            self.parent = pageViewController
            self.willTransitionTo = willTransitionTo
            self.didFinishAnimating = didFinishAnimating
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController?
        {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                if parent.wraps {
                    return parent.controllers.last
                } else {
                    return nil
                }
            }
            return parent.controllers[index - 1]
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == parent.controllers.count {
                if parent.wraps {
                    return parent.controllers.first
                } else {
                    return nil
                }
            }
            return parent.controllers[index + 1]
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool)
        {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = parent.controllers.firstIndex(of: visibleViewController)
            {
                parent.currentPage = index
            }
            self.didFinishAnimating(pageViewController, finished, previousViewControllers, completed)
        }
        
        func pageViewController(
            _ pageViewController: UIPageViewController,
            willTransitionTo pendingViewControllers: [UIViewController])
        {
            self.willTransitionTo(pageViewController, pendingViewControllers)
        }
    }
}

#endif
