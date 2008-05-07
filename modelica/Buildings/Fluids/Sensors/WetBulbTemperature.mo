model WetBulbTemperature "Ideal temperature sensor" 
  import SI = Modelica.SIunits;
  extends Modelica_Fluid.Sensors.BaseClasses.PartialFlowSensor;
  Medium.BaseProperties medium;
  Modelica.Blocks.Interfaces.RealOutput TWB(unit = "K", start=293.15) 
    "Wet bulb temperature in port medium" 
    annotation (extent=[-10,-120; 10,-100], rotation=-90);
  
annotation (
  Diagram(
      Line(points=[0,-70; 0,-100], style(rgbcolor={0,0,127})),
      Ellipse(extent=[-20, -98; 20, -60], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2,
          fillColor=74,
          rgbfillColor={0,0,127})),
      Rectangle(extent=[-12, 40; 12, -68], style(
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127})),
      Polygon(points=[-12, 40; -12, 80; -10, 86; -6, 88; 0, 90; 6, 88; 10, 86;
             12, 80; 12, 40; -12, 40], style(color=0, thickness=2)),
      Line(points=[-12, 40; -12, -64], style(color=0, thickness=2)),
      Line(points=[12, 40; 12, -64], style(color=0, thickness=2)),
      Line(points=[-40, -20; -12, -20], style(color=0)),
      Line(points=[-40, 20; -12, 20], style(color=0)),
      Line(points=[-40, 60; -12, 60], style(color=0))),
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
May 5, 2008 by Michael Wetter:<br>
First implementation based on temperature sensor of Modelica_Fluid.
</li>
</ul>
</html>"));
  Modelica.SIunits.SpecificEnthalpy hLiq "Enthalpy of liquid medium";
  
  Medium.BaseProperties stateWB "Medium state at wet bulb temperature";
equation 
  port_a.p = medium.p;
  h  = medium.h;
  Xi = medium.Xi;
  hLiq = Medium.enthalpyOfLiquid(medium.T);
  
  // equation whose solution defines the wet bulb temperature  
  stateWB.p = medium.p;
//  stateWB.X[Medium.Water] = Medium.Xsaturation(medium.state);
  stateWB.phi = 1;
  stateWB.h = h + (stateWB.X[Medium.Water] - medium.X[Medium.Water]) * hLiq;
  
  stateWB.h = Medium.h_pTX(stateWB.p, TWB, stateWB.X);
  //assert(TWB < medium.T, "Wet bulb temperature must be below dry bulb temperature.");
end WetBulbTemperature;
