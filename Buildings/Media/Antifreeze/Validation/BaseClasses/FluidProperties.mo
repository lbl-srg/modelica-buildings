within Buildings.Media.Antifreeze.Validation.BaseClasses;
model FluidProperties
  "Model that tests the implementation of temperature- and concentration-dependent fluid properties"

  replaceable package Medium =
      Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater
    "Package with medium functions";

  parameter Integer nX_a
    "Number of mass fractions to evaluate fluid properties";
  parameter Modelica.Units.SI.MassFraction X_a[nX_a]
    "Mass fraction of additive";
  parameter Modelica.Units.SI.Temperature T_min
    "Minimum temperature of mixture";
  parameter Modelica.Units.SI.Temperature T_max
    "Maximum temperature of mixture";
  Modelica.Units.SI.Temperature Tf[nX_a] "Fluid temperature";
  Modelica.Units.SI.Density d[nX_a] "Density of fluid mixture";
  Modelica.Units.SI.SpecificHeatCapacity cp[nX_a]
    "Specific heat capacity of fluid mixture";
  Modelica.Units.SI.ThermalConductivity lambda[nX_a] "Density of fluid mixture";
  Modelica.Units.SI.DynamicViscosity eta[nX_a]
    "Dynamic viscosity of fluid mixture";
  Modelica.Units.SI.Temperature T "Temperature of fluid mixture";
  Modelica.Units.NonSI.Temperature_degC T_degC "Celsius temperature";

protected
  parameter Modelica.Units.SI.Time dt=1 "Simulation length";
  parameter Real convT(unit="K/s") = (T_max-T_min)/dt
    "Rate of temperature change";

equation
  T = T_min + convT*time;
  T_degC =Modelica.Units.Conversions.to_degC(T);
  for i in 1:nX_a loop
    Tf[i] =Medium.fusionTemperature_TX_a(T=T, X_a=X_a[i]);
    d[i] =if T >= Tf[i] then Medium.density_TX_a(T=T, X_a=X_a[i]) else 0.;
    cp[i] =if T >= Tf[i] then Medium.specificHeatCapacityCp_TX_a(T=T, X_a=X_a[i])
       else 0.;
    lambda[i] =if T >= Tf[i] then Medium.thermalConductivity_TX_a(T=T, X_a=X_a[i]) else 0.;
    eta[i] =if T >= Tf[i] then Medium.dynamicViscosity_TX_a(T=T, X_a=X_a[i])
       else 0.;
  end for;

   annotation (
Documentation(info="<html>
<p>
This example checks the implementation of functions that evaluate the
temperature- and concentration-dependent thermophysical properties of the
medium.
</p>
<p>
Thermophysical properties (density, specific heat capacity, thermal conductivity
and dynamic viscosity) are shown as 0 if the temperature is below the fusion
temperature.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 16, 2026, by Michael Wetter:<br/>
Revised implementation for to use functions from new property function package.
</li>
<li>
March 14, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end FluidProperties;
