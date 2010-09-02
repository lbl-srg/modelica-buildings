within Buildings.Utilities.IO.WeatherData.BaseClasses;
block CheckSkyCover "Constrains the sky cover is between 0 and 10"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput nIn "Input sky cover"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput nOut "Output sky cover"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  constant Real delta = 0.01 "Smoothing parameter";
protected
  constant Real nMin = delta "Lower bound";
  constant Real nMax = 10-delta "Upper bound";
equation
  nOut = Buildings.Utilities.Math.Functions.smoothLimit(
    nIn,
    nMin,
    nMax,
    delta/10);
  annotation (
    defaultComponentName="cheSkyCov",
    Documentation(info="<HTML>
<p>
This component constrains the interpolated sky cover between 0 and 10.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
July 14, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-34,56},{46,-48}},
          lineColor={0,0,255},
          textString="Sky")}));
end CheckSkyCover;
