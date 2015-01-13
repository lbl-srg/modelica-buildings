within Buildings.Utilities.Psychrometrics;
block WetBul_pTX
  "Block to compute the wet bulb condition for given dry bulb temperature and humidity"
   extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput TDryBul(
    start=303,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput XDryBul(
    start=0.01,
    final unit="1",
    min=0) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Modelica.Blocks.Interfaces.RealInput p(
    final quantity="Pressure",
    final unit="Pa",
    min = 0) "Pressure"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealOutput TWetBul(
    start=293,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Wet bulb temperature"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput XWetBul(
    min=0,
    max=1,
    start=0.012,
    unit="1",
    nominal=0.01) "Water vapor mass fraction at wet bulb temperature"
  annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  XWetBul   = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
      pSat=   Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid(TWetBul),
      p=     p,
      phi=   1);
  TWetBul = (TDryBul * ((1-XDryBul) * Buildings.Utilities.Psychrometrics.Constants.cpAir +
             XDryBul * Buildings.Utilities.Psychrometrics.Constants.cpSte) +
             (XDryBul-XWetBul) * Buildings.Utilities.Psychrometrics.Constants.h_fg)/
              ( (1-XWetBul)*Buildings.Utilities.Psychrometrics.Constants.cpAir +
              XWetBul * Buildings.Utilities.Psychrometrics.Constants.cpSte);
  annotation (
    Documentation(info="<html>
<p>
Block to compute the temperature and mass fraction at the wet bulb condition
for a given dry bulb state.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 13, 2014, by Michael Wetter:<br/>
Removed wrong quantity attribute for <code>XDryBul</code>.
</li>
<li>
November 20, 2013 by Michael Wetter:<br/>
Removed package <code>Medium</code>.
Updated model to use
<code>Buildings.Utilities.Psychrometrics.Functions.saturationPressure()</code>
and
<code>Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid()</code>
as these functions have been moved from the medium to the psychrometrics package.
</li>
<li>
October 2, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Polygon(
          points={{-74,88},{-72,74},{-76,74},{-74,88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-70,84},{-48,66}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Line(points={{-74,86},{-74,-72}}, color={0,0,0}),
        Line(
          points={{50,-46},{0,-4}},
          color={255,0,0},
          thickness=0.5),
        Line(points={{-74,-46},{-60,-42},{-30,-30},{2,-2},{14,22},{22,54},{26,74}},
                    color={0,0,0}),
        Line(points={{76,-72},{-72,-72}}, color={0,0,0}),
        Polygon(
          points={{78,-72},{68,-70},{68,-74},{78,-72}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{76,-80},{86,-96}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T")}));
end WetBul_pTX;
