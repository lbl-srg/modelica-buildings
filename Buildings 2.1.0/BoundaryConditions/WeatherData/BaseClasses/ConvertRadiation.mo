within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block ConvertRadiation
  "Convert the unit of solar radiation received from the TMY3 data file"
  extends Modelica.Blocks.Icons.Block;
public
  Modelica.Blocks.Interfaces.RealInput HIn(final unit="W.h/m2")
    "Input radiation"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput HOut(final quantity=
        "RadiantEnergyFluenceRate", final unit="W/m2") "Radiation"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  constant Modelica.SIunits.Time Hou=3600 "1 hour";

equation
  HOut = HIn/Modelica.SIunits.Conversions.to_hour(Hou);
  annotation (
    defaultComponentName="conRad",
    Documentation(info="<html>
<p>
The TMY3 data for solar radiation is the radiation accumulated in one hour. Thus, it used a unit of <code>Wh/m2</code>.
This component converts <code>Wh/m2</code> to <code>W/m2</code> that is the standard unit in Modelica.
</p>
</html>", revisions="<html>
<ul>
<li>
October 27, 2011, by Wangda Zuo:<br/>
Add the unit conversion and delete the data validity check.
</li>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-24,44},{30,-32}},
          lineColor={0,0,255},
          textString="H")}));
end ConvertRadiation;
