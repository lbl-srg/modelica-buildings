within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo;
block PID "Identifies the parameters of a PID controller"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput kp(min=1E-6)
    "Connector for the signal of the gain of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T(min=0)
    "Connector for the signal of the time constant of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput L(min=1E-6)
    "Connector for the signal of the time delay of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput k
    "Connector for control gain signal"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Ti
    "Connector for time constant signal for the integral term"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Td
    "Connector for time constant signal for the derivative term"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.PIDGain gain
    "Calculate the control gain"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.PIDIntegralTime
    integralTime "Calculate the integral time"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.PIDDerivativeTime
    derivativeTime "Calculate the derivative time"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
	
equation
  connect(derivativeTime.Td, Td)
    annotation (Line(points={{11,-60},{110,-60}}, color={0,0,127}));
  connect(integralTime.Ti, Ti)
    annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  connect(gain.k, k) annotation (Line(points={{11,50},{94,50},{94,60},{110,60}},
        color={0,0,127}));
  connect(integralTime.T, gain.T) annotation (Line(points={{-12,6},{-40,6},{-40,
          50},{-12,50}}, color={0,0,127}));
  connect(derivativeTime.T, gain.T) annotation (Line(points={{-12,-54},{-40,-54},
          {-40,50},{-12,50}}, color={0,0,127}));
  connect(integralTime.L, gain.L) annotation (Line(points={{-12,-6},{-26,-6},{
          -26,44},{-12,44}}, color={0,0,127}));
  connect(derivativeTime.L, gain.L) annotation (Line(points={{-12,-66},{-26,-66},
          {-26,44},{-12,44}}, color={0,0,127}));
  connect(kp, gain.kp) annotation (Line(points={{-120,60},{-20,60},{-20,56},{
          -12,56}}, color={0,0,127}));
  connect(T, gain.T) annotation (Line(points={{-120,0},{-80,0},{-80,6},{-40,6},
          {-40,50},{-12,50}}, color={0,0,127}));
  connect(L, gain.L) annotation (Line(points={{-120,-60},{-26,-60},{-26,44},{
          -12,44}}, color={0,0,127}));
  annotation (defaultComponentName = "pID",
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
<p>This block calculates the control gain, the integral time, and the derivative time of a PI model.</p>
<P>Please refer to the following block for detailed information:</p>
<P><a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PIDGain\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.PIDGain</a></p>
<P><a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PIDIntegralTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.PIDIntegralTime</a></p>
<P><a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PIDDerivativeTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.PIDDerivativeTime</a></p>
</html>"));
end PID;
