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
        style(pattern=0))),
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
  Modelica.Blocks.Interfaces.RealSignal TDryBul(redeclare type SignalType = 
        Modelica.SIunits.Temperature (start=293.15, min=150, max=373)) 
    "Dry bulb temperature" 
    annotation (extent=[-100,70; -80,90]);
  Modelica.Blocks.Interfaces.RealSignal p(redeclare type SignalType = 
        Modelica.SIunits.Pressure (start=101325, nominal=100000)) "Pressure" 
    annotation (extent=[-100,-10; -80,10]);
  Modelica.Blocks.Interfaces.RealSignal TWetBul(redeclare type SignalType = 
        Modelica.SIunits.Temperature (start=283.15, min=150, max=350)) 
    "Wet bulb temperature" 
    annotation (extent=[80,-10; 100,10]);
  Modelica.Blocks.Interfaces.RealSignal X[Medium.nX](redeclare type SignalType 
      = 
       Medium.MassFraction) "Species concentration at dry bulb temperature" 
    annotation (extent=[-100,-90; -80,-70]);
equation 
  dryBul.p = p;
  dryBul.T = TDryBul;
  dryBul.Xi = X[1:Medium.nXi];
  wetBul.phi = 1;
  wetBul.h = dryBul.h + (wetBul.X[Medium.Water] - dryBul.X[Medium.Water])
         * Medium.enthalpyOfLiquid(dryBul.T);
  
  wetBul.h = Medium.h_pTX(dryBul.p, wetBul.T, wetBul.X);
  TWetBul = wetBul.T;
end WetBulbTemperature;
