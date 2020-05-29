//
//  ConsoleViewController.swift
//  MyGames
//
//  Created by Jaciel Ferreira da Siva on 28/05/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit

class ConsoleViewController: UIViewController {
    
    @IBOutlet weak var lbConsoleTitle: UILabel!
    @IBOutlet weak var IvConsoleCover: UIImageView!
    
    var console: Console?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        lbConsoleTitle.text = console?.name

        if let image = console?.cover as? UIImage {
            IvConsoleCover.image = image
        } else {
            IvConsoleCover.image = UIImage(named: "noCoverFull")
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditConsoleViewController
        vc.console = console
    }
    

}
