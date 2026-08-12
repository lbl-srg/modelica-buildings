within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses;
partial model PartialBorehole
  "Partial model to implement multi-segment boreholes"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    computeFlowResistance=
      computePressureDrop and (
        use_detailedPressureDrop or
        dp_nominal > Modelica.Constants.eps));

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (choices(
      choice(redeclare package Medium =
        Buildings.Media.Water
        "Water"),
      choice(redeclare package Medium =
        Buildings.Media.Antifreeze.EthyleneGlycolWater(
          property_T=293.15,
          X_a=0.40)
        "Ethylene glycol water, 40% mass fraction"),
      choice(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater(
          property_T=293.15,
          X_a=0.40)
        "Propylene glycol water, 40% mass fraction")));

  constant Real mSenFac(min=1)=1
   "Factor for scaling the sensible thermal mass of the volume";

  parameter Integer nSeg(min=1) = 10
    "Number of segments to use in vertical discretization of the boreholes";
  parameter Modelica.Units.SI.Temperature TGro_start[nSeg]
    "Start value of grout temperature" annotation (Dialog(tab="Initialization"));

  parameter Modelica.Units.SI.Temperature TFlu_start[nSeg]=TGro_start
    "Start value of fluid temperature" annotation (Dialog(tab="Initialization"));
        
  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));

  parameter Data.Borefield.Template borFieDat "Borefield parameters"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  
  // Advanced parameters borehole
  parameter Boolean computePressureDrop = true
    "Set to true to compute pressure drop"
    annotation (
      Evaluate=true,
      Dialog(tab="Advanced", group="Pressure drop"));

  parameter Boolean use_detailedPressureDrop = false
    "Set to true to compute the vertical pipe pressure drop from Darcy-Weisbach instead of using the nominal borehole pressure drop"
    annotation (
      Evaluate=true,
      Dialog(
        tab="Advanced",
        group="Pressure drop",
        enable=computePressureDrop));

  parameter Buildings.Fluid.Types.FluidProperties fluidProperties =
    Buildings.Fluid.Types.FluidProperties.DefaultTemperature
    "Fluid-property evaluation for the detailed pressure drop calculation"
    annotation (
      Evaluate=true,
      Dialog(
        tab="Advanced",
        group="Pressure drop",
        enable=computePressureDrop and use_detailedPressureDrop));

  parameter Modelica.Units.SI.Temperature T_ref = Medium.T_default
    "Reference temperature for fluid-property evaluation"
    annotation (Dialog(
      tab="Advanced",
      group="Pressure drop",
      enable=computePressureDrop and use_detailedPressureDrop and
             fluidProperties == Buildings.Fluid.Types.FluidProperties.DefaultTemperature));
  
  parameter Modelica.Units.SI.Density rhoMed =
    Medium.density(Medium.setState_pTX(
      Medium.p_default,
      T_ref,
      Medium.X_default))
    "User-specified density used only if fluidProperties=Constant; ensure consistency with Medium"
    annotation (Dialog(
      tab="Advanced",
      group="Pressure drop",
      enable=computePressureDrop and use_detailedPressureDrop and
             fluidProperties == Buildings.Fluid.Types.FluidProperties.Constant));
  parameter Modelica.Units.SI.DynamicViscosity muMed =
    Medium.dynamicViscosity(Medium.setState_pTX(
      Medium.p_default,
      T_ref,
      Medium.X_default))
    "User-specified dynamic viscosity used only if fluidProperties=Constant; ensure consistency with Medium"
    annotation (Dialog(
      tab="Advanced",
      group="Pressure drop",
      enable=computePressureDrop and use_detailedPressureDrop and
             fluidProperties == Buildings.Fluid.Types.FluidProperties.Constant));

  parameter Real kUBend(unit="1", min=0) = 2
    "Minor-loss coefficient of one U-bend"
    annotation (Dialog(
      tab="Advanced",
      group="Pressure drop",
      enable=computePressureDrop and use_detailedPressureDrop));

  parameter Boolean use_TDepRConv = false
    "Set to true to evaluate fluid thermal properties from the local medium state for the pipe convection resistance"
    annotation (
      Evaluate=true,
      Dialog(tab="Advanced", group="Heat transfer"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall[nSeg]
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

protected
  final parameter Boolean use_TDepFluidProperties=
    fluidProperties <> Buildings.Fluid.Types.FluidProperties.Constant or
    use_TDepRConv
    "Set to true if borefield-specific fluid-property evaluation is requested";


  final parameter Boolean isAllowedTDepMedium=
    .Buildings.Fluid.BaseClasses.Media.Functions.isTemperatureDependentFluidMedium(
      mediumName=Medium.mediumName)
    "Set to true if the medium supports temperature-dependent borefield property evaluation";

  parameter Medium.ThermodynamicState state_default=
    Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default[1:Medium.nXi])
    "Default medium state";

  parameter Modelica.Units.SI.Density rho_default=
    Medium.density(state_default)
    "Density at default medium state";

  parameter Modelica.Units.SI.DynamicViscosity mu_default=
    Medium.dynamicViscosity(state_default)
    "Dynamic viscosity at default medium state";

equation
  assert(
    noEvent(not use_TDepFluidProperties or isAllowedTDepMedium),
    "In " + getInstanceName() + ": Temperature-dependent borefield fluid-property "
    + "evaluation is only supported for the following media:\n"
    + "  Buildings.Media.Water\n"
    + "  Buildings.Media.Antifreeze.EthyleneGlycolWater\n"
    + "  Buildings.Media.Antifreeze.PropyleneGlycolWater\n"
    + "The redeclared medium has Medium.mediumName = \""
    + Medium.mediumName + "\".\n"
    + "Set fluidProperties=Buildings.Fluid.Types.FluidProperties.Constant "
    + "and disable use_TDepRConv, or redeclare one of the supported media.",
    AssertionLevel.error);

    annotation(Documentation(info="<html>
<p>
Partial model to implement models simulating geothermal U-tube boreholes modeled
as several borehole segments, with a uniform borehole wall boundary condition.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2026, by L. Meertens:<br/>
Added borehole-level propagation parameters for Darcy-Weisbach pressure-drop
calculation and temperature-dependent fluid-property evaluation for pipe
pressure drop and pipe convection resistance.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>

<li>
May 17, 2024, by Michael Wetter:<br/>
Updated model due to removal of parameter <code>dynFil</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1885\">IBPSA, #1885</a>.
</li>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice to water and glycolWater.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
July 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation of partial model.
</li>
<li>
July 2014, by Damien Picard:<br/>
First implementation.
</ul>
</html>"),
Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={
        Rectangle(
          extent={{-68,76},{72,-84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-56},{64,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,54},{64,50}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,2},{64,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,76},{-60,-84}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{64,76},{74,-84}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward)}));
end PartialBorehole;
