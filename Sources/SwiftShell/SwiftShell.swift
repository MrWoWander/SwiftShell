import Foundation

public class SwiftShell {
    
    private let dispatchGroup: DispatchGroup?
    
    private var launchPath: String
    
    public init(isDispatch: Bool) {
        if isDispatch {
            dispatchGroup = DispatchGroup()
            dispatchGroup!.enter()
        } else {
            dispatchGroup = nil
        }
        
        self.launchPath = "/usr/bin/env"
    }
    
    public convenience init(launchPath: String, isDispatch: Bool) {
        self.init(isDispatch: isDispatch)
        self.launchPath = launchPath
    }
    
    @discardableResult
    public func shell(_ args: [String], currentPath: String? = nil, pathHandler: ((String) -> Void)? = nil) -> Int32 {
        let task = Process()
        task.launchPath = self.launchPath
        if let path = currentPath {
            task.currentDirectoryPath = path
        }
        task.arguments = args
        
        if pathHandler != nil {
            task.terminationHandler = { t in
                if t.arguments != nil,
                   t.arguments![0].lowercased() == "cd",
                   t.terminationStatus == 0 {
                    let path = URL(fileURLWithPath: t.currentDirectoryPath).appendingPathComponent(t.arguments![1]).relativePath
                    pathHandler!(path)
                } else {
                    pathHandler!(t.currentDirectoryPath)
                }
            }
        }
        
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    @discardableResult
    public func shell(_ args: String, currentPath: String? = nil, pathHandler: ((String) -> Void)? = nil) -> Int32 {
        let array = args.components(separatedBy: " ")
        return shell(array, currentPath: currentPath, pathHandler: pathHandler)
    }
    
    @discardableResult
    public func shell(_ args: String..., currentPath: String? = nil, pathHandler: ((String) -> Void)? = nil) -> Int32 {
        return shell(args, currentPath: currentPath, pathHandler: pathHandler)
    }
    
    
    public func close(_ ifCloseMainLoop: Bool = false) {
        if dispatchGroup != nil {
            if ifCloseMainLoop {
                dispatchGroup!.notify(queue: DispatchQueue.main) {
                    exit(EXIT_SUCCESS)
                }
            }
            dispatchGroup!.leave()
        }
    }
}

