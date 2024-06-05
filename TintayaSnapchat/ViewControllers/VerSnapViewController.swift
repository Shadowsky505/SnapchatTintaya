import UIKit
import SDWebImage
import Firebase
import FirebaseStorage

class VerSnapViewController: UIViewController {
    
    @IBOutlet weak var lblMensaje: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var snap = Snap()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("LLL"+snap.imagenURL)
        lblMensaje.isEnabled = false
        lblMensaje.text = snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete(){
            (error) in
            print("Se elimino la imagen correctamente....")
        }
    }

}
