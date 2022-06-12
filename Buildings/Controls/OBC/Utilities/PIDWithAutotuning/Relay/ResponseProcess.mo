within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay;
block ResponseProcess
  "Calculates the lengths of the On period and the Off period, the half period ratio, as well as the times when the tuning starts and ends"
  parameter Real yHig(min=1E-6) = 1
    "Higher value for the output";
  parameter Real yLow(min=1E-6) = 0.5
    "Lower value for the output";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput On
    "Connector for relay switch signal" annotation (Placement(transformation(
          extent={{-140,-80},{-100,-40}}), iconTransformation(extent={{-140,-80},
            {-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tim
    "Connector for the input signal of the simulation time"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOn
    "Connector for a real signal of the length for the On period"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOff
    "Connector for a real output signal of the length for the Off period"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput triggerStart
    "Connector for a boolean signal, true if the tuning starts"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput triggerEnd
    "Connector for a boolean signal, true if the tuning ends"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tau
    "Connector for a real signal of the normalized time delay"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.OnOffPeriod onOffPeriod
    "Calculates the length of the On period and the Off period"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.HalfPeriodRatio halfPeriodRatio
    "Calculates the half period ratio"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.NormalizedTimeDelay normalizedTimeDelay(gamma=max(
        yHig, yLow)/min(yLow, yHig))
    "calculates the normalized time delay"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

equation
  connect(onOffPeriod.On, On) annotation (Line(points={{-62,4},{-94,4},{-94,-60},
          {-120,-60}}, color={255,0,255}));
  connect(onOffPeriod.tim, tim) annotation (Line(points={{-62,16},{-94,16},{-94,
          60},{-120,60}}, color={0,0,127}));
  connect(onOffPeriod.tOn, halfPeriodRatio.tOn)
    annotation (Line(points={{-39,14},{-20,14},{-20,16},{-2.22222,16}},
                                                color={0,0,127}));
  connect(onOffPeriod.tOff, halfPeriodRatio.tOff)
    annotation (Line(points={{-39,6},{-8,6},{-8,4},{-2.22222,4}},
                                                            color={0,0,127}));
  connect(halfPeriodRatio.rho, normalizedTimeDelay.rho) annotation (Line(points={{23.3333,
          16},{36,16},{36,10},{38,10}},     color={0,0,127}));
  connect(tOn, halfPeriodRatio.tOn) annotation (Line(points={{110,80},{-20,80},{
          -20,16},{-2.22222,16}},
                            color={0,0,127}));
  connect(tOff, halfPeriodRatio.tOff) annotation (Line(points={{110,40},{-8,40},
          {-8,4},{-2.22222,4}},
                          color={0,0,127}));
  connect(normalizedTimeDelay.tau, tau) annotation (Line(points={{61,10},{94,10},
          {94,0},{110,0}},     color={0,0,127}));
  connect(triggerEnd, halfPeriodRatio.triggerEnd) annotation (Line(points={{110,-80},
          {26,-80},{26,4},{23.3333,4}}, color={255,0,255}));
  connect(triggerStart, halfPeriodRatio.triggerStart) annotation (Line(points={{110,-40},
          {34,-40},{34,10},{23.3333,10}},          color={255,0,255}));
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
<p>This block processes a relay swtich output signall and calculates</p>
<p>1) the length of the On period (when the relay switch signal becomes True);</p>
<p>2) the length of the Off period (when the relay switch signal becomes False);</p>
<p>3) the normalized time delay of the responses;</p>
<p>4) the flags which indicates if the tuning starts and completes, respectively.</p>
<p>For more details, please refer to <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.HalfPeriodRatio\">Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.HalfPeriodRatio</a>,</p>
<p><a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.NormalizedTimeDelay\">Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.NormalizedTimeDelay</a>,</p>
<p><a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.OnOffPeriod\">Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.OnOffPeriod</a>.</p>
</html>"));
end ResponseProcess;
