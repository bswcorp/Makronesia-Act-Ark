// packages/propulsion/EngineCore.js
// Mengatur detakan mesin brutal 180 derajat ke luar orbit

const Biosphere = require('../../ecology/BiosphereAutomation');

const PROPULSION_SYSTEM = {
    TOTAL_VEHICLE_MASS_KG: 500000000, // 500 Ribu Ton
    ESCAPE_VELOCITY_MS: 11200,
    ENGINE_ANGLE_DEGREES: 180,        // Tegak lurus menghempas bumi menuju angkasa
    IS_SUPER_FAST_MODE: true
};

function initiateOrbitEscape() {
    console.log("BRUTAL MODE ACTIVATED: Diverting 95% of Nuclear Fusion Core to Thrusters.");
    
    // PENTING: Beri tahu sistem ekosistem untuk melakukan pengerasan struktural
    const structuralLockdownSuccess = Biosphere.prepareForGForceAkselerasi(5.5); // 5.5 G-Force
    
    if (structuralLockdownSuccess) {
        console.log("Ignition! Unleashing 31.3 Petajoules of energy. Direction: Space.");
        // Jalankan pendorong utama
    } else {
        console.log("ABORT: Biosphere structural integrity cannot withstand G-Force.");
    }
}
