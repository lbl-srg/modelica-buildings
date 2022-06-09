within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.ModelIdentification;
block ResponseProcess
  "Processes a relay signal to calculate the lengths of the On period and the Off period"
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput On
    "Connector for input signal"
     annotation (
      Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOff
    "Connector for a Real output signal of the length for the Off period"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOn
    "Connector for a output signal of the length for the On period"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler timOn
    "Simulation time when the input signal becomes On (True)"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler timOff
    "Simulation time when the input signal becomes Off (False)"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not Off "Relay switch off"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract lenOffCal
    "Calculating the horizon length for the Off period"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract lenOnCal
    "Calculating the horizon length for the On period"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greTimOff
    "Triggering the action to record the horizon length for the Off period"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greTimOn
    "Triggering the action to record the horizon length for the On period"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLen(final k=0)
    "Minimum value for the horizon length"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler timOffRecord
    "Recording the horizon length for the Off period"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler timOnRecord
    "Recording the horizon length for the On period"
    annotation (Placement(transformation(extent={{60,50},{80,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput tim
    "Connector for the input signal of the simulation time" annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
equation
  connect(Off.u, On) annotation (Line(points={{-82,-70},{-94,-70},{-94,-60},{
          -120,-60}},
               color={255,0,255}));
  connect(Off.y, timOff.trigger) annotation (Line(points={{-58,-70},{-20,-70},{-20,
          -42}}, color={255,0,255}));
  connect(timOn.trigger, On) annotation (Line(points={{-20,28},{-20,20},{-92,20},
          {-92,-60},{-120,-60}},
                             color={255,0,255}));
  connect(lenOffCal.u1, timOn.y) annotation (Line(points={{18,-24},{8,-24},{8,
          34},{4,34},{4,40},{-8,40}},
                                  color={0,0,127}));
  connect(lenOnCal.u2, timOn.y)
    annotation (Line(points={{18,34},{4,34},{4,40},{-8,40}}, color={0,0,127}));
  connect(lenOnCal.u1, timOff.y) annotation (Line(points={{18,46},{0,46},{0,-30},
          {-8,-30}}, color={0,0,127}));
  connect(lenOffCal.u2, timOff.y) annotation (Line(points={{18,-36},{0,-36},{0,-30},
          {-8,-30}}, color={0,0,127}));
  connect(minLen.y, greTimOn.u2)
    annotation (Line(points={{-58,70},{-52,70},{-52,62},{38,62}},
                                                color={0,0,127}));
  connect(lenOnCal.y, greTimOn.u1) annotation (Line(points={{42,40},{50,40},{50,
          56},{20,56},{20,70},{38,70}}, color={0,0,127}));
  connect(greTimOff.u2, greTimOn.u2) annotation (Line(points={{38,-78},{-52,-78},
          {-52,62},{38,62}}, color={0,0,127}));
  connect(lenOffCal.y, greTimOff.u1) annotation (Line(points={{42,-30},{48,-30},
          {48,-48},{20,-48},{20,-70},{38,-70}}, color={0,0,127}));
  connect(greTimOff.y, timOffRecord.trigger)
    annotation (Line(points={{62,-70},{70,-70},{70,-52}}, color={255,0,255}));
  connect(timOffRecord.u, greTimOff.u1) annotation (Line(points={{58,-40},{54,
          -40},{54,-48},{20,-48},{20,-70},{38,-70}},
                                                color={0,0,127}));
  connect(greTimOn.y, timOnRecord.trigger)
    annotation (Line(points={{62,70},{70,70},{70,52}}, color={255,0,255}));
  connect(timOnRecord.u, greTimOn.u1) annotation (Line(points={{58,40},{50,40},
          {50,56},{20,56},{20,70},{38,70}},color={0,0,127}));
  connect(timOffRecord.y, tOff)
    annotation (Line(points={{82,-40},{110,-40}}, color={0,0,127}));
  connect(timOnRecord.y, tOn)
    annotation (Line(points={{82,40},{110,40}}, color={0,0,127}));
  connect(timOn.u, tim) annotation (Line(points={{-32,40},{-92,40},{-92,60},{
          -120,60}}, color={0,0,127}));
  connect(timOff.u, tim) annotation (Line(points={{-32,-30},{-94,-30},{-94,60},
          {-120,60}},                   color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-154,148},{146,108}},
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
<p>This block processes a relay feedback signal and calculates</p>
<p>1) the length of the On period (when the relay switch signal becomes True);</p>
<p>2) the length of the Off period (when the relay switch signal becomes False).</p>
</html>"));
end ResponseProcess;
