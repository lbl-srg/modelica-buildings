within Buildings.Controls.OBC.CDL.Types;
block SunRiseSet "Sunrise or sunset time"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Angle lon(displayUnit="deg") "Longitude";
  parameter Modelica.SIunits.Angle lat(displayUnit="deg") "Latitude";
  parameter Modelica.SIunits.Time timZon(displayUnit="h") "Time zone";

  Real eqnTim "Equation of time";
  Real decAng "Declination angle";
  Real solHouAng "Solar hour angle";
  Real locTim "Local time";
  Real solTim "Solar time";
  Real zen "Zenith angle";
  Real alt "Altitude angle";

  Modelica.Blocks.Interfaces.RealInput nDay(quantity="Time", unit="s")
    "Day number with units of seconds"
    annotation (Placement(transformation(extent={{-142,-20},{-102,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput SunRiseSet(
    final quantity="Time",
    final unit="h",
    displayUnit="h") "Sunrise or sunset time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Real Bt "Intermediate variable used to calculate equation of time";
  constant Real k1 = sin(23.45*2*Modelica.Constants.pi/360) "Constant";
  constant Real k2 = 2*Modelica.Constants.pi/365.25 "Constant";
  final parameter Modelica.SIunits.Time diff = -timZon+lon*43200/Modelica.Constants.pi
    "Difference between local and clock time";

equation
  Bt = Modelica.Constants.pi*((nDay + 86400)/86400 - 81)/182
  "unit is in seconds";

  eqnTim = 60*(9.87*Modelica.Math.sin(2*Bt) - 7.53*Modelica.Math.cos(Bt) - 1.5*
    Modelica.Math.sin(Bt))
  "Equation of time; unit is in seconds";

  locTim = nDay + diff "difference between local time and civil time";

  solTim = locTim + eqnTim "Solar time";

  solHouAng = (solTim/3600 - 12)*2*Modelica.Constants.pi/24
  "Solar hour angle";

  decAng = Modelica.Math.asin(-k1 * Modelica.Math.cos((nDay/86400 + 10)*k2))
  "Solar declination angle";

  zen =  Modelica.Math.acos(Modelica.Math.cos(lat)*Modelica.Math.cos(decAng)*
    Modelica.Math.cos(solHouAng) + Modelica.Math.sin(lat)*Modelica.Math.sin(
    decAng))
  "Solar zenith angle";

  alt = (Modelica.Constants.pi/2) - zen
  "Solar altitude or elevation angle";

  when alt>=0 then
      SunRiseSet = mod(time/3600,24);
  elsewhen alt<=0 then
      SunRiseSet = mod(time/3600,24);
  end when
  "When solar altitude is bigger than 0, then the sun is above the horizon."
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    uses(Modelica(version="3.2.2")));

  annotation (Documentation(info="<html>
<p>This component calculates the sunrise and sunset time in hours. The outputs are like step functions: the sunrise time lasts from the begining of the current sunrise until the sunset time; likewise, the sunset time lasts from the begining of sunset time until the next sunrise time. </p>
<p>High latitude cases: when the output is zero, it means the sun is below the horizon i.e, there is no sunrise; when the output remains constant throughout the day(s), there is no sunset in that period. </p>
</html>"));
end SunRiseSet;
