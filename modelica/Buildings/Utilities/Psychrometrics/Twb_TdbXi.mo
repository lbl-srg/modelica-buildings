within Buildings.Utilities.Psychrometrics;
block Twb_TdbXi "Model to compute the wet bulb temperature"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
                                                            annotation (
      choicesAllMatching = true);

  Modelica.Blocks.Interfaces.RealInput Tdb(
    start=303,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}},rotation=
            0)));
  Modelica.Blocks.Interfaces.RealInput p(  final quantity="Pressure",
                                           final unit="Pa",
                                           min = 0) "Pressure"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}},
                                                                       rotation=
           0)));
  Modelica.Blocks.Interfaces.RealOutput Twb(
    start=293,
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Wet bulb temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},rotation=0)));
  Modelica.Blocks.Interfaces.RealInput Xi[Medium.nXi]
    "Species concentration at dry bulb temperature"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}},
          rotation=0)));
protected
  Medium.BaseProperties dryBul "Medium state at dry bulb temperature";
  Medium.BaseProperties wetBul(Xi(nominal=0.01*ones(Medium.nXi)))
    "Medium state at wet bulb temperature";
 parameter Integer i_w(min=1, fixed=false) "Index for water substance";
initial algorithm
  i_w :=1;
    for i in 1:Medium.nXi loop
      if Modelica.Utilities.Strings.isEqual(Medium.substanceNames[i], "Water") then
        i_w :=i;
      end if;
    end for;

equation
  dryBul.p = p;
  dryBul.T = Tdb;
  dryBul.Xi = Xi;
  wetBul.phi = 1;
  wetBul.p = dryBul.p;
  wetBul.h = dryBul.h + (wetBul.X[i_w] - dryBul.X[i_w])
         * Medium.enthalpyOfLiquid(dryBul.T);
  Twb = wetBul.T;
annotation (
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),
          graphics),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Ellipse(
          extent={{-22,-94},{18,-56}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,44},{10,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-14,44},{-14,84},{-12,90},{-8,92},{-2,94},{4,92},{8,90},{10,
              84},{10,44},{-14,44}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-14,44},{-14,-60}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{10,44},{10,-60}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-42,-16},{-14,-16}}, color={0,0,0}),
        Line(points={{-42,24},{-14,24}}, color={0,0,0}),
        Line(points={{-42,64},{-14,64}}, color={0,0,0}),
        Text(
          extent={{-92,100},{-62,56}},
          lineColor={0,0,127},
          textString="Tdb"),
        Text(
          extent={{-90,8},{-72,-10}},
          lineColor={0,0,127},
          textString="Xi"),
        Text(
          extent={{-90,-72},{-72,-90}},
          lineColor={0,0,127},
          textString="p"),
        Text(
          extent={{62,22},{92,-22}},
          lineColor={0,0,127},
          textString="Twb")}),
    Documentation(info="<HTML>
<p>
Given a moist are medium model, this component computes the states 
of the medium at its wet bulb temperature.
</p><p>
For a use of this model, see for example
<a href=\"modelica://Buildings.Fluid.Sensors.WetBulbTemperature\">Buildings.Fluid.Sensors.WetBulbTemperature</a>
</p>
</HTML>
",
revisions="<html>
<ul>
<li>
February 17, 2010 by Michael Wetter:<br>
Renamed block from <code>WetBulbTemperature</code> to <code>Twb_TdbXi</code>
and changed obsolete real connectors to input and output connectors.
</li>
<li>
May 19, 2008 by Michael Wetter:<br>
Added relative humidity as a port.
</li>
<li>
May 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Twb_TdbXi;
