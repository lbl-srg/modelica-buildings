within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block ConvertRadiation
  "Converts the units and ensures that the radiation is not smaller than 0"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput HIn(final unit="W.h/m2")
    "Input radiation (Wh/m2)"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput HOut(final quantity=
        "RadiantEnergyFluenceRate", final unit="W/m2") "Radiation"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  constant Modelica.SIunits.HeatFlux HMin=0.0001 "Minimum value for radiation";
equation
  // Modelica Table will interpolate data when it reads the weather data file.
  // It can generate negative value due to the interpolation.
  HOut = Buildings.Utilities.Math.Functions.smoothMax(
    x1=HIn,
    x2=HMin,
    deltaX=HMin/10);
  annotation (
    defaultComponentName="conRad",
    Documentation(info="<HTML>
<p>
This component ensures that the radiation is not smaller than 0.
It also converts the weather data from <code>Wh/m2</code>,
which is the unit used in the Typical Meteorological Year weather format,
to <code>W/m2</code>.
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
          extent={{-24,44},{30,-32}},
          lineColor={0,0,255},
          textString="H")}));
end ConvertRadiation;
