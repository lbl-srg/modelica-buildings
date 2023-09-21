within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Validation;
model ResponseProcess "Test model for processing the response of a relay controller"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess resPro(
    final yHig=1,
    final yLow=0.2)
    "Calculate the length of the On period and the Off period"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.ModelTime modTim
    "Simulation time"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse relSwi(
    width=0.2,
    period=0.8,
    shift=-0.1)
    "Control switch output"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse resSig(
    width=0.1,
    period=1,
    shift=-0.1)
    "Reset signal"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Latch tunSta
    "Display when tuning process starts"
    annotation (Placement(transformation(extent={{60,-2},{80,18}})));
  Buildings.Controls.OBC.CDL.Logical.Latch tunEnd
    "Display when tuning process ends"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=false)
    "False signal"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
equation
  connect(modTim.y, resPro.tim) annotation (Line(points={{-38,20},{-20,20},{-20,
          6},{-12,6}}, color={0,0,127}));
  connect(relSwi.y,resPro.on)  annotation (Line(points={{-38,-20},{-20,-20},{
          -20,0},{-12,0}},
                         color={255,0,255}));
  connect(resSig.y, resPro.trigger) annotation (Line(points={{-38,-60},{-16,-60},
          {-16,-6},{-12,-6}}, color={255,0,255}));
  connect(resPro.triSta, tunSta.u) annotation (Line(points={{12,-4},{40,-4},{40,
          8},{58,8}}, color={255,0,255}));
  connect(tunEnd.u, resPro.triEnd) annotation (Line(points={{58,-30},{38,-30},{38,
          -8},{12,-8}}, color={255,0,255}));
  connect(tunSta.clr, con.y) annotation (Line(points={{58,2},{48,2},{48,-70},{22,
          -70}}, color={255,0,255}));
  connect(tunEnd.clr, con.y) annotation (Line(points={{58,-36},{54,-36},{54,-70},
          {22,-70}}, color={255,0,255}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Relay/Validation/ResponseProcess.mos" "Simulate and plot"),
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
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess</a>.
</p>
<p>
This testing scenario in this example is the same as that in <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.Validation.TuningMonitor\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.Validation.TunMonitor</a>.
</p>
</html>"));
end ResponseProcess;
