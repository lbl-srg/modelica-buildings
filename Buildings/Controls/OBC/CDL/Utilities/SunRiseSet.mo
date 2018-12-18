within Buildings.Controls.OBC.CDL.Utilities;
block SunRiseSet "Sunrise and sunset time"

  parameter Modelica.SIunits.Angle lat(displayUnit="deg") "Latitude";
  parameter Modelica.SIunits.Angle lon(displayUnit="deg") "Longitude";
  parameter Modelica.SIunits.Time timZon(displayUnit="h") "Time zone";

  Modelica.Blocks.Interfaces.RealInput nDay(quantity="Time", final unit="s")
    "Day number with units of seconds"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput sunRise(
    final quantity="Time",
    final unit="s",
    displayUnit="h") "Time of next sunrise"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput sunSet(
    final quantity="Time",
    final unit="s",
    displayUnit="h") "Time of next sunset"
    annotation (Placement(transformation(extent={{100,-52},{120,-32}})));

protected
  constant Real k1 = sin(23.45*2*Modelica.Constants.pi/360) "Intermediate constant";
  constant Real k2 = 2*Modelica.Constants.pi/365.25 "Intermediate constant";
  final parameter Modelica.SIunits.Time
    diff = -timZon+lon*43200/Modelica.Constants.pi
    "Difference between local and civil time";
  Real Bt "Intermediate variable used to calculate equation of time";

  Modelica.SIunits.Time eqnTim "Equation of time";
  Modelica.SIunits.Time locTim "Local time";
  Modelica.SIunits.Time solTim "Solar time";
  Modelica.SIunits.Angle houAng "Solar hour angle";
  Modelica.SIunits.Angle decAng "Declination angle";
  Modelica.SIunits.Angle zenAng "Zenith angle";
  Modelica.SIunits.Angle altAng "Altitude angle";

initial equation
  sunRise = 0;
  sunSet = 0;

equation
  Bt = Modelica.Constants.pi*((nDay + 86400)/86400 - 81)/182;

  eqnTim = 60*(9.87*Modelica.Math.sin(2*Bt) - 7.53*Modelica.Math.cos(Bt) - 1.5*
    Modelica.Math.sin(Bt));

  locTim = nDay + diff;

  solTim = locTim + eqnTim;

  houAng = (solTim/3600 - 12)*2*Modelica.Constants.pi/24;

  decAng = Modelica.Math.asin(-k1 * Modelica.Math.cos((nDay/86400 + 10)*k2));

  zenAng =  Modelica.Math.acos(Modelica.Math.cos(lat)*Modelica.Math.cos(decAng)*
    Modelica.Math.cos(houAng) + Modelica.Math.sin(lat)*Modelica.Math.sin(
    decAng));

  altAng = (Modelica.Constants.pi/2) - zenAng;

  when altAng>=0 then
      sunRise = mod(time/3600,24)*3600;
  end when;

  when altAng<=0 then
      sunSet = mod(time/3600,24)*3600;
  end when;

annotation (
  defaultComponentName="sunRiseSet",
  Documentation(info="<html>
  <p>
  This model outputs the sunrise and sunset time.
  </p>
  <p>
  At each sunrise, the output for the sunrise is updated with the next sunrise.
  At each sunset, the output for the sunset is updated with the next sunset.  
  </p>
  <h4>
  Validation
  </h4>
  <p>
  A validation can be found at
  <a href=\"modelica://Buildings.Controls.OBC.CDL.Utilities.Validation.SunRiseSet\">
  Buildings.Controls.OBC.CDL.Utilities.Validation.SunRiseSet</a>.
  </p>
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
  Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,160},{100,106}},
            lineColor={0,0,255},
            textString="%name"),
          Ellipse(
            extent={{70,-100},{-70,20}},
            lineColor={238,46,47},
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
