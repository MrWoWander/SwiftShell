# SwiftShell

A description of this package.

## Example

```swift
import SwiftShell

var shell = SwiftShell(isDispatch: true)
shell.shell("mkdir testGit") { _ in
    
    let args = ["cd", "testGit"]
    shell.shell(args) { path in
        
        shell.shell("git", "clone", "https://github.com/RTUITLab/ITLab-iOS", ".", currentPath: path) { (path) in
            
            shell.shell("ls", currentPath: path) { _ in
                
                
                for i in 1...100 {
                    print(i)
                }
                
                shell.close(true)
            }
        }
        
    }
}

dispatchMain() //Needed if your program exits after executing a shell
```
