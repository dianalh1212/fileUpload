//
//  ViewController.swift
//  FilerUploader
//
//  Created by hui liu on 4/14/20.
//  Copyright © 2020 hui liu. All rights reserved.
//

import Cocoa
import WebKit

class HomeViewController: NSViewController {

   // @IBOutlet var imageView: NSImageView!
    @IBOutlet var dragView: DragView!
    @IBOutlet var previewView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dragView.acceptedFileExtensions = ["png", "jpg", "jpeg", "gif", "txt", "h", "m", "swift", "log", "html"]
        dragView.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        
        }
    }
}

extension HomeViewController: DragViewDelegate {

    func dragDropView(_ dragDropView: DragView, droppedFileWithURL URL: URL) {
        
        if URL.absoluteString.contains(".txt") {
            previewView.image = NSImage(imageLiteralResourceName: "iconText")
        } else if URL.absoluteString.contains(".html") {
            previewView.image = NSImage(imageLiteralResourceName: "iconHtml")
        }else if URL.absoluteString.contains("png") || URL.absoluteString.contains("jpg") || URL.absoluteString.contains("jpeg") || URL.absoluteString.contains("gif")
        {
            previewView.image = NSImage(byReferencing: URL)
        }
        else {
            
        }
    }
    
    func dragDropView(_ dragDropView: DragView, droppedFilesWithURLs URLs: [URL]) {
        
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "Please drop only one file"
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

