within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO;
block PI "Identify control gain and integral time of a PI controller"
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
    annotation (Placement(transformation(extent={{100,10},{140,50}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Ti(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant signal for the integral term"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
protected
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIGain
    gai "Block that calculates the control gain"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIIntegralTime
    intTim "Block that calculates the integral time"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));

equation
  connect(gai.k, k)
    annotation (Line(points={{12,30},{120,30}}, color={0,0,127}));
  connect(intTim.Ti, Ti) annotation (Line(points={{12,-30},{94,-30},{94,-30},{120,
          -30}}, color={0,0,127}));
  connect(intTim.T, gai.T) annotation (Line(points={{-12,-24},{-40,-24},{-40,30},
          {-12,30}}, color={0,0,127}));
  connect(intTim.L, gai.L) annotation (Line(points={{-12,-36},{-20,-36},{-20,24},
          {-12,24}}, color={0,0,127}));
  connect(T, gai.T) annotation (Line(points={{-120,0},{-40,0},{-40,30},{-12,30}},
        color={0,0,127}));
  connect(L, gai.L) annotation (Line(points={{-120,-60},{-20,-60},{-20,24},{-12,
          24}}, color={0,0,127}));
  connect(gai.kp, kp) annotation (Line(points={{-12,36},{-40,36},{-40,60},{-120,
          60}}, color={0,0,127}));
  annotation (defaultComponentName = "PI",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-16,-12},{84,-52}},
          textString="PI",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Polygon(
          points={{12,-30},{-10,-22},{-10,-38},{12,-30}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{32,-14},{24,8},{40,8},{32,-14}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{32,8},{32,44}}, color={28,108,200}),
        Line(points={{-42,-30},{-10,-30}}, color={28,108,200}),
        Text(
          extent={{-18,80},{82,40}},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="k"),
        Text(
          extent={{-116,-10},{-16,-50}},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="Ti")}),     Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
This block calculates the control gain and the integral time of a PI controller.
</p>
<p>Refer to the following blocks for detailed information:</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIGain\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.BaseClasses.AMIGO.PIGain</a>
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses.PIIntegralTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.AutoTuner.AMIGO.BaseClasses.PIIntegralTime</a>
</li>
</ul>
</html>"));
end PI;
