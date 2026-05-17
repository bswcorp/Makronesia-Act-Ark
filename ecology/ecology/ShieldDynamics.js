// ecology/ShieldDynamics.js

const SHIELD_CONFIG = {
    REQUIRED_FIELD_TESLA: 1.5,
    POWER_CONSUMPTION_GW: 2.5,
    CRITICAL_RADIATION_MSV: 10.0, // Ambang batas bahaya radiasi untuk 100K jiwa
    SHIELD_STATUS: "INACTIVE"
};

function monitorSpaceWeather(currentRadiationFlux) {
    if (currentRadiationFlux >= SHIELD_CONFIG.CRITICAL_RADIATION_MSV) {
        console.log(`CRITICAL RADIATION DETECTED: ${currentRadiationFlux} mSv/h.`);
        return requestEmergencyPowerDirect(SHIELD_CONFIG.POWER_CONSUMPTION_GW);
    }
    return "STABLE_ENVIRONMENT";
}

function requestEmergencyPowerDirect(requiredPower) {
    console.log(`REDIRECTING: Requesting ${requiredPower} GW from Fusion Reactor Core to HTS Superconducting Coils.`);
    SHIELD_CONFIG.SHIELD_STATUS = "ACTIVE_DEFLECTION_FIELD_1.5T";
    return SHIELD_CONFIG.SHIELD_STATUS;
}
