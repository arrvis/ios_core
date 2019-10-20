//
//  StringEx.swift
//  ArrvisCore
//
//  Created by Yutaka Izumaru on 2018/02/14.
//  Copyright © 2018年 Arrvis Co., Ltd. All rights reserved.
//

extension String {

    /// スネークケースに変換
    public func toSnakenized() -> String {
        // Ensure the first letter is capital
        let head = String(prefix(1))
        let tail = String(suffix(count - 1))
        let upperCased = head + tail

        let input = upperCased

        // split input string into words with Capital letter
        let pattern = "[A-Z]+[a-z,\\d]*"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return ""
        }

        var words: [String] = []

        regex.matches(in: input, options: [], range: NSRange(location: 0, length: count)).forEach { match in
            if let range = Range(match.range(at: 0), in: self) {
                words.append(String(self[range]).lowercased())
            }
        }

        return words.joined(separator: "_")
    }

    /// キャメルケースに変換
    ///
    /// - Parameter lower: true:lower false:upper
    /// - Returns: 変換後
    public func camelized(lower: Bool = true) -> String {
        let words = lowercased().split(separator: "_").map({ String($0) })
        let firstWord: String = words.first ?? ""

        let camel: String = lower
            ? firstWord
            : "\(firstWord.prefix(1).capitalized)\(firstWord.suffix(from: index(after: startIndex)))"
        return words.dropFirst().reduce(into: camel, { camel, word in
            camel.append(String(word.prefix(1).capitalized) + String(word.suffix(from: index(after: startIndex))))
        })
    }

    /// URLエンコード済みStringに変換
    public func toUrlEncodedString() -> String {
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: "-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }

    /// EXTからMIMETypeに
    // refs: http://www.iana.org/assignments/media-types/media-types.xhtml
    public func toMIMETypeFromExt() -> String? {
        let ext = self.replacingOccurrences(of: ".", with: "").lowercased()
        if let audio = toAudioMIMEType(ext) {
            return audio
        }
        if let image = toImageMIMEType(ext) {
            return image
        }
        if let video = toVideoMIMEType(ext) {
            return video
        }
        if let txt = toTxtMIMEType(ext) {
            return txt
        }
        return nil
    }

    private func toAudioMIMEType(_ ext: String) -> String? {
        switch ext {
        case "au":
            return "audio/basic"
        case "snd":
            return "audio/basic"
        case "mid":
            return "audio/mid"
        case "rmi":
            return "audio/mid"
        case "mp3":
            return "audio/mpeg"
        case "aif":
            return "audio/x-aiff"
        case "aifc":
            return "audio/x-aiff"
        case "aiff":
            return "audio/x-aiff"
        case "m3u":
            return "audio/x-mpegurl"
        case "ra":
            return "audio/x-pn-realaudio"
        case "ram":
            return "audio/x-pn-realaudio"
        case "wav":
            return "audio/x-wav"
        default:
            return nil
        }
    }

    private func toImageMIMEType(_ ext: String) -> String? {
        switch ext {
        case "bmp":
            return "image/bmp"
        case "cod":
            return "image/cis-cod"
        case "gif":
            return "image/gif"
        case "ief":
            return "image/ief"
        case "jpe":
            return "image/jpeg"
        case "jpeg":
            return "image/jpeg"
        case "jpg":
            return "image/jpeg"
        case "jfif":
            return "image/pipeg"
        case "svg":
            return "image/svg+xml"
        case "tif":
            return "image/tiff"
        case "tiff":
            return "image/tiff"
        case "ras":
            return "image/x-cmu-raster"
        case "cmx":
            return "image/x-cmx"
        case "ico":
            return "image/x-icon"
        case "pnm":
            return "image/x-portable-anymap"
        case "pbm":
            return "image/x-portable-bitmap"
        case "pgm":
            return "image/x-portable-graymap"
        case "ppm":
            return "image/x-portable-pixmap"
        case "rgb":
            return "image/x-rgb"
        case "xbm":
            return "image/x-xbitmap"
        case "xpm":
            return "image/x-xpixmap"
        case "xwd":
            return "image/x-xwindowdump"
        default:
            return nil
        }
    }

    private func toVideoMIMEType(_ ext: String) -> String? {
        switch ext {
        case "mp2":
            return "video/mpeg"
        case "mpa":
            return "video/mpeg"
        case "mpe":
            return "video/mpeg"
        case "mpeg":
            return "video/mpeg"
        case "mpg":
            return "video/mpeg"
        case "mpv2":
            return "video/mpeg"
        case "mp4":
            return "video/mp4"
        case "mov":
            return "video/quicktime"
        case "qt":
            return "video/quicktime"
        case "lsf":
            return "video/x-la-asf"
        case "lsx":
            return "video/x-la-asf"
        case "asf":
            return "video/x-ms-asf"
        case "asr":
            return "video/x-ms-asf"
        case "asx":
            return "video/x-ms-asf"
        case "avi":
            return "video/x-msvideo"
        case "movie":
            return "video/x-sgi-movie"
        default:
            return nil
        }
    }

    private func toTxtMIMEType(_ ext: String) -> String? {
        switch ext {
        case "txt":
            return "text/plain"
        case "csv":
            return "text/csv"
        case "htm", "html":
            return "text/html"
        case "xml":
            return "text/xml"
        case "js":
            return "text/javascript"
        case "vbs":
            return "text/vbscript"
        case "css":
            return "text/css"
        case "cgi":
            return "application/x-httpd-cgi"
        case "doc":
            return "application/msword"
        case "pdf":
            return "application/pdf"
        default:
            return nil
        }
    }
}
