//   .-
//  `+d/
//  -hmm/
//  ommmm/
//  `mmmmm/
//  `mmmmm/ .:+ssyso+-`
//  `mmmmmsydmmmmmmmmmho.
//  `mmmmmmh+:---/+ssssyd:
//  `mmmmmh.     /     .md-
//  `mmmmmo..-`       .ommo
//  `mmmmm+..`    ./oydmmm/
//  `mmmmm/      /dmmmmmmh`
//  `mmmmm/    `smmmmmmms`
//  `mmmmm/  `+dmmmmmy+.
//  :::::.   `-::-.`
//
//  GaugeView.swift
//  GaugeView
//
//  Created by Luca D'Incà on 18/10/15.
//  Copyright © 2015 BELKA S.R.L. All rights reserved.
//

import UIKit

@IBDesignable
public class GaugeView: UIView {
    ///
    // Class proprty
    ///

    private var label: UILabel!

    private var gaugeLayer: GaugeLayer!

    // Gauge property
    @IBInspectable public var startAngle: Float = 0.0

    @IBInspectable public var radius: CGFloat {
        return min(bounds.width, bounds.height) / 2
    }

    @IBInspectable public var thickness: CGFloat = 20 {
        didSet {
            if let gaugeLayer = gaugeLayer {
                setNeedsDisplay()
                gaugeLayer.setNeedsDisplay()
            }
        }
    }

    public var animationDuration: Float = 0.5

    @IBInspectable public var percentage: Float = 20 {
        didSet {
            if let gaugeLayer = gaugeLayer {
                gaugeLayer.stopAngle = convertPercentageInRadius(percentage: percentage)
                accessibilityValue = "\(percentage)%"
            }
        }
    }

    @IBInspectable public var gaugeBackgroundColor: UIColor = UIColor.gray {
        didSet {
            if let gaugeLayer = gaugeLayer {
                setNeedsDisplay()
                gaugeLayer.setNeedsDisplay()
            }
        }
    }

    @IBInspectable public var gaugeColor: UIColor = UIColor.red {
        didSet {
            if let gaugeLayer = gaugeLayer {
                setNeedsDisplay()
                gaugeLayer.setNeedsDisplay()
            }
        }
    }

    // Label property
    @IBInspectable public var labelText: String = "" {
        didSet {
            label.text = labelText
            updateTextLabel()
        }
    }

    @IBInspectable public var labelFont: UIFont? {
        didSet {
            if let labelFont = labelFont {
                label.font = labelFont
                updateTextLabel()
            }
        }
    }

    @IBInspectable public var labelColor: UIColor? {
        didSet {
            if let labelColor = labelColor {
                label.textColor = labelColor
                updateTextLabel()
            }
        }
    }

    ///
    // Class methods
    ///

    // MARK: - Init methods

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    // MARK: - Draw method

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        gaugeLayer.radius = radius
        gaugeLayer.thickness = thickness
        gaugeLayer.frame = bounds
        gaugeLayer.gaugeBackgroundColor = gaugeBackgroundColor
        gaugeLayer.gaugeColor = gaugeColor
        gaugeLayer.animationDuration = animationDuration
        gaugeLayer.startAngle = convertDegreesToRadius(degrees: startAngle)
        gaugeLayer.stopAngle = convertPercentageInRadius(percentage: percentage)

        updateTextLabel()
    }

    // MARK: - Setup method

    private func setup() {
        createGaugeView()
        createTitleLabel()

        setupAccessibility()
    }

    private func setupAccessibility() {
        isAccessibilityElement = true
    }

    private func createGaugeView() {
        gaugeLayer = GaugeLayer(layer: layer)

        gaugeLayer.radius = radius
        gaugeLayer.thickness = thickness
        gaugeLayer.frame = bounds
        gaugeLayer.gaugeBackgroundColor = gaugeBackgroundColor
        gaugeLayer.gaugeColor = gaugeColor
        gaugeLayer.animationDuration = animationDuration
        gaugeLayer.startAngle = convertDegreesToRadius(degrees: startAngle)
        gaugeLayer.stopAngle = convertPercentageInRadius(percentage: percentage)

        layer.addSublayer(gaugeLayer)

        backgroundColor = UIColor.clear
    }

    private func createTitleLabel() {
        label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize.zero))

        updateTextLabel()

        addSubview(label)
    }

    private func updateTextLabel() {
        label.sizeToFit()
        label.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }

    // MARK: - Utility method

    private func convertPercentageInRadius(percentage: Float) -> Float {
        return convertDegreesToRadius(degrees: (360.0 / 100.0 * percentage) + startAngle)
    }

    private func convertDegreesToRadius(degrees: Float) -> Float {
        return ((Float(Float.pi) * degrees) / 180.0)
    }
}
