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

  parameter Modelica.SIunits.SpecificEnthalpy dhVapStd=
    MediumSte.specificEnthalpy(MediumSte.setState_pTX(
        p=pSatHig,
        T=TSatHig,
        X=MediumSte.X_default)) -
      MediumWat.specificEnthalpy(MediumWat.setState_pTX(
        p=pSatHig,
        T=TSatHig,
        X=MediumWat.X_default))
    "Standard change in enthalpy due to vaporization";

  parameter Modelica.SIunits.SpecificHeatCapacity cpSteHigStd=
     MediumSte.specificHeatCapacityCp(MediumSte.setState_pTX(
       p=pSatHig,
       T=TSatHig,
       X=MediumSte.X_default))
    "Standard specific heat of steam at the high pressure setpoint";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialWaterPhaseChange;
