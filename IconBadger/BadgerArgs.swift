#! /usr/bin/swift

import AppKit

extension NSImage {
	convenience init?(url: URL) {
		guard let iconData = try? Data(contentsOf: url) else {
			return nil
		}

		self.init(data: iconData)
	}
	
	var asPNGData: Data? {
		guard let imageData = tiffRepresentation,
			  let newRep = NSBitmapImageRep(data: imageData) else {
			return nil
		}

		return newRep.representation(using: .png, properties: [:])
	}
}

func addBadge(_ text: String, imageSize: CGSize, with color: NSColor) {
	let paragraphStyle = NSMutableParagraphStyle()
	paragraphStyle.alignment = NSTextAlignment.center
	paragraphStyle.lineBreakMode = .byWordWrapping

	let attributes: [NSAttributedString.Key: Any] = [
		.font: NSFont.init(name: "SFProRounded-Medium", size: 120)!,
		.paragraphStyle: paragraphStyle,
		.foregroundColor: color
	]

	let textRect = NSRect(x: 0, y: imageSize.height * 3/4, width: imageSize.width, height: imageSize.height * 1/4)

	NSColor(red: 0.06, green: 0.13, blue: 0.27, alpha: 1.00).drawSwatch(in: textRect)

	text.draw(
		with: textRect,
		options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine],
		attributes: attributes
	)
}

let url = URL(filePath: FileManager.default.currentDirectoryPath + "/Icon.png")

guard let iconImage = NSImage(url: url) else {
	print("Error: icon not found")
	exit(1)
}

let args = CommandLine.arguments
print("Arguments:", args)

guard args.count > 1, !args[1].isEmpty else {
	print("Error: missing badge text argument")
	exit(1)
}

let badgedIcon = NSImage(size: iconImage.size, flipped: true) { rect -> Bool in 
	iconImage.draw(in: rect)

	addBadge(args[1], imageSize: iconImage.size, with: .white)

	return true
}

guard let pngData = badgedIcon.asPNGData else {
	print("Error: couldn't convert image to png data")
	exit(1)
}

let outputURL = URL(filePath: FileManager.default.currentDirectoryPath + "/BadgedIcon.png")
try pngData.write(to: outputURL)

if args.contains("--open") {
	NSWorkspace.shared.open(outputURL)
}
