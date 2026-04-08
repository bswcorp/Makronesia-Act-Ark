// SPDX-License-Identifier: Proprietary
// 🏛 STG GOVERNMENT - SOVEREIGN DIGITAL PROPERTY LICENSE
// 🛡 ARCHITECT: ANDI MUHAMMAD HARPIANTO | ID: 19546
// ⚠ WARNING: JANGAN AJARI IKAN BERENANG!

pragma solidity ^0.8.20;

contract SovereignAssetBacking {
    // Identitas Aset
    string public name = "Act-Ark Sovereign Credit";
    string public symbol = "ASSET-ARK";
    uint8 public decimals = 18;

    // Valuasi masif: 1 Sektiliun unit koin utuh
    uint256 public constant TOTAL_VALUATION = 1_000_000 * 10**15 * 10**18;
    uint256 public totalSupply;
    
    address public sovereignGovernment;
    bool public isVetoed = false; // Status Kedaulatan

    mapping(address => uint256) public balances;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Minted(address indexed to, uint256 amount);
    event SovereignVetoTriggered(address indexed architect, string reason);

    // Modifier: Memastikan hanya Pemerintah Berdaulat yang bisa akses
    modifier onlySovereign() {
        require(msg.sender == sovereignGovernment, "Access Denied: Not Sovereign Government");
        _;
    }

    // Modifier: Memastikan sistem tidak sedang dalam status Veto
    modifier activeSovereignty() {
        require(!isVetoed, "Sovereign Power: System has been Vetoed/Disabled");
        _;
    }

    constructor() {
        sovereignGovernment = msg.sender;
    }

    /**
     * @dev VETO POWER (METAPORTASI)
     * Poin 5 Lisensi: Arsitek berhak mematikan fungsi kode secara permanen.
     */
    function triggerSovereignVeto(string memory reason) public onlySovereign {
        isVetoed = true;
        emit SovereignVetoTriggered(msg.sender, reason);
    }

    /**
     * @dev Menambah jumlah koin (Minting).
     * Terikat pada batas TOTAL_VALUATION dan status Kedaulatan Aktif.
     */
    function mint(address to, uint256 amount) public onlySovereign activeSovereignty {
        require(to != address(0), "Cannot mint to zero address");
        require(totalSupply + amount <= TOTAL_VALUATION, "Exceeds Total Sovereign Valuation");

        totalSupply += amount;
        balances[to] += amount;

        emit Minted(to, amount);
        emit Transfer(address(0), to, amount);
    }

    /**
     * @dev Fungsi Transfer Dasar.
     * Tidak akan berfungsi jika Veto telah diaktifkan.
     */
    function transfer(address to, uint256 amount) public activeSovereignty returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient Sovereign Balance");
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }
}
