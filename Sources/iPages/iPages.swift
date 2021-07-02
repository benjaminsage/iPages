import SwiftUI
#if os(iOS)
import UIKit
#else
import AppKit
#endif

/// A `View` wrapper for `UIPageViewController` which lets you write 📝 and use 🔨 a page view in SwiftUI.
///
/// Binds to a zero-indexed 0️⃣1️⃣2️⃣ "current page" `Int`eger.
public struct iPages<Content: View>: View {
    @State private var viewControllers: [ViewController]
    
    @State private var internalSelection: Int = 0
    @Binding private var externalSelection: Int
    private var selection: Binding<Int> {
        hasExternalSelection ? $externalSelection : $internalSelection
    }
    private var hasExternalSelection = false
    
    // delegate
    var willTransitionTo: ((_ pageViewController: UIPageViewController,
                            _ pendingViewControllers: [UIViewController]) -> Void) = {_,_ in}
    var didFinishAnimating: ((_ pageViewController: UIPageViewController,
                              _ didFinishAnimating: Bool,
                              _ previousViewControllers: [UIViewController],
                              _ transitionCompleted: Bool) -> Void) = {_,_,_,_ in }
    
    // Page view controller
    var pageViewControllerWraps: Bool = false
    var pageViewAnimated: Bool = true
    #if os(iOS)
    var pageViewControllerNavigationOrientation: UIPageViewController.NavigationOrientation = .horizontal
    var pageViewControllerBounce: Bool = true
    var pageViewControllerInterPageSpacing: CGFloat = 0
    #endif
    private var pageViewController: PageViewController {
        #if os(iOS)
        return .init(controllers: viewControllers,
                     currentPage: selection,
                     wraps: pageViewControllerWraps,
                     navigationOrientation: pageViewControllerNavigationOrientation,
                     bounce: pageViewControllerBounce,
                     interPageSpacing: pageViewControllerInterPageSpacing,
                     animated: pageViewAnimated,
                     willTransitionTo: willTransitionTo,
                     didFinishAnimating: didFinishAnimating)
        #else
        return .init(controllers: viewControllers,
                     currentPage: selection)
        #endif
    }
    
    // Page control
    var pageControlAlignment: Alignment = .bottom
    var showsPageControl: Bool = true
    var pageControlHidesForSinglePage: Bool = false
    #if os(macOS)
    var pageControlCurrentPageIndicatorTintColor: Color?
    var pageControlPageIndicatorTintColor: Color?
    #endif
    
    #if os(iOS)
    var pageControlCurrentPageIndicatorTintColor: UIColor?
    var pageControlPageIndicatorTintColor: UIColor?
    private var _pageControlBackgroundStyle: Any? = nil
    @available(iOS 14, *)
    var pageControlBackgroundStyle: UIPageControl.BackgroundStyle {
        get {
            guard _pageControlBackgroundStyle != nil else {
                return .automatic
            }
            return _pageControlBackgroundStyle as! UIPageControl.BackgroundStyle
        }
        set(newStyle) {
            _pageControlBackgroundStyle = newStyle
        }
    }
    var pageControlAllowsContinuousInteraction: Bool = false
    private var pageControl: PageControl {
        if #available(iOS 14.0, *) {
            return .init(numberOfPages: viewControllers.count,
                         currentPage: selection,
                         hidesForSinglePage: pageControlHidesForSinglePage,
                         pageIndicatorTintColor: pageControlPageIndicatorTintColor,
                         currentPageIndicatorTintColor: pageControlCurrentPageIndicatorTintColor,
                         backgroundStyle: pageControlBackgroundStyle,
                         allowsContinuousInteraction: pageControlAllowsContinuousInteraction)
        } else {
            return .init(numberOfPages: viewControllers.count,
                         currentPage: selection,
                         hidesForSinglePage: pageControlHidesForSinglePage,
                         pageIndicatorTintColor: pageControlPageIndicatorTintColor,
                         currentPageIndicatorTintColor: pageControlCurrentPageIndicatorTintColor,
                         allowsContinuousInteraction: pageControlAllowsContinuousInteraction)
        }
    }
    #else
    private var ipageControl: iPageControl {
        .init(numberOfPages: viewControllers.count,
              currentPage: selection,
              hidesForSinglePage: pageControlHidesForSinglePage,
              pageIndicatorTintColor: pageControlPageIndicatorTintColor,
              currentPageIndicatorTintColor: pageControlCurrentPageIndicatorTintColor)
    }
    #endif
    
    /// Initializes the page 📃📖 view. 👷‍♀️
    /// - Parameters:
    ///   - selection: A binding to the page that the user is currently on ⌚️, zero indexed (meaning page 1 is 0, page 2 is 1, etc.)
    ///   - content: The ordered view builder of `View`s to appear in the page view 📑
    public init(selection: Binding<Int>? = nil,
                @ViewBuilder content: () -> Content)
    {
        _viewControllers = State(initialValue: content().decompose().map { HostingController(rootView: $0) })
        if let selection = selection {
            _externalSelection = selection
            hasExternalSelection = true
        } else {
            _externalSelection = Binding<Int>(get: { 0 }, set: { _ in })
        }
    }
    
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    
    public var body: some View {
        ZStack(alignment: pageControlAlignment) {
            pageViewController
            if showsPageControl {
                switch pageControlAlignment {
                case .leading, .trailing:
                    VStack {
                        if pageControlAlignment == .leading { Spacer() }
                        #if os(iOS)
                        pageControl
                        #else
                        ipageControl
                        #endif
                        if pageControlAlignment == .trailing { Spacer() }
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .rotationEffect(.degrees(layoutDirection ~= .leftToRight ? 90 : -90))
                default:
                    #if os(iOS)
                    pageControl
                        .fixedSize()
                        .padding(.vertical)
                    #else
                    ipageControl
                        .fixedSize()
                        .padding(.vertical)
                    #endif
                }
            }
        }
    }
}
