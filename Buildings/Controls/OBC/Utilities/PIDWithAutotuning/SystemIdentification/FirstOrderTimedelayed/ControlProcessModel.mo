within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed;
block ControlProcessModel
  "Identifies the parameters of a first order time delayed model for the control process"
  parameter Real yHig(min=1E-6) = 1
    "Higher value for the output";
  parameter Real yLow(min=1E-6) = 0.5
    "Lower value for the output";
  parameter Real deaBan(min=0) = 0.5
    "Deadband for holding the output value";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Connector for the response signal of a relay controller"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOn
    "Connector for a signal of the length for the On period"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
    iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOff
    "Connector for a signal of the length for the Off period"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau
    "Connector for the signal of normalized time delay" annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput k
    "Connector for a output signal of the gain"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput                        T
    "Connector for a output signal of the time constant"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput                        L
    "Connector for a output signal of the time constant"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.Gain gain(yHig=yHig, yLow=yLow)
    "Calculates the gain"
    annotation (Placement(transformation(extent={{-84,-10},{-64,10}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.TimeConstantDelay timeConstantDelay(yHig=yHig, yLow=yLow,
    deaBan=deaBan)
    "Calculates the time constant and the time delay"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triggerStart
    "Relay tuning status, true if the tuning starts" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput triggerEnd
    "Relay tuning status, true if the tuning ends" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={60,-120})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samT(y_start=1)
    "Sampling k when the tuning period ends"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samL(y_start=1)
    "Sampling L when the tuning period ends"
    annotation (Placement(transformation(extent={{44,-90},{64,-70}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samk(y_start=1)
    "Sampling k when the tuning period ends"
    annotation (Placement(transformation(extent={{-54,-10},{-34,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samtOn(y_start=1)
    "Sampling tOn when the tuning period ends"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler samtau(y_start=0.5)
    "Sampling the normalized time delay"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(k=-1)
    "Product of tau and -1"
    annotation (Placement(transformation(extent={{-36,-90},{-16,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(p=1)
   "1- tau"
    annotation (Placement(transformation(extent={{-8,-90},{12,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div
    "tau/(1- tau)"
    annotation (Placement(transformation(extent={{12,-60},{32,-40}})));
	
equation
  connect(gain.u, u) annotation (Line(points={{-86,8},{-88,8},{-88,80},{-120,80}},
        color={0,0,127}));
  connect(gain.tOn, tOn) annotation (Line(points={{-86,0},{-94,0},{-94,40},{
          -120,40}},               color={0,0,127}));
  connect(gain.tOff, tOff) annotation (Line(points={{-86,-8},{-94,-8},{-94,-40},
          {-120,-40}}, color={0,0,127}));
  connect(gain.triggerStart, triggerStart) annotation (Line(points={{-74,-12},{-74,
          -96},{-60,-96},{-60,-120}},     color={255,0,255}));
  connect(timeConstantDelay.T, samT.u)
    annotation (Line(points={{21,7},{60,7},{60,0},{68,0}}, color={0,0,127}));
  connect(samT.y, T)
    annotation (Line(points={{92,0},{110,0}}, color={0,0,127}));
  connect(samT.trigger, triggerEnd) annotation (Line(points={{80,-12},{80,-92},
          {60,-92},{60,-120}}, color={255,0,255}));
  connect(L, samL.y)
    annotation (Line(points={{110,-80},{66,-80}}, color={0,0,127}));
  connect(samL.u, timeConstantDelay.L) annotation (Line(points={{42,-80},{40,
          -80},{40,-6},{21,-6}}, color={0,0,127}));
  connect(samL.trigger, triggerEnd) annotation (Line(points={{54,-92},{54,-96},
          {60,-96},{60,-120}}, color={255,0,255}));
  connect(samk.y, timeConstantDelay.k)
    annotation (Line(points={{-32,0},{-2,0}}, color={0,0,127}));
  connect(samk.trigger, triggerEnd) annotation (Line(points={{-44,-12},{-44,-96},
          {60,-96},{60,-120}}, color={255,0,255}));
  connect(gain.k, samk.u)
    annotation (Line(points={{-63,0},{-56,0}}, color={0,0,127}));
  connect(samk.y, k) annotation (Line(points={{-32,0},{-20,0},{-20,60},{110,60}},
        color={0,0,127}));
  connect(timeConstantDelay.tOn, samtOn.y) annotation (Line(points={{-2,6},{-28,
          6},{-28,40},{-48,40}}, color={0,0,127}));
  connect(samtOn.u, tOn)
    annotation (Line(points={{-72,40},{-120,40}}, color={0,0,127}));
  connect(samtOn.trigger, triggerEnd) annotation (Line(points={{-60,28},{-60,
          -34},{-44,-34},{-44,-96},{60,-96},{60,-120}}, color={255,0,255}));
  connect(samtau.u, tau)
    annotation (Line(points={{-72,-80},{-120,-80}}, color={0,0,127}));
  connect(samtau.trigger, triggerEnd) annotation (Line(points={{-60,-68},{-60,-34},
          {-44,-34},{-44,-96},{60,-96},{60,-120}}, color={255,0,255}));
  connect(gai.u, samtau.y)
    annotation (Line(points={{-38,-80},{-48,-80}}, color={0,0,127}));
  connect(gai.y, addPar.u)
    annotation (Line(points={{-14,-80},{-10,-80}}, color={0,0,127}));
  connect(addPar.y, div.u2) annotation (Line(points={{14,-80},{20,-80},{20,-62},
          {4,-62},{4,-56},{10,-56}}, color={0,0,127}));
  connect(div.y, timeConstantDelay.ratioLT) annotation (Line(points={{34,-50},{
          34,-24},{-6,-24},{-6,-6},{-2,-6}}, color={0,0,127}));
  connect(div.u1, samtau.y) annotation (Line(points={{10,-44},{-40,-44},{-40,-80},
          {-48,-80}}, color={0,0,127}));
  annotation (
        defaultComponentName = "controlProcessModel",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
<p>This block calculates the parameters of a first-order time-delayed model.</p>
<p>For more details, please refer to <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.Gain\">Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.Gain</a>,</p>
<p><a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.TimeConstantDelay\">Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.TimeConstantDelay</a>.</p>
</html>"));
end ControlProcessModel;
