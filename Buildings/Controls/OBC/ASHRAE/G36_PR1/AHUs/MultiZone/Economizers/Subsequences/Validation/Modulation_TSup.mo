within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Validation;
model Modulation_TSup
  "Validation model for multi zone VAV AHU outdoor and return air damper position modulation sequence"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.Temperature TSupSet=291.15
    "Supply air temperature setpoint";

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Modulation mod
    "Economizer modulation sequence"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Modelica.Blocks.Sources.Ramp uTSup(
    final duration=900,
    final height=2,
    final offset=-1)
                    "Control signal for supply air temperature loop"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMin(final k=
        0.1)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMax(final k=
        0.9)
    annotation (Placement(transformation(extent={{-80,16},{-60,36}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant RetDamPosMin(final k=
        0.15)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant RetDamPosMax(final k=
        0.85)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

equation
  connect(RetDamPosMax.y, mod.uRetDamPosMax) annotation (Line(points={{-59,-40},
          {-20,-40},{-20,38},{39,38}},         color={0,0,127}));
  connect(RetDamPosMin.y, mod.uRetDamPosMin) annotation (Line(points={{-59,-70},
          {8,-70},{8,16},{8,34},{39,34}},color={0,0,127}));
  connect(outDamPosMax.y, mod.uOutDamPosMax) annotation (Line(points={{-59,26},
          {39,26}},                            color={0,0,127}));
  connect(outDamPosMin.y, mod.uOutDamPosMin) annotation (Line(points={{-59,-10},
          {-34,-10},{-24,-10},{-24,22},{39,22}}, color={0,0,127}));
  connect(uTSup.y, mod.uTSup) annotation (Line(points={{-39,70},{0,70},{0,30},{
          39,30}}, color={0,0,127}));
  annotation (
  experiment(StopTime=900.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/Economizers/Subsequences/Validation/Modulation_TSup.mos"
    "Simulate and plot"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Modulation\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Modulation</a>
for supply air temeperature <code>TSup</code> and supply air temperature heating setpoint <code>TSupSet</code>
control signals.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Modulation_TSup;
