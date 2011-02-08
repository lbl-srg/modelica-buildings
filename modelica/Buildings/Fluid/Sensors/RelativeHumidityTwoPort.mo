within Buildings.Fluid.Sensors;
model RelativeHumidityTwoPort "Ideal two port relative humidity sensor"
  extends Modelica.Fluid.Sensors.BaseClasses.PartialFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  parameter Medium.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate, used for regularization near zero flow"
    annotation(Dialog(group = "Nominal condition"));
  parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*m_flow_nominal
    "For bi-directional flow, temperature is regularized in the region |m_flow| < m_flow_small (m_flow_small > 0 required)"
    annotation(Dialog(group="Advanced"));

  Modelica.Blocks.Interfaces.RealOutput phi(unit="1", min=0)
    "Relative humidity of the passing fluid"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=90,
        origin={1,110})));

protected
  Medium.BaseProperties med_a_inflow
    "Medium state of inflowing fluid at port a";
  Medium.BaseProperties med_b_inflow
    "Medium state of inflowing fluid at port b";

equation
  med_a_inflow.p  = port_a.p;
  med_a_inflow.h  = port_b.h_outflow;
  med_a_inflow.Xi = port_b.Xi_outflow;
  med_b_inflow.p  = port_b.p;
  med_b_inflow.h  = port_a.h_outflow;
  med_b_inflow.Xi = port_a.Xi_outflow;

  if allowFlowReversal then
    phi = Modelica.Fluid.Utilities.regStep(port_a.m_flow,
            med_a_inflow.phi,
            med_b_inflow.phi, m_flow_small);
  else
    phi = med_a_inflow.phi;
  end if;
annotation (defaultComponentName="senRelHum",
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}},
        grid={1,1}),    graphics),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Text(
          extent={{102,124},{6,95}},
          lineColor={0,0,0},
          textString="phi"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
  Documentation(info="<HTML>
<p>
This component monitors the relative humidity of the fluid flowing from port_a to port_b. 
The sensor is ideal, i.e. it does not influence the fluid.
</p>
<p>
Note that this sensor can only be used with media that contain the variable <code>phi</code>,
which is typically the case for moist air models.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
Feb. 5, 2011 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end RelativeHumidityTwoPort;
