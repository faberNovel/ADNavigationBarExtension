import ADUtils
import UIKit

public protocol ExtensibleNavigationBarInformationProvider {
    var shouldExtendNavigationBar: Bool { get }
}

public class ExtensibleNavigationBarNavigationController: UINavigationController {

    // ?!!! (Samuel Gallet) 29/01/2020 isTranslucent property does not work with iOS 12. Use this property
    // to set isTranslucent to the custom navigationBar with iOS 12
    @available(iOS, deprecated: 13.0, message: "Use appearance instead of this property")
    // swiftlint:disable:next identifier_name
    public static var ad_isTranslucent: Bool = true

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

    override public func responds(to aSelector: Selector!) -> Bool {
        if shouldForwardSelector(aSelector) {
            return navigationControllerDelegate?.responds(to: aSelector) ?? false
        }
        return super.responds(to: aSelector)
    }

    override public func forwardingTarget(for aSelector: Selector!) -> Any? {
        if shouldForwardSelector(aSelector) {
            return navigationControllerDelegate
        }
        return super.forwardingTarget(for: aSelector)
    }

    // MARK: - ExtensibleNavigationBarNavigationController

    public func setNavigationBarExtensionView(_ view: UIView?, forHeight height: CGFloat = 0) {
        navBarExtensionView?.removeFromSuperview()
        guard let view = view else {
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

    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        viewController.additionalSafeAreaInsets = extensionAdditionalSafeAreaInsets
    }

    // MARK: - Private

    private func setup() {
        delegate = self
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        view.addSubview(navBarExtensionContainerView)
        navBarExtensionContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBarExtensionContainerBottomConstraint = navBarExtensionContainerView.bottomAnchor
            .constraint(equalTo: navigationBar.bottomAnchor, constant: navigationBarAdditionalSize)
        navBarExtensionContainerBottomConstraint?.isActive = true
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
        toolbarBottomConstraint = toolBar.bottomAnchor
            .constraint(equalTo: view.bottomAnchor, constant: -navigationBarAdditionalSize)
        toolbarBottomConstraint?.isActive = true
        return view
    }

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
        if #available(iOS 13, *) {
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
            if let standardNavigationBarAppearance = standardNavigationBarAppearance {
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
        } else {
            navigationBar.shadowImage = needsToShowExtension ? UIImage() : nil
        }
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
