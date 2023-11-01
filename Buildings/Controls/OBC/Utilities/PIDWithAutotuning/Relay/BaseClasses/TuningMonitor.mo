within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses;
block TuningMonitor "Monitor the tuning process"
  constant Modelica.Units.SI.Time minHorLen = 1E-5
    "Minimum value for horizon length, used to guard against rounding errors";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOn(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the on period"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOff(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the off period"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput triSta
    "A boolean signal, true if the tuning starts"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
    iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput triEnd
    "A boolean signal, true if the tuning completes"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
    iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Max tMax "Maximum value of the length for the on and Off period "
    annotation (Placement(transformation(origin = {0, -10}, extent = {{-80, 60}, {-60, 80}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gretOnOrtOff
    "Check if either the length for the on period or the length for the off period are larger than 0"
    annotation (Placement(transformation(origin = {0, 10}, extent = {{-40, 40}, {-20, 60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minLen(final k=minHorLen)
    "Minimum value for the horizon length"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samAddtOntOff
    "Block that samples the tmin when tmin is larger than 0"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Reals.Greater tInc
    "Block that checks if either the length for the on period or the length for the off period increases after they both become positive"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Reals.Add addtOntOff
    "Block that calculates the sum of the length for the on period and the length for the off period"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Less tDec
    "Block that checks if either the length for the on period or the length for the off period decreases after they both become positive"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Or tCha
    "Block that checks if the length for the on period or the length for the off period changes"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgTunSta
   "Detect if the tuning process starts"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgTunEnd
   "Detect if the tuning process ends"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
   "Calculate the product of two inputs"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Min tMin
   "Minimum value of the length for the on and Off period"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gretOnAndtOff
    "Check if both the length for the on period and the length for the off period are larger than 0"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

equation
  connect(tMax.u1, tOn) annotation (Line(points={{-82,66},{-94,66},{-94,80},{
          -120,80}}, color={0,0,127}));
  connect(tMax.u2, tOff) annotation (Line(points={{-82,54},{-90,54},{-90,-70},{
          -120,-70}}, color={0,0,127}));
  connect(minLen.y, gretOnOrtOff.u2) annotation (Line(points={{-58,30},{-50,30},
          {-50,52},{-42,52}}, color={0,0,127}));
  connect(samAddtOntOff.y, tInc.u2) annotation (Line(points={{2,0},{10,0},{10,22},
          {18,22}}, color={0,0,127}));
  connect(addtOntOff.u2, tOff) annotation (Line(points={{-82,-36},{-90,-36},{
          -90,-70},{-120,-70}},
                            color={0,0,127}));
  connect(addtOntOff.u1, tOn) annotation (Line(points={{-82,-24},{-94,-24},{-94,
          80},{-120,80}}, color={0,0,127}));
  connect(tCha.u1, tInc.y)
    annotation (Line(points={{48,0},{42,0},{42,30}},
          color={255,0,255}));
  connect(samAddtOntOff.y, tDec.u2) annotation (Line(points={{2,0},{10,0},{10,-38},
          {18,-38}}, color={0,0,127}));
  connect(gretOnOrtOff.u1, tMax.y) annotation (Line(points={{-42,60},{-58, 60}}, color={0,0,127}));
  connect(tDec.y, tCha.u2) annotation (Line(points={{42,-30},{42,-8},{48,-8}},
           color={255,0,255}));
  connect(edgTunSta.y, triSta) annotation (Line(points={{82,60},{88,60},{88,60},
          {120,60}}, color={255,0,255}));
  connect(tCha.y, edgTunEnd.u) annotation (Line(points={{72,0},{80,0},{80,-40},{
          52,-40},{52,-60},{58,-60}}, color={255,0,255}));
  connect(edgTunEnd.y, triEnd) annotation (Line(points={{82,-60},{92,-60},{92,-60},
          {120,-60}}, color={255,0,255}));
  connect(tMin.u1, tOn) annotation (Line(points={{-82,-64},{-94,-64},{-94,80},{-120,
          80}}, color={0,0,127}));
  connect(tMin.u2, tOff) annotation (Line(points={{-82,-76},{-90,-76},{-90,-70},
          {-120,-70}}, color={0,0,127}));
  connect(tMin.y, gretOnAndtOff.u1)
    annotation (Line(points={{-58,-70},{-42,-70}}, color={0,0,127}));
  connect(gretOnAndtOff.u2, minLen.y) annotation (Line(points={{-42,-78},{-50,
          -78},{-50,30},{-58,30}}, color={0,0,127}));
  connect(gretOnOrtOff.y, edgTunSta.u) annotation (Line(points={{-18, 60},{58,60}},color={255,0,255}));
  connect(gretOnAndtOff.y, samAddtOntOff.trigger) annotation (Line(points={{-18,
          -70},{-10,-70},{-10,-12}}, color={255,0,255}));
  connect(addtOntOff.y, mul.u1) annotation (Line(points={{-58,-30},{-54,-30},{-54,
          -24},{-42,-24}}, color={0,0,127}));
  connect(mul.u2, tMin.y) annotation (Line(points={{-42,-36},{-54,-36},{-54,-70},
          {-58,-70}}, color={0,0,127}));
  connect(mul.y, tDec.u1)
    annotation (Line(points={{-18,-30},{18,-30}}, color={0,0,127}));
  connect(tInc.u1, mul.y) annotation (Line(points={{18,30},{6,30},{6,-30},{-18,-30}},
        color={0,0,127}));
  connect(samAddtOntOff.u, mul.y) annotation (Line(points={{-22,0},{-32,0},{-32,
          -14},{-14,-14},{-14,-30},{-18,-30}}, color={0,0,127}));

annotation (defaultComponentName = "tunMon",
        Diagram(
           coordinateSystem(
           extent={{-100,-100},{100,100}})),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(revisions="<html>
<ul>
<li>
September 20, 2023, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
This block detects when a PID tuning period should start and end.
Specifically, the tuning period is triggered to begin when either <code>t<sub>on</sub></code>
or <code>t<sub>off</sub></code> becomes positive.
The tuning period is triggered to end when either <code>t<sub>on</sub></code>
or <code>t<sub>off</sub></code> changes after the tuning period starts, as illustrated below:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Controls/OBC/Utilities/PIDWithAutotuning/Relay/BaseClasses/algorithm.png\"/>
</p>

<h4>References</h4>
<p>Josefin Berner (2017)
\"Automatic Controller Tuning using Relay-based Model Identification.\"
Department of Automatic Control, Lund Institute of Technology, Lund University. </p>
</html>"));
end TuningMonitor;
