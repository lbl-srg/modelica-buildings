within Districts.Utilities.Psychrometrics;
block TDewPoi_pW
  "Model to compute the dew point temperature for given water vapor pressure of moist air"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  Modelica.Blocks.Interfaces.RealInput p_w "Water vapor partial pressure"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}},
                                                                      rotation=
            0)));
  Modelica.Blocks.Interfaces.RealOutput T(start=278.15,
                                         final quantity="Temperature",
                                         final unit="K",
                                         min = 0,
                                         displayUnit="degC")
    "Dew point temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
          rotation=0)));

equation
 p_w = Districts.Utilities.Psychrometrics.Functions.pW_TDewPoi(T=T);
    annotation (
    defaultComponentName="dewPoi",
    Documentation(info="<html>
<p>
Dew point temperature calculation for moist air above freezing temperature.
</p>
<p>
The correlation used in this model is valid for dew point temperatures between 
<code>0 degC</code> and <code>200 degC</code>. It is the correlation from 2005
ASHRAE Handbook, p. 6.2. In an earlier version of this model, the equation from
Peppers has been used, but this equation yielded about 15 Kelvin lower dew point 
temperatures.
</p>
</html>", revisions="<html>
<ul>
<li>
September 4, 2008 by Michael Wetter:<br/>
Changed from causal to acausal ports, needed, for example, for
<a href=\"modelica://Buildings.Fluid.Examples.MixingVolumeMoistAir\">
Buildings.Fluid.Examples.MixingVolumeMoistAir</a>.
</li>
<li>
August 7, 2008 by Michael Wetter:<br/>
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
          extent={{-124,50},{-86,4}},
          lineColor={0,0,255},
          textString="p_w"),
        Text(
          extent={{102,46},{140,0}},
          lineColor={0,0,255},
          textString="TDP"),
        Line(points={{-68,86},{-68,-72}}, color={0,0,0}),
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
          points={{-68,88},{-66,74},{-70,74},{-68,88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-64,84},{-42,66}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="X"),
        Text(
          extent={{82,-80},{92,-96}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Line(points={{68,-44},{-62,-44}}, color={175,175,175}),
        Line(points={{68,-18},{-10,-18}}, color={175,175,175}),
        Line(points={{70,6},{12,6}}, color={175,175,175}),
        Line(points={{68,32},{22,32}}, color={175,175,175})}),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}), graphics));
end TDewPoi_pW;
