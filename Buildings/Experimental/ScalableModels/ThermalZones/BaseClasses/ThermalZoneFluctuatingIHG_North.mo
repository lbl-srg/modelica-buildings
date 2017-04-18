within Buildings.Experimental.ScalableModels.ThermalZones.BaseClasses;
model ThermalZoneFluctuatingIHG_North
  "Thermal zone model: North exterior wall"
  extends Buildings.Experimental.ScalableModels.ThermalZones.BaseClasses.ThermalZoneFluctuatingIHG(
    roo(
      datConExtWin(
        azi={N_})));
end ThermalZoneFluctuatingIHG_North;
