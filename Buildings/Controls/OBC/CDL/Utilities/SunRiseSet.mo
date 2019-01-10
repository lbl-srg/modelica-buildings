within Buildings.Controls.OBC.CDL.Utilities;
block SunRiseSet "Sunrise or sunset time"

  parameter Modelica.SIunits.Angle lat(displayUnit="deg") "Latitude";
  parameter Modelica.SIunits.Angle lon(displayUnit="deg") "Longitude";
  parameter Modelica.SIunits.Time timZon(displayUnit="h") "Time zone";

  Modelica.SIunits.Time eqnTim "Equation of time";
  Modelica.SIunits.Time timDif "Time difference between local and civil time";
  Modelica.SIunits.Time timCor "Time correction factor";
  Modelica.SIunits.Angle decAng "Declination angle";
  Modelica.SIunits.Angle houAng "Solar hour angle";

  Modelica.Blocks.Interfaces.RealOutput sunRise(
    final quantity="Time",
    final unit="s",
    displayUnit="h") "Sunrise time"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput sunSet(
    final quantity="Time",
    final unit="s",
    displayUnit="h") "Sunset time"
    annotation (Placement(transformation(extent={{100,-52},{120,-32}})));

protected
  constant Real k1 = sin(23.45*2*Modelica.Constants.pi/360) "Intermediate constant";
  constant Real k2 = 2*Modelica.Constants.pi/365.25 "Intermediate constant";
  Real Bt "Intermediate variable used to calculate equation of time";
  Real cosHou "cosine of hour angle";

equation

  Bt = Modelica.Constants.pi*((time + 86400)/86400 - 81)/182;

  eqnTim = 60*(9.87*Modelica.Math.sin(2*Bt) - 7.53*Modelica.Math.cos(Bt) - 1.5
      *Modelica.Math.sin(Bt));

  timDif = lon*43200/Modelica.Constants.pi - timZon;

  timCor = timDif + eqnTim;

  decAng = Modelica.Math.asin(-k1*Modelica.Math.cos((time/86400 + 10)*k2));

  cosHou = -Modelica.Math.tan(lat)*Modelica.Math.tan(decAng);

  if noEvent(abs(cosHou) < 1) then
    houAng = Modelica.Math.acos(cosHou);
    sunRise = (12 - houAng*24/(2*Modelica.Constants.pi) - timCor/3600)*3600;
    sunSet = (12 + houAng*24/(2*Modelica.Constants.pi) - timCor/3600)*3600;
  elseif noEvent(cosHou >= 1) then
    houAng = Modelica.Constants.pi;
    sunRise = 0;
    sunSet = 0;
  else
    houAng = 0;
    sunRise = (12 - houAng*24/(2*Modelica.Constants.pi) - timCor/3600)*3600;
    sunSet = (12 + houAng*24/(2*Modelica.Constants.pi) - timCor/3600)*3600;
  end if;

  annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})),
  defaultComponentName="SunRiseSet",
  Documentation(info="<html>
<p>
This component calculates the sunrise and sunset time separately as two outputs.
The hours are output like step functions. </p>
<p>
During each day, the component outputs one sunrise time which keeps constant
until the next sunrise; sunset output works in the same fashion. </p>
<p>
When the sunrise and sunset time are identical,
it shows that there is no sunset on that day; </p>
<p>
when the sunrise and sunset time are zero,
it shows that there is no sunrise.</p>
<p>
Note that daylight savings time is not considered in this component.</p>
<h4>Validation </h4>
<p>
A validation can be found at
<a href=\"modelica://Buildings.Controls.OBC.CDL.Utilities.Validation.SunRiseSet\">
Buildings.Controls.OBC.CDL.Utilities.Validation.SunRiseSet</a>. </p>
</html>",
revisions="<html>
<ul>
<li>
November 27, 2018, by Kun Zhang:<br/>
First implementation.
This is for
issue <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/376\">829</a>.
</li>
</ul>
</html>"),
Icon(graphics={
          Text(
            extent={{-100,160},{100,106}},
            lineColor={0,0,255},
            textString="%name"),
          Rectangle(
            lineColor={200,200,200},
            fillColor={248,248,248},
            fillPattern=FillPattern.HorizontalCylinder,
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Rectangle(
            lineColor={128,128,128},
            extent={{-100.0,-100.0},{100.0,100.0}},
            radius=25.0),
          Ellipse(
            extent={{70,-100},{-70,20}},
            lineColor={28,108,200},
            startAngle=0,
            endAngle=180),
          Line(
            points={{-94,-40},{92,-40},{92,-40}},
            color={28,108,200},
            thickness=0.5),
          Line(points={{0,60},{0,32}}, color={238,46,47}),
          Line(points={{60,40},{40,20}}, color={238,46,47}),
          Line(points={{94,-6},{70,-6}}, color={238,46,47}),
          Line(
            points={{10,10},{-10,-10}},
            color={238,46,47},
            origin={-50,30},
            rotation=90),
          Line(points={{-70,-6},{-94,-6}}, color={238,46,47})}));
end SunRiseSet;
