
import ADUtils
import UIKit

public protocol ExtensibleNavigationBarInformationProvider {
    var shouldExtendNavigationBar: Bool { get }
}

public class ExtensibleNavigationBarNavigationController: UINavigationController {

    private lazy var navBarExtensionContainerView: UIView = self.initNavbarExtensionContainerView()
    private var navBarExtensionContainerBottomConstraint: NSLayoutConstraint?
    private var navBarExtensionBottomConstraint: NSLayoutConstraint?
    private var navBarExtensionTopConstraint: NSLayoutConstraint?
    private var toolbarBottomConstraint: NSLayoutConstraint?

    private var navigationBarAdditionalSize: CGFloat = 0 {
        didSet {
            let needsToShowExtension = (topViewController as? ExtensibleNavigationBarInformationProvider)?.shouldExtendNavigationBar ?? false
            navBarExtensionBottomConstraint?.constant = !needsToShowExtension ? -navigationBarAdditionalSize : 0
            navBarExtensionTopConstraint?.constant = -navigationBarAdditionalSize
            navBarExtensionContainerBottomConstraint?.constant = navigationBarAdditionalSize
            toolbarBottomConstraint?.constant = -navigationBarAdditionalSize
            topViewController?.additionalSafeAreaInsets = extensionAdditionalSafeAreaInsets
        }
    }
    private var navBarExtensionView: UIView?

    private var extensionAdditionalSafeAreaInsets: UIEdgeInsets {
        let needsToShowExtension = (topViewController as? ExtensibleNavigationBarInformationProvider)?.shouldExtendNavigationBar ?? false
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
            navigationController?.delegate = nil
            navigationController?.delegate = self
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    //MARK: - NSObject

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

    public func setNavigationBarExtensionView(_ view: UIView, forHeight height: CGFloat) {
        navBarExtensionView?.removeFromSuperview()
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        let toolBar = UIToolbar()
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolBar.isTranslucent = true
        container.addSubview(toolBar)
        toolBar.ad_pinToSuperview()
        container.addSubview(view)
        view.ad_pinToSuperview()
        self.navBarExtensionView = container
        navBarExtensionContainerView.addSubview(container)
        container.ad_pinToSuperview(edges: [.left, .right])
        navBarExtensionTopConstraint = container.topAnchor
            .constraint(equalTo: navBarExtensionContainerView.bottomAnchor,constant: -navigationBarAdditionalSize)
        navBarExtensionTopConstraint?.isActive = true
        navBarExtensionBottomConstraint = container.bottomAnchor
            .constraint(equalTo: navBarExtensionContainerView.bottomAnchor)
        navBarExtensionBottomConstraint?.isActive = true
        navigationBarAdditionalSize = height
    }

    // MARK: - UINavigationController

    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        viewController.additionalSafeAreaInsets = extensionAdditionalSafeAreaInsets
    }

    // MARK: - Private

    private func setup() {
        delegate = self
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = true
        view.addSubview(navBarExtensionContainerView)
        navBarExtensionContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBarExtensionContainerBottomConstraint = navBarExtensionContainerView.bottomAnchor
            .constraint(equalTo: navigationBar.bottomAnchor, constant: navigationBarAdditionalSize)
        navBarExtensionContainerBottomConstraint?.isActive = true
        navBarExtensionContainerView.ad_pinToSuperview(edges: [.left, .right])
        view.bringSubview(toFront: navigationBar)
    }

    private func initNavbarExtensionContainerView() -> UIView {
        let view = UIView()
        let toolBar = UIToolbar()
        view.isUserInteractionEnabled = false
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolBar.isTranslucent = true
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
}

extension ExtensibleNavigationBarNavigationController: UINavigationControllerDelegate {

    // MARK: - UINavigationControllerDelegate

    public func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        let needsToShowExtension = (viewController as? ExtensibleNavigationBarInformationProvider)?.shouldExtendNavigationBar ?? false
        let previousHeightConstraintConstant = navBarExtensionBottomConstraint?.constant ?? 0
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
