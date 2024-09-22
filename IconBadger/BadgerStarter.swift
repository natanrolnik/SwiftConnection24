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
