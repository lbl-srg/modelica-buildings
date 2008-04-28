model EnthalpyFlowRate "Ideal enthalphy flow rate sensor" 
  extends Modelica_Fluid.Sensors.BaseClasses.PartialFlowSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput H_flow(unit="W") 
    "Enthalpy flow rate, positive if from port_a to port_b" 
    annotation (extent=[-10,-120; 10,-100], rotation=-90);
  
annotation (
  Diagram(
      Line(points=[-100,0; -70,0], style(color=69, rgbcolor={0,128,255})),
      Line(points=[70,0; 100,0], style(color=69, rgbcolor={0,128,255})),
      Line(points=[0,-70; 0,-100], style(rgbcolor={0,0,127}))),
  Icon(
      Line(points=[-100,0; -70,0], style(color=69, rgbcolor={0,128,255})),
      Line(points=[70,0; 100,0], style(color=69, rgbcolor={0,128,255})),
      Line(points=[0,-70; 0,-100], style(rgbcolor={0,0,127})),
      Text(extent=[-126,160; 138,98], string="%name"),
      Text(
        extent=[204,-49; 44,-101],
        style(color=0),
        string="H_flow")),
  Documentation(info="<HTML>
<p>
This component monitors the enthalphy flow rate of the medium in the flow
between fluid ports. The sensor is ideal, i.e., it does not influence the fluid.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
April 9, 2008 by Michael Wetter:<br>
First implementation based on enthalpy sensor of Modelica_Fluid.
</li>
</ul>
</html>"));
equation 
  H_flow = port_a.H_flow;
end EnthalpyFlowRate;
