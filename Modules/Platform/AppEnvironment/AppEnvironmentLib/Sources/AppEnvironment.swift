import Foundation

public enum BuildType {
    case release
    case debug
}

public class AppEnvironment {

    private let notConfiguredErrorMessage = "AppEnvironment() - not configured yet, call configure() before accessing any members"

    public static let shared = AppEnvironment()

    private var _buildType: BuildType?
    public var buildType: BuildType {
        guard let buildType = _buildType else {
            fatalError(notConfiguredErrorMessage)
        }
        return buildType
    }

    public private(set) lazy var bundleIdentifier: String = {
        guard let bundleId = bundle.bundleIdentifier else {
            fatalError("Could not get bundle identifier from main bundle")
        }
        return bundleId
    }()

    public private(set) lazy var versionNumber: String = {
        guard
            let version = infoDictionary["CFBundleShortVersionString"] as? String
        else {
            fatalError("Could not read 'CFBundleShortVersionString' from main bundle")
        }
        return version
    }()

    public private(set) lazy var buildNumber: String = {
        guard
            let build = infoDictionary["CFBundleVersion"] as? String
        else {
            fatalError("Could not read 'CFBundleVersion' from main bundle")
        }
        return build
    }()

    public private(set) lazy var isXCTest: Bool = {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }()

    public init() {
        if isXCTest {
            configure(
                buildType: .debug
            )
        }
    }

    @discardableResult
    public func configure(buildType: BuildType) -> AppEnvironment {
        self._buildType = buildType
        return self
    }

    public var description: String {
        guard let _buildType else {
            return notConfiguredErrorMessage
        }
        return """
        AppEnvironment(
            buildType: \(_buildType),
            bundleIdentifier: \(bundleIdentifier),
            versionNumber: \(versionNumber),
            buildNumber: \(buildNumber),
        )
        """
    }

    // Private properties
    private let bundle: Bundle = .main
    
    private lazy var infoDictionary: [String: Any] = {
        guard let infoDictionary = bundle.infoDictionary else {
            fatalError("Could not get info dictionary from main bundle")
        }
        return infoDictionary
    }()

}
