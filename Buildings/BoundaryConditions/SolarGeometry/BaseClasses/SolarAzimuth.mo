within Buildings.BoundaryConditions.SolarGeometry.BaseClasses;
block SolarAzimuth "Solar azimuth"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput zen(quantity="Angle", unit="rad")
    "Zenith angle"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput solTim(quantity="Time", unit="s")
    "Solar time" annotation (Placement(transformation(extent={{-140,-60},{-100,
            -20}}), iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput lat(quantity="Angle", unit="rad")
    "Latitude" annotation (Placement(transformation(extent={{-140,-100},{-100,
            -60}}), iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput solAzi(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Solar Azimuth"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput decAng(quantity="Angle", unit="rad")
    "Declination angle"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,18},{-100,58}})));

protected
  Real arg "cos(solAzi) after data validity check";
  Real tmp "cos(solAzi) before data validity check";
  Real solAziTem "Temporary variable for solar azimuth";

  constant Modelica.Units.SI.Time day=86400 "Number of seconds in a day";
  constant Modelica.Units.SI.Angle polarCircle=1.1617
    "Latitude of polar circle (66 degree 33 min 44 sec)";
  Boolean outsidePolarCircle = lat < polarCircle and lat > -polarCircle
    "Flag, true if latitude is outside polar region";
equation
  tmp = (Modelica.Math.sin(lat)*Modelica.Math.cos(zen) - Modelica.Math.sin(
    decAng))/(Modelica.Math.cos(lat)*Modelica.Math.sin(zen));
  arg = min(1.0, max(-1.0, tmp));

  solAziTem =  Modelica.Math.acos(arg); // Solar azimuth (A4.9a and b) as a positive number

  // If outside the polar circle, the only non-differentiability is at night when the sun is set.
  // Hence, we use noEvent.
  // If inside the polar circle, there is a jump at (solar-)midnight when the sun can
  // be above the horizon. Hence, we do not use noEvent(...)
  // Written as one line with functions so that lat does not become structural parameter with JModelica.org
  solAzi = if outsidePolarCircle then solarAzimuthNoEvent(solAziTem, solTim, day) else solarAzimuthWithEvent(solAziTem, solTim, day);

  annotation (
    defaultComponentName="solAzi",
    Documentation(info="<html>
<p>
This component computes the solar azimuth angle.
</p>
</html>", revisions="<html>
<ul>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter <code>lat</code> and added an input connector for this quantity.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
June 9, 2020, by David Blum:<br/>
Reformulated to use one-line if-statements.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1373\">issue 1373</a>.
</li>
<li>
October 13, 2017, by Michael Wetter:<br/>
Reformulated to use equation rather than algorithm section.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/834\">issue 834</a>.
</li>
<li>
July 5, 2012, by Michael Wetter:<br/>
Changed model to avoid an event at solar noon.
</li>
<li>
February 28, 2012, by Wangda Zuo:<br/>
Add solar time conversion since it is removed from <code>solTim</code>.
</li>
<li>
May 18, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Bitmap(extent={{-90,-90},{90,90}}, fileName=
              "modelica://Buildings/Resources/Images/BoundaryConditions/SolarGeometry/BaseClasses/SolarAzimuth.png"),
                              Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-102,84},{-60,74}},
          textColor={0,0,127},
          textString="zen"),
        Text(
          extent={{-96,-36},{-54,-46}},
          textColor={0,0,127},
          textString="solTim"),
        Text(
          extent={{-96,24},{-54,14}},
          textColor={0,0,127},
          textString="decAng"),
        Text(
          extent={{-96,-86},{-54,-96}},
          textColor={0,0,127},
          textString="lat")}));
end SolarAzimuth;
