// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IQStateEconomy {
    function transferLogistics(address _to, uint256 _value) external returns (bool success);
    function balanceOf(address _account) external view returns (uint256);
}

contract SovereignAirdrop {
    address public sovereignGovernment; // STG Command
    IQStateEconomy public tokenEconomy; // Hubungan ke QSTATE Token
    
    uint256 public totalRescuedSouls;
    uint256 public baseGrantAmount = 1000 * 10**18; // Basis 1.000 QSTATE per jiwa

    struct VestingSchedule {
        uint256 totalAmount;
        uint256 claimedAmount;
        uint256 startTime;
        uint256 duration;
        bool isRegistered;
    }

    mapping(address => VestingSchedule) public rescueVestingRegistry;

    event SoulWelcomed(address indexed citizenDID, uint256 immediateRelease, uint256 lockedVesting);
    event LogisticsClaimed(address indexed citizenDID, uint256 amount);

    modifier onlySTG() {
        require(msg.sender == sovereignGovernment, "Unauthorized: Only Sovereign Command");
        _;
    }

    constructor(address _tokenEconomyAddress) {
        sovereignGovernment = msg.sender;
        tokenEconomy = IQStateEconomy(_tokenEconomyAddress);
    }

    /**
     * @notice Registrasi Otomatis Jiwa Baru Terintegrasi dengan Sistem Autopoiesis
     * Pemicu langsung ketika pintu dermaga penyelamatan mengonfirmasi DID warga baru.
     */
    function autoDistributeToNewSoul(address _newCitizenDID, uint256 _currentTotalPopulation) external onlySTG {
        require(!rescueVestingRegistry[_newCitizenDID].isRegistered, "DID already registered in economy");
        
        totalRescuedSouls++;

        // Hitung Modal Awal Dinamis menggunakan pendekatan peredam populasi (Anti-Inflasi)
        // Formula: Base Grant / sqrt(Populasi Saat Ini / 100K)
        uint256 dynamicScaleFactor = 1;
        if (_currentTotalPopulation > 100000) {
            dynamicScaleFactor = _currentTotalPopulation / 100000;
        }
        
        uint256 finalGrantAmount = baseGrantAmount / squareRoot(dynamicScaleFactor);
        
        // 20% Cair Instan untuk Hak Hidup Darurat (Makanan & Oksigen Ekstra)
        uint256 immediateRelease = (finalGrantAmount * 20) / 100;
        uint256 lockedAmount = finalGrantAmount - immediateRelease;

        // Catat jadwal penguncian token (Vesting) selama 30 Hari (2592000 Detik)
        rescueVestingRegistry[_newCitizenDID] = VestingSchedule({
            totalAmount: finalGrantAmount,
            claimedAmount: immediateRelease,
            startTime: block.timestamp,
            duration: 30 days,
            isRegistered: true
        });

        // Kirim 20% langsung ke DID Wallet warga baru dari cadangan kas Sovereign Government
        tokenEconomy.transferLogistics(_newCitizenDID, immediateRelease);

        emit SoulWelcomed(_newCitizenDID, immediateRelease, lockedAmount);
    }

    /**
     * @notice Klaim Mandiri Alokasi Berjangka oleh Warga Baru
     * Setiap jam, warga bisa menarik sisa jatah token \$QSTATE mereka secara bertahap.
     */
    function claimVestedLogistics() external {
        VestingSchedule storage schedule = rescueVestingRegistry[msg.sender];
        require(schedule.isRegistered, "DID not found in rescue database");
        
        uint256 vestedAmount = calculateVestedAmount(msg.sender);
        uint256 claimable = vestedAmount - schedule.claimedAmount;
        
        require(claimable > 0, "No claimable logistics token at this hour");
        
        schedule.claimedAmount += claimable;
        tokenEconomy.transferLogistics(msg.sender, claimable);
        
        emit LogisticsClaimed(msg.sender, claimable);
    }

    function calculateVestedAmount(address _citizen) public view returns (uint256) {
        VestingSchedule memory schedule = rescueVestingRegistry[_citizen];
        if (!schedule.isRegistered) return 0;
        if (block.timestamp >= schedule.startTime + schedule.duration) {
            return schedule.totalAmount;
        }
        
        uint256 timeElapsed = block.timestamp - schedule.startTime;
        uint256 vestedLinear = (schedule.totalAmount * 80 / 100) * timeElapsed / schedule.duration;
        uint256 baseTwentyPercent = (schedule.totalAmount * 20) / 100;
        
        return baseTwentyPercent + vestedLinear;
    }

    // Fungsi matematika pembantu untuk komputasi on-chain
    function squareRoot(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}
