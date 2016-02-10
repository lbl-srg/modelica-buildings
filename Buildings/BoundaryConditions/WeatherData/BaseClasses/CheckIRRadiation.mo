within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block CheckIRRadiation "Ensure that the radiation is not smaller than 0"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput HIn(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Input horizontal infrared irradiation"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput HOut(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Horizontal infrared irradiation"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  constant Modelica.SIunits.RadiantEnergyFluenceRate HMin=0.0001
    "Minimum value for radiation";
equation
  HOut = Buildings.Utilities.Math.Functions.smoothMax(
    x1=HIn,
    x2=HMin,
    deltaX=HMin/10);
  annotation (
    defaultComponentName="cheRad",
    Documentation(info="<html>
<p>
This block ensures that the radiation is not smaller than <i>0</i>.
The Modelica data reader will interpolate data when it reads the data from a file.
Thus, it is possible to generate negative values due to the interpolation.
</p>
</html>", revisions="<html>
<ul>
<li>
January 7, 2016, by Michael Wetter:<br/>
Updated comment.
</li>
<li>
October 27, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-24,44},{30,-32}},
          lineColor={0,0,255},
          textString="H")}));
end CheckIRRadiation;
