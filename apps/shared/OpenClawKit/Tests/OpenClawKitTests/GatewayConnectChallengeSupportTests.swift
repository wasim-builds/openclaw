import Foundation
import OpenClawKit
import OpenClawProtocol
import Testing

struct GatewayConnectChallengeSupportTests {
    @Test func `parses gateway issued timestamp`() {
        let challenge = GatewayConnectChallengeSupport.challenge(from: [
            "nonce": AnyCodable(" nonce-1 "),
            "ts": AnyCodable(1_700_000_000_123),
        ])

        #expect(challenge == GatewayConnectChallenge(
            nonce: "nonce-1",
            issuedAtMs: 1_700_000_000_123))
    }

    @Test(arguments: [
        ["nonce": AnyCodable("nonce-1"), "ts": AnyCodable("1700000000123")],
        ["nonce": AnyCodable("nonce-1"), "ts": AnyCodable(-1)],
        ["nonce": AnyCodable(" "), "ts": AnyCodable(1_700_000_000_123)],
    ])
    func `rejects malformed challenge`(payload: [String: AnyCodable]) {
        #expect(GatewayConnectChallengeSupport.challenge(from: payload) == nil)
    }

    @Test func `accepts legacy challenge without timestamp`() {
        #expect(GatewayConnectChallengeSupport.challenge(from: [
            "nonce": AnyCodable("nonce-1"),
        ]) == GatewayConnectChallenge(nonce: "nonce-1", issuedAtMs: nil))
    }
}
