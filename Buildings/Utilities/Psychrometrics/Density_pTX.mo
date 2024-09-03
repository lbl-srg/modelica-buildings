within Buildings.Utilities.Psychrometrics;
block Density_pTX
  "Block to compute the density for given pressure, dry bulb temperature and moisture mass fraction"
   extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Interfaces.RealInput T(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput X_w(
    final unit="1",
    min=0) "Water vapor mass fraction per unit mass total air"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Modelica.Blocks.Interfaces.RealInput p(final quantity="Pressure",
                                         final unit="Pa",
                                         displayUnit="Pa",
                                         min = 0) "Pressure"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealOutput d(
    final unit="kg/m3",
    final quantity="Density",
    final min=0) "Density"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

equation
  d = Buildings.Utilities.Psychrometrics.Functions.density_pTX(
    p=p,
    T=T,
    X_w=X_w);

  annotation (
  defaultComponentName="den",
    Documentation(info="<html>
<p>
Block to compute the mass density of air for given
pressure, temperature and water vapor mass fraction.
</p>
<p>
Note that the water vapor mass fraction must be in <i>kg/kg</i>
total air, and not dry air.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 19, 2015, by Michael Wetter:<br/>
Corrected default component name.
</li>
<li>
February 24, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                    graphics={
        Polygon(
          points={{-74,88},{-72,74},{-76,74},{-74,88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-70,84},{-48,66}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Line(points={{-74,86},{-74,-72}}),
        Line(points={{-74,-46},{-60,-42},{-30,-30},{2,-2},{14,22},{22,54},{26,74}},
                    smooth=Smooth.Bezier),
        Line(points={{74,-72},{-74,-72}}),
        Polygon(
          points={{78,-72},{68,-70},{68,-74},{78,-72}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{76,-80},{86,-96}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Text(
          extent={{24,-14},{78,-32}},
          textColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="density"),
        Line(
          points={{36,-72},{6,6}},
          color={255,0,0})}));
end Density_pTX;
