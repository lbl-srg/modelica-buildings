model WetBulbTemperature "Ideal wet bulb temperature sensor" 
  extends Modelica_Fluid.Sensors.BaseClasses.PartialFlowSensor;
  Medium.BaseProperties medium;
  
annotation (
  Diagram,
    Icon(
      Ellipse(extent=[-20,-88; 20,-50], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2,
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[-12,50; 12,-58], style(
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127})),
      Line(points=[0,-70; 0,-100], style(rgbcolor={0,0,127})),
      Polygon(points=[-12,50; -12,90; -10,96; -6,98; 0,100; 6,98; 10,96; 12,
            90; 12,50; -12,50],        style(color=0, thickness=2)),
      Line(points=[-12,50; -12,-54],   style(color=0, thickness=2)),
      Line(points=[12,50; 12,-54],   style(color=0, thickness=2)),
      Line(points=[-40,-10; -12,-10],   style(color=0)),
      Line(points=[-40,30; -12,30],   style(color=0)),
      Line(points=[-40,70; -12,70],   style(color=0)),
      Text(
        extent=[120,-40; 0,-90],
        string="T",
        style(pattern=0)),
      Text(extent=[-126,160; 138,98],   string="%name"),
      Line(points=[-100,0; -14,0], style(color=69, rgbcolor={0,128,255})),
      Line(points=[14,0; 100,0],   style(color=69, rgbcolor={0,128,255}))),
    Documentation(info="<HTML>
<p>
This component monitors the wet bulb temperature of the medium in the flow
between fluid ports. The sensor is ideal, i.e., it does not influence the fluid.
</p>
</HTML>
",
revisions="<html>
<ul>
<li>
September 10, 2008 by Michael Wetter:<br>
Renamed output port to have the same interfaces as the dry bulb temperature sensor.
</li>
<li>
May 5, 2008 by Michael Wetter:<br>
First implementation based on 
<a href=\"Modelica:Modelica_Fluid.Sensors.Temperature\">Modelica_Fluid.Sensors.Temperature</a>.
</li>
</ul>
</html>"));
  
  Modelica.Blocks.Interfaces.RealOutput T(
    redeclare type SignalType = Modelica.SIunits.Temperature,
    start=Medium.T_default) "Wet bulb temperature in port medium" 
    annotation (extent=[-10,-120; 10,-100], rotation=-90);
  
  Buildings.Utilities.Psychrometrics.WetBulbTemperature wetBulMod(redeclare 
      package Medium = Medium) "Model for wet bulb temperature";
  
equation 
  port_a.p = medium.p;
  h  = medium.h;
  Xi = medium.Xi;
  
  // Compute wet bulb temperature
  wetBulMod.dryBul.h  = medium.h;
  wetBulMod.dryBul.p  = medium.p;
  wetBulMod.dryBul.Xi = medium.Xi;
  T = wetBulMod.wetBul.T;
  
end WetBulbTemperature;
