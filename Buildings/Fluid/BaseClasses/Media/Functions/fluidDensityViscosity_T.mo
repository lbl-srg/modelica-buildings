within Buildings.Fluid.BaseClasses.Media.Functions;
function fluidDensityViscosity_T
  "Evaluate density and dynamic viscosity for borehole pressure-drop correlations"
  extends .Modelica.Icons.Function;

  input .Buildings.Fluid.BaseClasses.Media.Types.TemperatureDependentPropertyFluid
    fluid
    "Fluid used for temperature-dependent property evaluation";

  input .Modelica.Units.SI.Temperature T
    "Fluid temperature used for property evaluation";

  input .Modelica.Units.SI.AbsolutePressure p=300000
    "Fluid pressure used for property evaluation";

  input .Modelica.Units.SI.MassFraction X_a=0
    "Mass fraction of glycol in water";

  output .Modelica.Units.SI.DynamicViscosity mu
    "Dynamic viscosity used by the pressure-drop correlation";

  output .Modelica.Units.SI.Density rho
    "Density used by the pressure-drop correlation";

protected
  package Water =
    .Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water property package used for temperature-dependent water correlations";

  Water.ThermodynamicState staWat
    "Water state for temperature-dependent water correlations";

algorithm
  if fluid ==
    .Buildings.Fluid.BaseClasses.Media.Types.TemperatureDependentPropertyFluid.Water then

    staWat := Water.setState_pTX(
      p=p,
      T=T,
      X=Water.X_default);

    mu := Water.dynamicViscosity(staWat);
    rho := Water.density(staWat);

  elseif fluid ==
    .Buildings.Fluid.BaseClasses.Media.Types.TemperatureDependentPropertyFluid.EthyleneGlycolWater then

    assert(
      X_a >= 0 and X_a <= 0.6,
      "The ethylene glycol mass fraction X_a must be between 0 and 0.6.");

    mu :=
      .Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.dynamicViscosity_TX_a(
        T=T,
        X_a=X_a);

    rho :=
      .Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.density_TX_a(
        T=T,
        X_a=X_a);

  elseif fluid ==
    .Buildings.Fluid.BaseClasses.Media.Types.TemperatureDependentPropertyFluid.PropyleneGlycolWater then

    assert(
      X_a >= 0 and X_a <= 0.6,
      "The propylene glycol mass fraction X_a must be between 0 and 0.6.");

    mu :=
      .Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.dynamicViscosity_TX_a(
        T=T,
        X_a=X_a);

    rho :=
      .Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.density_TX_a(
        T=T,
        X_a=X_a);

  end if;

  annotation (
    Inline=false,
    Documentation(info="<html>
<p>
This function evaluates the temperature-dependent density and dynamic viscosity
used by borehole pressure-drop correlations.
</p>
<p>
For water, properties are evaluated using
<code>Buildings.Media.Specialized.Water.TemperatureDependentDensity</code>.
For ethylene-glycol/water and propylene-glycol/water, properties are evaluated
using the corresponding functions in
<code>Buildings.Media.Antifreeze.Functions</code>.
</p>
<p>
The fluid selector is an internal value derived from the redeclared medium.
It is not intended to be set by users.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2026, by L. Meertens:<br/>
Revised implementation to support water, ethylene-glycol/water and
propylene-glycol/water based on the redeclared medium.
</li>
<li>
July 27, 2026, by Lone Meertens:<br/>
First implementation.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4483\">Buildings, #4483</a>.
</li>
</ul>
</html>"));
end fluidDensityViscosity_T;
