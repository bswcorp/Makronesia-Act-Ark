// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract SovereignAssetBacking {
    string public name = "Act-Ark Sovereign Credit";
    string public symbol = "ASSET-ARK";
    uint256 public constant TOTAL_VALUATION = 1_000_000 * 10**15 * 10**18;
    address public sovereignGovernment;

    constructor() {
        sovereignGovernment = msg.sender;
    }
}
