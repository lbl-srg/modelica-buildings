within Buildings.Examples.VAVReheat.BaseClasses;
model FreezeStat "Freeze thermostat with timed lockout"

  parameter Real lockoutTime(
    final quantity="Time",
    final unit="s",
    displayUnit="min",
    min=60) = 900
    "Delay time";

  parameter Real TSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") = 276.15 "Temperature below which the freeze protection starts";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Connector of Real input signal used as measurement signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Connector of Real output signal used as actuator signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay locOut(final delayTime=
        lockoutTime) "If freeze stat triggers, keep it on for specified time"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not freStaSig "Signal for freeze stat"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=TSet,
    final h=0) "Greater comparison"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(locOut.y, freStaSig.u)
    annotation (Line(points={{12,0},{38,0}}, color={255,0,255}));
  connect(freStaSig.y, y)
    annotation (Line(points={{62,0},{120,0}}, color={255,0,255}));
  connect(greThr.y, locOut.u)
    annotation (Line(points={{-38,0},{-12,0}}, color={255,0,255}));
  connect(greThr.u, u)
    annotation (Line(points={{-62,0},{-120,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-160,140},{140,100}},
          lineColor={0,0,255},
          textString="%name")}),
Diagram(
    coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Freeze stat that outputs <code>true</code> if freeze protection should be engaged.
</p>
<p>
The freeze stat regulates around a set point. When it triggers freeze protection,
then the freeze protection stays engaged for at least <code>delayTime</code>.
It only becomes disengaged after this time period if the measured temperature is above
the set point.
</p>
</html>", revisions="<html>
<ul>
<li>
April 23, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FreezeStat;
