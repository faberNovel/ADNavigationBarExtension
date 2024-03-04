### Changed
- Bump ADUtils requirements to 12+

### Fix
- Fix safe area when setting the child VCs directly

### Removed
- Drop support of iOS 11, 12 and 13
- Remove workaround property `ad_isTranslucent`, use `UINavigationBar.appearance().isTranslucent` instead.

## [1.0.4]

### Fix
- Observe topViewController's properties for:
    - `preferredStatusBarStyle`
    - `preferredInterfaceOrientationForPresentation`
    - `shouldAutoRotate`
    - `supportedInterfaceOrientations`
- Fix navBar background image reset

## [1.0.3]

### Added
- Set toolbars to fake navigation bar appearance public

## [1.0.2]

### Fix
- Fix misplacement of navigation bar extension while hiding navigation bar (issue #5)

## [1.0.1]

### Update
- update ADUtils

## [1.0.0]

### Fixed
- Readme
- Swiftlint warning
- Repository migration

## [0.1.3]

### Fixed
- Prevent crash when standardAppearance is not set
- Update ruby version

## [0.1.1]

### Fixed
- Set all appearance object when editing property
- Update shadowimage when extension changes

## [0.1.1]

### Fixed
- Fixed crash when standardAppearance is not initialized

## [0.1.0]
