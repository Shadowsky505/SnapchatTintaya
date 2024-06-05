import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift
import SafariServices
import FirebaseDatabase

class iniciarSesionViewController: UIViewController {
    
    // MARK: OUTLETS
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: ACTIONS
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
            (user, error) in
            print("Intentando Iniciar Sesion")
            if error != nil{
                print("Se presento el siguiente error: \(error)")
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {(user, error) in
                    print("Intentando crear un usuario")
                    if error != nil {
                        print("Se presento el siguiente error al crear el ususario: ")
                    } else {
                        print("El usuario fue creado exitosamente!")
                        Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                        let alerta = UIAlertController(title: "Creación de Usuarios", message: "Uusario: \(self.emailTextField.text!) se creo correctamente", preferredStyle: .alert)
                        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: {(UIAlertAction) in self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)})
                        alerta.addAction(btnOK)
                        self.present(alerta, animated: true, completion: nil)
                                                  
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                    }
                })
            }else{
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
        
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
            return
          }
          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            return
          }
          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

        }
    }
}

