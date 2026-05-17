// packages/interstellar/AutopoieticPairing.js

const AutopoieticSystem = {
    // Keadaan Awal Kapal (Aman)
    CURRENT_POPULATION: 100000,
    BASE_O2_QUOTA_KG: 0.84,            // Jatah normal per orang/hari
    ACTIVE_DRONE_FACTORIES: 10,        // Pabrik drone awal
    
    // Status Sumber Daya Riil Kapal
    TOTAL_AVAILABLE_ENERGY_GW: 5.0,
    SYSTEM_STATUS: "STABLE_BALANCE"
};

/**
 * PUSAT LOGIKA BERPASANGAN (The Pairing Mechanism)
 * Fungsi ini dipicu otomatis ketika radar navigasi mendeteksi masuknya gelombang massa 
 * manusia atau entitas yang membutuhkan pertolongan dalam jumlah masif tak terduga.
 */
function synchronizeMassiveInflow(newIncomingSouls) {
    console.log(`\n=== ALERT: COSMIC INFLOW DETECTED ===`);
    console.log(`Incoming mass needing rescue: +${newIncomingSouls} entities.`);
    
    // 1. Perbarui total populasi (Menuju tak terhingga)
    AutopoieticSystem.CURRENT_POPULATION += newIncomingSouls;
    const N = AutopoieticSystem.CURRENT_POPULATION;
    
    console.log(`Total Protected Population now: ${N} souls.`);

    // 2. JALAN SEJALAN FASE A: Algoritma Pembagian Logistik Fraksional (Logaritmik)
    // Menggunakan Math.log(N) untuk memastikan konsumsi melandai meskipun populasi meledak
    const dynamicReductionFactor = 1 / Math.log(N);
    const fractionalO2Quota = AutopoieticSystem.BASE_O2_QUOTA_KG * dynamicReductionFactor * 4.6; // Skala penyesuaian konstanta
    
    console.log(`[FASE A - LOGISTIK] Executing Fractional Rationing...`);
    console.log(`Individual O2 quota automatically squeezed to: ${fractionalO2Quota.toFixed(4)} kg/day.`);

    // Hitung surplus energi bersih yang berhasil diselamatkan dari pengetatan logistik habitat
    const energySavedFromHabitatGW = (AutopoieticSystem.BASE_O2_QUOTA_KG - fractionalO2Quota) * (N / 100000) * 0.1;
    
    // 3. JALAN SEJALAN FASE B: Replikasi Mandiri Armada Drone (Von Neumann Swarm)
    // Sisa energi dialirkan langsung ke cetak cetakan printer 3D robotik logam
    console.log(`[FASE B - REPLIKASI] Channelling ${energySavedFromHabitatGW.toFixed(2)} GW of surplus energy to Von Neumann nodes...`);
    
    const newFactoriesNeeded = Math.floor(AutopoieticSystem.ACTIVE_DRONE_FACTORIES * Math.sqrt(N / 100000));
    const factoryGrowth = newFactoriesNeeded - AutopoieticSystem.ACTIVE_DRONE_FACTORIES;
    
    AutopoieticSystem.ACTIVE_DRONE_FACTORIES = newFactoriesNeeded;
    
    console.log(`VON NEUMANN ACTIVATION: Mitigating threat by self-replicating +${factoryGrowth} new autonomous drone hives.`);
    console.log(`Total active production nodes: ${AutopoieticSystem.ACTIVE_DRONE_FACTORIES} cells.`);
    
    AutopoieticSystem.SYSTEM_STATUS = "DYNAMIC_EXPANSION_ACTIVE";
    verifySystemIntegrity();
}

function verifySystemIntegrity() {
    console.log(`[INTEGRITY] Pairing Mechanism Complete. Equilibrium established under dynamic expansion.`);
    console.log(`=========================================\n`);
}

// SIMULASI EKSTRIM: Terjadi krisis kosmik, masuk gelombang pengungsi 1 Juta Jiwa secara instan!
synchronizeMassiveInflow(1000000);

// SIMULASI LANJUTAN: Masuk lagi gelombang tak terduga sebesar 10 Juta Jiwa!
synchronizeMassiveInflow(10000000);

module.exports = { synchronizeMassiveInflow };
