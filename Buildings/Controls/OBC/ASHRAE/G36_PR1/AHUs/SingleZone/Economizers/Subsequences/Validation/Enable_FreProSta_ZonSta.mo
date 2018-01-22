within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Validation;
model Enable_FreProSta_ZonSta
  "Model validates economizer disable for heating zone state and activated freeze protection"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Enable enaDis
    "Single zone VAV AHU enable disable sequence"
    annotation (Placement(transformation(extent={{82,40},{102,60}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Enable enaDis1
    "Single zone VAV AHU enable disable sequence"
    annotation (Placement(transformation(extent={{82,-40},{102,-20}})));

protected
  final parameter Modelica.SIunits.Temperature TOutCutoff=297.15
    "Outdoor temperature high limit cutoff";
  final parameter Modelica.SIunits.SpecificEnergy hOutCutoff=65100
    "Outdoor air enthalpy high limit cutoff";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 2)
    "Outdoor air temperature cutoff"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=TOutCutoff)
    "Outdoor temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 1000)
    "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage0)
    "Freeze protection status is stage0"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zonSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.heating)
    "Zone state is heating"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta1(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage1)
    "Freeze protection status is stage1"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zonSta1(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.deadband)
    "Zone state is deadband"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMax(
    final k=0.9)
    "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMin(
    final k=0.1)
    "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFanSta(
    final k=true)
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));

equation
  connect(TOutBelowCutoff.y, enaDis.TOut)
    annotation (Line(points={{-19,150},{32,150},{32,60},{81,60}}, color={0,0,127}));
  connect(TOutCut.y, enaDis.TOutCut)
    annotation (Line(points={{-19,110},{31.5,110},{31.5,58},{81,58}}, color={0,0,127}));
  connect(TOutCut.y, enaDis1.TOutCut)
    annotation (Line(points={{-19,110},{32,110},{32,-22},{81,-22}}, color={0,0,127}));
  connect(TOutBelowCutoff.y, enaDis1.TOut)
    annotation (Line(points={{-19,150},{32,150},{32,-20},{81,-20}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, enaDis.hOut)
    annotation (Line(points={{-79,110},{-60,110},{-60,56},{81,56}}, color={0,0,127}));
  connect(hOutCut.y, enaDis.hOutCut)
    annotation (Line(points={{-79,70},{-70,70},{-70,54},{81,54}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, enaDis1.hOut)
    annotation (Line(points={{-79,110},{-60,110},{-60,56},{10,56},{10,-24},{81,-24}},
    color={0,0,127}));
  connect(hOutCut.y, enaDis1.hOutCut)
    annotation (Line(points={{-79,70},{-70,70},{-70,54},{6,54},{6,-26},{81,-26}},
    color={0,0,127}));
  connect(zonSta.y, enaDis.uZonSta)
    annotation (Line(points={{-139,10},{-120,10},{-120,50},{81,50}}, color={255,127,0}));
  connect(freProSta.y, enaDis.uFreProSta)
    annotation (Line(points={{-139,50},{-130,50},{-130,52},{81,52}}, color={255,127,0}));
  connect(freProSta1.y, enaDis1.uFreProSta)
    annotation (Line(points={{61,-110},{70,-110},{70,-28},{81,-28}}, color={255,127,0}));
  connect(zonSta1.y, enaDis1.uZonSta)
    annotation (Line(points={{61,-70},{72,-70},{72,-30},{81,-30}}, color={255,127,0}));
  connect(outDamPosMax.y, enaDis.uOutDamPosMax)
    annotation (Line(points={{-39,-110},{-30,-110},{-30,46},{81,46}}, color={0,0,127}));
  connect(outDamPosMin.y, enaDis.uOutDamPosMin)
    annotation (Line(points={{-39,-150},{-28,-150},{-28,44},{81,44}}, color={0,0,127}));
  connect(outDamPosMin.y, enaDis1.uOutDamPosMin)
    annotation (Line(points={{-39,-150},{22,-150},{22,-36},{81,-36}}, color={0,0,127}));
  connect(outDamPosMax.y, enaDis1.uOutDamPosMax)
    annotation (Line(points={{-39,-110},{20,-110},{20,-34},{81,-34}}, color={0,0,127}));
  connect(supFanSta.y, enaDis.uSupFan)
    annotation (Line(points={{-139,-30},{-34,-30},{-34,48},{81,48}}, color={255,0,255}));
  connect(supFanSta.y, enaDis1.uSupFan)
    annotation (Line(points={{-139,-30},{-34,-30},{-34,-32},{81,-32}}, color={255,0,255}));
    annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/Economizers/Subsequences/Validation/Enable_FreProSta_ZonSta.mos"
    "Simulate and plot"),
  Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-180},{180,180}}), graphics={
        Text(
          extent={{80,42},{164,14}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Tests zone state disable condition"),
        Text(
          extent={{80,-36},{174,-64}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Tests freeze protection disable condition")}),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences.Enable</a>
for the following control signals: zone state, freeze protection stage.
</p>
</html>", revisions="<html>
<ul>
<li>
June 13, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Enable_FreProSta_ZonSta;
