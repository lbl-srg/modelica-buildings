within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses;
block OnOffPeriod "Calculate the lengths of the On period and the Off period"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tim(
    final quantity="Time",
    final unit="s")
    "Simulation time"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput on
   "Relay switch signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput trigger
    "Reset the output when trigger becomes true"  annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOff(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the Off period"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOn(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the On period"
    annotation (Placement(transformation(extent={{100,20},{140,60}})));
protected
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler timOn
    "Simulation time when the input signal becomes on (True)"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler timOff
    "Simulation time when the input signal becomes off (False)"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract lenOffCal
    "Block that calculates the horizon length for the Off period"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract lenOnCal
    "Block that calculates the horizon length for the On period"
    annotation (Placement(transformation(extent={{12,30},{32,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "True: the relay output switch to false"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.SamplerWithResetThreshold timOnRec(
     final lowLim=0, final y_reset=0)
    "Sampling the On time"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.SamplerWithResetThreshold timOffRec(
     final lowLim=0, final y_reset=0)
    "Sampling the Off time"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));

equation
  connect(lenOffCal.u1, timOn.y) annotation (Line(points={{8,-34},{0,-34},{0,40},
          {-28,40}},color={0,0,127}));
  connect(lenOnCal.u2, timOn.y)
    annotation (Line(points={{10,34},{0,34},{0,40},{-28,40}},color={0,0,127}));
  connect(lenOnCal.u1, timOff.y) annotation (Line(points={{10,46},{-4,46},{-4,0},
          {-28,0}}, color={0,0,127}));
  connect(lenOffCal.u2, timOff.y) annotation (Line(points={{8,-46},{-14,-46},{-14,
          0},{-28,0}}, color={0,0,127}));
  connect(timOn.u, tim) annotation (Line(points={{-52,40},{-80,40},{-80,60},{-120,
          60}}, color={0,0,127}));
  connect(timOff.u, tim) annotation (Line(points={{-52,0},{-60,0},{-60,40},{-80,
          40},{-80,60},{-120,60}},
          color={0,0,127}));
  connect(timOn.trigger, on) annotation (Line(points={{-40,28},{-40,20},{-86,20},
          {-86,0},{-120,0}}, color={255,0,255}));
  connect(not1.u, on) annotation (Line(points={{-82,-20},{-92,-20},{-92,0},{-120,
          0}}, color={255,0,255}));
  connect(not1.y, timOff.trigger) annotation (Line(points={{-58,-20},{-40,-20},{
          -40,-12}}, color={255,0,255}));
  connect(timOnRec.y, tOn)
    annotation (Line(points={{82,40},{120,40}}, color={0,0,127}));
  connect(timOffRec.y, tOff)
    annotation (Line(points={{82,-40},{120,-40}}, color={0,0,127}));
  connect(lenOnCal.y, timOnRec.u) annotation (Line(points={{34,40},{46,40},{46,46},
          {58,46}}, color={0,0,127}));
  connect(lenOffCal.y, timOffRec.u) annotation (Line(points={{32,-40},{48,-40},{
          48,-34},{58,-34}}, color={0,0,127}));
  connect(timOnRec.trigger, trigger) annotation (Line(points={{58,34},{40,34},{40,
          -60},{-120,-60}}, color={255,0,255}));
  connect(timOffRec.trigger, trigger) annotation (Line(points={{58,-46},{52,-46},
          {52,-60},{-120,-60}}, color={255,0,255}));
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
This block processes a relay switch output and calculates the length of
the On period, <code>tOn</code>, and the length of the Off period, <code>tOff</code>, as shown below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Controls/OBC/Utilities/PIDWithAutotuning/Relay/BaseClasses/OnOff.png\"/>
</p>
<p>
Note that <code>tOn</code> is sampled when the relay switch output becomes false.
Likewise, <code>tOff</code> is sampled when the relay switch output becomes true.
</p>
<h4>References</h4>
<p>
Josefin Berner (2017)
\"Automatic Controller Tuning using Relay-based Model Identification.\"
Department of Automatic Control, Lund Institute of Technology, Lund University.
</p>
</html>"));
end OnOffPeriod;
