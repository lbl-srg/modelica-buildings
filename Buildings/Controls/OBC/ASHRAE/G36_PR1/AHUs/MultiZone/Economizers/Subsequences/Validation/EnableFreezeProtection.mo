within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Validation;
model EnableFreezeProtection
  "Model validates economizer disabling due to too low mixed air temperature"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.Temperature TOutCutoff=297.15
    "Outdoor temperature high limit cutoff";
  parameter Modelica.SIunits.SpecificEnergy hOutCutoff=65100
    "Outdoor air enthalpy high limit cutoff";

  CDL.Continuous.Sources.Ramp TMixMea(
    height=4,
    duration=1,
    offset=273.15 + 2,
    startTime=0)     "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable enaDis(kPFre=2)
    "Multi zone VAV AHU enable disable sequence"
    annotation (Placement(transformation(extent={{82,40},{102,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 2)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=TOutCutoff)
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 1000)
    "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    k=Constants.FreezeProtectionStages.stage0)
    "Freeze protection status is stage0"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMax(
    k=0.9) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMin(
    k=0.1) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPhyPosMax(
    k=1) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPosMax(
    k=0.8) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPosMin(
    k=0) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFanSta(k=true)
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

equation
  connect(TOutBelowCutoff.y, enaDis.TOut)
    annotation (Line(points={{-19,150},{32,150},{32,60},{81,60}}, color={0,0,127}));
  connect(TOutCut.y, enaDis.TOutCut)
    annotation (Line(points={{-19,110},{31.5,110},{31.5,58},{81,58}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, enaDis.hOut)
    annotation (Line(points={{-79,110},{-60,110},{-60,56},{81,56}}, color={0,0,127}));
  connect(hOutCut.y, enaDis.hOutCut)
    annotation (Line(points={{-79,70},{-70,70},{-70,54},{81,54}},
    color={0,0,127}));
  connect(freProSta.y, enaDis.uFreProSta)
    annotation (Line(points={{-119,50},{-110,50},{-110,50},{81,50}}, color={255,127,0}));
  connect(retDamPosMax.y, enaDis.uRetDamPosMax)
    annotation (Line(points={{-79,-50},{-68,-50},{-68,42},{81,42}}, color={0,0,127}));
  connect(retDamPhyPosMax.y, enaDis.uRetDamPhyPosMax)
    annotation (Line(points={{-79,-10},{-70,-10},{-70,44},{81,44}}, color={0,0,127}));
  connect(retDamPosMin.y, enaDis.uRetDamPosMin)
    annotation (Line(points={{-79,-90},{-66,-90},{-66,40},{81,40},{81,40}},color={0,0,127}));
  connect(outDamPosMax.y, enaDis.uOutDamPosMax)
    annotation (Line(points={{-39,-110},{-30,-110},{-30,48},{81,48}}, color={0,0,127}));
  connect(outDamPosMin.y, enaDis.uOutDamPosMin)
    annotation (Line(points={{-39,-150},{-28,-150},{-28,46},{81,46}}, color={0,0,127}));
  connect(supFanSta.y, enaDis.uSupFan)
    annotation (Line(points={{-119,-30},{-34,-30},{-34,52},{81,52}}, color={255,0,255}));
  connect(enaDis.TMix, TMixMea.y) annotation (Line(points={{81.2857,47.8571},{
          28,47.8571},{28,90},{21,90}},
                    color={0,0,127}));
  annotation (
    experiment(StopTime=1, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/Economizers/Subsequences/Validation/EnableFreezeProtection.mos"
    "Simulate and plot"),
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-180},{180,180}})),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable</a>
to test whether the outdoor air damper closes and the return air damper opens
if the mixed air temperature is below the set point for freeze protection.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableFreezeProtection;
