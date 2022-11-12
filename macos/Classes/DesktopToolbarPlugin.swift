import Cocoa
import FlutterMacOS

struct FontManifestEntry: Decodable {
    let family: String
    let fonts: [Asset]

    struct Asset: Decodable {
        let asset: String
    }
}

public enum FontRegistry {
    static let defaultFontFamily = "MaterialIcons"
    static let defaultFontSize: CGFloat = 24

    public static func resolve(family: String?, size: CGFloat?) -> NSFont? {
        guard let fontFamily = registeredFonts[family ?? Self.defaultFontFamily] else { return nil }
        return NSFont(name: fontFamily, size: size ?? Self.defaultFontSize)
    }

    fileprivate static func register(family: String, fontName: String) {
        print("Registering font family: \(family), name: \(fontName)")
        registeredFonts[family] = fontName
    }

    private static var registeredFonts = [String: String]()

    fileprivate static func registerFonts(registrar _: FlutterPluginRegistrar) {
        let flutterBundleId = "io.flutter.flutter.app"

        guard let flutterBundle = Bundle(identifier: flutterBundleId) else {
            fatalError("Could not get Flutter App bundle with ID: \(flutterBundleId)")
        }

        guard
            let manifestURL = flutterBundle.url(forResource: "FontManifest", withExtension: "json", subdirectory: "flutter_assets")
        else {
            fatalError("Could not get font manifest URL!")
        }

        guard
            let manifestData = try? Data(contentsOf: manifestURL, options: .mappedIfSafe)
        else {
            fatalError("Could not get font manifest Data! URL = \(manifestURL)")
        }

        guard
            let manifest = try? JSONDecoder().decode([FontManifestEntry].self, from: manifestData)
        else {
            fatalError("Could not decode font manifest! DATA = \(manifestData)")
        }

        manifest.forEach { manifestEntry in
            print(manifestEntry)
            let family = NSString(string: manifestEntry.family).lastPathComponent
            manifestEntry.fonts.forEach { fontAsset in
                let fontName = NSString(string: NSString(string: fontAsset.asset).lastPathComponent).deletingPathExtension

                var error: Unmanaged<CFError>?

                guard
                    let fontUrl = flutterBundle.url(forResource: fontAsset.asset, withExtension: nil, subdirectory: "flutter_assets"),
                    let data = try? Data(contentsOf: fontUrl),
                    let provider = CGDataProvider(data: data as CFData),
                    let cgFont = CGFont(provider),
                    CTFontManagerRegisterGraphicsFont(cgFont, &error),
                    NSFont(name: fontName, size: NSFont.systemFontSize) != nil
                else {
                    assertionFailure("Could not register font family: \(family) with asset path: \(fontAsset.asset). ERROR: \(String(describing: error))\nFONT MANIFEST: \(manifest)")
                    return
                }

                FontRegistry.register(family: family, fontName: fontName)
            }
        }
    }
}

public class DesktopToolbarPlugin: NSObject, FlutterPlugin {
    private static var instance: DesktopToolbarPlugin?

    public static func register(with registrar: FlutterPluginRegistrar) {
        guard let window = NSApplication.shared.windows.first else { fatalError("Can't get window!") }
        let flutterApi = ToolbarFlutterApi(binaryMessenger: registrar.messenger)
        let toolbar = Toolbar(identifier: NSToolbar.Identifier.mainWindowToolbar, flutterApi: flutterApi)
        ToolbarHostApiSetup.setUp(binaryMessenger: registrar.messenger, api: toolbar)
        DesktopToolbarPlugin.instance = DesktopToolbarPlugin()
        FontRegistry.registerFonts(registrar: registrar)
        window.toolbar = toolbar
    }
}
