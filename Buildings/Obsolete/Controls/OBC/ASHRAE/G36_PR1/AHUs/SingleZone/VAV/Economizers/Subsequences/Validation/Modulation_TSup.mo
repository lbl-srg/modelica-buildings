within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Validation;
model Modulation_TSup
  "Validation model for single zone VAV AHU outdoor and return air damper position modulation sequence"

  final parameter Real TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=291.15
    "Supply air temperature setpoint";

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation
    mod "Economizer modulation sequence"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupSetSig(
    final k=TSupSet) "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final duration=900,
    final height=4,
    final offset=TSupSet - 2) "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMin(final k=0.1)
    "Minimum outdoor air damper position"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMax(final k=0.9)
    "Maximum outdoor air damper position"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant RetDamPosMin(final k=0.1)
    "Minimum return air damper position"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant RetDamPosMax(final k=0.9)
    "Maximum return air damper position"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanStatus(k=true)
    "Fan is on"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(TSupSetSig.y, mod.THeaSupSet)
    annotation (Line(points={{2,70},{10,70},{10,48},{10,36},{38,36}},color={0,0,127}));
  connect(TSup.y,mod.TSup)
    annotation (Line(points={{-38,70},{-30,70},{-30,38},{38,38}},color={0,0,127}));
  connect(RetDamPosMax.y, mod.uRetDamPosMax)
    annotation (Line(points={{-58,-40},{-20,-40},{-20,32},{38,32}}, color={0,0,127}));
  connect(RetDamPosMin.y, mod.uRetDamPosMin)
    annotation (Line(points={{-58,-70},{-10,-70},{-10,30},{38,30}}, color={0,0,127}));
  connect(outDamPosMax.y, mod.uOutDamPosMax)
    annotation (Line(points={{-58,20},{-30,20},{-30,26},{38,26}},  color={0,0,127}));
  connect(outDamPosMin.y, mod.uOutDamPosMin)
    annotation (Line(points={{-58,-10},{-26,-10},{-26,24},{38,24}},  color={0,0,127}));
  connect(mod.uSupFan, fanStatus.y)
    annotation (Line(points={{38,21},{32,21},{32,0},{22,0}}, color={255,0,255}));
  annotation (
  experiment(StopTime=900.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/Economizers/Subsequences/Validation/Modulation_TSup.mos"
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
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation</a>
for supply air temeperature <code>TSup</code> and supply air temperature heating setpoint <code>TSupSet</code>
control signals.
</p>
</html>", revisions="<html>
<ul>
<li>
July 29, 2019, by Kun Zhang:<br/>
Modified inputs for better representation of results plotting.
</li>
<li>
October 31, 2018, by David Blum:<br/>
Added heating coil output.
</li>
<li>
July 07, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Modulation_TSup;
