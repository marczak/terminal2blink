//
//  main.swift
//  terminal2blink
//
//  Created by Edward Marczak on 7/9/20.
//

import Cocoa
import Foundation

// These are the default terminal.app keys
var keyDict = [ "ANSIBlackColor":           "#000000",
                "ANSIBlueColor":            "#66D9EF",
                "ANSIBrightBlackColor":     "#C2E8FF",
                "ANSIBrightBlueColor":      "#66D9EF",
                "ANSIBrightCyanColor":      "#28C6E4",
                "ANSIBrightGreenColor":     "#529B2F",
                "ANSIBrightMagentaColor":   "#F92672",
                "ANSIBrightRedColor":       "#FD971F",
                "ANSIBrightWhiteColor":     "#E0E0E0",
                "ANSIBrightYellowColor":    "#9F9F8F",
                "ANSICyanColor":            "#28C6E4",
                "ANSIGreenColor":           "#6AAF19",
                "ANSIMagentaColor":         "#AE81FF",
                "ANSIRedColor":             "#F25A00",
                "ANSIWhiteColor":           "#ffffff",
                "ANSIYellowColor":          "#9F9F8F",
                "BackgroundColor":          "#000000",
                "CursorBlink":              "1",
                "CursorColor":              "#CCCCCC",
                "CursorType":               "1",
                "Font":                     "Pragmata Pro Mono",
                "FontAntialias":            "",
                "ProfileCurrentVersion":    "",
                "SelectionColor":           "",
                "TextBoldColor":            "#FFFFFF",
                "TextColor":                "#AAAAAA",
                "name": ""
]

// This is what the Blink Shell profile calls these colors
// and how they map to the color names from Terminal.app.
// Options with no equivalent in Blink SHell map to "-drop-"
let colorMap = [ "ANSIBlackColor"          : "black",
                 "ANSIRedColor"            : "red",
                 "ANSIGreenColor"          : "green",
                 "ANSIYellowColor"         : "yellow",
                 "ANSIBlueColor"           : "blue",
                 "ANSIMagentaColor"        : "magenta",
                 "ANSICyanColor"           : "cyan",
                 "ANSIWhiteColor"          : "white",
                 "ANSIBrightBlackColor"    : "lightBlack",
                 "ANSIBrightRedColor"      : "lightRed",
                 "ANSIBrightGreenColor"    : "lightGreen",
                 "ANSIBrightYellowColor"   : "lightYellow",
                 "ANSIBrightBlueColor"     : "lightBlue",
                 "ANSIBrightMagentaColor"  : "lightMagenta",
                 "ANSIBrightCyanColor"     : "lightCyan",
                 "ANSIBrightWhiteColor"    : "lightWhite",
                 "TextColor"               : "foreground-color",
                 "BackgroundColor"         : "background-color",
                 "CursorColor"             : "cursor-color",
                 "SelectionColor"          : "-drop-",
                 "TextBoldColor"           : "-drop-"
]

let defaultANSIColors = ["black"        : "ANSIBlackColor",
                         "red"          : "ANSIRedColor",
                         "green"        : "ANSIGreenColor",
                         "yellow"       : "ANSIYellowColor",
                         "blue"         : "ANSIBlueColor",
                         "magenta"      : "ANSIMagentaColor",
                         "cyan"         : "ANSICyanColor",
                         "white"        : "ANSIWhiteColor",
                         "lightBlack"   : "ANSIBrightBlackColor",
                         "lightRed"     : "ANSIBrightRedColor",
                         "lightGreen"   : "ANSIBrightGreenColor",
                         "lightYellow"  : "ANSIBrightYellowColor",
                         "lightBlue"    : "ANSIBrightBlueColor",
                         "lightMagenta" : "ANSIBrightMagentaColor",
                         "lightCyan"    : "ANSIBrightCyanColor",
                         "lightWhite"   : "ANSIBrightWhiteColor"
]


func usage() {
    print("Usage: terminal2blink {exported .terminal file}.")
    exit(20)
}


func htmlRGBColor(from: NSColor) -> String {
    return String(format: "#%02x%02x%02x", Int(from.redComponent * 255), Int(from.greenComponent * 255), Int(from.blueComponent * 255))
}


func RGBAColor(from: NSColor) -> String {
    return String(format: "rgba(%d, %d, %d, %f)", Int(from.redComponent * 255), Int(from.greenComponent * 255), Int(from.blueComponent * 255), from.alphaComponent)
}


// Check commandline args
if CommandLine.arguments.count < 2 {
    usage()
}

let plistPath = CommandLine.arguments[1]

// Check if input file exists
guard FileManager.default.fileExists(atPath: plistPath)
else {
    print("\(plistPath) does not exist.")
    exit(10)
}


var prefValues = [String: String]()

// Read .terminal plist file
if let terminalDict = NSDictionary(contentsOfFile: plistPath) {
    for (key, value) in terminalDict {
        if value is NSData {
            let theData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(value as! Data)
            let keyname = key as! String
            if (key as! String).contains("Color") {
                let color = theData as! NSColor
                if (key as! String) == "CursorColor" {
                    keyDict.updateValue(RGBAColor(from: color), forKey: keyname)
                } else {
                    if colorMap[keyname] != "-drop-" {
                        keyDict.updateValue(htmlRGBColor(from: color).uppercased(), forKey: keyname)
                    }
                }
            }
        } else {
            prefValues.updateValue(String(describing: value), forKey: key as! String)
        }
    }
}

var writebuf: String
let blinkfile: FileManager
let filename = "\(prefValues["name"] ?? "blinktheme")" + ".js"

guard FileManager.default.createFile(atPath: filename, contents: nil, attributes: nil)
else {
    print("Cannot create to output file.")
    exit(25)
}

let blinktheme: FileHandle? = FileHandle(forWritingAtPath: filename)
if blinktheme == nil {
    print("Cannot write to output file.")
    exit(30)
}

// Write the initial color map
for (key, value) in defaultANSIColors {
    print("key = \(key)")
    writebuf = "\(key) = '\(keyDict[value]!)';\n"
    print(writebuf)
    blinktheme?.write(writebuf.data(using: .utf8)!)
}

writebuf = """
t.prefs_.set('color-palette-overrides',
                 [ black , red     , green  , yellow,
                  blue     , magenta , cyan   , white,
                  lightBlack   , lightRed  , lightGreen , lightYellow,
                  lightBlue    , lightMagenta  , lightCyan  , lightWhite ]);
"""
print(writebuf)
writebuf = writebuf + "\n"
blinktheme?.write(writebuf.data(using: .utf8)!)

writebuf = "t.prefs_.set('cursor-color', '" + keyDict["CursorColor"]! + "');\n"
print(writebuf)
blinktheme?.write(writebuf.data(using: .utf8)!)

writebuf = "t.prefs_.set('foreground-color', '" + keyDict["TextColor"]! + "');\n"
print(writebuf)
blinktheme?.write(writebuf.data(using: .utf8)!)

writebuf = "t.prefs_.set('background-color', '" + keyDict["BackgroundColor"]! + "');\n"
print(writebuf)
blinktheme?.write(writebuf.data(using: .utf8)!)

blinktheme?.closeFile()
