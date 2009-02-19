within Buildings.Utilities.Psychrometrics;
model DewPointTemperature
  "Model to compute the dew point temperature of moist air"
 extends Buildings.BaseClasses.BaseIcon;
    annotation (
    Documentation(info="<html>
<p>
Dew point temperature calculation for moist air above freezing temperature.
</p>
<p>
The correlation used in this model is valid for dew point temperatures between 
<tt>0 degC</tt> and <tt>200 degC</tt>. It is the correlation from 2005
ASHRAE Handbook, p. 6.2. In an earlier version of this model, the equation from
Peppers has been used, but this equation yielded about 15 Kelvin lower dew point 
temperatures.
</p>
</html>", revisions="<html>
<ul>
<li>
September 4, 2008 by Michael Wetter:<br>
Changed from causal to acausal ports, needed, for example, for
<a href=\"Modelica:Buildings.Fluids.Examples.MixingVolumeMoistAir\">
Buildings.Fluids.Examples.MixingVolumeMoistAir</a>.
</li>
<li>
August 7, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{104,44},{142,-2}},
          lineColor={0,0,255},
          textString="p_w"),
        Text(
          extent={{-124,46},{-86,0}},
          lineColor={0,0,255},
          textString="TDP"),
        Line(points={{70,86},{70,-72}}, color={0,0,0}),
        Line(points={{82,-72},{-66,-72}}, color={0,0,0}),
        Line(points={{-68,-46},{-54,-42},{-24,-30},{8,-2},{20,22},{28,54},{32,
              74}}, color={0,0,0}),
        Line(
          points={{42,-32},{-28,-32}},
          color={255,0,0},
          thickness=0.5),
        Polygon(
          points={{-28,-32},{-14,-30},{-14,-34},{-28,-32}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{84,-72},{74,-70},{74,-74},{84,-72}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{70,86},{72,72},{68,72},{70,86}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{74,84},{96,66}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Text(
          extent={{82,-80},{92,-96}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal p_w
    "Water vapor partial pressure" 
    annotation (Placement(transformation(extent={{100,-10},{120,10}}, rotation=
            0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal T(start=278.15,
                                           final quantity="ThermodynamicTemperature",
                                           final unit="K",
                                           min = 0,
                                           displayUnit="degC")
    "Dew point temperature" 
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}},
          rotation=0)));
protected
  constant Real C8 = -5.800226E3;
  constant Real C9 =  1.3914993E0;
  constant Real C10= -4.8640239E-2;
  constant Real C11 = 4.1764768E-5;
  constant Real C12= -1.4452093E-8;
  constant Real C13 = 6.5459673E0;
equation
 p_w = Modelica.Math.exp(C8/T + C9 + T * ( C10
           + T * ( C11 + T * C12))  + C13 * Modelica.Math.log(T));
end DewPointTemperature;
