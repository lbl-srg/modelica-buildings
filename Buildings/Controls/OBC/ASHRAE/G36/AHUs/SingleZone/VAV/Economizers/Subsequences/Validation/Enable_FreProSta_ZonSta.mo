within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Validation;
model Enable_FreProSta_ZonSta
  "Model validates economizer disable for heating zone state and activated freeze protection"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable
    enaDis "Single zone VAV AHU enable disable sequence"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable
    enaDis1 "Single zone VAV AHU enable disable sequence"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

protected
  final parameter Real TOutCutoff(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")=297.15
    "Outdoor temperature high limit cutoff";
  final parameter Real hOutCutoff(
    final unit="J/kg",
    final quantity = "SpecificEnergy")=65100
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
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage0)
    "Freeze protection status is stage0"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zonSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.heating)
    "Zone state is heating"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta1(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage1)
    "Freeze protection status is stage1"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zonSta1(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.deadband)
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
    final k=true) "Supply fan status"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));

equation
  connect(TOutBelowCutoff.y, enaDis.TOut)
    annotation (Line(points={{-18,150},{34,150},{34,59},{78,59}}, color={0,0,127}));
  connect(TOutCut.y, enaDis1.TCut)
    annotation (Line(points={{-18,110},{20,110},{20,-23},{78,-23}}, color={0,0,127}));
  connect(TOutBelowCutoff.y, enaDis1.TOut)
    annotation (Line(points={{-18,150},{34,150},{34,-21},{78,-21}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, enaDis.hOut)
    annotation (Line(points={{-78,110},{-60,110},{-60,60},{10,60},{10,55},{78,55}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, enaDis1.hOut)
    annotation (Line(points={{-78,110},{-60,110},{-60,60},{10,60},{10,-25},{78,-25}},
    color={0,0,127}));
  connect(zonSta.y, enaDis.uZonSta)
    annotation (Line(points={{-138,10},{-120,10},{-120,45},{78,45}}, color={255,127,0}));
  connect(freProSta.y, enaDis.uFreProSta)
    annotation (Line(points={{-138,50},{-130,50},{-130,47},{78,47}}, color={255,127,0}));
  connect(freProSta1.y, enaDis1.uFreProSta)
    annotation (Line(points={{62,-110},{70,-110},{70,-33},{78,-33}}, color={255,127,0}));
  connect(zonSta1.y, enaDis1.uZonSta)
    annotation (Line(points={{62,-70},{72,-70},{72,-35},{78,-35}}, color={255,127,0}));
  connect(outDamPosMax.y, enaDis.uOutDam_max) annotation (Line(points={{-38,-110},
          {-30,-110},{-30,43},{78,43}}, color={0,0,127}));
  connect(outDamPosMin.y, enaDis.uOutDam_min) annotation (Line(points={{-38,-150},
          {-28,-150},{-28,41},{78,41}}, color={0,0,127}));
  connect(outDamPosMin.y, enaDis1.uOutDam_min) annotation (Line(points={{-38,-150},
          {22,-150},{22,-39},{78,-39}}, color={0,0,127}));
  connect(outDamPosMax.y, enaDis1.uOutDam_max) annotation (Line(points={{-38,-110},
          {20,-110},{20,-37},{78,-37}}, color={0,0,127}));
  connect(supFanSta.y, enaDis.u1SupFan) annotation (Line(points={{-138,-30},{-34,
          -30},{-34,50},{78,50}}, color={255,0,255}));
  connect(supFanSta.y, enaDis1.u1SupFan)
    annotation (Line(points={{-138,-30},{78,-30}}, color={255,0,255}));
  connect(TOutCut.y, enaDis.TCut) annotation (Line(points={{-18,110},{20,110},{20,
          57},{78,57}}, color={0,0,127}));
  connect(hOutCut.y, enaDis.hCut) annotation (Line(points={{-78,20},{-60,20},{-60,
          53},{78,53}}, color={0,0,127}));
  connect(hOutCut.y, enaDis1.hCut) annotation (Line(points={{-78,20},{-60,20},{-60,
          -27},{78,-27}}, color={0,0,127}));
    annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/Economizers/Subsequences/Validation/Enable_FreProSta_ZonSta.mos"
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
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Tests zone state disable condition"),
        Text(
          extent={{80,-40},{178,-58}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Tests freeze protection disable condition")}),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable</a>
for the zone state and freeze protection stage control signals.
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
