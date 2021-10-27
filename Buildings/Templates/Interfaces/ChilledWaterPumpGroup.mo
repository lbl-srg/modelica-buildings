within Buildings.Templates.Interfaces;
partial model ChilledWaterPumpGroup
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  parameter Boolean has_ParChi = true "Chillers in inlet are connected in parallel";
  parameter Boolean has_WSEByp "= true if there is a waterside economizer bypass";
  parameter Boolean has_byp "= true if there is an outlet bypass or common leg";

  parameter Integer nChi = 1 "Number of chillers";
  parameter Integer nPumPri = 1 "Number of primary pumps";
  parameter Integer nPumSec = 1 "Number of secondary pumps";

  Buildings.Templates.BaseClasses.Connectors.BusInterface busCon "Control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  parameter Types.ChilledWaterPumpGroup typ "Type of pump"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Modelica.Fluid.Interfaces.FluidPorts_a ports_parallel[nChi](
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if has_ParChi
    "Pump group inlet for chiller connected in parallel" annotation (Placement(
        transformation(extent={{-108,-30},{-92,30}}), iconTransformation(extent=
           {{-108,-30},{-92,30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_WSEByp(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if has_WSEByp
    "Pump group inlet for waterside economizer bypass"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_series(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if not has_ParChi
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
    if has_byp
    "Pump group outlet for bypass or commong leg"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
equation
  connect(port_b, port_b)
    annotation (Line(points={{100,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChilledWaterPumpGroup;
