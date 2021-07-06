within Buildings.Fluid.Interfaces;
partial model PartialWaterPhaseChange
  "Partial model with fundamental equations for water phase change"
  replaceable package MediumSte = Buildings.Media.Steam constrainedby
    Modelica.Media.Interfaces.PartialMedium
     "Steam medium";
  replaceable package MediumWat = Buildings.Media.Water constrainedby
    Modelica.Media.Interfaces.PartialMedium
    "Water medium";

  parameter Modelica.SIunits.AbsolutePressure pSatHig
    "Saturation pressure at the high pressure setpoint";

  parameter Modelica.SIunits.Temperature TSatHig=
     MediumSte.saturationTemperature(pSatHig)
     "Saturation temperature at the high pressure setpoint";

protected
  parameter MediumWat.ThermodynamicState staWat_default=MediumWat.setState_pTX(
      T=TSatHig, p=pSatHig, X=MediumWat.X_default);
  parameter MediumSte.ThermodynamicState staSte_default=MediumSte.setState_pTX(
      T=TSatHig, p=pSatHig, X=MediumSte.X_default);

  parameter Modelica.SIunits.SpecificEnthalpy dhVapStd=
    MediumSte.specificEnthalpy(staSte_default) -
      MediumWat.specificEnthalpy(staWat_default)
    "Standard change in enthalpy due to vaporization";

  parameter Modelica.SIunits.SpecificHeatCapacity cpWatStd=
     MediumWat.specificHeatCapacityCp(staWat_default)
    "Standard specific heat of liquid water";
  parameter Modelica.SIunits.SpecificHeatCapacity cpSteStd=
     MediumSte.specificHeatCapacityCp(staSte_default)
    "Standard specific heat of steam";

  parameter Modelica.SIunits.Density rhoWatStd=
     MediumWat.density(staWat_default)
    "Standard density of liquid water";
  parameter Modelica.SIunits.Density rhoSteStd=
     MediumSte.density(staSte_default)
    "Standard density of steam";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialWaterPhaseChange;
