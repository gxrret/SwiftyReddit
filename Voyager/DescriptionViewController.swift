//
//  DescriptionViewController.swift
//  Voyager
//
//  Created by Garret Koontz on 5/22/18.
//  Copyright © 2018 Garret Koontz. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    
    @IBOutlet weak var descTextField: UITextField!
    
    var subreddit:Subreddit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descTextField.text = subreddit?.description
    }

}
