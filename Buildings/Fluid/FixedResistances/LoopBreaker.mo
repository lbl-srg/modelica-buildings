within Buildings.Fluid.FixedResistances;
model LoopBreaker
  "Model that makes mass flow rate a state and thereby avoids nonlinear systems of equations"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Modelica.SIunits.Time tau = 10 "Time constant";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.PressureDifference dp_small(displayUnit="Pa") = 10
    "Pressure difference between port_a and port_b";
  Modelica.SIunits.PressureDifference dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b";
  Real mNor_flow "Normalized mass flow rate";
equation
  mNor_flow = port_a.m_flow/m_flow_nominal;
  der(mNor_flow) = dp/(dp_small*tau);
  dp = port_a.p - port_b.p;

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  // Energy conservation
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

  // Transport of substances
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  annotation (
  defaultComponentName = "looBre",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,50},{100,-48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={244,125,35})}),                             Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LoopBreaker;
