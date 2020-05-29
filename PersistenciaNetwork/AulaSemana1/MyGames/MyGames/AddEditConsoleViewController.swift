//
//  AddEditConsoleViewController.swift
//  MyGames
//
//  Created by Jaciel Ferreira da Siva on 28/05/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit
import Photos

class AddEditConsoleViewController: UIViewController {
    
    @IBOutlet weak var tfConsoleTitle: UITextField!
    @IBOutlet weak var ivConsoleCover: UIImageView!
    @IBOutlet weak var btConsoleAddEdit: UIButton!
    @IBOutlet weak var btConsoleCover: UIButton!
    
    var console: Console?
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self as? UIPickerViewDelegate
        pickerView.dataSource = self as? UIPickerViewDataSource
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConsolesManager.shared.loadConsoles(with: context)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareDataLayout()
    }
    
    func prepareDataLayout() {
        if console != nil {
            title = "Editar Console"
            btConsoleAddEdit.setTitle("ALTERAR", for: .normal)
            tfConsoleTitle.text = console?.name
            
            ivConsoleCover.image = console?.cover as? UIImage
            if console?.cover != nil {
                btConsoleCover.setTitle(nil, for: .normal)
            }
            
        }
       
    }
    
    @objc func cancel() {
        // ocultar teclado
        //tfConsole.resignFirstResponder()
    }
    
    @objc func done() {
//        tfConsole.text = ConsolesManager.shared.consoles[pickerView.selectedRow(inComponent: 0)].name
//        cancel()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addEditCover(_ sender: UIButton){
        
        print("AddEditrCover")
        
        let alert = UIAlertController(title:"Selecione a capa", message: "De onde você quer escolher a capa?", preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        })
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        })
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
            
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = sourceType
                imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.allowsEditing = false
                imagePicker.navigationBar.tintColor = UIColor(named: "main")
                
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }
        
        func selectPicture(sourceType: UIImagePickerController.SourceType) {
            
            //Photos
            let photos = PHPhotoLibrary.authorizationStatus()
            
            if photos == .denied {
                // TODO considetar exibir um dialogo pedindo para o usuario ir em configuracoes
                print(".denied")
                
            } else if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        
                        self.chooseImageFromLibrary(sourceType: sourceType)
                        
                    } else {
                        // TODO considetar exibir um dialogo pedindo para o usuario ir em configuracoes
                        print("unauthorized -- TODO message")
                    }
                })
            } else if photos == .authorized {
                
                self.chooseImageFromLibrary(sourceType: sourceType)
            }
        }
    
    
    @IBAction func addEditConsole(_ sender: UIButton){
        
        print("Add console jsdjksdjks")
        
        if console == nil {
            console = Console(context: context)
            
        }
        
        console?.name = tfConsoleTitle.text
        console?.cover = ivConsoleCover.image
        
        do{
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }
    

}

extension AddEditConsoleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewDataSource
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ConsolesManager.shared.consoles.count
    }
    
    
    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = ConsolesManager.shared.consoles[row]
        
        return console.name
    }
}


extension AddEditConsoleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // tip. implementando os 2 protocols o evento sera notificando apos user selecionar a imagem
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // ImageView won't update with new image
            // bug fixed: https://stackoverflow.com/questions/42703795/imageview-wont-update-with-new-image
            DispatchQueue.main.async {
                self.ivConsoleCover.image = pickedImage
                self.ivConsoleCover.setNeedsDisplay() // fixed here
                self.btConsoleCover.setTitle(nil, for: .normal)
                self.btConsoleCover.setNeedsDisplay()
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
