//
//  DragView.swift
//  FilerUploader
//
//  Created by hui liu on 4/14/20.
//  Copyright © 2020 hui liu. All rights reserved.
//

import Cocoa

class DragView: NSView {
    
    fileprivate var highlight : Bool = false
    
    fileprivate var fileTypeIsOk = false
    
    public var acceptedFileExtensions : [String] = []
    
    public weak var delegate: DragViewDelegate?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        super.draw(dirtyRect)
        
        // Drawing code here.
        if(NSAppKitVersion.current.rawValue < NSAppKitVersion.macOS10_10.rawValue) {
            NSColor.windowBackgroundColor.setFill()
        } else {
            NSColor.clear.set()
        }
        
        __NSRectFillUsingOperation(dirtyRect, NSCompositingOperation.sourceOver)
        
        let grayColor = NSColor(deviceWhite: 0, alpha: highlight ? 1.0/4.0 : 1.0/8.0)
        grayColor.set()
        grayColor.setFill()
        
        let bounds = self.bounds
        let size = min(bounds.size.width - 8.0, bounds.size.height - 8.0);
        let width =  max(2.0, size / 32.0)
        let frame = NSMakeRect((bounds.size.width-size)/2.0, (bounds.size.height-size)/2.0, size, size)
        
        NSBezierPath.defaultLineWidth = width
        
        // draw rounded corner square with dotted borders
        let squarePath = NSBezierPath(roundedRect: frame, xRadius: size/14.0, yRadius: size/14.0)
        let dash : [CGFloat] = [size / 10.0, size / 16.0]
        squarePath.setLineDash(dash, count: 2, phase: 2)
        squarePath.stroke()
        
        // draw arrow
        let arrowPath = NSBezierPath()
        let baseWidth = size / 8.0
        let baseHeight = size / 8.0
        let arrowWidth = baseWidth * 2.0
        let pointHeight = baseHeight * 3.0
        let offset = -size / 8.0
        
        arrowPath.move(to: NSMakePoint(bounds.size.width/2.0 - baseWidth, bounds.size.height/2.0 + baseHeight - offset))
        
        arrowPath.line(to: NSMakePoint(bounds.size.width/2.0 + baseWidth, bounds.size.height/2.0 + baseHeight - offset))
        arrowPath.line(to: NSMakePoint(bounds.size.width/2.0 + baseWidth, bounds.size.height/2.0 - baseHeight - offset))
        arrowPath.line(to: NSMakePoint(bounds.size.width/2.0 + arrowWidth, bounds.size.height/2.0 - baseHeight - offset))
        arrowPath.line(to: NSMakePoint(bounds.size.width/2.0, bounds.size.height/2.0 - pointHeight - offset))
        arrowPath.line(to: NSMakePoint(bounds.size.width/2.0 - arrowWidth, bounds.size.height/2.0 - baseHeight - offset))
        arrowPath.line(to: NSMakePoint(bounds.size.width/2.0 - baseWidth, bounds.size.height/2.0 - baseHeight - offset))
        
        arrowPath.fill()
        // Drawing code here.
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        if #available(OSX 10.13, *) {
            registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
        } else {
            // Fallback on earlier versions
            registerForDraggedTypes([NSPasteboard.PasteboardType("NSFilenamesPboardType")])
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        highlight = true
        fileTypeIsOk = isExtensionAcceptable(draggingInfo: sender)
        
        self.setNeedsDisplay(self.bounds)
        return []
    }
    
    public override func draggingExited(_ sender: NSDraggingInfo?) {
        highlight = false
        self.setNeedsDisplay(self.bounds)
    }
    
    public override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return fileTypeIsOk ? .copy : []
    }
    
    public override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        // finished with dragging so remove any highlighting
        highlight = false
        self.setNeedsDisplay(self.bounds)
        
        return true
    }
    
    public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if sender.filePathURLs.count == 0 {
            return false
        }
        
        if(fileTypeIsOk) {
            if sender.filePathURLs.count == 1 {
                delegate?.dragDropView(self, droppedFileWithURL: sender.filePathURLs.first!)
            } else {
                delegate?.dragDropView(self, droppedFilesWithURLs: sender.filePathURLs)
            }
        } else {
            print("type wrong")
        }
        
        return true
    }
    
    fileprivate func isExtensionAcceptable(draggingInfo: NSDraggingInfo) -> Bool {
        if draggingInfo.filePathURLs.count == 0 {
            return false
        }
        
        for filePathURL in draggingInfo.filePathURLs {
            let fileExtension = filePathURL.pathExtension.lowercased()
            
            if !acceptedFileExtensions.contains(fileExtension) {
                return false
            }
        }
        
        return true
    }
    
    public override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
}

protocol DragViewDelegate: class {
    func dragDropView(_ dragDropView: DragView, droppedFileWithURL  URL: URL)
    func dragDropView(_ dragDropView: DragView, droppedFilesWithURLs URLs: [URL])
}

extension DragViewDelegate {
    func dragDropView(_ dragDropView: DragView, droppedFileWithURL  URL: URL) {
    }
    
    func dragDropView(_ dragDropView: DragView, droppedFilesWithURLs URLs: [URL]) {
    }
}


