//
//  ViewController.swift
//  fc_practica2
//
//  Created by Carlos Villa on 02/10/2017.
//  Copyright © 2017 Carlos Fernando. All rights reserved.
//	

import UIKit

class ViewController: UIViewController, GraphViewDataSource {
    var time = 0.0
    func start(_ View: GraphView) -> Double {
        return 0.0
    }
    
    func end(_ View: GraphView) -> Double {
        if( View == trajectoryGraph)||(View == trajectoryGraphZoomed){
            let h = tank.waterHeightAt(time: time)
            let v = tank.waterOutPutSpeed(waterHeight: h)
            trajectory.vInicial = v
            return trajectory.timeToTarget()
        }else{
            return 200
        }
    }
    
    func nextPoint(_ View: GraphView, _ index: Double) -> Point {
        switch View{
        case tankWater:
            if (tank.waterHeightAt(time: index) < 0.01){
                return Point(x: -10, y: -10)
            }
           return Point(x: index, y: tank.waterHeightAt(time: index))
        case waterTankSpeed:
           if (index >= tank.initialHeight){
                return Point(x: -10, y: -10)
            }
            let waterHeightSpeed = tank.waterHeightSpeed(waterHeight: index)
            return Point(x: index, y: waterHeightSpeed)
        case waterOutPutSpeed:
            if (index >= tank.initialHeight){
                return Point(x: -10, y: -10)
            }
            let waterOutPutSpeed = tank.waterOutPutSpeed(waterHeight: index)
            return Point(x: index, y: waterOutPutSpeed)
        case trajectoryGraph, trajectoryGraphZoomed:
            let pos = trajectory.positionAt(time: index)
            if pos.y < 0.01 {
               return Point(x: -10, y: -10)
            }
            return Point(x: index, y: pos.y)
        default:
            return Point (x: 0.0, y: 0.0)
        }
    }
    
    func place(_ View: GraphView) -> Point {
        switch View{
        case tankWater:
             return Point(x: time, y: tank.waterHeightAt(time: time))
        case waterTankSpeed:
            let waterHeightSpeed = tank.waterHeightSpeed(waterHeight: tank.waterHeightAt(time: time))
            return Point(x: tank.waterHeightAt(time: time),y: waterHeightSpeed)
        case waterOutPutSpeed:
            let waterOutPutSpeed = tank.waterOutPutSpeed(waterHeight: tank.waterHeightAt(time: time))
            return Point(x: tank.waterHeightAt(time: time), y: waterOutPutSpeed)
        case trajectoryGraph, trajectoryGraphZoomed:
            let pos = trajectory.positionAt(time: 0)
            return Point(x: 0, y: pos.y)
        default:
              return Point (x: 0.0, y: 0.0)
        }
        
        
    }
    let tank = TankModel()
    let trajectory = TrajectoryModel()
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tankWater: GraphView!
    @IBOutlet weak var trajectoryGraph: GraphView!
    @IBOutlet weak var waterOutPutSpeed: GraphView!
    @IBOutlet weak var waterTankSpeed: GraphView!
    @IBOutlet weak var trajectoryGraphZoomed: GraphView!
    @IBOutlet weak var viewSafe: UIView!
    
   
    @IBOutlet weak var slider: UISlider!
    @IBAction func slider(_ sender: UISlider) {
        time = Double(sender.value)
        trajectory.vInicial = tank.waterOutPutSpeed(waterHeight: tank.waterHeightAt(time: time))

        tankWater.setNeedsDisplay()
        trajectoryGraph.setNeedsDisplay()
        waterOutPutSpeed.setNeedsDisplay()
        waterTankSpeed.setNeedsDisplay()
        trajectoryGraphZoomed.setNeedsDisplay()
        timeLabel.text = "Time: " + String(slider.value)
        
    }
    @IBOutlet weak var sliderWater: UISlider!
    @IBAction func sliderWater(_ sender: UISlider) {
        tank.initialHeight = Double(sender.value)
        trajectory.vInicial = tank.waterOutPutSpeed(waterHeight: tank.waterHeightAt(time: Double(slider.value)))
        tankWater.setNeedsDisplay()
        trajectoryGraph.setNeedsDisplay()
        waterOutPutSpeed.setNeedsDisplay()
        waterTankSpeed.setNeedsDisplay()
        trajectoryGraphZoomed.setNeedsDisplay()
    }
    @IBAction func zoom1(_ sender: UIPinchGestureRecognizer) {
        tankWater.scaleX *= Double(sender.scale	)
        tankWater.scaleY *= Double(sender.scale)
        sender.scale = 1
        tankWater.setNeedsDisplay()
        
    }
    
    @IBAction func fullScreen(_ sender: UITapGestureRecognizer) {
        trajectoryGraphZoomed.isHidden = false
        viewSafe.isHidden = false
    }
    
    @IBAction func fullScreenOff(_ sender: UITapGestureRecognizer) {
        trajectoryGraphZoomed.isHidden = true
        viewSafe.isHidden = true
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the graphs
        setTrajectoryGraph()
        setWaterLevelGraph()
        setWaterHeightSpeedGraph()
        setWaterOutputSpeedGraph()
        setTrajectoryGraphZoomed()
        
        // Updating data
        trajectory.originPos = (0,5)
        trajectory.targetPos = (2,0)
        //trajectory.vInicial = 25.0
        trajectory.vInicial = tank.waterOutPutSpeed(waterHeight: tank.initialHeight)//no es oficial
        // Do any additional setup after loading the view, typically from a nib.
        timeLabel.text = "time: " + String(slider.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setWaterLevelGraph(){
        tankWater.dataSource = self
        tankWater.scaleX = 3.5
        tankWater.scaleY = 78
    }
    
    func setTrajectoryGraph(){
        trajectoryGraph.dataSource = self
        trajectoryGraph.scaleX = 80
        trajectoryGraph.scaleY = 8
    }

    func  setWaterOutputSpeedGraph(){
        waterOutPutSpeed.dataSource = self
        waterOutPutSpeed.scaleX = 168
        waterOutPutSpeed.scaleY = 10
    }

    func setWaterHeightSpeedGraph(){
        waterTankSpeed.dataSource = self
        waterTankSpeed.scaleX = 160
        waterTankSpeed.scaleY = 1500
    }
    func setTrajectoryGraphZoomed(){
        trajectoryGraphZoomed.dataSource = self
        trajectoryGraphZoomed.scaleX = 100
        trajectoryGraphZoomed.scaleY = 10
    }
    

}

