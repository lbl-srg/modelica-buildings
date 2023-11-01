within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.Validation;
model TuningMonitor "Test model for the tuning period management"
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse tOnSig1(
    amplitude=-0.1,
    width=0.1,
    period=1,
    offset=0.1)
    "Block that generates signals for forming the signal of the length of On period"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse tOnSig2(
    amplitude=-0.1,
    width=0.9,
    period=1,
    offset=0.1)
    "Block that generates signals for forming the signal of the length of On period"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Add tOn
    "The length of the on period"
    annotation (Placement(transformation(extent={{-34,40},{-14,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse tOff(
    amplitude=-0.5,
    width=0.7,
    period=1,
    offset=0.5)
    "The length of the off period"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.TuningMonitor
    tunMan "Manage the tuning process"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch tunSta "Display when tuning process starts"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Logical.Latch tunEnd "Display when tuning process ends"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=false) "False signal"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
equation
  connect(tOnSig2.y, tOn.u1) annotation (Line(points={{-58,70},{-40,70},{-40,56},
          {-36,56}}, color={0,0,127}));
  connect(tOnSig1.y, tOn.u2) annotation (Line(points={{-58,30},{-40,30},{-40,44},
          {-36,44}}, color={0,0,127}));
  connect(tunMan.tOn, tOn.y)
    annotation (Line(points={{18,6},{0,6},{0,50},{-12,50}}, color={0,0,127}));
  connect(tunMan.tOff, tOff.y) annotation (Line(points={{18,-6},{0,-6},{0,-30},
          {-58,-30}}, color={0,0,127}));
  connect(con.y, tunSta.clr) annotation (Line(points={{2,-60},{52,-60},{52,24},
          {58,24}}, color={255,0,255}));
  connect(tunEnd.clr, con.y) annotation (Line(points={{58,-36},{52,-36},{52,-60},
          {2,-60}}, color={255,0,255}));
  connect(tunMan.triSta, tunSta.u) annotation (Line(points={{42,6},{48,6},{48,
          30},{58,30}}, color={255,0,255}));
  connect(tunMan.triEnd, tunEnd.u) annotation (Line(points={{42,-6},{48,-6},{48,
          -30},{58,-30}}, color={255,0,255}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Relay/BaseClasses/Validation/TuningMonitor.mos" "Simulate and plot"),
      Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
September 20, 2023, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.TuningMonitor\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.TuningMonitor</a>.
</p>
<ul>
<li>
At <i>0.1</i>s, the length of the on period becomes <i>0.1</i>s,
triggering the training period to start.
</li>
<li>
At <i>0.7</i>s, the length of the off period becomes <i>0.5</i>s.
</li>
<li>
At <i>0.9</i>s, the length of the on period changes from <i>0.1</i>s to <i>0.9</i>s
while that of the off period remains <i>0.5</i>s.
This triggers the tuning period to end.
</li>
</ul>
</html>"));
end TuningMonitor;
