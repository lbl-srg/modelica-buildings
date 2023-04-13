within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO;
block PID "Identify control gain, integral time, and derivative time of the PID model"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput kp(
    final min=1E-6)
    "Gain of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput L(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time delay of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput k
    "Control gain signal"
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Ti(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Connector for time constant signal for the integral term"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Td(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Connector for time constant signal for the derivative term"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PIDGain gai
    "Calculate the control gain"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PIDIntegralTime
    intTim "Calculate the integral time"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PIDDerivativeTime
    derTim "Calculate the derivative time"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

equation
  connect(derTim.Td, Td) annotation (Line(points={{12,-60},{120,-60}},
                     color={0,0,127}));
  connect(intTim.Ti, Ti)
    annotation (Line(points={{12,0},{120,0}}, color={0,0,127}));
  connect(gai.k, k) annotation (Line(points={{12,50},{120,50}},
        color={0,0,127}));
  connect(intTim.T, gai.T) annotation (Line(points={{-12,6},{-40,6},{-40,50},{-12,
          50}}, color={0,0,127}));
  connect(derTim.T, gai.T) annotation (Line(points={{-12,-54},{-40,-54},{-40,50},
          {-12,50}}, color={0,0,127}));
  connect(intTim.L, gai.L) annotation (Line(points={{-12,-6},{-26,-6},{-26,44},
          {-12,44}}, color={0,0,127}));
  connect(derTim.L, gai.L) annotation (Line(points={{-12,-66},{-26,-66},{-26,44},
          {-12,44}}, color={0,0,127}));
  connect(kp, gai.kp) annotation (Line(points={{-120,60},{-20,60},{-20,56},{-12,
          56}}, color={0,0,127}));
  connect(T, gai.T) annotation (Line(points={{-120,0},{-80,0},{-80,6},{-40,6},{
          -40,50},{-12,50}}, color={0,0,127}));
  connect(L, gai.L) annotation (Line(points={{-120,-60},{-26,-60},{-26,44},{-12,
          44}}, color={0,0,127}));
  annotation (defaultComponentName = "PID",
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
<p>
This block calculates the control gain, the integral time, and the
derivative time of a PID model.
</p>
<p>Please refer to the following block for detailed information:</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PIDGain\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.PIDGain</a>
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PIDIntegralTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.PIDIntegralTime</a>
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PIDDerivativeTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.PIDDerivativeTime</a>
</li>
</ul>
</html>"));
end PID;
