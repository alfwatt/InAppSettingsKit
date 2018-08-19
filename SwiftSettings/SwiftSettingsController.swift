
import KitBridge
import InAppSettingsKit

class SwiftSettingsController: IASKAppSettingsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

#if os(macOS)
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
#endif

}
