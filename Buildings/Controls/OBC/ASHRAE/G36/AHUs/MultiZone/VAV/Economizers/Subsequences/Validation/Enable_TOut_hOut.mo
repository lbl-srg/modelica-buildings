within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Validation;
model Enable_TOut_hOut
  "Model validates economizer disable in case outdoor air conditions are above cutoff"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=TOutCutoff) "Outdoor air temperature cutoff"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut1(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Logical.TriggeredTrapezoid TOut(
    final rising=1000,
    final falling=800,
    final amplitude=4,
    final offset=TOutCutoff - 2) "Outoor air temperature"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Logical.TriggeredTrapezoid hOut(
    final amplitude=4000,
    final offset=hOutCutoff - 2200,
    final rising=1000,
    final falling=800) "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable enaDis
    "Multi zone VAV AHU economizer enable disable sequence"
    annotation (Placement(transformation(extent={{-80,-44},{-60,-16}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable enaDis1
    "Multi zone VAV AHU economizer enable disable sequence"
    annotation (Placement(transformation(extent={{80,-44},{100,-16}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable enaDis2(
    final use_enthalpy=false)
    "Multi zone VAV AHU economizer enable disable sequence"
    annotation (Placement(transformation(extent={{220,-44},{240,-16}})));

protected
  final parameter Real TOutCutoff(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=297.15
    "Outdoor temperature high limit cutoff";
  final parameter Real hOutCutoff(
    final unit="J/kg",
    final quantity="SpecificEnergy")=65100
    "Outdoor air enthalpy high limit cutoff";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-240,80},{-220,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut1(
    final k=TOutCutoff) "Outdoor air temperature cutoff"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 1000)
    "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-240,118},{-220,138}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 2)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMax(
    final k=0.9) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-240,-80},{-220,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMin(
    final k=0.1) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-240,-120},{-220,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPosMax(
    final k=0.8) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPosMin(
    final k=0) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-160,-200},{-140,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPhyPosMax(
    final k=1) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage0)
    "Freeze Protection Status - Disabled"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFanSta(
    final k=true) "Supply fan status signal"
      annotation (Placement(transformation(extent={{-200,-42},{-180,-22}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(final shift=10,
    final period=2000) "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-200,150},{-180,170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(final shift=10,
    final period=2000) "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

equation
  connect(TOutCut.y, enaDis.TOutCut)
    annotation (Line(points={{-138,90},{-112,90},{-112,-19},{-82,-19}}, color={0,0,127}));
  connect(hOutCut.y, enaDis.hOutCut)
    annotation (Line(points={{-218,90},{-186,90},{-186,58},{-138,58},{-138,-24},
          {-82,-24}},      color={0,0,127}));
  connect(freProSta.y, enaDis.uFreProSta)
    annotation (Line(points={{-178,30},{-120,30},{-120,-29},{-82,-29}},  color={255,127,0}));
  connect(outDamPosMax.y, enaDis.uOutDam_max) annotation (Line(points={{-218,-70},
          {-150,-70},{-150,-32},{-82,-32}}, color={0,0,127}));
  connect(outDamPosMin.y, enaDis.uOutDam_min) annotation (Line(points={{-218,-110},
          {-210,-110},{-210,-60},{-140,-60},{-140,-34},{-82,-34}}, color={0,0,
          127}));
  connect(retDamPhyPosMax.y, enaDis.uRetDamPhy_max) annotation (Line(points={{-138,
          -110},{-110,-110},{-110,-39},{-82,-39}}, color={0,0,127}));
  connect(retDamPosMax.y, enaDis.uRetDam_max) annotation (Line(points={{-138,-150},
          {-106,-150},{-106,-41},{-82,-41}}, color={0,0,127}));
  connect(retDamPosMin.y, enaDis.uRetDam_min) annotation (Line(points={{-138,-190},
          {-100,-190},{-100,-43},{-82,-43}}, color={0,0,127}));
  connect(TOutCut1.y, enaDis1.TOutCut)
    annotation (Line(points={{22,90},{30,90},{30,-19},{78,-19}}, color={0,0,127}));
  connect(hOutCut1.y, enaDis1.hOutCut)
    annotation (Line(points={{-18,50},{10,50},{10,-24},{78,-24}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, enaDis.hOut)
    annotation (Line(points={{-218,128},{-180,128},{-180,66},{-130,66},{-130,-22},
          {-82,-22}},      color={0,0,127}));
  connect(TOutBelowCutoff.y, enaDis1.TOut)
    annotation (Line(points={{62,90},{70,90},{70,-20},{78,-20},{78,-17}}, color={0,0,127}));
  connect(booPul.y, TOut.u)
    annotation (Line(points={{-178,160},{-162,160}}, color={255,0,255}));
  connect(TOut.y, enaDis.TOut)
    annotation (Line(points={{-138,160},{-110,160},{-110,-17},{-82,-17}}, color={0,0,127}));
  connect(booPul1.y, hOut.u)
    annotation (Line(points={{-58,90},{-58,90},{-42,90}}, color={255,0,255}));
  connect(hOut.y, enaDis1.hOut)
    annotation (Line(points={{-18,90},{-10,90},{-10,60},{20,60},{20,-22},{78,-22}}, color={0,0,127}));
  connect(freProSta.y, enaDis1.uFreProSta)
    annotation (Line(points={{-178,30},{-46,30},{-46,-29},{78,-29}}, color={255,127,0}));
  connect(outDamPosMax.y, enaDis1.uOutDam_max) annotation (Line(points={{-218,-70},
          {8,-70},{8,-32},{78,-32}}, color={0,0,127}));
  connect(outDamPosMin.y, enaDis1.uOutDam_min) annotation (Line(points={{-218,-110},
          {-190,-110},{-190,-64},{12,-64},{12,-34},{78,-34}}, color={0,0,127}));
  connect(retDamPhyPosMax.y, enaDis1.uRetDamPhy_max) annotation (Line(points={{
          -138,-110},{16,-110},{16,-39},{78,-39}}, color={0,0,127}));
  connect(retDamPosMax.y, enaDis1.uRetDam_max) annotation (Line(points={{-138,-150},
          {20,-150},{20,-41},{78,-41}}, color={0,0,127}));
  connect(retDamPosMin.y, enaDis1.uRetDam_min) annotation (Line(points={{-138,-190},
          {30,-190},{30,-43},{78,-43}}, color={0,0,127}));
  connect(TOut.y, enaDis2.TOut)
    annotation (Line(points={{-138,160},{200,160},{200,-17},{218,-17}}, color={0,0,127}));
  connect(TOutCut.y, enaDis2.TOutCut)
    annotation (Line(points={{-138,90},{-120,90},{-120,120},{188,120},{188,-19},
          {218,-19}},  color={0,0,127}));
  connect(freProSta.y, enaDis2.uFreProSta)
    annotation (Line(points={{-178,30},{170,30},{170,-29},{218,-29}}, color={255,127,0}));
  connect(outDamPosMax.y, enaDis2.uOutDam_max) annotation (Line(points={{-218,-70},
          {178,-70},{178,-32},{218,-32}}, color={0,0,127}));
  connect(outDamPosMin.y, enaDis2.uOutDam_min) annotation (Line(points={{-218,-110},
          {-180,-110},{-180,-70},{188,-70},{188,-34},{218,-34}}, color={0,0,127}));
  connect(retDamPhyPosMax.y, enaDis2.uRetDamPhy_max) annotation (Line(points={{
          -138,-110},{192,-110},{192,-39},{218,-39}}, color={0,0,127}));
  connect(retDamPosMax.y, enaDis2.uRetDam_max) annotation (Line(points={{-138,-150},
          {196,-150},{196,-41},{218,-41}}, color={0,0,127}));
  connect(retDamPosMin.y, enaDis2.uRetDam_min) annotation (Line(points={{-138,-190},
          {198,-190},{198,-43},{218,-43}}, color={0,0,127}));
  connect(supFanSta.y, enaDis.u1SupFan) annotation (Line(points={{-178,-32},{-160,
          -32},{-160,-28},{-80,-28},{-80,-27},{-82,-27}}, color={255,0,255}));
  connect(supFanSta.y, enaDis1.u1SupFan) annotation (Line(points={{-178,-32},{-160,
          -32},{-160,-12},{-20,-12},{-20,-27},{78,-27}}, color={255,0,255}));
  connect(supFanSta.y, enaDis2.u1SupFan) annotation (Line(points={{-178,-32},{-160,
          -32},{-160,-12},{140,-12},{140,-27},{218,-27}}, color={255,0,255}));

annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/Economizers/Subsequences/Validation/Enable_TOut_hOut.mos"
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
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-220},{260,220}}),
        graphics={Text(
          extent={{-50,214},{530,162}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Example high limit cutoff conditions:
                      ASHRAE 90.1-2013:
                      Device Type: Fixed Enthalpy + Fixed Drybulb, Fixed Drybulb
                      TOut > 75 degF [24 degC]
                      hOut > 28 Btu/lb [65.1 kJ/kg]"),
        Text(
          extent={{-92,-42},{4,-68}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Tests temperature hysteresis"),
        Text(
          extent={{80,-40},{166,-66}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Tests enthalpy hysteresis"),
        Text(
          extent={{204,-46},{272,-68}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="No enthalpy
sensor")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Enable</a>
for the following control signals: <code>TOut</code>, <code>TOutCut</code>,
<code>hOut</code>, <code>hOutCut</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 13, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Enable_TOut_hOut;
