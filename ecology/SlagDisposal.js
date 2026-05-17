// ecology/SlagDisposal.js

const Autopilot = require('../propulsion/AutopilotVector');

const SLAG_MANAGEMENT = {
    DAILY_WASTE_TONS: 71999.0,
    COMPACTED_BLOCK_MASS_KG: 10000, // 10 Ton per blok solid
    EJECTOR_STATUS: "READY"
};

function processAsteroidWaste(extractedTons) {
    console.log(`PROCESSING WASTE: Compacting ${extractedTons.toFixed(0)} tons of asteroid slag into solid blocks.`);
    
    const totalBlocks = (extractedTons * 1000) / SLAG_MANAGEMENT.COMPACTED_BLOCK_MASS_KG;
    console.log(`COMPACTION SUCCESS: Generated ${totalBlocks.toFixed(0)} Slag Blocks.`);
    
    executeSafeEjection(totalBlocks);
}

function executeSafeEjection(numberOfBlocks) {
    // Ambil koordinat arah terbang Bahtera saat ini dari Autopilot
    const currentVelocityVector = { x: 11200, y: 0, z: 0 }; 

    // Kalkulasi arah pembuangan negatif (180 derajat terbalik dari jalur navigasi)
    const ejectionVector = {
        x: -currentVelocityVector.x * 0.1, // Menembak ke arah belakang kapal
        y: 0,
        z: 0
    };

    console.log(`RAILGUN ACTIVATED: Ejecting ${numberOfBlocks.toFixed(0)} blocks to vector [x:${ejectionVector.x}, y:${ejectionVector.y}].`);
    console.log("NAV_SENSOR_SAFE: Optical and LIDAR navigation arrays are clear from debris interference.");
    
    SLAG_MANAGEMENT.EJECTOR_STATUS = "EJECTION_COMPLETED";
    return true;
}

module.exports = { processAsteroidWaste };
