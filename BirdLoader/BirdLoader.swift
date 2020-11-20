//
//  BirdLoader.swift
//  BirdLoader
//
//  Created by Abhijit Singh on 20/11/20.
//

import UIKit

final public class BirdLoader: UIView {
    
    public enum Direction {
        case facingLeft, facingRight
    }

    /// Dependency for chicken
    /// - Parameters:
    ///     - hairColor: Color of the chicken's hair
    ///     - foreheadColor: Color of the chicken's forehead
    ///     - beardColor: Color of the chicken's beard
    ///     - beakColor: Color of the chicken's beak
    ///     - mouthColor: Color of the chicken's mouth
    ///     - eyeColor: Color of the chicken's eye
    ///     - startDirection: Determines the chicken's initial face direction
    ///     - duration: Total animation duration
    public struct Properties {
        let hairColor: UIColor
        let foreheadColor: UIColor
        let beardColor: UIColor
        let beakColor: UIColor
        let mouthColor: UIColor
        let eyeColor: UIColor
        let startDirection: Direction
        let duration: TimeInterval
        
        public init(hairColor: UIColor, foreheadColor: UIColor, beardColor: UIColor, beakColor: UIColor, mouthColor: UIColor, eyeColor: UIColor, startDirection: Direction, duration: TimeInterval) {
            self.hairColor = hairColor
            self.foreheadColor = foreheadColor
            self.beardColor = beardColor
            self.beakColor = beakColor
            self.mouthColor = mouthColor
            self.eyeColor = eyeColor
            self.startDirection = startDirection
            self.duration = duration
        }
    }
    
    private struct Style {
        let eyeSpacing: CGFloat = 2.5
        let eyeRadiusRatio: CGFloat = 1 / 6
        let firstCycleRightRotationValues: [CGFloat] = [.pi / 2, .pi, -.pi, -.pi / 2, -.pi / 2]
        let secondCycleRightRotationValues: [CGFloat] = [0, 2 * .pi, 0, -2 * .pi, 0]
        let firstCycleLeftRotationValues: [CGFloat] = [-.pi / 2, .pi, -.pi, .pi / 2, .pi / 2]
        let secondCycleLeftRotationValues: [CGFloat] = [0, 2 * .pi, 0, 2 * .pi, 0]
        let animationDelay: TimeInterval = 0.75
    }
    
    // MARK: - Lazy Vars
    private lazy var mouthLayer: CAShapeLayer = {
        return createLayer(
            startingFrom: properties.startDirection == .facingRight ? 0 : .pi / 2,
            endAngle: properties.startDirection == .facingRight ? .pi / 2 : .pi,
            color: properties.mouthColor,
            radiusRatio: 1 / 3
        )
    }()
    private lazy var hairLayer: CAShapeLayer = {
        return createLayer(
            startingFrom: properties.startDirection == .facingRight ? .pi / 2 : 3 * .pi / 2,
            endAngle: properties.startDirection == .facingRight ? 3 * .pi / 2 : .pi / 2,
            color: properties.hairColor
        )
    }()
    private lazy var foreheadLayer: CAShapeLayer = {
        return createLayer(
            startingFrom: properties.startDirection == .facingRight ? .pi / 2 : 3 * .pi / 2,
            endAngle: properties.startDirection == .facingRight ? 3 * .pi / 2 : .pi / 2,
            color: properties.foreheadColor,
            radiusRatio: 2 / 3
        )
    }()
    private lazy var beardLayer: CAShapeLayer = {
        return createLayer(
            startingFrom: properties.startDirection == .facingRight ? .pi / 2 : 0,
            endAngle: properties.startDirection == .facingRight ? .pi : .pi / 2,
            color: properties.beardColor,
            radiusRatio: 2 / 3
        )
    }()
    private lazy var eyeLayer: CAShapeLayer = {
        return createLayer(
            startingFrom: 0,
            endAngle: 2 * .pi,
            color: properties.eyeColor,
            radiusRatio: style.eyeRadiusRatio,
            isEye: true
        )
    }()
    private lazy var beakLayer: CAShapeLayer = {
        return createLayer(
            startingFrom: properties.startDirection == .facingRight ? 3 * .pi / 2 : .pi,
            endAngle: properties.startDirection == .facingRight ? 0 : 3 * .pi / 2,
            color: properties.beakColor,
            radiusRatio: 2 / 3
        )
    }()
    
    private let style: Style = .init()
    private let properties: Properties
    private var chickenLayers: [CAShapeLayer] = []
    private var animationCounter: Int = 0
    
    public init(properties: Properties) {
        self.properties = properties
        super.init(frame: .init())
        performInitialSetup()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard didLayoutLoader else {
            setupLoader()
            return
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Requirements Setup
private extension BirdLoader {
    
    func createLayer(startingFrom startAngle: CGFloat, endAngle: CGFloat, color: UIColor, radiusRatio: CGFloat = 1, isEye: Bool = false) -> CAShapeLayer {
        let layer: CAShapeLayer = .init()
        layer.frame = bounds
        let radius: CGFloat = maximumRadius * radiusRatio
        let layerCenter: CGPoint = isEye ? .init(
            x: properties.startDirection == .facingRight ? bounds.midX - (style.eyeSpacing + radius) : bounds.midX + style.eyeSpacing + radius,
            y: bounds.midY - (style.eyeSpacing + radius)
        ) : .init(
            x: bounds.midX,
            y: bounds.midY
        )
        let layerPath: UIBezierPath = .init(
            arcCenter: layerCenter,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        layerPath.addLine(to: .init(
            x: bounds.midX,
            y: bounds.midY
        ))
        layer.path = layerPath.cgPath
        layer.fillColor = color.cgColor
        return layer
    }
    
}

// MARK: - Private Helpers
private extension BirdLoader {
    
    var maximumRadius: CGFloat {
        return min(bounds.width, bounds.height) / 2
    }
    
    var didLayoutLoader: Bool {
        return subviews.last?.layer is CAShapeLayer
    }
    
    func performInitialSetup() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLoader() {
        layer.addSublayer(mouthLayer)
        layer.insertSublayer(hairLayer, above: mouthLayer)
        layer.insertSublayer(foreheadLayer, above: hairLayer)
        layer.insertSublayer(beardLayer, above: foreheadLayer)
        layer.insertSublayer(eyeLayer, above: beardLayer)
        layer.insertSublayer(beakLayer, above: eyeLayer)
        chickenLayers = [
            mouthLayer,
            hairLayer,
            foreheadLayer,
            beardLayer,
            beakLayer
        ]
        startAnimating()
    }
    
    var shouldFadeBeard: Bool {
        return !animationCounter.isMultiple(of: 2)
    }
    
    var eyeTranslation: CGFloat {
        let translation: CGFloat = style.eyeSpacing + maximumRadius * style.eyeRadiusRatio
        return animationCounter.isMultiple(of: 2) ? 2 * (properties.startDirection == .facingRight ? translation : -translation) : 0
    }
    
}

// MARK: - Animation
private extension BirdLoader {
    
    func startAnimating() {
        let rotationValues: [CGFloat] = properties.startDirection == .facingRight ? style.firstCycleRightRotationValues : style.firstCycleLeftRotationValues
        performAnimation(with: rotationValues)
    }
    
    func performAnimation(with values: [CGFloat], and delay: TimeInterval = 0) {
        chickenLayers.enumerated().forEach { (index, layer) in
            let rotation: CABasicAnimation = getAnimation(
                for: "transform.rotation",
                finalValue: values[index],
                duration: properties.duration,
                delay: delay
            )
            if index == 0 {
                rotation.delegate = self
            }
            layer.add(rotation, forKey: nil)
        }
        
        let translation: CABasicAnimation = getAnimation(
            for: "transform.translation.x",
            finalValue: eyeTranslation,
            duration: properties.duration,
            delay: delay
        )
        eyeLayer.add(translation, forKey: nil)
        guard shouldFadeBeard else { return }
        let fadeInOut: CABasicAnimation = getAnimation(
            for: "opacity",
            finalValue: 0,
            duration: 3 * properties.duration / 5,
            delay: delay,
            autoreverses: true
        )
        beardLayer.add(fadeInOut, forKey: nil)
    }
    
    func getAnimation(for keyPath: String, finalValue: CGFloat, duration: TimeInterval, delay: TimeInterval, autoreverses: Bool = false) -> CABasicAnimation {
        let animation: CABasicAnimation = .init(keyPath: keyPath)
        animation.beginTime = CACurrentMediaTime() + delay
        animation.toValue = finalValue
        animation.duration = duration
        animation.timingFunction = .init(name: .easeIn)
        animation.autoreverses = autoreverses
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
}

// MARK: - CAAnimationDelegate Methods
extension BirdLoader: CAAnimationDelegate {
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else { return }
        animationCounter += 1
        let rotationValues: [CGFloat] = animationCounter.isMultiple(of: 2) ? (properties.startDirection == .facingRight ? style.firstCycleRightRotationValues : style.firstCycleLeftRotationValues) : (properties.startDirection == .facingRight ? style.secondCycleRightRotationValues : style.secondCycleLeftRotationValues)
        performAnimation(
            with: rotationValues,
            and: style.animationDelay
        )
    }
    
}
