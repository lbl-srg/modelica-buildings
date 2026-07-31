within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions;
function fluidDensityViscosity_T
  "Evaluate density and dynamic viscosity for borehole pressure-drop correlations"
  extends Modelica.Icons.Function;

  input Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation
    fluidPropertyEvaluation =
      Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.Water
    "Method used to evaluate fluid properties";

  input Modelica.Units.SI.Temperature T
    "Fluid temperature used for property evaluation";

  input Modelica.Units.SI.AbsolutePressure p=300000
    "Fluid pressure used for property evaluation";

  input Modelica.Units.SI.MassFraction X_a
    "Mass fraction of propylene glycol in water";

  output Modelica.Units.SI.DynamicViscosity mu
    "Dynamic viscosity used by the pressure-drop correlation";

  output Modelica.Units.SI.Density rho
    "Density used by the pressure-drop correlation";

protected
  package Water =
    Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water property package used for temperature-dependent water correlations";

  Water.ThermodynamicState staWat
    "Water state for temperature-dependent water correlations";

algorithm
  if fluidPropertyEvaluation ==
    Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.Water then

    staWat := Water.setState_pTX(
      p=p,
      T=T,
      X=Water.X_default);

    mu := Water.dynamicViscosity(staWat);
    rho := Water.density(staWat);

  elseif fluidPropertyEvaluation ==
    Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.PropyleneGlycolWater then

    assert(
      X_a >= 0 and X_a <= 0.6,
      "The propylene glycol mass fraction X_a must be between 0 and 0.6.");

    mu :=
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.dynamicViscosity_TX_a(
        T=T,
        X_a=X_a);

    rho :=
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.density_TX_a(
        T=T,
        X_a=X_a);

  else
    assert(
      false,
      "fluidDensityViscosity_T does not handle GenericMedium. Use Medium property calls directly for GenericMedium.");
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
For propylene-glycol/water, properties are evaluated using
<code>Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater</code>.
Fixed/default properties should be assigned directly by the caller. 
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
</html>")
);
end fluidDensityViscosity_T;
