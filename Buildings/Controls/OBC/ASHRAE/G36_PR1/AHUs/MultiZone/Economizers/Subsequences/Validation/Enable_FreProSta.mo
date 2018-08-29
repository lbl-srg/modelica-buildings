within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Validation;
model Enable_FreProSta
  "Model validates economizer disable for heating zone state and activated freeze protection"
  parameter Modelica.SIunits.Temperature TOutCutoff=297.15
    "Outdoor temperature high limit cutoff";
  parameter Modelica.SIunits.SpecificEnergy hOutCutoff=65100
    "Outdoor air enthalpy high limit cutoff";

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable enaDis
    "Multi zone VAV AHU enable disable sequence"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 2)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=TOutCutoff)
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 1000)
    "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMax(
    final k=0.9) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-110,-120},{-90,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMin(
    final k=0.1) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPhyPosMax(
    final k=1) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPosMax(
    final k=0.8) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-110,-60},{-90,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPosMin(
    final k=0) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFanSta(k=true)
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(period=1800)
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger freProSta1(
    integerTrue=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage0,
    integerFalse=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage1)
    "Freese protection stage changes from stage 0 to stage 1"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));

equation
  connect(TOutCut.y, enaDis.TOutCut)
    annotation (Line(points={{-59,110},{-20,110},{-20,-22},{59,-22}},color={0,0,127}));
  connect(TOutBelowCutoff.y, enaDis.TOut)
    annotation (Line(points={{-59,150},{-10,150},{-10,-20},{59,-20}},color={0,0,127}));
  connect(hOutBelowCutoff.y, enaDis.hOut)
    annotation (Line(points={{-119,90},{-100,90},{-100,60},{-30,60},{-30,-24},{59,-24}},
    color={0,0,127}));
  connect(hOutCut.y, enaDis.hOutCut)
    annotation (Line(points={{-119,50},{-40,50},{-40,-26},{59,-26}},color={0,0,127}));
  connect(outDamPosMin.y, enaDis.uOutDamPosMin)
    annotation (Line(points={{-119,-140},{-30,-140},{-30,-34},{59,-34}},
    color={0,0,127}));
  connect(outDamPosMax.y, enaDis.uOutDamPosMax)
    annotation (Line(points={{-89,-110},{-40,-110},{-40,-32},{59,-32}},color={0,0,127}));
  connect(retDamPosMin.y, enaDis.uRetDamPosMin)
    annotation (Line(points={{-89,-80},{48,-80},{48,-40},{59,-40}},color={0,0,127}));
  connect(retDamPosMax.y, enaDis.uRetDamPosMax)
    annotation (Line(points={{-89,-50},{-60,-50},{-60,-38},{59,-38}},
    color={0,0,127}));
  connect(retDamPhyPosMax.y, enaDis.uRetDamPhyPosMax)
    annotation (Line(points={{-119,10},{-60,10},{-60,-36},{59,-36}},color={0,0,127}));
  connect(supFanSta.y, enaDis.uSupFan)
    annotation (Line(points={{-119,-30},{-70,-30},{-70,-28},{59,-28}},color={255,0,255}));
  connect(booPul1.y, freProSta1.u)
    annotation (Line(points={{1,-150},{4,-150},{4,-150},{8,-150},{8,-150},{18,-150}},
    color={255,0,255}));
  connect(freProSta1.y, enaDis.uFreProSta)
    annotation (Line(points={{41,-150},{50,-150},{50,-120},{-20,-120},{-20,-30},{59,-30}},
    color={255,127,0}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/Economizers/Subsequences/Validation/Enable_FreProSta.mos"
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
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Tests freeze protection disable condition")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable</a>
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
