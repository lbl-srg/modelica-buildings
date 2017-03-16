within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model DryWetCalcsSweep
  "Creates a plot of using the DryWetCalcs over a range of input relative humidity"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.Examples.DryWetCalcs(
    wAirInExp(y = wAirIn * R),
    hAirInExp(y = Medium_A.specificEnthalpy_pTX(
      p = pAir,
      T = TAirIn,
      X = {wAirIn * R, 1 - (wAirIn * R)})));
  Real R
    "Parameter to adjust wAirIn with time";
equation
  R = time / 10;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DryWetCalcsSweep;
