within Buildings.BoundaryConditions.SolarGeometry.BaseClasses;
block Declination "Declination angle"
  extends Buildings.BoundaryConditions.WeatherData.BaseClasses.PartialConvertTime;
  Modelica.Blocks.Interfaces.RealInput nDay(quantity="Time", unit="s")
    "Day number with units of seconds"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput decAng(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Solar declination angle"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  constant Real k1 = sin(23.45*2*Modelica.Constants.pi/360) "Constant";
  constant Real k2 = 2*Modelica.Constants.pi/365.25 "Constant";
equation
  modTimAux = nDay;
  decAng = Modelica.Math.asin(-k1 * Modelica.Math.cos((calTimAux/86400 + 10)*k2))
    "(A4.5)";
  annotation (
    defaultComponentName="decAng",
    Documentation(info="<html>
<p>
This component computes the solar declination, which is
the angle between the equatorial plane and the solar beam.
The input signal <code>nDay</code> is the one-based number of the day, but in seconds.
Hence, during January 1, we should have <code>nDay = 86400</code> seconds.
Since the effect of using a continuous number rather than an integer is small,
we approximate this so that <code>nDay = 0</code> at the start of January 1,
and <code>nDay = 86400</code> at the end of January 1.
</p>
<h4>Validation</h4>
<p>
A validation with a more detailed calculation can be found at
<a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples.Declination\">
Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Examples.Declination</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 27, 2023, by Ettore Zanetti:<br/>
Updated to use partial class for conversion from simulation time to calendar time.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1716\">IBPSA #1716</a>.
</li>
<li>
January 6, 2015, by Michael Wetter:<br/>
Updated documentation and added validation.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/382\">issue 382</a>.
</li>
<li>
January 5, 2015, by Michael Wetter:<br/>
Updated comment of output signal as this is used in the weather bus connector.
This is for
issue <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/376\">376</a>.
</li>
<li>
November 11, 2015, by Michael Wetter:<br/>
Corrected typo in documentation.
</li>
<li>
Dec 7, 2010, by Michael Wetter:<br/>
Rewrote equation in explicit form to avoid nonlinear equations in room model.
</li>
<li>
May 17, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={  Bitmap(extent={{-90,-90},{90,90}}, fileName=
              "modelica://Buildings/Resources/Images/BoundaryConditions/SolarGeometry/BaseClasses/Declination.png"),
                              Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255})}));
end Declination;
