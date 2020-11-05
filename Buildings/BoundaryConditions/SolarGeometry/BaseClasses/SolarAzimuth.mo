within Buildings.BoundaryConditions.SolarGeometry.BaseClasses;
block SolarAzimuth "Solar azimuth"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Angle lat "Latitude";
  Modelica.Blocks.Interfaces.RealInput zen(quantity="Angle", unit="rad")
    "Zenith angle"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput solTim(quantity="Time", unit="s")
    "Solar time" annotation (Placement(transformation(extent={{-140,-80},{-100,
            -40}}), iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput solAzi(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Solar Azimuth"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput decAng(quantity="Angle", unit="rad")
    "Declination angle"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

protected
  Real arg "cos(solAzi) after data validity check";
  Real tmp "cos(solAzi) before data validity check";
  Real solAziTem "Temporary variable for solar azimuth";

  constant Modelica.SIunits.Time day=86400 "Number of seconds in a day";
  constant Modelica.SIunits.Angle polarCircle = 1.1617
    "Latitude of polar circle (66 degree 33 min 44 sec)";
  final parameter Boolean outsidePolarCircle = lat < polarCircle and lat > -polarCircle
    "Flag, true if latitude is outside polar region";
equation
  tmp = (Modelica.Math.sin(lat)*Modelica.Math.cos(zen) - Modelica.Math.sin(
    decAng))/(Modelica.Math.cos(lat)*Modelica.Math.sin(zen));

  arg = min(1.0, max(-1.0, tmp));

  solAziTem =  Modelica.Math.acos(arg); // Solar azimuth (A4.9a and b) as a positive number

  if outsidePolarCircle then
    // Outside the polar circle, the only non-differentiability is at night when the sun is set.
    // Hence, we use noEvent.
    if noEvent(solTim - integer(solTim/day)*day < 43200) then
      solAzi =-solAziTem;
    else
      solAzi = solAziTem;
    end if;
  else
    // Inside the polar circle, there is a jump at (solar-)midnight when the sun can
    // be above the horizon. Hence, we do not use noEvent(...)
    if solTim - integer(solTim/day)*day < 43200 then
      solAzi =-solAziTem;
    else
      solAzi = solAziTem;
    end if;
  end if;

  annotation (
    defaultComponentName="solAzi",
    Documentation(info="<html>
<p>
This component computes the solar azimuth angle.
</p>
</html>", revisions="<html>
<ul>
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
          lineColor={0,0,255}),
        Text(
          extent={{-100,68},{-58,58}},
          lineColor={0,0,127},
          textString="zen"),
        Text(
          extent={{-102,-54},{-60,-64}},
          lineColor={0,0,127},
          textString="solTim"),
        Text(
          extent={{-102,6},{-60,-4}},
          lineColor={0,0,127},
          textString="decAng")}));
end SolarAzimuth;
