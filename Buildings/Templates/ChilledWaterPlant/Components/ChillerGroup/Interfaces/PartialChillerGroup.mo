within Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces;
partial model PartialChillerGroup
  replaceable package MediumCW = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium 1 in the component"
      annotation (Dialog(enable=not isAirCoo));
  replaceable package MediumCHW = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium 2 in the component";

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup typ
    "Type of chiller group"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_series = typ == Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerSeries
    "= true if chillers are connected in series";
  parameter Boolean isAirCoo
    "= true, chillers in group are air cooled,
    = false, chillers in group are water cooled"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Integer nChi "Number of chillers in group";
  outer parameter Integer nCooTow "Number of cooling towers";

  parameter Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.Data dat(
    final typ=typ,
    final isAirCoo=isAirCoo,
    final nChi=nChi)
    "Chiller group data";

  parameter Boolean allowFlowReversal1 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1"
    annotation(Dialog(tab="Assumptions", enable=not isAirCoo), Evaluate=true);
  parameter Boolean allowFlowReversal2 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 2"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter MediumCW.MassFlowRate m1_flow_small(min=0) = 1E-4*abs(dat.m1_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced", enable=not isAirCoo));
  parameter MediumCHW.MassFlowRate m2_flow_small(min=0) = 1E-4*abs(dat.m2_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

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
    h_outflow(start = MediumCHW.h_default, nominal = MediumCHW.h_default))
    if typ == Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerSeries
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));

  Modelica.Fluid.Interfaces.FluidPorts_b ports_b2[nChi](
    redeclare each final package Medium = MediumCHW,
    each m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumCHW.h_default, nominal=MediumCHW.h_default))
    if typ == Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerParallel
    "Fluid connector b2 for multiple outlets (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-92,-32},{-108,32}}),
        iconTransformation(extent={{8,-32},{-8,32}},
        rotation=270,
        origin={-60,-100})));

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busCon(
    final nChi=nChi, final nCooTow=nCooTow)
    "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  BoundaryConditions.WeatherData.Bus weaBus if isAirCoo
    "Weather control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=180,
        origin={-40,100}), iconTransformation(
        extent={{-12.5,11.7677},{7.5,-8.23748}},
        rotation=180,
        origin={-42.5,101.768})));
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
