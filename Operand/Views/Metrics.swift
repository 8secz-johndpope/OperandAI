//
//  Metrics.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-10-27.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import ScrollableGraphView
import SnapKit
import UIKit
import os

class MetricsVC: UIViewController, UITextFieldDelegate, ScrollableGraphViewDataSource {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: "group.nameless.financials", category: "Metrics")
    
    var data: CellModel = CellModel(arrowImage: true, name: "test", amount: 1, historicalAmount: [0.0], relevance: 1)
    
    var test: [Double] = []
    
    var titleLabel: UILabel = createTitleLabel(text: "Metric Specifics", textSize: 30, numberOfLines: 0)
    
    var cancelButton: UIButton = createBlueButton(textSize: 16, text: "Return to Dashboard", identifier: "Return to Dashboard")
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        
        os_log(.info, log: self.app, "Loaded")
        
        super.viewDidLoad()
        
        // allows a tap outside textfields to hide the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        self.view.backgroundColor = .systemBackground
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupSignUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        os_log(.info, log: self.app, "Ready to be presented")
        
        for i in data.historicalAmount {
            test.append(i)
        }
        test.append(data.amount)
        titleLabel.text = data.name + " Metrics"
        
        os_log(.info, log: self.app, "Loaded %{public}@ historical value points", String(data.historicalAmount.count))
    }
    
    // MARK: ScrollableGraphView
    
    /// Brief: Value of the graph at points
    /// Return: Double of the value
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "line":
            return test[pointIndex]
        default:
            return 0
        }
    }
    
    /// Brief: Returns label for graph
    /// Return: Character to be displayed on graph
    func label(atIndex pointIndex: Int) -> String {
        let lastIndex = data.historicalAmount.count
        switch pointIndex {
        case lastIndex:
            return "|"
        default:
            return "."
        }
    }
    
    /// Brief: Give the number of point that are in the graph
    /// Return: Integer of point count
    func numberOfPoints() -> Int {
        return test.count
    }
    
    // MARK: Action Functions
    
    /// Brief: Dismisses modal view of edit account
    /// Parameters; Touch up event on cancel button
    @objc func dismissMetric() {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        os_log(.info, log: self.app, "User exited %{public}@ metric", data.name)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helper Functions
    
    /// Brief: Sets the sign in view with SnapKit
    func setupSignUpView() {
        
        let graphView = ScrollableGraphView(frame: self.view.frame, dataSource: self)
        graphView.shouldAdaptRange = true
        graphView.shouldAnimateOnStartup = true
        graphView.rightmostPointPadding = 20
        graphView.dataPointSpacing = 125
        graphView.bottomMargin = 10
        graphView.topMargin = 10
        graphView.backgroundFillColor = UIColor.systemBackground
        graphView.direction = .rightToLeft
        
        let linePlot = LinePlot(identifier: "line") // Identifier should be unique for each plot.
        linePlot.lineColor = UIColor.label
        linePlot.fillColor = UIColor.label
        
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineColor = UIColor.systemGray4
        referenceLines.dataPointLabelColor = UIColor.label
        referenceLines.referenceLineLabelColor = UIColor.label
        
        graphView.addPlot(plot: linePlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        self.view.addSubview(graphView)
        graphView.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(200)
        }
        
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(graphView.snp.top).offset(-35)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(graphView.snp.bottom).offset(30)
            make.width.equalTo(250)
            make.height.equalTo(30)
        }
        cancelButton.addTarget(self, action: #selector(self.dismissMetric),
                               for: .touchUpInside)
    }
    
}
