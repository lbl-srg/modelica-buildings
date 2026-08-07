within Buildings.Fluid.BaseClasses.Media.Functions.Validation;
model FluidDensityViscosity_T
  "Validation model for fluidDensityViscosity_T"
  extends .Modelica.Icons.Example;

  .Modelica.Units.SI.Temperature T
    "Temperature sweep";

  .Modelica.Units.SI.AbsolutePressure p=300000
    "Pressure";

  constant Real X_aGly(unit="1", min=0, max=0.6) = 0.40
    "Mass fraction of propylene glycol in water";

  .Modelica.Units.SI.DynamicViscosity muFix
    "Constant reference dynamic viscosity";

  .Modelica.Units.SI.Density rhoFix
    "Constant reference density";

  .Modelica.Units.SI.DynamicViscosity muWat
    "Temperature-dependent water dynamic viscosity";

  .Modelica.Units.SI.Density rhoWat
    "Temperature-dependent water density";

  .Modelica.Units.SI.DynamicViscosity muGly
    "Temperature-dependent glycol dynamic viscosity";

  .Modelica.Units.SI.Density rhoGly
    "Temperature-dependent glycol density";

equation
  T = 273.15 + 5 + 35*time/3600;

  muFix = 1.0e-3;
  rhoFix = 995.586;

  (muWat, rhoWat) =
    .Buildings.Fluid.BaseClasses.Media.Functions.fluidDensityViscosity_T(
      fluidPropertyEvaluation=
        .Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.Water,
      T=T,
      p=p,
      X_a=X_aGly);

  (muGly, rhoGly) =
    .Buildings.Fluid.BaseClasses.Media.Functions.fluidDensityViscosity_T(
      fluidPropertyEvaluation=
        .Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.PropyleneGlycolWater,
      T=T,
      p=p,
      X_a=X_aGly);

  annotation (
    experiment(StopTime=3600, Tolerance=1e-6),
    __Dymola_Commands(file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/Media/Functions/Validation/fluidDensityViscosity_T.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This validation model tests
<a href=\"modelica://Buildings.Fluid.BaseClasses.Media.Functions.fluidDensityViscosity_T\">
Buildings.Fluid.BaseClasses.Media.Functions.fluidDensityViscosity_T</a>.
</p>
<p>
The model compares constant reference density and dynamic viscosity with
temperature-dependent water properties and temperature-dependent
propylene-glycol/water properties over a prescribed temperature sweep.
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
end FluidDensityViscosity_T;
