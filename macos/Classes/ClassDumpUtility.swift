//
//  ClassDumpUtility.swift
//  bottom_tabs_ios
//
//  Created by Grushka, Tom on 9/26/22.
//

// Fail in production builds to remind us to remove invocations.
#if DEBUG

    import ObjectiveC

    struct ClassDumpUtility {
        static func dumpClass(klass: AnyClass, skipMethods: Bool = false) {
            print("DUMPING CLASS: \(NSStringFromClass(klass))")
            print("==============================\nMETHODS:")
            var methodNames = [String]()
            var methodCount: UInt32 = 0
            let methodList = class_copyMethodList(klass, &methodCount)
            for i in 0 ..< Int(methodCount) {
                let unwrapped = methodList![i]
                let name = NSStringFromSelector(method_getName(unwrapped))
                if skipMethods && name.contains(":") { continue }
                methodNames.append(name as String)
            }
            print(methodNames.sorted().joined(separator: "\n"))

            print("==============================\nPROPS")
            var propNames = [String]()
            var propCount: UInt32 = 0
            let propList = class_copyPropertyList(klass, &propCount)
            for i in 0 ..< Int(propCount) {
                let unwrapped = propList![i]
                guard
                    let name = NSString(utf8String: property_getName(unwrapped))
                else { continue }
                if skipMethods && name.contains(":") { continue }
                propNames.append(name as String)
            }
            print(propNames.sorted().joined(separator: "\n"))

            print("==============================\nIVARS")
            var ivarNames = [String]()
            var ivarCount: UInt32 = 0
            let ivarList = class_copyIvarList(klass, &ivarCount)
            for i in 0 ..< Int(ivarCount) {
                let unwrapped = ivarList![i]
                guard
                    let ivar = ivar_getName(unwrapped),
                    let name = NSString(utf8String: ivar)
                else { continue }
                if skipMethods && name.contains(":") { continue }
                ivarNames.append(name as String)
            }
            print(ivarNames.sorted().joined(separator: "\n"))
        }

        static func dumpClass(string: String, skipMethods: Bool = false) {
            guard
                let klass = NSClassFromString(string)
            else { fatalError("Cannot get class: \(string)") }
            dumpClass(klass: klass, skipMethods: skipMethods)
        }

        static func dump(_ object: AnyObject, skipMethods: Bool = false) {
            guard
                let klass = object_getClass(object)
            else { fatalError("Cannot get class from object: \(object)") }
            dumpClass(klass: klass, skipMethods: skipMethods)
        }
    }

#endif
