// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ArkCivilLaw {
    address public sovereignGovernment; // STG Hak Veto Absolut
    uint256 public totalCitizens = 100000;

    enum CitizenshipStatus { ACTIVE, RESTRICTED, EXILED }
    enum ViolationType { RESOURCE_HOARDING, SABOTAGE, CIVIL_DISORDER }

    struct CitizenProfile {
        bytes32 citizenIDHash;          // DID Anonim terenkripsi demi privasi
        CitizenshipStatus status;
        uint256 socialCreditScore;      // Skala 0 - 100 (Default: 100)
        uint256 resourceQuotaMultiplier;// Jatah logistik harian (Basis: 100 = 100%)
        uint256 mandatoryEcoServiceHours;
    }

    mapping(address => CitizenProfile) public arkCitizens;
    mapping(uint256 => bool) public activeLaws;

    event LawEnacted(uint256 lawId, string description);
    event JusticeExecuted(address indexed offender, ViolationType violation, string sanction);
    event RehabilitationCompleted(address indexed citizen, uint256 hoursServed);

    modifier onlySTG() {
        require(msg.sender == sovereignGovernment, "Unauthorized: Only STG Sovereign Command");
        _;
    }

    constructor() {
        sovereignGovernment = msg.sender;
    }

    // 1. Logika Penjatuhan Sanksi Otomatis (Aksi Tegas Demi Kebaikan Bersama)
    // Jika warga tertangkap basah menimbun oksigen/makanan oleh sensor IoT logistik
    function reportViolation(
        address _offender, 
        ViolationType _type, 
        uint256 _severity
    ) external onlySTG {
        CitizenProfile storage citizen = arkCitizens[_offender];
        
        if (_type == ViolationType.RESOURCE_HOARDING) {
            citizen.socialCreditScore -= (10 * _severity);
            citizen.status = CitizenshipStatus.RESTRICTED;
            
            // HUKUMAN: Jatah logistik dipotong 30% dan wajib kerja bakti di reaktor alga
            citizen.resourceQuotaMultiplier = 70; 
            citizen.mandatoryEcoServiceHours += (5 * _severity);
            
            emit JusticeExecuted(_offender, _type, "Resource Quota Reduced 30%. Mandatory Eco-Service Assigned.");
        } else if (_type == ViolationType.SABOTAGE) {
            // Pelanggaran fatal merusak infrastruktur navigasi/perisai magnetik
            citizen.socialCreditScore = 0;
            citizen.status = CitizenshipStatus.EXILED;
            citizen.resourceQuotaMultiplier = 0;
            
            emit JusticeExecuted(_offender, _type, "FATAL: Total Revocation of Ark Citizenship.");
        }
    }

    // 2. Sistem Pemulihan Hak (Restorative Justice)
    // Warga dapat mengembalikan status jatah mereka setelah membersihkan tangki biosfer
    function logCompletedEcoService(address _citizen, uint256 _hours) external onlySTG {
        CitizenProfile storage citizen = arkCitizens[_citizen];
        require(citizen.mandatoryEcoServiceHours >= _hours, "Logged hours exceed requirement");
        
        citizen.mandatoryEcoServiceHours -= _hours;
        
        if (citizen.mandatoryEcoServiceHours == 0 && citizen.status == CitizenshipStatus.RESTRICTED) {
            citizen.status = CitizenshipStatus.ACTIVE;
            citizen.resourceQuotaMultiplier = 100; // Jatah oksigen/pangan kembali penuh (100%)
            citizen.socialCreditScore += 15;
            if(citizen.socialCreditScore > 100) citizen.socialCreditScore = 100;
            
            emit RehabilitationCompleted(_citizen, _hours);
        }
    }

    // 3. Sistem Legislasi Kuorum Konstitusi Baru via $QSTATE
    function emergencyLegislate(uint256 _lawId, string memory _lawDetails, bool _stgVeto) external onlySTG {
        require(!_stgVeto, "STG Veto Active: Law proposal struck down!");
        activeLaws[_lawId] = true;
        emit LawEnacted(_lawId, _lawDetails);
    }
}
