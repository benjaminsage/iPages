//
//  iPages+ViewModifiers.swift
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

public extension iPages {
    
    func willTransitionTo(_ delegate: @escaping (_ pageViewController: UIPageViewController,
                                                 _ pendingViewControllers: [UIViewController]) -> Void) -> iPages {
        var view = self
        view.willTransitionTo = delegate
        return view
    }
    
    func didFinishAnimationg(_ delegate: @escaping (_ pageViewController: UIPageViewController,
                                                    _ didFinishAnimating: Bool,
                                                    _ previousViewControllers: [UIViewController],
                                                    _ transitionCompleted: Bool) -> Void ) -> iPages {
        var view = self
        view.didFinishAnimating = delegate
        return view
    }
    
    /// Modifies whether or not the page view should include the standard page control **dots**. (••••)
    /// - Parameter hideDots: Whether the page view should hide the page dots at the bottom 👇
    /// - Returns: A page view with the the desired presence or absence of dots
    func hideDots(_ hideDots: Bool) -> iPages {
        var view = self
        view.showsPageControl = !hideDots
        return view
    }
    
    #if os(iOS)
    /// Modifies whether the page dots are hidden when there is only one page. 1️⃣⤵️
    /// - Parameter hide: Whether the page dots are hidden when there is only one page
    /// - Returns: A page view with the desired dots hiding with one page settings
    func dotsHideForSinglePage(_ hide: Bool) -> iPages {
        var view = self
        view.pageControlHidesForSinglePage = hide
        return view
    }
    #endif
    
    /// Modifies **tint colors** 🟡🟢🔴🟣 to be used for the page dots.
    /// - Parameters:
    ///   - currentPage: The tint color to be used for the current page dot ⬇️
    ///   - otherPages: The Tint color to be used for dots which are not the current page⬅️➡️
    /// - Returns: A page view with the desired dot colors
    @available(iOS 14, *)
    func dotsTintColors(currentPage: Color, otherPages: Color) -> iPages {
        var view = self
        #if os(iOS)
        view.pageControlCurrentPageIndicatorTintColor = UIColor(currentPage)
        view.pageControlPageIndicatorTintColor = UIColor(otherPages)
        #else
        view.pageControlCurrentPageIndicatorTintColor = currentPage
        view.pageControlPageIndicatorTintColor = otherPages
        #endif
        return view
    }
    
    #if os(iOS)
    /// Modifies **tint colors** 🟡🟢🔴🟣 to be used for the page dots.
    /// - Parameters:
    ///   - currentPage: The tint color to be used for the current page dot ⬇️
    ///   - otherPages: The Tint color to be used for dots which are not the current page⬅️➡️
    /// - Returns: A page view with the desired dot colors
    @available(iOS, introduced: 13, obsoleted: 14)
    func dotsTintColors(currentPage: UIColor, otherPages: UIColor) -> iPages {
        var view = self
        view.pageControlCurrentPageIndicatorTintColor = currentPage
        view.pageControlPageIndicatorTintColor = otherPages
        return view
    }
    
    /// Modifies the **background style** ⚪️🔘  of the page dots.
    /// - Parameter style: The style of the background of the page dots
    /// - Returns: A page view with the desired background style of the dots
    @available(iOS 14, *)
    func dotsBackgroundStyle(_ style: UIPageControl.BackgroundStyle) -> iPages {
        var view = self
        view.pageControlBackgroundStyle = style
        return view
    }
    
    /// Modifies the continuous interaction settings of the dots. 🔄
    /// - Parameter allowContinuousInteraction: Whether the dots allow continuous interaction
    /// - Returns: A page view with the desired continuous interaction settings of the page dots
    @available(iOS 14, *)
    func dotsAllowContinuousInteraction(_ allowContinuousInteraction: Bool) -> iPages {
        var view = self
        view.pageControlAllowsContinuousInteraction = allowContinuousInteraction
        return view
    }
    #endif
    
    /// Modifies the **alignment of the page dots**. 👆 👇
    ///
    /// *Trailing* and *leading* alignments will cause the page dots to rotate vertical
    /// - Parameter alignment: Page dot alignment
    /// - Returns: A page view with the desired dots alignment
    func dotsAlignment(_ alignment: Alignment) -> iPages {
        var view = self
        view.pageControlAlignment = alignment
        return view
    }
    
    #if os(iOS)
    /// Modifies the navigation **orientation** of the page view. ↔️ ↕️
    ///
    /// By default, moves the page dots to the trailing edge
    /// - Parameter orientation: The navigation orientation, either horizontal or vertical.
    /// - Returns: A page view with the desired navigation orientation
    func navigationOrientation(_ orientation: UIPageViewController.NavigationOrientation) -> iPages {
        var view = self
        view.pageViewControllerNavigationOrientation = orientation
        if orientation == .vertical {
            view.pageControlAlignment = .trailing
        }
        return view
    }
    
    /// Disables the **bounce** settings of the page view.
    ///
    /// This is especially useful for scroll views.
    /// - Parameter disable: Whether the bounce settings should be disabled
    /// - Returns: A page view with the desired bounce settings
    func disableBounce(_ disable: Bool) -> iPages {
        var view = self
        view.pageViewControllerBounce = !disable
        return view
    }
    
    /// Modifies the spacing between the pages. ↔️
    /// - Parameter spacing: The spacing between pages, in Points. Defaults to 0.
    /// - Returns: A page view with modified inter-page spacing
    func interPageSpacing(_ spacing: CGFloat) -> iPages {
        var view = self
        view.pageViewControllerInterPageSpacing = spacing
        return view
    }
    
    /// Modifies whether or not the page view should **restart at the beginning** 🔁 when swiping past the end (and vise-versa).
    /// - Parameter wraps: Whether or not the page view wraps infinitely 🔄
    /// - Returns: A page view with the desired infinite wrap
    func wraps(_ wraps: Bool) -> iPages {
        var view = self
        view.pageViewControllerWraps = wraps
        return view
    }
    
    func animated(_ animated: Bool) -> iPages {
        var view = self
        view.pageViewAnimated = animated
        return view
    }
    #endif
}
