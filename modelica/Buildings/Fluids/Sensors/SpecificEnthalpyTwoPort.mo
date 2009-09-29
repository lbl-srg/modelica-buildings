within Buildings.Fluids.Sensors;
model SpecificEnthalpyTwoPort "Ideal two port sensor for the specific enthalpy"
  extends Modelica.Fluid.Sensors.BaseClasses.PartialFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput h_out(final quantity="SpecificEnergy",
                                              final unit="J/kg")
    "Specific enthalpy of the passing fluid" 
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));

  parameter Medium.MassFlowRate m_flow_small(min=0) = system.m_flow_small
    "For bi-directional flow, specific enthalpy is regularized in the region |m_flow| < m_flow_small (m_flow_small > 0 required)"
    annotation(Dialog(tab="Advanced"));

annotation (defaultComponentName="specificEnthalpy",
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}), graphics),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), 
        graphics={
        Text(
          extent={{102,120},{0,90}},
          lineColor={0,0,0},
          textString="h"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
  Documentation(info="<HTML>
<p>
This component monitors the specific enthalpy of a passing fluid. 
The sensor is ideal, i.e. it does not influence the fluid.
</p>
</HTML>
"));
equation
  if allowFlowReversal then
     h_out = Modelica.Fluid.Utilities.regStep(port_a.m_flow, port_b.h_outflow, port_a.h_outflow, m_flow_small);
  else
     h_out = port_b.h_outflow;
  end if;
end SpecificEnthalpyTwoPort;
