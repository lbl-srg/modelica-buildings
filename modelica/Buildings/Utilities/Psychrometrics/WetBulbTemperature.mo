model WetBulbTemperature "Model to compute the wet bulb temperature" 
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium = 
    Modelica.Media.Interfaces.PartialMedium "Medium model"  annotation (
      choicesAllMatching = true);
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
      Text(extent=[-126,160; 138,98],   string="%name")),
    Documentation(info="<HTML>
<p>
Given a moist are medium model, this component computes the states 
of the medium at its wet bulb temperature.
</p><p>
For a use of this model, see for example
<a href=\"Modelica://Buildings.Fluids.Sensors.WetBulbTemperature\">Buildings.Fluids.Sensors.WetBulbTemperature</a>
</p>
</HTML>
",
revisions="<html>
<ul>
<li>
May 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  Medium.BaseProperties dryBul "Medium state at dry bulb temperature";
  Medium.BaseProperties wetBul "Medium state at wet bulb temperature";
equation 
  wetBul.phi = 1;
  wetBul.h = dryBul.h + (wetBul.X[Medium.Water] - dryBul.X[Medium.Water])
         * Medium.enthalpyOfLiquid(dryBul.T);
  
  wetBul.h = Medium.h_pTX(dryBul.p, wetBul.T, wetBul.X);
end WetBulbTemperature;
