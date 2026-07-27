within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions;
function fluidProperties_T
  "Evaluate fluid properties for borehole heat-transfer and pressure-drop correlations"
  extends Modelica.Icons.Function;

  input Boolean use_TDep
    "Set to true to evaluate properties at the current fluid temperature";

  input Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation
    fluidPropertyEvaluation=
      Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.Water
    "Method used to evaluate fluid properties";

  input Modelica.Units.SI.Temperature T
    "Fluid temperature used for property evaluation";

  input Modelica.Units.SI.AbsolutePressure p=300000
    "Fluid pressure used for property evaluation";

  input Modelica.Units.SI.MassFraction X_a=0.40
    "Mass fraction of propylene glycol in water";

  input Modelica.Units.SI.SpecificHeatCapacity cp_default
    "Default specific heat capacity, used if use_TDep=false";

  input Modelica.Units.SI.ThermalConductivity k_default
    "Default thermal conductivity, used if use_TDep=false";

  input Modelica.Units.SI.DynamicViscosity mu_default
    "Default dynamic viscosity, used if use_TDep=false";

  input Modelica.Units.SI.Density rho_default
    "Default density, used if use_TDep=false";

  output Modelica.Units.SI.SpecificHeatCapacity cp
    "Specific heat capacity used by the correlation";

  output Modelica.Units.SI.ThermalConductivity k
    "Thermal conductivity used by the correlation";

  output Modelica.Units.SI.DynamicViscosity mu
    "Dynamic viscosity used by the correlation";

  output Modelica.Units.SI.Density rho
    "Density used by the correlation";

protected
  package Water =
    Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water property package used for temperature-dependent water correlations";

  Water.ThermodynamicState staWat
    "Water state for temperature-dependent water correlations";

algorithm
  if not use_TDep then
    cp := cp_default;
    k := k_default;
    mu := mu_default;
    rho := rho_default;

  elseif fluidPropertyEvaluation ==
    Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.Water then

    staWat := Water.setState_pTX(
      p=p,
      T=T,
      X=Water.X_default);

    cp := Water.specificHeatCapacityCp(staWat);
    k := Water.thermalConductivity(staWat);
    mu := Water.dynamicViscosity(staWat);
    rho := Water.density(staWat);

  elseif fluidPropertyEvaluation ==
    Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.PropyleneGlycolWater then

    assert(
      X_a >= 0 and X_a <= 0.6,
      "The propylene glycol mass fraction X_a must be between 0 and 0.6.");

    cp :=
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.specificHeatCapacityCp_TX_a(
        T=T,
        X_a=X_a);

    k :=
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.thermalConductivity_TX_a(
        T=T,
        X_a=X_a);

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
      "fluidProperties_T does not handle GenericMedium. Use Medium property calls directly for GenericMedium.");
  end if;

  annotation (
    Inline=false,
    Documentation(info="<html>
<p>
This function evaluates fluid properties used by borehole heat-transfer and
pressure-drop correlations.
</p>
<p>
If <code>use_TDep=false</code>, the function returns the supplied default
properties. If <code>use_TDep=true</code>, the function evaluates either water
properties using
<code>Buildings.Media.Specialized.Water.TemperatureDependentDensity</code>
or propylene-glycol/water properties using
<code>Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater</code>.
</p>
<p>
The generic medium case is intentionally not handled here to avoid
replaceable-package function-call syntax. Generic medium properties should be
evaluated directly in the calling model using <code>Medium.*</code>.
</p>
</html>"));
end fluidProperties_T;
