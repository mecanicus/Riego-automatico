//
//  TrayectoryModel.swift
//  fc_practica2
//
//  Created by Carlos Villa on 02/10/2017.
//  Copyright © 2017 Carlos Fernando. All rights reserved.
//
import Foundation

class TrajectoryModel {
    
    //Posicion origen del disparo.
    var originPos = (x: 0.0, y: 0.0){
        didSet {
            update()
        }
    }
    
    //Posicion del destino del disparo
    var targetPos = (x: 0.0, y: 0.0) {
        didSet {
            update()
        }
    }
    
    //Velocidad inicial
    var vInicial: Double = 0.0 {
        didSet {
            update()
        }
    }
    
    //Angulo disparo inicial
    private var angle: Double = 0.0
    
    private var speedX = 0.0
    private var speedY = 0.0
    
    //Actualiza los datos de la trayectoria si cambia la posicion del origen, la destino o la Vinicial
    private func update() {
        let g = Constants.g
        let xf = targetPos.x - originPos.x
        let yf = targetPos.y - originPos.y
        
        angle = atan((pow(vInicial,2) + sqrt(pow(vInicial,4) - g*g*xf*xf - 2*g*yf*vInicial*vInicial)) / (g*xf))
        
        if !angle.isNormal {
            speedX = 0
            speedY = 0
        }else{
            speedX = vInicial * cos(angle)
            speedY = vInicial * sin(angle)
        }
    }
    
    //Tiempo que tarda origen-destino
    func timeToTarget() -> Double {
        let t = (targetPos.x - originPos.x) / speedX
        return t.isNormal ? t : 0
    }
    
    //Posicion en un momento dado
    func positionAt(time: Double) -> (x: Double, y: Double) {
        let x = originPos.x + speedX * time
        let y = originPos.y + speedY * time - 0.5 * Constants.g * time * time
        return (x,y)
    }
    
    
}
