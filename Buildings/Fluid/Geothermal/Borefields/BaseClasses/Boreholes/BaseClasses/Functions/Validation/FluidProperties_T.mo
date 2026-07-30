within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.Validation;
model FluidProperties_T
  "Validation model for fluidProperties_T"
  extends Modelica.Icons.Example;

  Modelica.Units.SI.Temperature T
    "Temperature sweep";

  Modelica.Units.SI.AbsolutePressure p=300000
    "Pressure";

  Modelica.Units.SI.SpecificHeatCapacity cpFix;
  Modelica.Units.SI.ThermalConductivity kFix;
  Modelica.Units.SI.DynamicViscosity muFix;
  Modelica.Units.SI.Density rhoFix;

  Modelica.Units.SI.SpecificHeatCapacity cpWat;
  Modelica.Units.SI.ThermalConductivity kWat;
  Modelica.Units.SI.DynamicViscosity muWat;
  Modelica.Units.SI.Density rhoWat;

  Modelica.Units.SI.SpecificHeatCapacity cpGly;
  Modelica.Units.SI.ThermalConductivity kGly;
  Modelica.Units.SI.DynamicViscosity muGly;
  Modelica.Units.SI.Density rhoGly;

equation
  T = 273.15 + 5 + 35*time/3600;

  cpFix = 4184;
  kFix = 0.6;
  muFix = 1.0e-3;
  rhoFix = 995.586;

  (cpWat, kWat, muWat, rhoWat) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T(
      fluidPropertyEvaluation=
        Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.Water,
      T=T,
      p=p,
      X_a=0.40);

  (cpGly, kGly, muGly, rhoGly) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T(
      fluidPropertyEvaluation=
        Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.PropyleneGlycolWater,
      T=T,
      p=p,
      X_a=0.40);

  annotation (
    experiment(StopTime=3600, Tolerance=1e-6),
    __Dymola_Commands(file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Functions/Validation/FluidProperties_T.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This validation model tests
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T</a>.
</p>
<p>
The model compares constant reference properties with temperature-dependent
water properties and temperature-dependent propylene-glycol/water properties
over a prescribed temperature sweep. The constant reference properties are
assigned directly, while the temperature-dependent properties are evaluated
with the property function.
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2026, by Lone Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4483\">Buildings, #4483</a>.
</li>
</ul>
</html>"));

end FluidProperties_T;
