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
  parameter Buildings.Templates.AirHandlersFans.Types.ControlReturnFan typCtrFanRet
    "Return fan control type"
    annotation (Evaluate=true,
      Dialog(
        group="Configuration",
        enable=typFanRet <> Buildings.Templates.Components.Types.Fan.None));
  parameter Boolean have_recHea
    "Set to true in case of heat recovery"
    annotation (Evaluate=true,
      Dialog(
        group="Configuration",
        enable=typ <> AirHandlersFans.Types.ReliefReturnSection.NoRelief));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpFan_nominal=
    if typFanRel <> Buildings.Templates.Components.Types.Fan.None or
      typFanRet <> Buildings.Templates.Components.Types.Fan.None then
      dat.getReal(varName=id + ".Mechanical.Relief/return fan.Total pressure rise.value")
    else 0
    "Relief/return fan total pressure rise"
    annotation (
      Dialog(group="Nominal condition",
        enable=typFanRel <> Buildings.Templates.Components.Types.Fan.None or
          typFanRet <> Buildings.Templates.Components.Types.Fan.None));

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
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,140}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,140})));

  Buildings.Templates.BaseClasses.PassThroughFluid pas(
    redeclare final package Medium = MediumAir)
    if not have_recHea and typ <> Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.NoRelief
    "Direct pass through (conditional)"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
protected
  Modelica.Fluid.Interfaces.FluidPort_a port_aIns(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ <> Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.NoRelief
    "Inside fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(port_aHeaRec, pas.port_a) annotation (Line(points={{-80,-140},{-80,0},
          {-70,0}},  color={0,127,255}));
  connect(port_aIns, pas.port_b)
    annotation (Line(points={{-40,0},{-50,0}}, color={0,127,255}));
  connect(port_aIns, port_bHeaRec) annotation (Line(points={{-40,0},{-40,-140}},
                      color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},
            {180,140}}), graphics={
        Text(
          extent={{-149,-150},{151,-190}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}})));
end PartialReliefReturnSection;
