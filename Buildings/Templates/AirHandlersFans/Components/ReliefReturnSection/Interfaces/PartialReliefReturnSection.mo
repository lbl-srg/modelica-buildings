within Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces;
partial model PartialReliefReturnSection "Relief/return air section"

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  parameter AirHandlersFans.Types.ReliefReturnSection typ
    "Relief/return air section type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Damper typDamRel
    "Relief damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Fan typFanRel
    "Relief fan type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Return fan type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  outer parameter Buildings.Templates.AirHandlersFans.Types.ControlFanReturn typCtrFanRet
    "Return fan control type";
  outer parameter Boolean have_recHea
    "Set to true in case of heat recovery";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpFan_nominal
    "Relief/return fan total pressure rise"
    annotation (
      Dialog(group="Nominal condition",
        enable=typFanRel <> Buildings.Templates.Components.Types.Fan.None or
          typFanRet <> Buildings.Templates.Components.Types.Fan.None));
  parameter Modelica.SIunits.PressureDifference dpDamRel_nominal
    "Relief air damper pressure drop"
    annotation (
      Dialog(group="Nominal condition",
        enable=typDamRel<>Buildings.Templates.Components.Types.Damper.None));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{170,-10},{190,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ <> Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.NoRelief
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-170,-10},{-190,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aHeaRec(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default)) if have_recHea
    "Optional fluid connector for heat recovery"
    annotation (Placement(transformation(extent={{-90,-150},{-70,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHeaRec(
    redeclare final package Medium = MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default)) if have_recHea
    "Optional fluid connector for heat recovery"
    annotation (Placement(transformation(extent={{-30,-150},{-50,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bRet(
    redeclare final package Medium = MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ <> Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.NoEconomizer
    "Optional fluid connector for return branch"
    annotation (Placement(transformation(extent={{10,-150},{-10,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bPre(
    redeclare final package Medium = MediumAir)
    "Fluid connector for differential pressure sensor"
    annotation (Placement(transformation(extent={{90,-150},{70,-130}})));

  Buildings.Templates.AirHandlersFans.Interfaces.Bus bus
    "Control bus"
    annotation (Placement(
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,140}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,140})));

  Fluid.FixedResistances.Junction splEco(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal={1,-1,-1}*m_flow_nominal,
    final dp_nominal=fill(0, 3),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Splitter with air economizer"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure pRet_rel(
    redeclare final package Medium = MediumAir,
    final have_sen=typFanRet<>Buildings.Templates.Components.Types.Fan.None and
      typCtrFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.Pressure,
    final m_flow_nominal=m_flow_nominal)
    "Return fan discharge static pressure sensor"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
protected
  final parameter Boolean have_porPre=
    typCtrFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.Pressure
    "Set to true for an outside fluid connector for differential pressure sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
equation
  connect(splEco.port_3, port_bRet)
    annotation (Line(points={{0,-10},{0,-140}}, color={0,127,255}));
  connect(pRet_rel.port_a, splEco.port_1) annotation (Line(points={{50,40},{20,40},
          {20,0},{10,0}}, color={0,127,255}));
  connect(pRet_rel.port_b, port_bPre)
    annotation (Line(points={{70,40},{80,40},{80,-140}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},
            {180,140}}), graphics={
        Text(
          extent={{-149,-150},{151,-190}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}})));
end PartialReliefReturnSection;
