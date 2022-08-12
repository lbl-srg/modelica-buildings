within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo;
block PI "Identifies the parameters of a PI controller"
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
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.PIGain gain
    "Calculate the control gain"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.PIIntegralTime
    integralTime
    "Calculate the integral time"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));

equation
  connect(gain.k, k) annotation (Line(points={{11,30},{96,30},{96,60},{110,60}},
        color={0,0,127}));
  connect(integralTime.Ti, Ti) annotation (Line(points={{11,-30},{94,-30},{94,-40},
          {110,-40}}, color={0,0,127}));
  connect(integralTime.T, gain.T) annotation (Line(points={{-12,-24},{-40,-24},
          {-40,30},{-12,30}}, color={0,0,127}));
  connect(integralTime.L, gain.L) annotation (Line(points={{-12,-36},{-20,-36},
          {-20,24},{-12,24}}, color={0,0,127}));
  connect(T, gain.T) annotation (Line(points={{-120,0},{-40,0},{-40,30},{-12,30}},
        color={0,0,127}));
  connect(L, gain.L) annotation (Line(points={{-120,-60},{-20,-60},{-20,24},{
          -12,24}}, color={0,0,127}));
  connect(gain.kp, kp) annotation (Line(points={{-12,36},{-40,36},{-40,60},{
          -120,60}}, color={0,0,127}));
  annotation (defaultComponentName = "pI",
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
<p>This block calculates the control gain and the integral time of a PI model.</p>
<P>Please refer to the following block for detailed information:</p>
<P><a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PIGain\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.PIGain</a></p>
<P><a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.PIIntegralTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.PIIntegralTime</a></p>
</html>"));
end PI;
