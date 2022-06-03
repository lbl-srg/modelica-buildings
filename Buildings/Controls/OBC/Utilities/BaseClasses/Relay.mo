within Buildings.Controls.OBC.Utilities.BaseClasses;
block Relay
  "Outputs a relay signal for PID tuning purposes"
  parameter Real yHig(min=0) = 1
    "Higher value for the output";
  parameter Real yLow(max=0) = -0.5
    "Lower value for the output";
  parameter Real deaBan(min=0) = 0.5
    "Deadband for holding the output value";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector for the setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector for the measurement input signal"
    annotation (Placement(transformation(origin={0,-120},extent={{20,-20},{-20,20}},rotation=270),
    iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y "Relay output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput On "Relay switch signal"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Logical.OnOffController greMeaSet(bandwidth=deaBan*2, pre_y_start=true)
    "check if the measured value is larger than the reference"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch between a higher value and a lower value"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yHigSig(final k=yHig)
    "Higher value for the output"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yLowSig(final k=yLow)
    "Default temperature slope in case of zero division"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not notCon
    "reverse the swtich signal"
    annotation (Placement(transformation(extent={{12,-10},{32,10}})));

initial equation
  assert(
    abs(abs(yHig) - abs(yLow))>1E-6,
    "the absulte values of yHig should be different from that of yLow. Check parameters.");

equation
  connect(swi.y, y)
    annotation (Line(points={{82,0},{90,0},{90,0},{110,0}}, color={0,0,127}));
  connect(greMeaSet.reference, u_s)
    annotation (Line(points={{-22,6},{-94,6},{-94,0},{-120,0}},
                                               color={0,0,127}));
  connect(greMeaSet.u, u_m)
    annotation (Line(points={{-22,-6},{-64,-6},{-64,-94},
          {0,-94},{0,-120}}, color={0,0,127}));
  connect(greMeaSet.y, notCon.u)
    annotation (Line(points={{2,0},{10,0}}, color={255,0,255}));
  connect(notCon.y, swi.u2)
    annotation (Line(points={{34,0},{58,0}}, color={255,0,255}));
  connect(yHigSig.y, swi.u1)
    annotation (Line(points={{-18,50},{50,50},{50,8},{58,
          8}}, color={0,0,127}));
  connect(yLowSig.y, swi.u3)
    annotation (Line(points={{-18,-40},{50,-40},{50,-8},
          {58,-8}}, color={0,0,127}));
  connect(On, swi.u2)
    annotation (Line(points={{110,-30},{40,-30},{40,0},{58,0}},
        color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-148,154},{152,114}},
          textString="%name",
          textColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This block grenerates a relay feedback signal, as described below:</p>
<p>if e(t) &gt; &delta;, then y(t) = y<sub>hig</sub>,</p>
<p>if e(t) &lt; &delta;, then y(t) = y<sub>low</sub>,</p>
<p>otherwise, y(t) = y(t-&Delta;t).</p>
<p>where <i>e(t) = u<sub>s</sub>(t) - u<sub>m</sub>(t)</i> is the control error, <i>y<sub>hig</i></sub> and <i>y<sub>low</i></sub> are the higher value and the lower value of the output <i>y,</i> respectively.</p>
<p><i>y(t-&Delta;t)</i> is the output at the previous time step.</p>
<p>Note that this block generates a asymmetric signal, meaning <i>|y<sub>hig</sub>| &ne; |y<sub>low</sub>|</i> </p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"));
end Relay;
