#!/usr/bin/env swift
// Renders Resources/AppIcon.icns featuring three overlapping cultural layer glyphs:
// 1. Ancient Chinese/Pictographic character (象形/古典「言」) in background layer
// 2. English character ("A") in mid ground layer
// 3. Modern Chinese character ("譯") in foreground layer
import AppKit

let sizes = [16, 32, 64, 128, 256, 512, 1024]
let outputDirectory = URL(fileURLWithPath: "Resources/AppIcon.iconset")
try? FileManager.default.createDirectory(at: outputDirectory, withIntermediateDirectories: true)

func render(size: Int) -> Data {
    let side = CGFloat(size)
    let image = NSImage(size: NSSize(width: side, height: side))
    image.lockFocus()

    // 1. Background Squircle with modern gradient (Deep Royal Blue to Indigo Purple)
    let inset = side * 0.06
    let body = NSRect(x: inset, y: inset, width: side - inset * 2, height: side - inset * 2)
    let squircle = NSBezierPath(
        roundedRect: body,
        xRadius: side * 0.225,
        yRadius: side * 0.225
    )
    
    let gradient = NSGradient(colors: [
        NSColor(calibratedRed: 0.08, green: 0.14, blue: 0.32, alpha: 1.0),
        NSColor(calibratedRed: 0.22, green: 0.28, blue: 0.62, alpha: 1.0),
        NSColor(calibratedRed: 0.42, green: 0.22, blue: 0.72, alpha: 1.0)
    ])
    gradient?.draw(in: squircle, angle: -65)

    // Inner subtle glow border
    squircle.lineWidth = max(1.0, side * 0.015)
    NSColor.white.withAlphaComponent(0.2).setStroke()
    squircle.stroke()

    // Layer 1: Ancient Pictographic style character ("言" in Songti / Calligraphic font)
    // Translucent background watermark style
    let ancientGlyph = "言" as NSString
    let ancientFontSize = side * 0.52
    let ancientFont = NSFont(name: "Songti TC Bold", size: ancientFontSize) 
        ?? NSFont(name: "Kaiti TC Regular", size: ancientFontSize) 
        ?? NSFont.systemFont(ofSize: ancientFontSize, weight: .thin)
    
    let ancientAttrs: [NSAttributedString.Key: Any] = [
        .font: ancientFont,
        .foregroundColor: NSColor(calibratedRed: 0.56, green: 0.82, blue: 1.0, alpha: 0.28)
    ]
    let ancientBounds = ancientGlyph.size(withAttributes: ancientAttrs)
    ancientGlyph.draw(
        at: NSPoint(x: (side - ancientBounds.width) * 0.22, y: (side - ancientBounds.height) * 0.65),
        withAttributes: ancientAttrs
    )

    // Layer 2: English character ("A" in serif/sans typography)
    // Semi-transparent overlapping layer
    let enGlyph = "A" as NSString
    let enFontSize = side * 0.46
    let enFont = NSFont(name: "New York Medium", size: enFontSize) 
        ?? NSFont.systemFont(ofSize: enFontSize, weight: .heavy)
    
    let enAttrs: [NSAttributedString.Key: Any] = [
        .font: enFont,
        .foregroundColor: NSColor(calibratedRed: 0.94, green: 0.78, blue: 0.35, alpha: 0.55)
    ]
    let enBounds = enGlyph.size(withAttributes: enAttrs)
    enGlyph.draw(
        at: NSPoint(x: (side - enBounds.width) * 0.30, y: (side - enBounds.height) * 0.25),
        withAttributes: enAttrs
    )

    // Layer 3: Modern Chinese character ("譯" in bold PingFang TC)
    // Primary foreground element with subtle drop shadow
    let modernGlyph = "譯" as NSString
    let modernFontSize = side * 0.44
    let modernFont = NSFont(name: "PingFangTC-Semibold", size: modernFontSize)
        ?? NSFont.systemFont(ofSize: modernFontSize, weight: .bold)

    let shadow = NSShadow()
    shadow.shadowColor = NSColor.black.withAlphaComponent(0.4)
    shadow.shadowOffset = NSSize(width: 0, height: -side * 0.02)
    shadow.shadowBlurRadius = side * 0.04

    let modernAttrs: [NSAttributedString.Key: Any] = [
        .font: modernFont,
        .foregroundColor: NSColor.white,
        .shadow: shadow
    ]
    let modernBounds = modernGlyph.size(withAttributes: modernAttrs)
    modernGlyph.draw(
        at: NSPoint(x: (side - modernBounds.width) * 0.72, y: (side - modernBounds.height) * 0.36),
        withAttributes: modernAttrs
    )

    image.unlockFocus()

    guard let tiff = image.tiffRepresentation,
        let bitmap = NSBitmapImageRep(data: tiff),
        let png = bitmap.representation(using: .png, properties: [:])
    else { fatalError("failed to render \(size)px") }
    return png
}

for size in sizes {
    let png = render(size: size)
    try png.write(to: outputDirectory.appendingPathComponent("icon_\(size)x\(size).png"))
    if size <= 512 {
        let retina = render(size: size * 2)
        try retina.write(to: outputDirectory.appendingPathComponent("icon_\(size)x\(size)@2x.png"))
    }
}
print("wrote \(outputDirectory.path)")

