within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckPressure
  "Ensures that the interpolated pressure is between prescribed bounds"
  extends Modelica.Blocks.Icons.Block;
public
  Modelica.Blocks.Interfaces.RealInput PIn(final quantity="Pressure", final unit=
           "Pa") "Input pressure"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput POut(final quantity="Pressure", final unit=
           "Pa") "Atmospheric pressure"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  constant Modelica.SIunits.Pressure PMin=3100 "Minimum allowed pressure";
  constant Modelica.SIunits.Pressure PMax=120000 "Maximum allowed pressure";
equation
  assert(PIn > PMin, "Pressure out of bounds.\n" + "   PIn = " + String(PIn));
  assert(PIn < PMax, "Pressure out of bounds.\n" + "   PIn = " + String(PIn));
  POut = PIn;

  annotation (
    defaultComponentName="chePre",
    Documentation(info="<html>
<p>
This component ensures that the interpolated pressure is between <i>31,000</i> Pa and <i>120,000</i> Pa.
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-28,42},{26,-34}},
          lineColor={0,0,255},
          textString="P")}));
end CheckPressure;
