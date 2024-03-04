import ADUtils
import UIKit

public protocol ExtensibleNavigationBarInformationProvider {
    var shouldExtendNavigationBar: Bool { get }
}

public class ExtensibleNavigationBarNavigationController: UINavigationController {

    // ?!!! (Samuel Gallet) 29/01/2020 isTranslucent property does not work with iOS 12. Use this property
    // to set isTranslucent to the custom navigationBar with iOS 12
    @available(iOS, deprecated: 13.0, message: "Use appearance instead of this property")
    public static var ad_isTranslucent = true

    public private(set) var navigationBarToolbar: UIToolbar?
    public private(set) var navigationBarExtensionToolbar: UIToolbar?

    private lazy var navBarExtensionContainerView: UIView = self.initNavbarExtensionContainerView()
    private var navBarExtensionContainerBottomConstraint: NSLayoutConstraint?
    private var navBarExtensionBottomConstraint: NSLayoutConstraint?
    private var navBarExtensionTopConstraint: NSLayoutConstraint?
    private var toolbarBottomConstraint: NSLayoutConstraint?

    private var navigationBarAdditionalSize: CGFloat = 0 {
        didSet {
            let needsToShowExtension = self.needsToShowExtension(for: topViewController)
            navBarExtensionBottomConstraint?.constant = !needsToShowExtension ? -navigationBarAdditionalSize : 0
            navBarExtensionTopConstraint?.constant = -navigationBarAdditionalSize
            navBarExtensionContainerBottomConstraint?.constant = navigationBarAdditionalSize
            toolbarBottomConstraint?.constant = -navigationBarAdditionalSize
            topViewController?.additionalSafeAreaInsets = extensionAdditionalSafeAreaInsets
        }
    }
    private var navBarExtensionView: UIView?

    private var extensionAdditionalSafeAreaInsets: UIEdgeInsets {
        let needsToShowExtension = self.needsToShowExtension(for: topViewController)
        return needsToShowExtension ?
        UIEdgeInsets(top: navigationBarAdditionalSize)
        : .zero
    }

    /**
     All calls from `UINavigationControllerDelegate` methods are forwarded to this object
     */
    public weak var navigationControllerDelegate: UINavigationControllerDelegate? {
        didSet {
            // Make the navigationController reevaluate respondsToSelector
            // for UINavigationControllerDelegate methods
            delegate = nil
            delegate = self
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - NSObject

    // swiftlint:disable:next implicitly_unwrapped_optional
    override public func responds(to aSelector: Selector!) -> Bool {
        if shouldForwardSelector(aSelector) {
            return navigationControllerDelegate?.responds(to: aSelector) ?? false
        }
        return super.responds(to: aSelector)
    }

    // swiftlint:disable:next implicitly_unwrapped_optional
    override public func forwardingTarget(for aSelector: Selector!) -> Any? {
        if shouldForwardSelector(aSelector) {
            return navigationControllerDelegate
        }
        return super.forwardingTarget(for: aSelector)
    }

    // MARK: - ExtensibleNavigationBarNavigationController

    public func setNavigationBarExtensionView(_ view: UIView?, forHeight height: CGFloat = 0) {
        navBarExtensionView?.removeFromSuperview()
        guard let view else {
            self.navBarExtensionView = nil
            navigationBarAdditionalSize = height
            updateShadowImage()
            return
        }
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        let toolBar = UIToolbar()
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolBar.ad_setValuesFromAppearance()
        container.addSubview(toolBar)
        toolBar.ad_pinToSuperview()
        navigationBarExtensionToolbar = toolbar
        container.addSubview(view)
        view.ad_pinToSuperview()
        container.clipsToBounds = true
        self.navBarExtensionView = container
        navBarExtensionContainerView.addSubview(container)
        container.ad_pinToSuperview(edges: [.left, .right])
        navBarExtensionTopConstraint = container.topAnchor
            .constraint(equalTo: navBarExtensionContainerView.bottomAnchor, constant: -navigationBarAdditionalSize)
        navBarExtensionTopConstraint?.isActive = true
        navBarExtensionBottomConstraint = container.bottomAnchor
            .constraint(equalTo: navBarExtensionContainerView.bottomAnchor)
        navBarExtensionBottomConstraint?.isActive = true
        navigationBarAdditionalSize = height
        updateShadowImage()
    }

    // MARK: - UINavigationController

    override public var viewControllers: [UIViewController] {
        didSet {
            for viewController in viewControllers {
                updateChildViewController(viewController)
            }
        }
    }

    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        updateChildViewController(viewController)
    }

    override public func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)
        resetExtensionContainerBottomConstraint()
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        if let viewController = topViewController {
            return viewController.preferredStatusBarStyle
        }
        return super.preferredStatusBarStyle
    }

    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let viewController = topViewController {
            return viewController.preferredInterfaceOrientationForPresentation
        }
        return super.preferredInterfaceOrientationForPresentation
    }

    override public var shouldAutorotate: Bool {
        if let viewController = topViewController {
            return viewController.shouldAutorotate
        }
        return super.shouldAutorotate
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let viewController = topViewController {
            return viewController.supportedInterfaceOrientations
        }
        return super.supportedInterfaceOrientations
    }

    // MARK: - Private

    private func setup() {
        delegate = self
        view.addSubview(navBarExtensionContainerView)
        navBarExtensionContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        resetExtensionContainerBottomConstraint()
        navBarExtensionContainerView.ad_pinToSuperview(edges: [.left, .right])
        view.bringSubviewToFront(navigationBar)
    }

    private func initNavbarExtensionContainerView() -> UIView {
        let view = UIView()
        let toolBar = UIToolbar()
        view.isUserInteractionEnabled = false
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolBar.ad_setValuesFromAppearance()
        view.addSubview(toolBar)
        toolBar.ad_pinToSuperview(edges: [.left, .right])
        toolBar.ad_pinToSuperview(edges: .top, insets: UIEdgeInsets(value: -40))
        navigationBarToolbar = toolBar
        toolbarBottomConstraint = toolBar.bottomAnchor
            .constraint(equalTo: view.bottomAnchor, constant: -navigationBarAdditionalSize)
        toolbarBottomConstraint?.isActive = true
        return view
    }

    // swiftlint:disable:next implicitly_unwrapped_optional
    private func shouldForwardSelector(_ aSelector: Selector!) -> Bool {
        let description = protocol_getMethodDescription(UINavigationControllerDelegate.self, aSelector, false, true)
        return
            description.name != nil // belongs to UINavigationControllerDelegate
                && class_getInstanceMethod(type(of: self), aSelector) == nil // self does not implement aSelector
    }

    private func needsToShowExtension(for viewController: UIViewController?) -> Bool {
        return navBarExtensionView != nil
        && ((viewController as? ExtensibleNavigationBarInformationProvider)?.shouldExtendNavigationBar ?? false)
    }

    private func updateShadowImage() {
        let needsToShowExtension = self.needsToShowExtension(for: topViewController)
        let compactNavigationBarAppearance = UINavigationBar
            .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
            .compactAppearance
        let scrollEdgeNavigationBarAppearance = UINavigationBar
            .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
            .scrollEdgeAppearance
        let standardNavigationBarAppearance: UINavigationBarAppearance? = UINavigationBar
            .appearance(whenContainedInInstancesOf: [ExtensibleNavigationBarNavigationController.self])
            .standardAppearance
        var color = needsToShowExtension
        ? nil
        : standardNavigationBarAppearance?.shadowColor
        if let standardNavigationBarAppearance {
            navigationBar.standardAppearance = UINavigationBarAppearance(
                barAppearance: standardNavigationBarAppearance
            )
            navigationBar.standardAppearance.shadowColor = color
        }
        color = needsToShowExtension
        ? nil
        : scrollEdgeNavigationBarAppearance?.shadowColor
        navigationBar.scrollEdgeAppearance = scrollEdgeNavigationBarAppearance.map {
            UINavigationBarAppearance(barAppearance: $0)
        }
        navigationBar.scrollEdgeAppearance?.shadowColor = color
        color = needsToShowExtension
        ? nil
        : compactNavigationBarAppearance?.shadowColor
        navigationBar.compactAppearance = compactNavigationBarAppearance.map {
            UINavigationBarAppearance(barAppearance: $0)
        }
        navigationBar.compactAppearance?.shadowColor = color
    }

    private func resetExtensionContainerBottomConstraint() {
        NSLayoutConstraint.deactivate(navBarExtensionContainerBottomConstraint.map { [$0] } ?? [])
        navBarExtensionContainerBottomConstraint = navBarExtensionContainerView.bottomAnchor
            .constraint(equalTo: navigationBar.bottomAnchor, constant: navigationBarAdditionalSize)
        navBarExtensionContainerBottomConstraint?.isActive = true
    }

    private func updateChildViewController(_ viewController: UIViewController) {
        viewController.additionalSafeAreaInsets = extensionAdditionalSafeAreaInsets
    }
}

extension ExtensibleNavigationBarNavigationController: UINavigationControllerDelegate {

    // MARK: - UINavigationControllerDelegate

    public func navigationController(_ navigationController: UINavigationController,
                                     willShow viewController: UIViewController,
                                     animated: Bool) {
        navigationControllerDelegate?.navigationController?(
            navigationController,
            willShow: viewController,
            animated: animated
        )

        let needsToShowExtension = self.needsToShowExtension(for: viewController)
        updateShadowImage()
        let previousHeightConstraintConstant = navBarExtensionBottomConstraint?.constant ?? 0
        navBarExtensionContainerView.isUserInteractionEnabled = needsToShowExtension
        navBarExtensionBottomConstraint?.constant = !needsToShowExtension ? -navigationBarAdditionalSize : 0
        if animated {
            let animationBlock: (UIViewControllerTransitionCoordinatorContext) -> Void = { [weak self] _ in
                self?.navBarExtensionContainerView.layoutIfNeeded()
            }
            transitionCoordinator?.animate(alongsideTransition: animationBlock) { [weak self] context in
                if context.isCancelled {
                    self?.navBarExtensionBottomConstraint?.constant = previousHeightConstraintConstant
                }
            }
        } else {
            navBarExtensionContainerView.layoutIfNeeded()
        }
    }
}
