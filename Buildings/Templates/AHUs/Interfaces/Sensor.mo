within Buildings.Templates.AHUs.Interfaces;
partial model Sensor
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Types.Sensor typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Types.Branch bra
    "Branch where the equipment is installed"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y if typ<>Types.Sensor.None
    "Measured quantity"
    annotation (Placement(transformation(
        origin={0,120},
        extent={{-20,-20},{20,20}},
        rotation=90), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,120})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bRef(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if
    typ==Types.Sensor.DifferentialPressure
    "Port at the reference pressure for differential pressure sensor"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Sensor;
