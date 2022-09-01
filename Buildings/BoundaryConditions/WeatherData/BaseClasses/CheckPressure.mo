within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckPressure
  "Ensures that the interpolated pressure is between prescribed bounds"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput PIn(
    final quantity="Pressure",
    final unit="Pa") "Atmospheric pressure"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput pAtm(
    final quantity="Pressure",
    final unit="Pa") "Atmospheric pressure"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  constant Modelica.Units.SI.Pressure PMin=3100 "Minimum allowed pressure";
  constant Modelica.Units.SI.Pressure PMax=120000 "Maximum allowed pressure";
equation
  pAtm = PIn;
  assert(noEvent(PIn > PMin and PIn < PMax), "In " + getInstanceName() +
    ": Weather data atmospheric pressure out of bounds.\n" + "   PIn = " + String(PIn));

  annotation (
    defaultComponentName="chePre",
    Documentation(info="<html>
<p>
This component ensures that the interpolated pressure is between <i>31,000</i> Pa and <i>120,000</i> Pa.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Added <code>noEvent</code> and removed output connector.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1340\">#1340</a>.
</li>
<li>
January 31, 2020 by Filip Jorissen:<br/>
Improved error message.
</li>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-28,42},{26,-34}},
          textColor={0,0,255},
          textString="P")}));
end CheckPressure;
