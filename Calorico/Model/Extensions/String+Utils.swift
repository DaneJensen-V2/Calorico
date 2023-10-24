import Foundation
import CryptoSwift

 public extension String {
    /**
    String set for URL encoding process described in RFC 3986.
     Also refered to as percent encoding.
     */
    func getPercentEncodingCharacterSet() -> String {
        let digits = "0123456789"
        let lowercase = "abcdefghijklmnopqrstuvwxyz"
        let uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let unreserved = "-._~"

        return digits + lowercase + uppercase + unreserved
    }

    /**
    Reserved character set for URL as described in RFC 3986.
     These characters are reserved for a URL but we need to percent encode when creating the OAuth Signature.
     */
    func replaceReservedCharacters() -> String {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "%:/?#[]@!$&'()*+,;= ").inverted)!
    }

    /**
    Creates the signature string based on the consumer key and signature base string
     Uses HMAC-SHA1 encryption
     */
    func getSignature(key: String, params: String) -> String {
        var array = [UInt8]()
        array += params.utf8
        
        
        let keyTemp = key + "3e063856d4614902b1eb8cb5642c0363"

        let sign = try! HMAC(key: keyTemp, variant: .sha1).authenticate(array).toBase64()

        return sign
    }

    /**
    Determines if string contains another string.
     Returns boolean value.
     */
    func contains(find: String) -> Bool{ return self.range(of: find) != nil }
}
