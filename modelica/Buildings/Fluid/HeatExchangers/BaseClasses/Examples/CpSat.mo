within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model CpSat "Test model for cpSat function"
 parameter Modelica.SIunits.Pressure p = 101325 "Atmospheric pressure";
 Modelica.SIunits.Temperature T1 "Temperature";
 Modelica.SIunits.MassFraction XW2 "Species concentration";
 Modelica.SIunits.SpecificHeatCapacity cpSat
    "Specific heat capacity along saturation line";
 constant Real conv = (0.025-0.05) "Conversion factor";
equation
  T1=293.15;
  XW2=0.05 + conv * time;
 cpSat = Buildings.Fluid.HeatExchangers.BaseClasses.cpSat(T1=T1, XW2=XW2, p=p);
 annotation(Commands(file="CpSat.mos" "run"));
end CpSat;
