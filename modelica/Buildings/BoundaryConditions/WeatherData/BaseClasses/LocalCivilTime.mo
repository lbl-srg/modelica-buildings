within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block LocalCivilTime "Converts the clock time to local civil time."
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput cloTim(final quantity="Time", final unit
      ="s") "Clock time"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  parameter Modelica.SIunits.Time timZon(displayUnit="h") "Time zone";
  parameter Modelica.SIunits.Angle lon(displayUnit="deg") "Longitude";
  Modelica.Blocks.Interfaces.RealOutput locTim(final quantity="Time", final unit
      =    "s") "Local civil time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  locTim = cloTim - timZon + lon*43200/Modelica.Constants.pi;

  annotation (
    defaultComponentName="locTim",
    Documentation(info="<HTML>
<p>
This component converts the clock time to local civil time. 
The parameter <code>timZon</code> represents the time zone of the facility  (relative to Greenwich Mean Time or the 0th meridian). Time zones west of  GMT (e.g. North America) are represented as negative; east of GMT as  positive. Non-whole hours can be represented in decimal (e.g. 6:30 is  6.5).
<br>
The formula is based on Michael Wetter's thesis (A4.1): locTim = greTim + (lon*180/pi)*86400/360 = cloTim - timZon + lon*43200/pi 
</p>
</HTML>
", revisions="<html>
<ul>
<li>
February 27, 2011, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-98,6},{-60,-6}},
          lineColor={0,0,127},
          textString="cloTim"), Text(
          extent={{74,6},{98,-4}},
          lineColor={0,0,127},
          textString="calTim")}));
end LocalCivilTime;
