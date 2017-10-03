within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Validation;
model Enable_TOut_hOut
  "Model validates economizer disable in case outdoor air conditions are above cutoff"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=TOutCutoff) "Outdoor air temperature cutoff"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut1(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Logical.TriggeredTrapezoid TOut(
    final rising=1000,
    final falling=800,
    final amplitude=4,
    final offset=TOutCutoff - 2) "Outoor air temperature"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
  Buildings.Controls.OBC.CDL.Logical.TriggeredTrapezoid hOut(
    final amplitude=4000,
    final offset=hOutCutoff - 2200,
    final rising=1000,
    final falling=800) "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable enaDis
    "Multi zone VAV AHU economizer enable disable sequence"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable enaDis1
    "Multi zone VAV AHU economizer enable disable sequence"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable enaDis2(
    final use_enthalpy=false)
    "Multi zone VAV AHU economizer enable disable sequence"
    annotation (Placement(transformation(extent={{220,-40},{240,-20}})));

protected
  final parameter Modelica.SIunits.Temperature TOutCutoff=297.15
    "Outdoor temperature high limit cutoff";
  final parameter Modelica.SIunits.SpecificEnergy hOutCutoff=65100
    "Outdoor air enthalpy high limit cutoff";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-240,40},{-220,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut1(
    final k=TOutCutoff) "Outdoor air temperature cutoff"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 1000)
    "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-240,80},{-220,100}})));
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
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zonSta(
    final k=Constants.ZoneStates.deadband) "Zone State is deadband"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Constants.FreezeProtectionStages.stage0)
    "Freeze Protection Status - Disabled"
    annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFanSta(
    final k=true) "Supply fan status signal"
      annotation (Placement(transformation(extent={{-200,-42},{-180,-22}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final startTime=10,
    final period=2000) "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-200,120},{-180,140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final startTime=10,
    final period=2000) "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

equation
  connect(TOutCut.y, enaDis.TOutCut)
    annotation (Line(points={{-139,90},{-112,90},{-112,-22},{-81,-22}}, color={0,0,127}));
  connect(hOutCut.y, enaDis.hOutCut)
    annotation (Line(points={{-219,50},{-150,50},{-150,-26},{-81,-26}}, color={0,0,127}));
  connect(freProSta.y, enaDis.uFreProSta)
    annotation (Line(points={{-179,30},{-120,30},{-120,-28},{-81,-28}}, color={255,127,0}));
  connect(outDamPosMax.y, enaDis.uOutDamPosMax)
    annotation (Line(points={{-219,-70},{-150,-70},{-150,-34},{-81,-34}}, color={0,0,127}));
  connect(outDamPosMin.y, enaDis.uOutDamPosMin)
    annotation (Line(points={{-219,-110},{-210,-110},{-210,-60},{-140,-60},{-140,-36},{-81,-36}}, color={0,0,127}));
  connect(retDamPhyPosMax.y, enaDis.uRetDamPhyPosMax)
    annotation (Line(points={{-139,-110},{-110,-110},{-110,-38},{-81,-38}}, color={0,0,127}));
  connect(retDamPosMax.y, enaDis.uRetDamPosMax)
    annotation (Line(points={{-139,-150},{-106,-150},{-106,-40},{-81,-40}}, color={0,0,127}));
  connect(retDamPosMin.y, enaDis.uRetDamPosMin)
    annotation (Line(points={{-139,-190},{-100,-190},{-100,-42},{-81,-42}}, color={0,0,127}));
  connect(TOutCut1.y, enaDis1.TOutCut)
    annotation (Line(points={{21,90},{30,90},{30,-22},{79,-22}}, color={0,0,127}));
  connect(hOutCut1.y, enaDis1.hOutCut)
    annotation (Line(points={{-59,50},{10,50},{10,-26},{79,-26}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, enaDis.hOut)
    annotation (Line(points={{-219,90},{-180,90},{-180,66},{-130,66},{-130,-24},{-81,-24}}, color={0,0,127}));
  connect(TOutBelowCutoff.y, enaDis1.TOut)
    annotation (Line(points={{61,90},{70,90},{70,-20},{80,-20},{79,-20}}, color={0,0,127}));
  connect(booPul.y, TOut.u)
    annotation (Line(points={{-179,130},{-162,130}}, color={255,0,255}));
  connect(TOut.y, enaDis.TOut)
    annotation (Line(points={{-139,130},{-110,130},{-110,-20},{-81,-20}}, color={0,0,127}));
  connect(booPul1.y, hOut.u) annotation (Line(points={{-59,90},{-50,90},{-42,90}}, color={255,0,255}));
  connect(hOut.y, enaDis1.hOut)
    annotation (Line(points={{-19,90},{-10,90},{-10,60},{20,60},{20,-24},{79,-24}}, color={0,0,127}));
  connect(freProSta.y, enaDis1.uFreProSta)
    annotation (Line(points={{-179,30},{-46,30},{-46,-28},{79,-28}}, color={255,127,0}));
  connect(outDamPosMax.y, enaDis1.uOutDamPosMax)
    annotation (Line(points={{-219,-70},{8,-70},{8,-34},{79,-34}}, color={0,0,127}));
  connect(outDamPosMin.y, enaDis1.uOutDamPosMin)
    annotation (Line(points={{-219,-110},{-190,-110},{-190,-64},{12,-64},{12,-36},{79,-36}}, color={0,0,127}));
  connect(retDamPhyPosMax.y, enaDis1.uRetDamPhyPosMax)
    annotation (Line(points={{-139,-110},{16,-110},{16,-38},{79,-38}}, color={0,0,127}));
  connect(retDamPosMax.y, enaDis1.uRetDamPosMax)
    annotation (Line(points={{-139,-150},{20,-150},{20,-40},{79,-40}}, color={0,0,127}));
  connect(retDamPosMin.y, enaDis1.uRetDamPosMin)
    annotation (Line(points={{-139,-190},{30,-190},{30,-42},{79,-42}}, color={0,0,127}));
  connect(TOut.y, enaDis2.TOut)
    annotation (Line(points={{-139,130},{-82,130},{200,130},{200,-20},{219,-20}}, color={0,0,127}));
  connect(TOutCut.y, enaDis2.TOutCut)
    annotation (Line(points={{-139,90},{-120,90},{-120,120},{188,120},{188,-22},{219,-22}}, color={0,0,127}));
  connect(freProSta.y, enaDis2.uFreProSta)
    annotation (Line(points={{-179,30},{170,30},{170,-28},{219,-28}}, color={255,127,0}));
  connect(outDamPosMax.y, enaDis2.uOutDamPosMax)
    annotation (Line(points={{-219,-70},{178,-70},{178,-34},{219,-34}}, color={0,0,127}));
  connect(outDamPosMin.y, enaDis2.uOutDamPosMin) annotation (Line(points={{-219,-110},{-180,-110},{-180,-70},{188,-70},
          {188,-38},{188,-36},{219,-36}}, color={0,0,127}));
  connect(retDamPhyPosMax.y, enaDis2.uRetDamPhyPosMax)
    annotation (Line(points={{-139,-110},{192,-110},{192,-38},{219,-38}}, color={0,0,127}));
  connect(retDamPosMax.y, enaDis2.uRetDamPosMax)
    annotation (Line(points={{-139,-150},{196,-150},{196,-40},{219,-40}}, color={0,0,127}));
  connect(retDamPosMin.y, enaDis2.uRetDamPosMin)
    annotation (Line(points={{-139,-190},{198,-190},{198,-42},{219,-42}}, color={0,0,127}));
  connect(supFanSta.y, enaDis.uSupFan)
    annotation (Line(points={{-179,-32},{-134,-32},{-81,-32}}, color={255,0,255}));
  connect(supFanSta.y, enaDis1.uSupFan)
    annotation (Line(points={{-179,-32},{-160,-32},{-160,-12},{-20,-12},{-20,-32},{79,-32}}, color={255,0,255}));
  connect(supFanSta.y, enaDis2.uSupFan)
    annotation (Line(points={{-179,-32},{-170,-32},{-170,-12},{140,-12},{140,-32},{219,-32}}, color={255,0,255}));
  connect(zonSta.y, enaDis.uZonSta)
    annotation (Line(points={{-179,0},{-132,0},{-132,-30},{-81,-30}}, color={255,127,0}));
  connect(zonSta.y, enaDis1.uZonSta)
    annotation (Line(points={{-179,0},{-48,0},{-48,-30},{79,-30}}, color={255,127,0}));
  connect(zonSta.y, enaDis2.uZonSta)
    annotation (Line(points={{-179,0},{160,0},{160,-30},{220,-30},{219,-30}}, color={255,127,0}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/Economizers/Subsequences/Validation/Enable_TOut_hOut.mos"
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
          extent={{-234,206},{346,154}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Example high limit cutoff conditions:
                      ASHRAE 90.1-2013:
                      Device Type: Fixed Enthalpy + Fixed Drybulb, Fixed Drybulb
                      TOut > 75 degF [24 degC]
                      hOut > 28 Btu/lb [65.1 kJ/kg]"),
        Text(
          extent={{-82,-40},{42,-68}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Tests temperature hysteresis"),
        Text(
          extent={{80,-40},{208,-68}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Tests enthalpy hysteresis"),
        Text(
          extent={{220,-46},{348,-74}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="No enthalpy
sensor")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers.Subsequences.Enable</a>
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
