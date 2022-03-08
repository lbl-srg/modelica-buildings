within Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces;
partial model PartialPrimaryPumpGroup

  parameter Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces.Data dat(
    final nPum=nPum,
    final have_chiByp=have_chiByp,
    final have_byp=have_byp)
    "Primary pump group data";

  replaceable package Medium = Buildings.Media.Water;

  parameter Integer nPum=2 "Number of pumps";
  parameter Integer nChi=2 "Number of chillers in group";
  outer parameter Integer nCooTow "Number of cooling towers";

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);


  parameter Boolean have_parChi "= true if chillers in inlet are connected in parallel";
  parameter Boolean have_chiByp "= true if chilled water loop has a chiller bypass";
  parameter Boolean have_byp "= true if chilled water loop has a minimum flow bypass";
  parameter Boolean have_comLeg "= true if there is a commong leg";
  parameter Boolean have_floSen "= true if primary flow is measured";
  parameter Boolean have_comLegFloSen = have_comLeg and not have_floSen "= true if common leg flow is measured"
    annotation(Dialog(enable=have_comLeg));

  outer parameter Boolean have_secondary;

  parameter Boolean have_TPCHWSup = not have_secondary
    "= true if primary chilled water supply temperature is measured"
    annotation(Dialog(enable=have_secondary));

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busCon(
    final nChi=nChi, final nCooTow=nCooTow)
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
    if have_chiByp
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

    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false),
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
