within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block ConvertTime
  "Converts the simulation time to calendar time in scale of 1 year (365 days)"
  extends Modelica.Blocks.Icons.Block;
public
  Modelica.Blocks.Interfaces.RealInput modTim(final quantity="Time", final unit=
       "s") "Simulation time"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput calTim(final quantity="Time", final
      unit="s") "Calendar time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  constant Modelica.SIunits.Time year=31536000 "Number of seconds in a year";
  discrete Modelica.SIunits.Time tStart "Start time of period";

initial equation
  tStart = integer(modTim/year)*year;
equation
  when modTim - pre(tStart) > year then
    tStart = integer(modTim/year)*year;
  end when;
  calTim = modTim - tStart;
  annotation (
    defaultComponentName="conTim",
    Documentation(info="<html>
<p>
This component converts the simulation time to calendar time in a scale of 1 year (365 days).
</p>
</html>", revisions="<html>
<ul>
<li>
September 27, 2011, by Wangda Zuo, Michael Wetter:<br/>
Modify it to convert negative value of time.
Use the when-then to allow dymola differentiating this model when conducting index reduction which is not allowed in previous implementation.
</li>
<li>
February 27, 2011, by Wangda Zuo:<br/>
Renamed the component.
</li>
<li>
July 08, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-98,6},{-74,-4}},
          lineColor={0,0,127},
          textString="modTim"),
        Text(
          extent={{74,6},{98,-4}},
          lineColor={0,0,127},
          textString="calTim"),
        Rectangle(
          extent={{-66,76},{60,58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={120,120,120}),
        Rectangle(extent={{-66,58},{60,-62}}, lineColor={0,0,0}),
        Line(
          points={{-24,-62},{-24,58}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{18,-62},{18,58}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{60,28},{-66,28}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{60,-2},{-66,-2}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{60,-32},{-66,-32}},
          color={0,0,0},
          smooth=Smooth.None)}));
end ConvertTime;
