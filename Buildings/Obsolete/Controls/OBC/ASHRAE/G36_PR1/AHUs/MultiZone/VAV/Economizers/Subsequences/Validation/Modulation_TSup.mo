within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Validation;
model Modulation_TSup
  "Validation model for multi zone VAV AHU outdoor and return air damper position modulation sequence"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulation
    mod "Economizer modulation sequence"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uTSup(
    final duration=900,
    final height=2,
    final offset=-1)
    "Control signal for supply air temperature loop"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMin(
    final k=0.1) "Outdoor air damper minimum position"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMax(final k=0.8)
    "Outdoor air damper maximum position"
    annotation (Placement(transformation(extent={{-80,16},{-60,36}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPosMin(final k=0.2)
    "Return air damper minimum position"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPosMax(final k=0.6)
    "Return air damper maximum position"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulation
    modFre
    "Economizer modulation sequence if the dampers positions prevent freezing at the mixed air"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMaxFre(final k=0)
    "Outdoor damper if freeze protection is on"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPosMinFre(final k=1)
    "Return damper position if freeze protection is on"
    annotation (Placement(transformation(extent={{4,-10},{24,10}})));

equation
  connect(retDamPosMax.y, mod.uRetDamPosMax)
    annotation (Line(points={{-58,-40},{-20,-40},{-20,39},{38,39}},color={0,0,127}));
  connect(retDamPosMin.y, mod.uRetDamPosMin)
    annotation (Line(points={{-58,-70},{-10,-70},{-10,35},{38,35}},color={0,0,127}));
  connect(outDamPosMax.y, mod.uOutDamPosMax)
    annotation (Line(points={{-58,26},{-10,26},{-10,25},{38,25}},
                                               color={0,0,127}));
  connect(outDamPosMin.y, mod.uOutDamPosMin)
    annotation (Line(points={{-58,-10},{-58,-10},{-24,-10},{-24,21},{38,21}}, color={0,0,127}));
  connect(uTSup.y, mod.uTSup)
    annotation (Line(points={{-38,70},{0,70},{0,30},{38,30}}, color={0,0,127}));
  connect(retDamPosMax.y, modFre.uRetDamPosMax)
    annotation (Line(points={{-58,-40},{-20,-40},{-20,-21},{38,-21}}, color={0,0,127}));
  connect(outDamPosMin.y, modFre.uOutDamPosMin)
    annotation (Line(points={{-58,-10},{-34,-10},{-34,-39},{38,-39}}, color={0,0,127}));
  connect(uTSup.y, modFre.uTSup)
    annotation (Line(points={{-38,70},{0,70},{0,-30},{38,-30}}, color={0,0,127}));
  connect(outDamPosMaxFre.y, modFre.uOutDamPosMax)
    annotation (Line(points={{22,-70},{30,-70},{30,-35},{38,-35}}, color={0,0,127}));
  connect(retDamPosMinFre.y, modFre.uRetDamPosMin)
    annotation (Line(points={{26,0},{32,0},{32,-25},{38,-25}}, color={0,0,127}));
  annotation (
  experiment(StopTime=900.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/Economizers/Subsequences/Validation/Modulation_TSup.mos"
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
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulation\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulation</a>
for a varying supply air temperature control loop signal.
The instance <code>mod</code> is in normal operation, whereas
for the instance <code>modFre</code>, the damper limits are
as if the mixed air temperature were below its freezing set point.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, 2017, by Michael Wetter:<br/>
Added additional instance to validate the behavior when dampers are
such positioned that they prevent the mixed air temperature from being
below the freezing set point.
</li>
<li>
June 30, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Modulation_TSup;
