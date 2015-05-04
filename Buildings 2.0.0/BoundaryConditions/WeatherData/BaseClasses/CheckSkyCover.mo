within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckSkyCover "Constrains the sky cover to [0, 1]"
  extends Modelica.Blocks.Icons.Block;
public
  Modelica.Blocks.Interfaces.RealInput nIn(min=0, max=1, unit="1")
    "Input sky cover [0, 10]"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput nOut(min=0, max=1, unit="1")
    "Sky cover [0, 1]"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  constant Real delta=0.01 "Smoothing parameter";
protected
  constant Real nMin=delta "Lower bound";
  constant Real nMax=10 - delta "Upper bound";
equation
  nOut = Buildings.Utilities.Math.Functions.smoothLimit(
    nIn,
    nMin,
    nMax,
    delta/10);
  annotation (
    defaultComponentName="cheSkyCov",
    Documentation(info="<html>
<p>
This component constrains the interpolated sky cover between <i>0</i> and <i>1</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 17, 2014, by Michael Wetter:<br/>
Changed model as
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">
Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>
send a signal between <i>0</i> and <i>1</i>.
Added <code>min</code> and <code>max</code>
attributes.
</li>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-64,48},{70,-48}},
          lineColor={0,0,255},
          textString="Sky")}));
end CheckSkyCover;
