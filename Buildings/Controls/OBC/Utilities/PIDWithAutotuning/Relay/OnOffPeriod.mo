within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay;
block OnOffPeriod
  "Calculate the lengths of the on period and the off period"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tim(
    final quantity="Time",
    final unit="s")
    "Simulation time"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput On
    "Relay switch signal"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOff(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the off period"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
        iconTransformation(extent={{102,-60},{142,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOn(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the on period"
    annotation (Placement(transformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler timOn
    "Simulation time when the input signal becomes on (True)"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler timOff
    "Simulation time when the input signal becomes off (False)"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not Off
    "Relay switch off"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract lenOffCal
    "Calculate the horizon length for the off period"
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract lenOnCal
    "Calculate the horizon length for the on period"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greTimOff
    "Trigger the action to record the horizon length for the off period"
    annotation (Placement(transformation(extent={{50,-80},{70,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greTimOn
    "Trigger the action to record the horizon length for the on period"
    annotation (Placement(transformation(extent={{50,60},{70,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLen(final k=0)
    "Minimum value for the horizon length"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler timOffRec
    "Record the horizon length for the off period"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler timOnRec
    "Record the horizon length for the on period"
    annotation (Placement(transformation(extent={{70,50},{90,30}})));

equation
  connect(Off.u, On) annotation (Line(points={{-82,-70},{-120,-70}},
                      color={255,0,255}));
  connect(Off.y, timOff.trigger) annotation (Line(points={{-58,-70},{-40,-70},{
          -40,-52}}, color={255,0,255}));
  connect(timOn.trigger, On) annotation (Line(points={{-40,28},{-40,20},{-90,20},
          {-90,-70},{-120,-70}}, color={255,0,255}));
  connect(lenOffCal.u1, timOn.y) annotation (Line(points={{8,-24},{0,-24},{0,40},
          {-28,40}},     color={0,0,127}));
  connect(lenOnCal.u2, timOn.y)
    annotation (Line(points={{8,34},{0,34},{0,40},{-28,40}}, color={0,0,127}));
  connect(lenOnCal.u1, timOff.y) annotation (Line(points={{8,46},{-10,46},{-10,
          -40},{-28,-40}},
                     color={0,0,127}));
  connect(lenOffCal.u2, timOff.y) annotation (Line(points={{8,-36},{-10,-36},{
          -10,-40},{-28,-40}},
                           color={0,0,127}));
  connect(minLen.y, greTimOn.u2)
    annotation (Line(points={{-38,0},{-20,0},{-20,62},{48,62}}, color={0,0,127}));
  connect(lenOnCal.y, greTimOn.u1) annotation (Line(points={{32,40},{40,40},{40,
          70},{48,70}},                 color={0,0,127}));
  connect(greTimOff.u2, greTimOn.u2) annotation (Line(points={{48,-78},{-20,-78},
          {-20,62},{48,62}}, color={0,0,127}));
  connect(lenOffCal.y, greTimOff.u1) annotation (Line(points={{32,-30},{40,-30},
          {40,-70},{48,-70}},                   color={0,0,127}));
  connect(greTimOff.y, timOffRec.trigger)
    annotation (Line(points={{72,-70},{80,-70},{80,-42}}, color={255,0,255}));
  connect(greTimOn.y, timOnRec.trigger)
    annotation (Line(points={{72,70},{80,70},{80,52}}, color={255,0,255}));
  connect(timOn.u, tim) annotation (Line(points={{-52,40},{-120,40}},
                     color={0,0,127}));
  connect(timOff.u, tim) annotation (Line(points={{-52,-40},{-80,-40},{-80,40},
          {-120,40}},                   color={0,0,127}));
  connect(timOnRec.y, tOn) annotation (Line(points={{92,40},{120,40}},
                color={0,0,127}));
  connect(timOffRec.y, tOff) annotation (Line(points={{92,-30},{120,-30}},
                      color={0,0,127}));
  connect(lenOffCal.y, timOffRec.u)
    annotation (Line(points={{32,-30},{68,-30}}, color={0,0,127}));
  connect(lenOnCal.y, timOnRec.u)
    annotation (Line(points={{32,40},{68,40}}, color={0,0,127}));
  annotation (
        defaultComponentName = "onOffPer",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
This block processes a relay swtich output signal and calculates the length of
the on period (when the relay switch signal becomes <code>true</code>),
and the length of the off period (when the relay switch signal becomes
<code>false</code>), respectively.
<h4>References</h4>
<p>
Josefin Berner (2017)
\"Automatic Controller Tuning using Relay-based Model Identification.\"
Department of Automatic Control, Lund Institute of Technology, Lund University.
</p>
</html>"));
end OnOffPeriod;
