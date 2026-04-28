within Buildings.Fluid.HeatExchangers;
package CoolingTowers "Package with cooling tower models"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains components models for cooling towers.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.DryCooler\">
Buildings.Fluid.HeatExchangers.CoolingTowers.DryCooler</a>
computes the performance of a dry cooler using the epsilon-NTU approach,
with flow and temperature dependent convective heat transfer coefficients.
It uses the dry bulb air temperature as an input.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach\">
Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach</a>
computes a fixed approach temperature.
It can be used with either the dry bulb or the wet bulb temperature as an input,
as it simply sets the coolant leaving temperature to be equal to the air temperature
plus a constant offset.
Note that this model does not compute fan energy consumption.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc\">
Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc</a>
computes the performance of a wet, open cooling tower based the York formula.
It uses the wet bulb temperature as an input.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a>
computes the performance of a wet, open cooling tower using the Merkel formula.
It uses the wet bulb temperature as an input.
</p>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-74,68},{-4,44}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-4,70},{68,44}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,32},{-30,-68},{-18,-62},{-58,38},{-70,32}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{68,30},{28,-70},{16,-64},{56,36},{68,30}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}));
end CoolingTowers;
