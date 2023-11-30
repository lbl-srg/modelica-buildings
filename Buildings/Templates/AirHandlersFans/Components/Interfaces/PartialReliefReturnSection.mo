within Buildings.Templates.AirHandlersFans.Components.Interfaces;
partial model PartialReliefReturnSection "Interface class for relief/return air section"

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium"
    annotation(__ctrl_flow(enable=false));

  parameter Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection typ
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
  parameter Integer nFanRel
    "Number of relief fans"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nFanRet
    "Number of return fans"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Boolean have_recHea
    "Set to true in case of heat recovery";
  parameter Buildings.Templates.AirHandlersFans.Types.ControlFanReturn typCtlFanRet
    "Return fan control type";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer typCtlEco
    "Economizer control type";

  parameter
    Buildings.Templates.AirHandlersFans.Components.Data.OutdoorReliefReturnSection
    dat "Design and operating parameters";

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=
    if typFanRet <> Buildings.Templates.Components.Types.Fan.None then dat.fanRet.m_flow_nominal
    elseif typFanRel <> Buildings.Templates.Components.Types.Fan.None then dat.fanRel.m_flow_nominal
    elseif typDamRel <> Buildings.Templates.Components.Types.Damper.None then dat.damRel.m_flow_nominal
    else dat.damRet.m_flow_nominal
    "Air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  final parameter Modelica.Units.SI.PressureDifference dpFan_nominal=
    if typFanRel <> Buildings.Templates.Components.Types.Fan.None then
      dat.fanRel.dp_nominal
    elseif typFanRet <> Buildings.Templates.Components.Types.Fan.None then
      dat.fanRet.dp_nominal
    else 0
    "Relief/return fan total pressure rise"
    annotation (
      Dialog(group="Nominal condition",
        enable=typFanRel <> Buildings.Templates.Components.Types.Fan.None or
          typFanRet <> Buildings.Templates.Components.Types.Fan.None));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"),
      __ctrl_flow(enable=false));

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true, __ctrl_flow(enable=false));

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
    if typ <> Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.NoReturn
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
  Buildings.Fluid.FixedResistances.Junction splEco(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal={1,-1,-1}*m_flow_nominal,
    final dp_nominal=fill(0, 3),
    final energyDynamics=energyDynamics,
    final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter with air economizer"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure pAirRet_rel(
    redeclare final package Medium = MediumAir,
    final have_sen=typFanRet<>Buildings.Templates.Components.Types.Fan.None and
      typCtlFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.BuildingPressure)
    "Return fan discharge static pressure sensor"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
equation
  /* Control point connection - start */
  connect(pAirRet_rel.y, bus.pAirRet_rel);
  /* Control point connection - end */
  connect(splEco.port_3, port_bRet)
    annotation (Line(points={{0,-10},{0,-140}}, color={0,127,255}));
  connect(pAirRet_rel.port_a, splEco.port_1) annotation (Line(points={{50,40},{20,40},
          {20,0},{10,0}}, color={0,127,255}));
  connect(pAirRet_rel.port_b, port_bPre)
    annotation (Line(points={{70,40},{80,40},{80,-140}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},
            {180,140}}), graphics={
        Text(
          extent={{-149,-150},{151,-190}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}})),
    Documentation(info="<html>
<p>
This class provides a standard interface for the relief/return
air section of an air handler.
Typical components in that section include
</p>
<ul>
<li>
shut off relief (or exhaust) air dampers,
</li>
<li>
the relief air side of the heat recovery unit,
</li>
<li>
the relief damper of the air economizer,
</li>
<li>
the relief or return fan.
</li>
</ul>
</html>"));
end PartialReliefReturnSection;
