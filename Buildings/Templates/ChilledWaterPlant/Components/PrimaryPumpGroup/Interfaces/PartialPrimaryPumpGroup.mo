within Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces;
partial model PartialPrimaryPumpGroup

  replaceable package Medium = Buildings.Media.Water;
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPumpGroup typ "Type of pump"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  parameter Boolean have_parChi "= true if chillers in inlet are connected in parallel";
  parameter Boolean have_ChiByp "= true if chilled water loop has a chiller bypass";
  parameter Boolean have_byp "= true if chilled water loop has a minimum flow bypass";
  parameter Boolean have_comLeg "= true if there is a commong leg";
  parameter Boolean have_floSen "= true if primary flow is measured";
  parameter Boolean have_comLegFloSen = have_comLeg and not have_floSen "= true if common leg flow is measured"
    annotation(Dialog(enable=have_comLeg));

  outer parameter Boolean have_secondary;

  parameter Boolean have_TPCHWSup = not have_secondary
    "= true if primary chilled water supply temperature is measured"
    annotation(Dialog(enable=have_secondary));

  final parameter Boolean is_dedicated = typ == Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPumpGroup.Dedicated;

  parameter Integer nChi "Number of chillers";
  parameter Integer nPum = nChi "Number of pumps"
  annotation(Dialog(enable=not is_dedicated));

  parameter Modelica.Units.SI.MassFlowRate mTot_flow_nominal = m_flow_nominal*nPum "Total mass flow rate for pump group";

  // FixMe: Flow and dp should be read from pump curve, but are currently
  // assumed from system flow rate and pressure drop.
  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = mTot_flow_nominal/nPum
    "Nominal mass flow rate per pump";
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure drop per pump";

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal=
    dat.getReal(varName=id + ".PrimaryPump.dpValve_nominal.value")
    "Check valve pressure drop";
  parameter Modelica.Units.SI.PressureDifference dpByp_nominal=
    if have_byp
    then dat.getReal(varName=id + ".PrimaryPump.dpByp_nominal.value")
    else 0
    "Bypass valve pressure drop";

  Bus busCon(final nPum=nPum)
    "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  Modelica.Fluid.Interfaces.FluidPorts_a ports_parallel[nChi](
    redeclare each final package Medium = Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if have_parChi
    "Pump group inlet for chiller connected in parallel" annotation (Placement(
        transformation(extent={{-108,-30},{-92,30}}), iconTransformation(extent=
           {{-108,-30},{-92,30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_ChiByp(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_ChiByp
    "Pump group inlet for waterside economizer bypass"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_series(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if not have_parChi
    "Pump group inlet for chiller connected in series"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Pump group outlet"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_byp(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_byp or have_comLeg
    "Pump group outlet for bypass or commong leg"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));

  replaceable parameter Fluid.Movers.Data.Generic per(
    pressure(
      V_flow=m_flow_nominal / 1000 .* {0,1,2},
      dp=dp_nominal .* {1.5,1,0.5}))
    constrainedby Fluid.Movers.Data.Generic
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-88,-90},{-68,-70}})));
equation
  connect(port_b, port_b)
    annotation (Line(points={{100,0},{100,0}}, color={0,127,255}));
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
end PartialPrimaryPumpGroup;
