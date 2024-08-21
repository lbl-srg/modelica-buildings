within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Validation;
model Enable_FreProSta
  "Model validates economizer disable for heating zone state and activated freeze protection"
  parameter Real TOutCutoff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=297.15
    "Outdoor temperature high limit cutoff";
  parameter Real hOutCutoff(
    final unit="J/kg",
    final quantity="SpecificEnergy")=65100
    "Outdoor air enthalpy high limit cutoff";

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable enaDis
    "Multi zone VAV AHU enable disable sequence"
    annotation (Placement(transformation(extent={{60,-40},{80,-12}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 2)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOutCut(
    final k=TOutCutoff) "OA temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 1000)
    "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hOutCut(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant outDamPosMax(
    final k=0.9) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-110,-120},{-90,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant outDamPosMin(
    final k=0.1) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant retDamPhyPosMax(
    final k=1) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant retDamPosMax(
    final k=0.8) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-110,-60},{-90,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant retDamPosMin(
    final k=0) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFanSta(k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(period=1800)
    "Boolean pulse for generating freeze protection stage"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger freProSta1(
    integerTrue=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage0,
    integerFalse=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage1)
    "Freeze protection stage changes from stage 0 to stage 1"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));

equation
  connect(TOutCut.y, enaDis.TOutCut)
    annotation (Line(points={{-58,110},{-20,110},{-20,-15},{58,-15}},color={0,0,127}));
  connect(TOutBelowCutoff.y, enaDis.TOut)
    annotation (Line(points={{-58,150},{-10,150},{-10,-13},{58,-13}},color={0,0,127}));
  connect(hOutBelowCutoff.y, enaDis.hOut)
    annotation (Line(points={{-118,90},{-100,90},{-100,60},{-30,60},{-30,-18},{58,
          -18}}, color={0,0,127}));
  connect(hOutCut.y, enaDis.hOutCut)
    annotation (Line(points={{-118,50},{-40,50},{-40,-20},{58,-20}},color={0,0,127}));
  connect(outDamPosMin.y, enaDis.uOutDam_min) annotation (Line(points={{-118,-140},
          {-30,-140},{-30,-30},{58,-30}}, color={0,0,127}));
  connect(outDamPosMax.y, enaDis.uOutDam_max) annotation (Line(points={{-88,-110},
          {-40,-110},{-40,-28},{58,-28}}, color={0,0,127}));
  connect(retDamPosMin.y, enaDis.uRetDam_min) annotation (Line(points={{-88,-80},
          {48,-80},{48,-39},{58,-39}}, color={0,0,127}));
  connect(retDamPosMax.y, enaDis.uRetDam_max) annotation (Line(points={{-88,-50},
          {-60,-50},{-60,-37},{58,-37}}, color={0,0,127}));
  connect(retDamPhyPosMax.y, enaDis.uRetDamPhy_max) annotation (Line(points={{-118,
          10},{-60,10},{-60,-35},{58,-35}}, color={0,0,127}));
  connect(supFanSta.y, enaDis.u1SupFan) annotation (Line(points={{-118,-30},{-70,
          -30},{-70,-23},{58,-23}}, color={255,0,255}));
  connect(booPul1.y, freProSta1.u)
    annotation (Line(points={{2,-150},{4,-150},{4,-150},{8,-150},{8,-150},{18,-150}},
    color={255,0,255}));
  connect(freProSta1.y, enaDis.uFreProSta)
    annotation (Line(points={{42,-150},{50,-150},{50,-120},{-20,-120},{-20,-25},
          {58,-25}},
    color={255,127,0}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/Economizers/Subsequences/Validation/Enable_FreProSta.mos"
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
          extent={{58,-38},{176,-64}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Tests freeze protection disable condition")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable</a>
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
end Enable_FreProSta;
