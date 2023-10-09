import Foundation

 struct FatSecretParams {
    /// OAuth Parameters
    static var oAuth = ["oauth_consumer_key":"8a70cd32aae046aab880e1a206bfe312",
                        "oauth_signature_method":"HMAC-SHA1",
                        "oauth_timestamp":"",
                        "oauth_nonce":"",
                        "oauth_version":"1.0"] as Dictionary

    static var fatSecret = [:] as Dictionary<String, String>

    /// Fat Secret Consumer Secret Key
    static var key = "3e063856d4614902b1eb8cb5642c0363"

    /// Fat Secret API URL
    static let url = "https://platform.fatsecret.com/rest/server.api"

    /// Fat Secret HTTP Request Method
    static let httpType = "GET"
}
