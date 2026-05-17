// packages/propulsion/FusionOptimizer.js

const AsteroidContract = require('../../contracts/AsteroidMiningGovernance');
const ShieldSystem = require('../../ecology/ShieldDynamics');

const FUSION_REACTOR = {
    HE3_INVENTORY_KG: 0.05,            // Sisa pasokan kritis karena kegagalan penambangan
    CURRENT_OUTPUT_GW: 4.0,            // Beban saat ini (Perisai + Biosfer esensial)
    CONVERSION_EFFICIENCY: 0.45,       // Efisiensi awal (45%)
    PLASMA_MODE: "PURE_HE3",
    DEUTERIUM_RESERVE_KG: 5000.0       // Melimpah dari siklus air ekosistem
};

function runEmergencyGridSimulation() {
    console.log("--- SIMULATION START: FUEL STARVATION UNDER CME ATTACK ---");
    
    const isShieldActive = ShieldSystem.getShieldStatus().includes("ACTIVE");
    
    if (isShieldActive && FUSION_REACTOR.HE3_INVENTORY_KG <= 0.1) {
        console.log("CRITICAL WARP: Fuel depletion imminent while Deflector Shield is drawing 2.5GW!");
        executeFusionEfficiencyOptimization();
    }
}

function executeFusionEfficiencyOptimization() {
    console.log("INITIATING OPTIMIZATION: Injecting Deuterium Catalysis...");
    
    // Mengubah mode fusi untuk meningkatkan Cross-Section energi
    FUSION_REACTOR.PLASMA_MODE = "DEUTERIUM_HE3_HYBRID";
    
    // Menerapkan pengereman magnetik untuk retensi panas plasma
    FUSION_REACTOR.CONVERSION_EFFICIENCY = 0.78; // Efisiensi melonjak ke 78%
    
    // Perhitungan matematis penghematan bahan bakar baru
    const extendedTimeHours = (FUSION_REACTOR.HE3_INVENTORY_KG / 0.024) * (0.78 / 0.45);
    
    console.log(`OPTIMIZATION SUCCESSFUL: Efficiency raised to 78%.`);
    console.log(`Reactor lifespan extended to: ${extendedTimeHours.toFixed(2)} Hours.`);
    
    // Jika waktu masih kurang dari durasi badai surya, eksekusi protokol brutal terakhir
    if (extendedTimeHours < 24.0) {
        enforceBrutalCivilianRationing();
    }
}

function enforceBrutalCivilianRationing() {
    console.log("BRUTAL ACTION FOR GOOD: Cutting civilian sector gravity and light by 70%.");
    console.log("Re-routing remaining 1.0 GW from habitat luxury to the Magnetic Shield Core.");
    FUSION_REACTOR.CURRENT_OUTPUT_GW = 3.0; // Total beban ditekan seminimal mungkin
}

module.exports = { runEmergencyGridSimulation };
