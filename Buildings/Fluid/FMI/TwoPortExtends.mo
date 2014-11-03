within Buildings.Fluid.FMI;
model TwoPortExtends
  "Container to export a thermofluid flow model with two ports as an FMU"
  replaceable package Med =
      Buildings.Media.Air "Medium in the component"
      annotation (choicesAllMatching = true);
  extends Buildings.Fluid.FixedResistances.FixedResistanceDpM(
   redeclare final package Medium = Med,
   m_flow_nominal = 9999,
   dp_nominal = 9999,
   allowFlowReversal=true);

  Interfaces.Inlet inlet(redeclare final package Medium = Medium)
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Interfaces.Outlet outlet(redeclare final package Medium = Medium) annotation (Placement(transformation(extent={{100,
            -10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
equation
  port_a.p          = inlet.p;
  port_a.m_flow     = inlet.m_flow;
  inStream(port_a.h_outflow)  = inlet.h_inflow;
  inStream(port_a.Xi_outflow) = inlet.Xi_inflow;
  inStream(port_a.C_outflow)  = inlet.C_inflow;

  port_a.h_outflow  = inlet.h_outflow;
  port_a.Xi_outflow = inlet.Xi_outflow;
  port_a.C_outflow  = inlet.C_outflow;

  port_b.p          = outlet.p;
  port_b.m_flow     = outlet.m_flow;
  port_b.h_outflow  = outlet.h_outflow;
  port_b.Xi_outflow = outlet.Xi_outflow;
  port_b.C_outflow  = outlet.C_outflow;

  inStream(port_b.h_outflow)  = outlet.h_inflow;
  inStream(port_b.Xi_outflow) = outlet.Xi_inflow;
  inStream(port_b.C_outflow)  = outlet.C_inflow;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={0,0,255}),
            Text(
          extent={{-151,147},{149,107}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}}), graphics));
end TwoPortExtends;
