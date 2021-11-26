within Buildings.Templates.Components.Fans.Interfaces;
partial model PartialFan
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Buildings.Templates.Components.Types.Fan typ
  "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_senFlo
    "Set to true for air flow measurement"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Fan total pressure rise"
    annotation (
      Dialog(group="Nominal condition"));

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(
      V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
      dp={2*dp_nominal,dp_nominal,0}))
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Dialog(enable=typ <> Buildings.Templates.Components.Types.Fan.None),
      Placement(transformation(extent={{-90,-88},{-70,-68}})));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Buildings.Templates.Components.Interfaces.Bus bus
    if typ <> Buildings.Templates.Components.Types.Fan.None
    "Control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate V_flow(
    redeclare final package Medium = Medium,
    final have_sen=have_senFlo,
    final m_flow_nominal=m_flow_nominal)
    "Air volume flow rate sensor"
    annotation (
      Placement(transformation(extent={{70,-10},{90,10}})));
equation
  connect(port_b, V_flow.port_b)
    annotation (Line(points={{100,0},{90,0}}, color={0,127,255}));
  connect(V_flow.y, bus.V_flow)
    annotation (Line(points={{80,12},{80,100},{0,100}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialFan;
