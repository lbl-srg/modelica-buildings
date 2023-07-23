within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay;
block ResponseProcess
  "Calculate the lengths of the on andoff period, the half period ratio, and the times when the tuning starts and ends"
  parameter Real yHig(min=1E-6) = 1
    "Higher value for the output";
  parameter Real yLow(min=1E-6) = 0.5
    "Lower value for the output";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput on
    "Relay switch. True: tuning on perid, False: tuningoff period"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tim(
    final quantity="Time",
    final unit="s")
    "Simulation time"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOn(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length of the On period"
    annotation (Placement(transformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tOff(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length of the Off period"
    annotation (Placement(transformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput triSta
    "True: the tuning starts"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput triEnd
    "True: the tuning ends"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tau
    "Normalized time delay"
    annotation (Placement(transformation(extent={{100,-10},{140,30}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.OnOffPeriod onOffPer
    "Block that calculates the length of the On period and the Off period"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.HalfPeriodRatio halPerRatio
    "Block that calculates the half period ratio"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.NormalizedTimeDelay norTimDel(
     final gamma=max(yHig, yLow)/min(yLow, yHig))
    "Block that calculates the normalized time delay"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

equation
  connect(onOffPer.on,on)  annotation (Line(points={{-82,4},{-90,4},{-90,-60},{
          -120,-60}}, color={255,0,255}));
  connect(onOffPer.tim, tim) annotation (Line(points={{-82,16},{-90,16},{-90,60},
          {-120,60}}, color={0,0,127}));
  connect(onOffPer.tOn, halPerRatio.tOn) annotation (Line(points={{-58,14},{-40,
          14},{-40,16},{-22,16}},      color={0,0,127}));
  connect(onOffPer.tOff, halPerRatio.tOff) annotation (Line(points={{-57.8,6},{
          -30,6},{-30,4},{-22,4}},    color={0,0,127}));
  connect(halPerRatio.rho, norTimDel.rho) annotation (Line(points={{2,16},{30,
          16},{30,10},{38,10}},     color={0,0,127}));
  connect(tOn, halPerRatio.tOn) annotation (Line(points={{120,80},{-40,80},{-40,
          16},{-22,16}},      color={0,0,127}));
  connect(tOff, halPerRatio.tOff) annotation (Line(points={{120,40},{-30,40},{
          -30,4},{-22,4}},  color={0,0,127}));
  connect(norTimDel.tau, tau) annotation (Line(points={{62,10},{120,10}},
                   color={0,0,127}));
  connect(triEnd, halPerRatio.triEnd) annotation (Line(points={{120,-80},{10,
          -80},{10,4},{2,4}},       color={255,0,255}));
  connect(triSta, halPerRatio.triSta) annotation (Line(points={{120,-40},{20,
          -40},{20,10},{2,10}},       color={255,0,255}));
  annotation (
        defaultComponentName = "resPro",
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
        Polygon(
          points={{-54,56},{-62,34},{-46,34},{-54,56}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{34,-58},{26,-36},{42,-36},{34,-58}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-54,60},{30,60},{34,60},{34,-36}}, color={28,108,200}),
        Line(points={{-54,34},{-54,-64},{36,-64}}, color={28,108,200})}),
                                  Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
This block processes a relay switch output signal and calculates:
</p>
<ol>
<li>
the length of the On period;
</li>
<li>
the length of the Off period;
</li>
<li>
the normalized time delay of the responses;
</li>
<li>
the flags which indicate if the tuning starts and completes, respectively.
</li>
</ol>
<p>
For more details, please refer to:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.HalfPeriodRatio\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.HalfPeriodRatio</a>,
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.NormalizedTimeDelay\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.NormalizedTimeDelay</a>,
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.OnOffPeriod\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.OnOffPeriod</a>.
</li>
</ul>
</html>"));
end ResponseProcess;
