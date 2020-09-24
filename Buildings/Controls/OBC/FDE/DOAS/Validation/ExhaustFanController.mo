within Buildings.Controls.OBC.FDE.DOAS.Validation;
model ExhaustFanController
  "This model simulates ExhaustFanController"

  parameter Real bldgSPset(
   final unit="Pa",
   final quantity="PressureDifference")=15
    "Building static pressure set point";

  Buildings.Controls.OBC.FDE.DOAS.ExhaustFanController EFcon
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    delayTime=10,
    delayOnInit=true)
    "Simulates delay between fan start command and status feedback."
      annotation (Placement(transformation(extent={{14,-40},{34,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse SFproof(
    width=0.75,
    period=5760)
      annotation (Placement(transformation(extent={{-34,8},{-14,28}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine bldgSP(
    amplitude=3,
    freqHz=1/3280,
    offset=15)
    annotation (Placement(transformation(extent={{-34,-26},{-14,-6}})));
equation
  connect(SFproof.y, EFcon.supFanProof) annotation (Line(points={{-12,18},{4,18},
          {4,6},{44,6}}, color={255,0,255}));
  connect(bldgSP.y, EFcon.bldgSP) annotation (Line(points={{-12,-16},{4,-16},{4,
          -6.4},{44,-6.4}}, color={0,0,127}));
  connect(truDel.y, EFcon.exhFanProof) annotation (Line(points={{36,-30},{40,
          -30},{40,0},{44,0}}, color={255,0,255}));
  connect(EFcon.exhFanStart, truDel.u) annotation (Line(points={{68,6},{74,6},{
          74,-48},{4,-48},{4,-30},{12,-30}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
September 14, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.DOAS.ExhaustFanController\">
Buildings.Controls.OBC.FDE.DOAS.ExhaustFanController</a>.
</p>
</html>"),
    experiment(StopTime=5760, __Dymola_Algorithm="Dassl"));
end ExhaustFanController;
