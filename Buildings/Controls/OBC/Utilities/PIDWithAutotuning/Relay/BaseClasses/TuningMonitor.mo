within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses;
block TuningMonitor "Monitor the tuning process"
  constant Modelica.Units.SI.Time minHorLen = 1E-5
    "Minimum value for horizon length, used to guard against rounding errors";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOn(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the on period"
    annotation (Placement(transformation(extent={{-200,60},{-160,100}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOff(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the off period"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput triSta
    "A boolean signal, true if the tuning starts"
    annotation (Placement(transformation(extent={{160,40},{200,80}}),
    iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput triEnd
    "A boolean signal, true if the tuning completes"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
    iconTransformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Max tMax
    "Maximum value of the length for the on and Off period "
    annotation (Placement(transformation(origin={-50,-10}, extent = {{-80, 60}, {-60, 80}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greThr
    "Check if either the length for the on period or the length for the off period are larger than 0"
    annotation (Placement(transformation(origin={-40,10}, extent = {{-40, 40}, {-20, 60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minLen(
    final k=minHorLen)
    "Minimum value for the horizon length"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samAddtOntOff
    "Sample the minimum period when the minimum period is greater than 0"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Reals.Greater tInc
    "Check if either the length for the on period or the length for the off period increases after they both become positive"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Reals.Add addtOntOff
    "Block that calculates the sum of the length for the on period and the length for the off period"
    annotation (Placement(transformation(extent={{-130,-20},{-110,0}})));
  Buildings.Controls.OBC.CDL.Reals.Greater tDec
    "Check if either the length for the on period or the length for the off period decreases after they both become positive"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Or tCha
    "Block that checks if the length for the on period or the length for the off period changes"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgTunSta
   "Detect if the tuning process starts"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgTunEnd
   "Detect if the tuning process ends"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
   "Calculate the product of two inputs"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Reals.Min tMin
   "Minimum value of the length for the on and Off period"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greThr1
    "Check if both the length for the on period and the length for the off period are larger than 0"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub "Find the input difference"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1 "Find the input difference"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

equation
  connect(tMax.u1, tOn) annotation (Line(points={{-132,66},{-150,66},{-150,80},{
          -180,80}}, color={0,0,127}));
  connect(tMax.u2, tOff) annotation (Line(points={{-132,54},{-140,54},{-140,-80},
          {-180,-80}},color={0,0,127}));
  connect(addtOntOff.u2, tOff) annotation (Line(points={{-132,-16},{-140,-16},{-140,
          -80},{-180,-80}}, color={0,0,127}));
  connect(addtOntOff.u1, tOn) annotation (Line(points={{-132,-4},{-150,-4},{-150,
          80},{-180,80}}, color={0,0,127}));
  connect(edgTunSta.y, triSta) annotation (Line(points={{142,60},{180,60}},
         color={255,0,255}));
  connect(tCha.y, edgTunEnd.u) annotation (Line(points={{102,0},{118,0}},
          color={255,0,255}));
  connect(edgTunEnd.y, triEnd) annotation (Line(points={{142,0},{180,0}},
          color={255,0,255}));
  connect(tMin.u1, tOn) annotation (Line(points={{-132,-74},{-150,-74},{-150,80},
          {-180,80}}, color={0,0,127}));
  connect(tMin.u2, tOff) annotation (Line(points={{-132,-86},{-140,-86},{-140,-80},
          {-180,-80}}, color={0,0,127}));
  connect(greThr.y, edgTunSta.u)
    annotation (Line(points={{-58,60},{118,60}}, color={255,0,255}));
  connect(greThr1.y, samAddtOntOff.trigger) annotation (Line(points={{-58,-80},{
          -30,-80},{-30,-22}}, color={255,0,255}));
  connect(addtOntOff.y, mul.u1) annotation (Line(points={{-108,-10},{-100,-10},{
          -100,-4},{-82,-4}}, color={0,0,127}));
  connect(mul.u2, tMin.y) annotation (Line(points={{-82,-16},{-100,-16},{-100,-80},
          {-108,-80}},color={0,0,127}));
  connect(samAddtOntOff.u, mul.y) annotation (Line(points={{-42,-10},{-58,-10}},
          color={0,0,127}));
  connect(tInc.y, tCha.u1) annotation (Line(points={{62,30},{70,30},{70,0},{78,0}},
        color={255,0,255}));
  connect(tDec.y, tCha.u2) annotation (Line(points={{62,-60},{70,-60},{70,-8},{78,
          -8}}, color={255,0,255}));
  connect(samAddtOntOff.y, sub.u2) annotation (Line(points={{-18,-10},{-10,-10},
          {-10,24},{-2,24}}, color={0,0,127}));
  connect(mul.y, sub.u1) annotation (Line(points={{-58,-10},{-50,-10},{-50,36},{
          -2,36}}, color={0,0,127}));
  connect(samAddtOntOff.y, sub1.u1) annotation (Line(points={{-18,-10},{-10,-10},
          {-10,-54},{-2,-54}}, color={0,0,127}));
  connect(mul.y, sub1.u2) annotation (Line(points={{-58,-10},{-50,-10},{-50,-66},
          {-2,-66}}, color={0,0,127}));
  connect(tMax.y, greThr.u1)
    annotation (Line(points={{-108,60},{-82,60}}, color={0,0,127}));
  connect(tMin.y, greThr1.u1)
    annotation (Line(points={{-108,-80},{-82,-80}}, color={0,0,127}));
  connect(minLen.y, greThr.u2) annotation (Line(points={{-118,100},{-90,100},{-90,
          52},{-82,52}}, color={0,0,127}));
  connect(minLen.y, greThr1.u2) annotation (Line(points={{-118,100},{-90,100},{-90,
          -88},{-82,-88}}, color={0,0,127}));
  connect(sub.y, tInc.u1)
    annotation (Line(points={{22,30},{38,30}}, color={0,0,127}));
  connect(sub1.y, tDec.u1)
    annotation (Line(points={{22,-60},{38,-60}}, color={0,0,127}));
  connect(minLen.y, tInc.u2) annotation (Line(points={{-118,100},{30,100},{30,22},
          {38,22}}, color={0,0,127}));
  connect(minLen.y, tDec.u2) annotation (Line(points={{-118,100},{30,100},{30,-68},
          {38,-68}}, color={0,0,127}));
annotation (defaultComponentName = "tunMon",
        Diagram(
           coordinateSystem(
           extent={{-160,-120},{160,120}})),
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
<p>
J. Berner (2017).
<a href=\"https://lucris.lub.lu.se/ws/portalfiles/portal/33100749/ThesisJosefinBerner.pdf\">
\"Automatic Controller Tuning using Relay-based Model Identification.\"</a>
Department of Automatic Control, Lund University.
</p>
</html>"));
end TuningMonitor;
