within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.Validation;
model OnOffPeriod "Test model for calculating the length of the On period and the Off period"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.OnOffPeriod
    onOffPer "Calculate the length of the On period and the Off period"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.ModelTime modTim
    "Simulation time"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse relSwi(
    width=0.2,
    period=0.8,
    shift=-0.1) "Control switch output"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse retSig(
    width=0.1,
    period=1,
    shift=-0.1) "Reset signal"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(modTim.y, onOffPer.tim) annotation (Line(points={{-38,20},{-20,20},{-20,
          6},{-12,6}}, color={0,0,127}));
  connect(relSwi.y, onOffPer.on) annotation (Line(points={{-38,-10},{-20,-10},{
          -20,0},{-12,0}}, color={255,0,255}));
  connect(onOffPer.trigger, retSig.y) annotation (Line(points={{-12,-6},{-16,-6},
          {-16,-50},{-38,-50}}, color={255,0,255}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Relay/BaseClasses/Validation/OnOffPeriod.mos" "Simulate and plot"),
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.OnOffPeriod\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.OnOffPeriod</a>.
</p>
This example considers a relay switch output from a relay controller, <code>relSwi</code>.
<ul>
<li>
At <i>0.06</i>s, <code>relSwi</code> changes from On to Off.
</li>
<li>
At <i>0.7</i>s, <code>relSwi</code> changes into On.
</li>
<li>
At <i>0.86</i>s, <code>relSwi</code> changes into Off.
</li>
</ul>
</html>"));
end OnOffPeriod;
