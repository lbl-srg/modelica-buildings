within Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces;
partial model PartialChillerGroup
//   extends Buildings.Fluid.Interfaces.PartialOptionalFourPortInterface(
//     redeclare package MediumCW=Buildings.Media.Water,
//     redeclare package Medium2=Buildings.Media.Water,
//     final haveMediumCW=not isAirCoo,
//     final haveMedium2=true);

  parameter Boolean isAirCoo
    "= true, chillers in group are air cooled,
    = false, chillers in group are water cooled";
  parameter Boolean have_dedPum "Parallel chillers are connected to dedicated pumps";

  parameter Integer nChi "Number of chillers in group";

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup typ "Type of chiller group"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  replaceable package MediumCW = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component"
      annotation (Dialog(enable=not isAirCoo));
  replaceable package MediumCHW = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium 2 in the component";

  parameter Boolean allowFlowReversal1 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1"
    annotation(Dialog(tab="Assumptions", enable=not isAirCoo), Evaluate=true);
  parameter Boolean allowFlowReversal2 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 2"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nChi](
    redeclare each final package Medium = MediumCW,
    each m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
    each h_outflow(start=MediumCW.h_default, nominal=MediumCW.h_default))
    if not isAirCoo
    "Fluid connectors a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-108,28},{-92,92}}),
        iconTransformation(extent={{-108,28},{-92,92}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = MediumCW,
    m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
    h_outflow(start = MediumCW.h_default, nominal = MediumCW.h_default)) if not isAirCoo
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,50},{90,70}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = MediumCHW,
    m_flow(min=if allowFlowReversal2 then -Modelica.Constants.inf else 0),
    h_outflow(start = MediumCHW.h_default, nominal = MediumCHW.h_default))
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = MediumCHW,
    m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
    h_outflow(start = MediumCHW.h_default, nominal = MediumCHW.h_default)) if typ == Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerSeries
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));

  Modelica.Fluid.Interfaces.FluidPorts_b ports_b2[nChi](
    redeclare each final package Medium = MediumCHW,
    each m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumCHW.h_default, nominal=MediumCHW.h_default)) if typ == Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerParallel
    "Fluid connector b2 for multiple outlets (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-92,-32},{-108,32}}),
        iconTransformation(extent={{8,-32},{-8,32}},
        rotation=270,
        origin={-60,-100})));

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition", enable=not isAirCoo));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dp1_nominal=
    if isAirCoo then 0
    else dat.getReal(varName=id + ".ChillerGroup.dpCW_nominal.value")
    "Pressure difference"
    annotation(Dialog(group = "Nominal condition", enable=not isAirCoo));
  parameter Modelica.Units.SI.PressureDifference dp2_nominal=
    dat.getReal(varName=id + ".ChillerGroup.dpCHW_nominal.value")
    "Pressure difference"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal=
    if have_dedPum then 0
    else dat.getReal(varName=id + ".ChillerGroup.dpValve_nominal.value")
    "Nominal pressure drop of chiller valves"
    annotation(Dialog(group = "Nominal condition"));

  final parameter Modelica.Units.SI.PressureDifference dpCHW_nominal=
    dp2_nominal + dpValve_nominal
    "Total nominal pressure drop on chilled water side";

  parameter MediumCW.MassFlowRate m1_flow_small(min=0) = 1E-4*abs(m1_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced", enable=not isAirCoo));
  parameter MediumCHW.MassFlowRate m2_flow_small(min=0) = 1E-4*abs(m2_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.Bus busCon(nChi=nChi) "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  parameter Modelica.Units.SI.Power Q_nominal=
    dat.getReal(varName=id + ".ChillerGroup.Q_nominal.value");

  parameter Modelica.Units.SI.Temperature TCHWSet=
    dat.getReal(varName=id + ".ChillerGroup.TCHWSet.value");

  replaceable parameter Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    per constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller(
      QEva_flow_nominal=-Q_nominal,
      TEvaLvg_nominal=TCHWSet,
      mEva_flow_nominal=m2_flow_nominal,
      mCon_flow_nominal=m1_flow_nominal) "Chiller performance data"
    annotation (Placement(transformation(extent={{70,-8},{90,12}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
      Text(
          extent={{-100,-100},{100,-140}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialChillerGroup;
