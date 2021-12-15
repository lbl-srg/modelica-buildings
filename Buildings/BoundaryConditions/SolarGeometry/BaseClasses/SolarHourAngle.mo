within Buildings.BoundaryConditions.SolarGeometry.BaseClasses;
block SolarHourAngle "Solar hour angle"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput solTim(quantity="Time", unit="s")
    "Solar time"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput solHouAng(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Solar hour angle"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  solHouAng = (solTim/3600 - 12)*2*Modelica.Constants.pi/24
    "Our unit is s instead of h in (A4.6)";
  annotation (
    defaultComponentName="solHouAng",
    Documentation(info="<html>
<p>
This component computes the solar hour angle,
which is defined as the angle between the circle
that passes through an observer, the north pole and the south pole,
and the circle that passes through the sun, the north and the south pole.
</p>
</html>", revisions="<html>
<ul>
<li>
May 17, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={  Bitmap(extent={{-90,-90},{90,90}}, fileName=
              "modelica://Buildings/Resources/Images/BoundaryConditions/SolarGeometry/BaseClasses/SolarHourAngle.png"),
                              Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255})}));
end SolarHourAngle;
