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
    "Time constant signal for the integral term"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Td(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant signal for the derivative term"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
protected
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIDGain                                                        gai
    "Block that calculates the control gain"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIDIntegralTime
    intTim "Block that calculates the integral time"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIDDerivativeTime
    derTim "Block that calculates the derivative time"
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
          textColor={0,0,255}),
        Text(
          extent={{-16,20},{84,-20}},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="PID"),
        Polygon(
          points={{32,22},{24,44},{40,44},{32,22}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,2},{-22,10},{-22,-6},{0,2}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{32,44},{32,68}}, color={28,108,200}),
        Polygon(
          points={{32,-22},{24,-44},{40,-44},{32,-22}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-22,2},{-48,2}}, color={28,108,200}),
        Line(points={{32,-44},{32,-62}}, color={28,108,200}),
        Text(
          visible=(controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI),
          extent={{-16,102},{84,62}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="k"),
        Text(
          extent={{-116,26},{-16,-14}},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="Ti"),
        Text(
          extent={{-18,-62},{82,-102}},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="Td")}),     Diagram(coordinateSystem(preserveAspectRatio=false)),
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIDGain\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.BaseClasses.PIDGain</a>
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIDIntegralTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.BaseClasses.PIDIntegralTime</a>
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIDDerivativeTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.BaseClasses.PIDDerivativeTime</a>
</li>
</ul>
</html>"));
end PID;
