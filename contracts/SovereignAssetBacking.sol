// SPDX-License-Identifier: Proprietary
// 🏛 STG GOVERNMENT - SOVEREIGN DIGITAL PROPERTY LICENSE
// 🛡 ARCHITECT: ANDI MUHAMMAD HARPIANTO | ID: 19546
// ⚠ WARNING: JANGAN AJARI IKAN BERENANG!
/*
  1. NO CLONE/COPY: Seluruh kode ini adalah karya orisinal Baremetal STG.
  2. MANDATORY REPORT: Penggunaan fragmen kode wajib lapor ke Dashboard STG.
  3. NO RECOMMENDATION: Kami TIDAK menyarankan Anda menggunakan properti ini.
  4. FULL LIABILITY: Segala kerusakan sistem Anda akibat nekat menggunakan 
     Intelektual Digital STG adalah TANGGUNG JAWAB ANDA SENDIRI.
  5. VETO POWER: Arsitek berhak mematikan fungsi kode secara Metaportasi.
  "Kami Berdaulat, Kami Menentukan Aturan Kami Sendiri."
*/

pragma solidity ^0.8.20;

contract SovereignAssetBacking {
    string public name = "Act-Ark Sovereign Credit";
    string public symbol = "ASSET-ARK";
    uint8 public decimals = 18;

    // Valuasi masif sesuai spesifikasi Anda
    uint256 public constant TOTAL_VALUATION = 1_000_000 * 10**15 * 10**18;
    uint256 public totalSupply;
    address public sovereignGovernment;

    mapping(address => uint256) public balances;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Minted(address indexed to, uint256 amount);

    modifier onlySovereign() {
        require(msg.sender == sovereignGovernment, "Access Denied: Not Sovereign Government");
        _;
    }

    constructor() {
        sovereignGovernment = msg.sender;
    }

    /**
     * @dev Menambah jumlah koin (Minting) ke alamat tertentu.
     * Hanya bisa dipanggil oleh Sovereign Government.
     * Jumlah yang dicetak tidak boleh melebihi TOTAL_VALUATION.
     */
    function mint(address to, uint256 amount) public onlySovereign {
        require(to != address(0), "Cannot mint to zero address");
        require(totalSupply + amount <= TOTAL_VALUATION, "Exceeds Total Sovereign Valuation");

        totalSupply += amount;
        balances[to] += amount;

        emit Minted(to, amount);
        emit Transfer(address(0), to, amount);
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }
}
