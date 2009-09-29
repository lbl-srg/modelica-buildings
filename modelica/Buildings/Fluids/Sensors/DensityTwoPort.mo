within Buildings.Fluids.Sensors;
model DensityTwoPort "Ideal two port density sensor"
  extends Modelica.Fluid.Sensors.BaseClasses.PartialFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput d(final quantity="Density",
                                          final unit="kg/m3",
                                          displayUnit="g/cm3",
                                          min=0) "Density of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
  parameter Medium.MassFlowRate m_flow_small(min=0) = system.m_flow_small
    "For bi-directional flow, density is regularized in the region |m_flow| < m_flow_small (m_flow_small > 0 required)"
    annotation(Dialog(tab="Advanced"));
annotation (defaultComponentName="density",
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}},
        grid={1,1}),    graphics),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Text(
          extent={{102,124},{6,95}},
          lineColor={0,0,0},
          textString="d"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
  Documentation(info="<HTML>
<p>
This component monitors the density of the fluid flowing from port_a to port_b. 
The sensor is ideal, i.e. it does not influence the fluid.
</p>
</HTML>
"));
protected
  Medium.Density rho_a_inflow "Density of inflowing fluid at port_a";
  Medium.Density rho_b_inflow
    "Density of inflowing fluid at port_b or rho_a_inflow, if uni-directional flow";
equation
  if allowFlowReversal then
     rho_a_inflow = Medium.density(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
     rho_b_inflow = Medium.density(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow));
     d = Modelica.Fluid.Utilities.regStep(port_a.m_flow, rho_a_inflow, rho_b_inflow, m_flow_small);
  else
     d = Medium.density(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
     rho_a_inflow = d;
     rho_b_inflow = d;
  end if;
end DensityTwoPort;
