within Buildings.Media.Antifreeze.Functions.Validation;
model EthyleneGlycolWater "Validation model for antifreeze mixture"
  extends Modelica.Icons.Example;
  constant Real conPhi(unit="1/s") = 1.0 "Conversion factor";
  constant Real conX_a(unit="1/s") =
    (Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.X_a_max-
     Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.X_a_min)
      "Conversion factor";

  parameter Modelica.Units.SI.Temperature T = 293.15 "Temperature";
  Real phi
    "Volume fraction of antifreeze";
  Modelica.Units.SI.MassFraction X_a_phi
    "Mass fraction of antifreeze";
  Modelica.Units.SI.MassFraction X_a
    "Mass fraction of antifreeze";

  Modelica.Units.SI.Density d(displayUnit="kg/m3")
    "Density of antifreeze-water mixture";
  Modelica.Units.SI.DynamicViscosity eta
      "Dynamic Viscosity of antifreeze-water mixture";
  Modelica.Units.SI.Temperature Tf
    "Temperature of fusion of antifreeze-water mixture";
  Modelica.Units.SI.SpecificHeatCapacity cp
    "Specific heat capacity of antifreeze-water mixture";
  Modelica.Units.SI.ThermalConductivity lambda
      "Thermal conductivity of antifreeze-water mixture";

equation
  phi = conPhi*time;
  X_a = Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.X_a_min+conX_a*time;

  X_a_phi = Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.volumeToMassFraction(
    T=T,
    phi=phi);

  d = Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.density_TX_a(
    T=T,
    X_a=X_a);
  eta = Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.dynamicViscosity_TX_a(
    T=T,
    X_a=X_a);
  Tf = Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.fusionTemperature_TX_a(
    T=T,
    X_a=X_a);
  cp = Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.specificHeatCapacityCp_TX_a(
    T=T,
    X_a=X_a);
  lambda = Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.thermalConductivity_TX_a(
    T=T,
    X_a=X_a);

  annotation (
    experiment(
      StopTime=1,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/Antifreeze/Functions/Validation/EthyleneGlycolWater.mos"
        "Simulate and plot"),
     Documentation(info="<html>
<p>
Validation model for the functions of
<a href=\"modelica://Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater\">
Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater</a>.
The model plots the fluid properties for different volume and mass conctentrations.
</p>
</html>", revisions="<html>
<ul>
<li>
April 16, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end EthyleneGlycolWater;
