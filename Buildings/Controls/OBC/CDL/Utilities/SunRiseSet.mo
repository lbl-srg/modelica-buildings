within Buildings.Controls.OBC.CDL.Utilities;
block SunRiseSet
  "Next sunrise and sunset time"
  parameter Real lat(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg")
    "Latitude";
  parameter Real lon(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg")
    "Longitude";
  parameter Real timZon(
    final quantity="Time",
    final unit="s",
    displayUnit="h")
    "Time zone";
  Interfaces.RealOutput nextSunRise(
    final quantity="Time",
    final unit="s",
    displayUnit="h")
    "Time of next sunrise"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Interfaces.RealOutput nextSunSet(
    final quantity="Time",
    final unit="s",
    displayUnit="h")
    "Time of next sunset"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Interfaces.BooleanOutput sunUp
    "Output true if the sun is up"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));

protected
  constant Real k1=sin(
    23.45*2*Modelica.Constants.pi/360)
    "Intermediate constant";
  constant Real k2=2*Modelica.Constants.pi/365.25
    "Intermediate constant";
  parameter Real staTim(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "Simulation start time";
  Real eqnTim(
    final quantity="Time",
    final unit="s")
    "Equation of time";
  Real timDif(
    final quantity="Time",
    final unit="s")
    "Time difference between local and civil time";
  Real timCor(
    final quantity="Time",
    final unit="s")
    "Time correction";
  Real decAng(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg")
    "Declination angle";
  Real Bt
    "Intermediate variable to calculate equation of time";
  Real cosHou
    "Cosine of hour angle";
  function nextHourAngle
    "Calculate the hour angle when the sun rises or sets next time"
    input Real t(
      final quantity="Time",
      final unit="s")
      "Current simulation time";
    input Real lat(
      final quantity="Angle",
      final unit="rad",
      displayUnit="deg")
      "Latitude";
    output Real houAng(
      final quantity="Angle",
      final unit="rad",
      displayUnit="deg")
      "Solar hour angle";
    output Real tNext(
      final quantity="Time",
      final unit="s")
      "Timesnap when sun rises or sets next time";
    output Real timCor(
      final quantity="Time",
      final unit="s")
      "Time correction";

  protected
    Integer iDay;
    Boolean compute
      "Flag, set to false when the sun rise or sets ";
    Real Bt
      "Intermediate variable to calculate equation of time";
    Real eqnTim(
      final quantity="Time",
      final unit="s")
      "Equation of time";
    Real timDif(
      final quantity="Time",
      final unit="s")
      "Time difference";
    Real decAng(
      final quantity="Angle",
      final unit="rad",
      displayUnit="deg")
      "Declination angle";
    Real cosHou
      "Cosine of hour angle";

  algorithm
    iDay := 1;
    compute := true;
    while compute loop
      tNext := t+iDay*86400;
      Bt := Modelica.Constants.pi*((tNext+86400)/86400-81)/182;
      eqnTim := 60*(9.87*Modelica.Math.sin(
        2*Bt)-7.53*Modelica.Math.cos(Bt)-1.5*Modelica.Math.sin(Bt));
      timCor := eqnTim+timDif;
      decAng := Modelica.Math.asin(
        -k1*Modelica.Math.cos(
          (tNext/86400+10)*k2));
      cosHou :=-Modelica.Math.tan(lat)*Modelica.Math.tan(decAng);
      compute := abs(cosHou) > 1;
      iDay := iDay+1;
    end while;
    houAng := Modelica.Math.acos(cosHou);
  end nextHourAngle;
  function sunRise
    "Output the next sunrise time"
    input Real t(
      final quantity="Time",
      final unit="s")
      "Current simulation time";
    input Real staTim(
      final quantity="Time",
      final unit="s")
      "Simulation start time";
    input Real lat(
      final quantity="Angle",
      final unit="rad",
      displayUnit="deg")
      "Latitude";
    output Real nextSunRise(
      final quantity="Time",
      final unit="s");

  protected
    Real houAng(
      final quantity="Angle",
      final unit="rad",
      displayUnit="deg")
      "Solar hour angle";
    Real tNext(
      final quantity="Time",
      final unit="s")
      "Timesnap when sun rises next time";
    Real timCor(
      final quantity="Time",
      final unit="s")
      "Time correction";
    Real sunRise(
      final quantity="Time",
      final unit="s")
      "Sunrise of the same day as input time";
    Real cosHou(
      final quantity="Time",
      final unit="s")
      "Cosine of hour angle";

  algorithm
    (houAng,tNext,timCor) := nextHourAngle(
      t,
      lat);
    sunRise :=(12-houAng*24/(2*Modelica.Constants.pi)-timCor/3600)*3600+floor(
      tNext/86400)*86400;
    //If simulation start time has passed the sunrise of the initial day, output
    //the sunrise of the next day.
    if staTim > sunRise then
      nextSunRise := sunRise+86400;
    else
      nextSunRise := sunRise;
    end if;
  end sunRise;
  function sunSet
    "Output the next sunset time"
    input Real t(
      final quantity="Time",
      final unit="s")
      "Current simulation time";
    input Real staTim(
      final quantity="Time",
      final unit="s")
      "Simulation start time";
    input Real lat(
      final quantity="Angle",
      final unit="rad",
      displayUnit="deg")
      "Latitude";
    output Real nextSunSet(
      final quantity="Time",
      final unit="s");

  protected
    Real houAng(
      final quantity="Angle",
      final unit="rad",
      displayUnit="deg")
      "Solar hour angle";
    Real tNext(
      final quantity="Time",
      final unit="s")
      "Timesnap when sun sets next time";
    Real timCor(
      final quantity="Time",
      final unit="s")
      "Time correction";
    Real sunSet(
      final quantity="Time",
      final unit="s")
      "Sunset of the same day as input time";
    Real cosHou(
      final quantity="Time",
      final unit="s")
      "Cosine of hour angle";

  algorithm
    (houAng,tNext,timCor) := nextHourAngle(
      t,
      lat);
    sunSet :=(12+houAng*24/(2*Modelica.Constants.pi)-timCor/3600)*3600+floor(
      tNext/86400)*86400;
    //If simulation start time has passed the sunset of the initial day, output
    //the sunset of the next day.
    if staTim > sunSet then
      nextSunSet := sunSet+86400;
    else
      nextSunSet := sunSet;
    end if;
  end sunSet;

initial equation
  staTim=time;
  nextSunRise=sunRise(
    time-86400,
    staTim,
    lat);
  //In the polar cases where the sun is up during initialization, the next sunset
  //actually occurs before the next sunrise
  if cosHou <-1 then
    nextSunSet=sunSet(
      time-86400,
      staTim,
      lat)-86400;
  else
    nextSunSet=sunSet(
      time-86400,
      staTim,
      lat);
  end if;

equation
  Bt=Modelica.Constants.pi*((time+86400)/86400-81)/182;
  eqnTim=60*(9.87*Modelica.Math.sin(
    2*Bt)-7.53*Modelica.Math.cos(Bt)-1.5*Modelica.Math.sin(Bt));
  timDif=lon*43200/Modelica.Constants.pi-timZon;
  timCor=eqnTim+timDif;
  decAng=Modelica.Math.asin(
    -k1*Modelica.Math.cos(
      (time/86400+10)*k2));
  cosHou=-Modelica.Math.tan(lat)*Modelica.Math.tan(decAng);
  //When time passes the current sunrise/sunset, output the next sunrise/sunset
  when time >= pre(nextSunRise) then
    nextSunRise=sunRise(
      time,
      staTim,
      lat);
  end when;
  when time >= pre(nextSunSet) then
    nextSunSet=sunSet(
      time,
      staTim,
      lat);
  end when;
  sunUp=nextSunSet < nextSunRise;
  annotation (
    defaultComponentName="sunRiseSet",
    Documentation(
      info="<html>
<p>
This block outputs the next sunrise and sunset time.
The sunrise time keeps constant until the model time reaches the next sunrise,
at which time the output gets updated.
Similarly, the output for the next sunset is updated at each sunset.
</p>
<p>
The time zone parameter is based on UTC time; for instance, Eastern Standard Time is -5h.
Note that daylight savings time is not considered in this component.
</p>
<h4>Validation</h4>
<p>
A validation can be found at
<a href=\"modelica://Buildings.Controls.OBC.CDL.Utilities.Validation.SunRiseSet\">
Buildings.Controls.OBC.CDL.Utilities.Validation.SunRiseSet</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.SIunits</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
November 27, 2018, by Kun Zhang:<br/>
First implementation.
This is for
issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/829\">829</a>.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Rectangle(
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
        Line(
          points={{0,60},{0,32}},
          color={238,46,47}),
        Line(
          points={{60,40},{40,20}},
          color={238,46,47}),
        Line(
          points={{94,-6},{70,-6}},
          color={238,46,47}),
        Line(
          points={{10,10},{-10,-10}},
          color={238,46,47},
          origin={-50,30},
          rotation=90),
        Line(
          points={{-70,-6},{-94,-6}},
          color={238,46,47})}));
end SunRiseSet;
