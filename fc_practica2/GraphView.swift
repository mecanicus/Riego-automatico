//
//  GraphView.swift
//  fc_practica2
//
//  Created by Carlos Villa on 02/10/2017.
//  Copyright © 2017 Carlos Fernando. All rights reserved.
//

import UIKit

struct Point{
    var x = 0.0
    var y = 0.0
}

protocol GraphViewDataSource{//nombre correcto?
    func start(_ View: GraphView) -> Double
    func end(_ View: GraphView) -> Double
    func nextPoint(_ View: GraphView,_ index : Double) -> Point
    func place(_ View: GraphView) -> Point
}

class GraphView: UIView {

    var dataSource: GraphViewDataSource!
    var scaleX: Double = 0.0
    var scaleY: Double = 0.0
    
    
    
    override func draw(_ rect: CGRect) {
        axes()
        function()
        pointsOfInterest()
    }
    
    func pointsOfInterest(){
       // let point = UIBezierPath()
       // let place = dataSource.place(self)
     
        let height = bounds.height
        let width = bounds.width
        
        let x = scaleX*dataSource.place(self).x + Double(width/2)
        let y = Double(height/2) - scaleY*dataSource.place(self).y
        let p1 = CGRect(x: x-3, y: y-3, width: 5.0, height: 5.0)
       // point.move(to: CGPoint(x: x, y: y))
       let point1 = UIBezierPath(ovalIn: p1)
        UIColor.red.set()
        point1.stroke()
        point1.fill()
        
    }
    
    func axes(){
        let axesx = UIBezierPath()
        let axesy = UIBezierPath()
        
        let h = bounds.height
        let w = bounds.width
        
        axesx.move(to: CGPoint(x: 0, y: h/2))
        axesy.move(to: CGPoint(x: w/2, y: 0))
        
        axesx.addLine(to: CGPoint(x: w, y: h/2))
        axesy.addLine(to: CGPoint(x: w/2, y: h))
        
        axesx.lineWidth = 2
        axesy.lineWidth = 2
        
        UIColor.black.setStroke()
        
        axesx.stroke()
        axesy.stroke()      
    }
    
    func function(){
        let path = UIBezierPath()
        
        //Placing it on its relative middle
        let height = bounds.height
        let width = bounds.width
        
        var xi = dataSource.nextPoint(self, 0).x
        var yi = dataSource.nextPoint(self, 0).y
        
        xi = scaleX*xi + Double(width/2)
        yi = Double(height/2) - scaleY*yi
        let pointi = CGPoint(x: xi, y: yi)
        
        path.move(to: pointi)
        
        for p in stride(from: dataSource.start(self), to: dataSource.end(self), by: 0.01) {
            
            var x = dataSource.nextPoint(self, p).x
            var y = dataSource.nextPoint(self, p).y
            
            if (x<0 && y<0) {
                break
            }
            
            //Gathering data from source
            x = scaleX*x + Double(width/2)
            y = Double(height/2) - scaleY*y
            let point = CGPoint(x: x, y: y)
            
            /*if (y > (Double(height/2) - 0.05)){
                break
            }*/
            //Adding to draw
            path.addLine(to: point)
        }
        
        //Setting blue colour, line width
        path.lineWidth = 2
        UIColor.blue.setStroke()
        
        //Painting
        path.stroke()
        
    }
 

}
