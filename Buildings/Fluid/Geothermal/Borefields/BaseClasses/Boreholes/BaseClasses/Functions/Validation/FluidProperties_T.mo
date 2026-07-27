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

  (cpFix, kFix, muFix, rhoFix) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T(
      use_TDep=false,
      fluidPropertyEvaluation=
        Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.Water,
      T=T,
      p=p,
      X_a=0.40,
      cp_default=4184,
      k_default=0.6,
      mu_default=1.0e-3,
      rho_default=995.586);

  (cpWat, kWat, muWat, rhoWat) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T(
      use_TDep=true,
      fluidPropertyEvaluation=
        Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.Water,
      T=T,
      p=p,
      X_a=0.40,
      cp_default=4184,
      k_default=0.6,
      mu_default=1.0e-3,
      rho_default=995.586);

  (cpGly, kGly, muGly, rhoGly) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.fluidProperties_T(
      use_TDep=true,
      fluidPropertyEvaluation=
        Buildings.Fluid.Geothermal.Borefields.Types.FluidPropertyEvaluation.PropyleneGlycolWater,
      T=T,
      p=p,
      X_a=0.40,
      cp_default=3600,
      k_default=0.45,
      mu_default=0.003,
      rho_default=1030);

  annotation (
    experiment(StopTime=3600, Tolerance=1e-6),
    Documentation(info="<html>
<p>
This model validates the fluid property helper function for fixed properties,
temperature-dependent water correlation properties, and temperature-dependent
propylene-glycol/water correlation properties.
</p>
</html>"));
end FluidProperties_T;
