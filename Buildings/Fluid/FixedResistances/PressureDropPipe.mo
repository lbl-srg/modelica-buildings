within Buildings.Fluid.FixedResistances;
model PressureDropPipe
  "Pipe pressure drop model with selectable pressure drop calculation"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Boolean computePressureDrop = true
    "Set to true to compute pressure drop"
    annotation (
      Evaluate=true,
      Dialog(group="Pressure drop"));

  parameter Boolean use_detailedPressureDrop = false
    "Set to true to compute pressure drop from pipe geometry using Darcy-Weisbach equation"
    annotation (
      Evaluate=true,
      Dialog(
        group="Pressure drop",
        enable=computePressureDrop));

  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa") = 0
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(
      group="Nominal pressure drop",
      enable=computePressureDrop and not use_detailedPressureDrop));

  parameter Real n(min=1, max=2) = 2
    "Flow exponent, n=1 for laminar, n=2 for turbulent"
    annotation (
      Evaluate=true,
      Dialog(
        tab="Advanced",
        group="Nominal pressure drop",
        enable=computePressureDrop and not use_detailedPressureDrop and
               abs(dp_nominal) > Modelica.Constants.eps));

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (
      Evaluate=true,
      Dialog(
        tab="Advanced",
        group="Nominal pressure drop",
        enable=computePressureDrop and not use_detailedPressureDrop and
               abs(dp_nominal) > Modelica.Constants.eps));

  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (
      Evaluate=true,
      Dialog(
        tab="Advanced",
        group="Nominal pressure drop",
        enable=computePressureDrop and not use_detailedPressureDrop and
               abs(dp_nominal) > Modelica.Constants.eps));

  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
    annotation (
      Evaluate=true,
      Dialog(
        tab="Advanced",
        group="Nominal pressure drop",
        enable=computePressureDrop and not use_detailedPressureDrop and
               abs(dp_nominal) > Modelica.Constants.eps and not linearized));

  parameter Modelica.Units.SI.Length length
    "Pipe length"
    annotation (Dialog(
      group="Geometry",
      enable=computePressureDrop and use_detailedPressureDrop));

  parameter Modelica.Units.SI.Length dh
    "Hydraulic diameter"
    annotation (Dialog(
      group="Geometry",
      enable=computePressureDrop and use_detailedPressureDrop));

  parameter Modelica.Units.SI.Length roughness = 0.001e-3
    "Absolute pipe wall roughness"
    annotation (Dialog(
      group="Geometry",
      enable=computePressureDrop and use_detailedPressureDrop));

  parameter Real kMinor(unit="1", min=0) = 0
    "Total minor-loss coefficient"
    annotation (Dialog(
      group="Pressure drop",
      enable=computePressureDrop and use_detailedPressureDrop));

  parameter Buildings.Fluid.Types.FluidProperties fluidProperties =
    Buildings.Fluid.Types.FluidProperties.DefaultTemperature
    "Fluid-property evaluation for the detailed pressure drop calculation"
    annotation (
      Evaluate=true,
      Dialog(
        group="Fluid properties",
        enable=computePressureDrop and use_detailedPressureDrop));

  parameter Modelica.Units.SI.Temperature T_ref = Medium.T_default
    "Reference temperature for fluid-property evaluation"
    annotation (Dialog(
      group="Fluid properties",
      enable=computePressureDrop and use_detailedPressureDrop and
             fluidProperties == Buildings.Fluid.Types.FluidProperties.DefaultTemperature));

  parameter Modelica.Units.SI.Density rhoMed =
    Medium.density(Medium.setState_pTX(
      Medium.p_default,
      T_ref,
      Medium.X_default))
    "Constant fluid density used for detailed pressure drop calculation"
    annotation (Dialog(
      group="Fluid properties",
      enable=computePressureDrop and use_detailedPressureDrop and
             fluidProperties == Buildings.Fluid.Types.FluidProperties.Constant));

  parameter Modelica.Units.SI.DynamicViscosity muMed =
    Medium.dynamicViscosity(Medium.setState_pTX(
      Medium.p_default,
      T_ref,
      Medium.X_default))
    "Constant fluid dynamic viscosity used for detailed pressure drop calculation"
    annotation (Dialog(
      group="Fluid properties",
      enable=computePressureDrop and use_detailedPressureDrop and
             fluidProperties == Buildings.Fluid.Types.FluidProperties.Constant));

  Modelica.Units.SI.PressureDifference dpMajor
    "Major Darcy-Weisbach pressure drop";

  Modelica.Units.SI.PressureDifference dpMinor
    "Minor pressure drop";

  Modelica.Units.SI.ReynoldsNumber Re
    "Reynolds number";

protected
  final parameter Boolean use_detailedPressureDrop_internal =
    computePressureDrop and use_detailedPressureDrop
    "Set to true to use detailed Darcy-Weisbach pressure drop model"
    annotation (Evaluate=true);

  final parameter Boolean use_nominalPressureDrop_internal =
    computePressureDrop and not use_detailedPressureDrop
    "Set to true to use nominal pressure drop model"
    annotation (Evaluate=true);

  final parameter Boolean use_losslessPipe_internal =
    not computePressureDrop
    "Set to true to use lossless pipe model"
    annotation (Evaluate=true);

  Buildings.Fluid.FixedResistances.LosslessPipe los(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal)
    if use_losslessPipe_internal
    "Lossless pipe"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop preDro(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=if use_nominalPressureDrop_internal then dp_nominal else 1,
    final n=n,
    final from_dp=from_dp,
    final linearized=linearized,
    final deltaM=deltaM)
    if use_nominalPressureDrop_internal
    "Pressure drop model using nominal pressure drop"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.FixedResistances.HydraulicDiameter hydDia(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final computePressureDrop=true,
    final length=length,
    final dh=dh,
    final roughness=roughness,
    final kMinor=kMinor,
    final fluidProperties=fluidProperties,
    final T_ref=T_ref,
    final rhoMed=rhoMed,
    final muMed=muMed)
    if use_detailedPressureDrop_internal
    "Pressure drop model using Darcy-Weisbach equation"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  if use_losslessPipe_internal then
    connect(port_a, los.port_a);
    connect(los.port_b, port_b);

    dpMajor = 0;
    dpMinor = 0;
    Re = 0;

  elseif use_nominalPressureDrop_internal then
    connect(port_a, preDro.port_a);
    connect(preDro.port_b, port_b);

    dpMajor = dp;
    dpMinor = 0;
    Re = 0;

  else
    connect(port_a, hydDia.port_a);
    connect(hydDia.port_b, port_b);

    dpMajor = hydDia.dpMajor;
    dpMinor = hydDia.dpMinor;
    Re = hydDia.Re;

  end if;

  annotation (
    defaultComponentName="res",
    Icon(graphics={Text(
          extent={{-40,18},{38,-20}},
          textColor={255,255,255},
          textString="dp")}),
    Documentation(info="<html>
<p>
This model is a wrapper for pipe pressure drop calculations.
It conditionally instantiates one of three pressure drop models:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.FixedResistances.LosslessPipe\">
Buildings.Fluid.FixedResistances.LosslessPipe</a>
if no pressure drop is computed.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a>
if the pressure drop is computed from the nominal pressure drop and nominal
mass flow rate.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.FixedResistances.HydraulicDiameter\">
Buildings.Fluid.FixedResistances.HydraulicDiameter</a>
if the pressure drop is computed from pipe geometry using a Darcy-Weisbach
pressure loss calculation.
</li>
</ul>
<p>
If <code>computePressureDrop=false</code>, the model uses a lossless pipe.
If <code>computePressureDrop=true</code> and
<code>use_detailedPressureDrop=false</code>, the model uses the nominal pressure
drop model when <code>abs(dp_nominal) &gt; 0</code>, and otherwise uses a
lossless pipe.
If <code>computePressureDrop=true</code> and
<code>use_detailedPressureDrop=true</code>, the model uses the detailed
Darcy-Weisbach pressure drop model.
</p>
<p>
The conditional implementation removes the unused pressure drop models during
translation.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2026, by Lone Meertens:<br/>
First implementation for selecting between lossless, nominal and detailed
Darcy-Weisbach pipe pressure drop calculations.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4687\">Buildings, #4687</a>.
</li>
</ul>
</html>"));
end PressureDropPipe;
