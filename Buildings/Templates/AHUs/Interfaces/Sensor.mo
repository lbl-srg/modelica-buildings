within Buildings.Templates.AHUs.Interfaces;
partial model Sensor
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Types.Sensor typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Modelica.Fluid.Interfaces.FluidPort_b port_bRef(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if
    typ==Types.Sensor.DifferentialPressure
    "Port at the reference pressure for differential pressure sensor"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
  Buildings.Templates.BaseClasses.AhuBus ahuBus "AHU control bus" annotation (
      Placement(transformation(extent={{-20,80},{20,120}}), iconTransformation(
          extent={{-10,90},{10,110}})));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Sensor;
