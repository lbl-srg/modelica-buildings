within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Validation;
model Enable_TOut_hOut
  "Model validates economizer disable in case outdoor air conditions are above cutoff"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut(
    final k=TOutCutoff) "Outdoor air temperature cutoff"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut1(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Logical.TriggeredTrapezoid TOut(
    final rising=1000,
    final falling=800,
    final amplitude=4,
    final offset=TOutCutoff - 2) "Outoor air temperature"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Logical.TriggeredTrapezoid hOut(
    final amplitude=4000,
    final offset=hOutCutoff - 2200,
    final rising=1000,
    final falling=800) "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable
    enaDis "Single zone VAV AHU economizer enable disable sequence"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable
    enaDis1 "Single zone VAV AHU economizer enable disable sequence"
    annotation (Placement(transformation(extent={{88,-80},{108,-60}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable
    enaDis2(use_enthalpy=false)
    "Single zone VAV AHU economizer enable disable sequence"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));

  Enable enaDis4(use_enthalpy=false, use_fixed_plus_differential_drybulb=true)
    "Test fixed and differential dry bulb"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  CDL.Logical.TriggeredTrapezoid TRet(
    final rising=1000,
    final falling=800,
    final amplitude=4,
    final offset=TOutCutoff - 4) "Outoor air temperature"
    annotation (Placement(transformation(extent={{-50,106},{-30,126}})));
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
  final parameter Real outDamPosMin=0.1
    "Minimum outdoor air damper position";
  final parameter Real outDamPosMax=0.9
    "Minimum return air damper position";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutCut(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-240,0},{-220,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutCut1(
    final k=TOutCutoff) "Outdoor air temperature cutoff"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 1000)
    "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-240,40},{-220,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 2)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{54,40},{74,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zoneState(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.deadband) "Zone State is deadband"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMaxSig(
    final k=outDamPosMax)
    "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-240,-120},{-220,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPosMinSig(
    final k=outDamPosMin)
    "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-240,-160},{-220,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage0)
    "Freeze Protection Status - Disabled"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFanSta(
    final k=true) "Supply fan status signal"
      annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final delay=10,
    final period=2000) "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final delay=10,
    final period=2000) "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  CDL.Logical.Sources.Pulse booPul2(
    final delay=10,
    final period=2000) "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-90,106},{-70,126}})));
equation
  connect(TOutCut.y, enaDis.TCut) annotation (Line(points={{-138,50},{-112,50},
          {-112,-62.2},{-81,-62.2}},
                                color={0,0,127}));
  connect(hOutCut.y, enaDis.hCut) annotation (Line(points={{-218,10},{-150,10},
          {-150,-68},{-81,-68}},color={0,0,127}));
  connect(freProSta.y, enaDis.uFreProSta)
    annotation (Line(points={{-178,-10},{-120,-10},{-120,-70},{-81,-70}}, color={255,127,0}));
  connect(outDamPosMaxSig.y, enaDis.uOutDamPosMax)
    annotation (Line(points={{-218,-110},{-150,-110},{-150,-76},{-81,-76}}, color={0,0,127}));
  connect(outDamPosMinSig.y, enaDis.uOutDamPosMin)
    annotation (Line(points={{-218,-150},{-180,-150},{-180,-120},{-140,-120},{
          -140,-78},{-81,-78}},                                                                     color={0,0,127}));
  connect(enaDis.uZonSta, zoneState.y)
    annotation (Line(points={{-81,-72},{-140,-72},{-140,-40},{-178,-40}}, color={255,127,0}));
  connect(TOutCut1.y, enaDis1.TCut) annotation (Line(points={{22,50},{30,50},{
          30,-62.2},{87,-62.2}},
                          color={0,0,127}));
  connect(hOutCut1.y, enaDis1.hCut) annotation (Line(points={{-58,10},{10,10},{
          10,-68},{87,-68}},
                          color={0,0,127}));
  connect(hOutBelowCutoff.y, enaDis.hOut)
    annotation (Line(points={{-218,50},{-180,50},{-180,26},{-130,26},{-130,-66},
          {-81,-66}},                                                                       color={0,0,127}));
  connect(TOutBelowCutoff.y, enaDis1.TOut)
    annotation (Line(points={{76,50},{80,50},{80,-60.6},{87,-60.6}},      color={0,0,127}));
  connect(booPul.y, TOut.u)
    annotation (Line(points={{-178,90},{-162,90}}, color={255,0,255}));
  connect(TOut.y, enaDis.TOut)
    annotation (Line(points={{-138,90},{-110,90},{-110,-60.6},{-81,-60.6}},
                                                                        color={0,0,127}));
  connect(booPul1.y, hOut.u)
    annotation (Line(points={{-58,50},{-58,50},{-42,50}}, color={255,0,255}));
  connect(hOut.y, enaDis1.hOut)
    annotation (Line(points={{-18,50},{-10,50},{-10,20},{20,20},{20,-66},{87,
          -66}},                                                                    color={0,0,127}));
  connect(freProSta.y, enaDis1.uFreProSta)
    annotation (Line(points={{-178,-10},{-30,-10},{-30,-70},{87,-70}}, color={255,127,0}));
  connect(zoneState.y, enaDis1.uZonSta)
    annotation (Line(points={{-178,-40},{-160,-40},{-160,-26},{4,-26},{4,-72},{
          87,-72}},                                                                      color={255,127,0}));
  connect(outDamPosMaxSig.y, enaDis1.uOutDamPosMax)
    annotation (Line(points={{-218,-110},{60,-110},{60,-76},{87,-76}},
                                                                     color={0,0,127}));
  connect(outDamPosMinSig.y, enaDis1.uOutDamPosMin)
    annotation (Line(points={{-218,-150},{-180,-150},{-180,-120},{70,-120},{70,
          -78},{87,-78}},                                                                      color={0,0,127}));
  connect(TOut.y, enaDis2.TOut)
    annotation (Line(points={{-138,90},{-138,90},{200,90},{200,-60.6},{219,
          -60.6}},                                                             color={0,0,127}));
  connect(TOutCut.y, enaDis2.TCut) annotation (Line(points={{-138,50},{-112,50},
          {-112,80},{188,80},{188,-62.2},{219,-62.2}},
                                                   color={0,0,127}));
  connect(freProSta.y, enaDis2.uFreProSta)
    annotation (Line(points={{-178,-10},{170,-10},{170,-70},{219,-70}}, color={255,127,0}));
  connect(zoneState.y, enaDis2.uZonSta)
    annotation (Line(points={{-178,-40},{-170,-40},{-170,-20},{150,-20},{150,
          -72},{219,-72}},                                                                    color={255,127,0}));
  connect(outDamPosMaxSig.y, enaDis2.uOutDamPosMax)
    annotation (Line(points={{-218,-110},{180,-110},{180,-76},{219,-76}}, color={0,0,127}));
  connect(outDamPosMinSig.y, enaDis2.uOutDamPosMin)
    annotation (Line(points={{-218,-150},{-180,-150},{-180,-120},{190,-120},{
          190,-78},{219,-78}},                                                                    color={0,0,127}));
  connect(supFanSta.y, enaDis.uSupFan)
    annotation (Line(points={{-178,-70},{-150,-70},{-150,-74},{-81,-74}}, color={255,0,255}));
  connect(supFanSta.y, enaDis1.uSupFan)
    annotation (Line(points={{-178,-70},{-160,-70},{-160,-54},{-40,-54},{-40,
          -74},{87,-74}},                                                                    color={255,0,255}));
  connect(supFanSta.y, enaDis2.uSupFan)
    annotation (Line(points={{-178,-70},{-170,-70},{-170,-50},{140,-50},{140,
          -74},{219,-74}},                                                                    color={255,0,255}));
  connect(enaDis4.uFreProSta, enaDis2.uFreProSta) annotation (Line(points={{119,
          110},{-8,110},{-8,-10},{128,-10},{128,-70},{219,-70}}, color={255,127,
          0}));
  connect(enaDis4.uZonSta, enaDis2.uZonSta) annotation (Line(points={{119,108},{
          -6,108},{-6,-20},{150,-20},{150,-72},{219,-72}}, color={255,127,0}));
  connect(enaDis4.uSupFan, enaDis2.uSupFan) annotation (Line(points={{119,106},{
          -4,106},{-4,-50},{140,-50},{140,-74},{219,-74}}, color={255,0,255}));
  connect(enaDis4.uOutDamPosMax, enaDis2.uOutDamPosMax) annotation (Line(points=
         {{119,104},{32,104},{32,-110},{180,-110},{180,-76},{219,-76}}, color={0,
          0,127}));
  connect(enaDis4.uOutDamPosMin, enaDis2.uOutDamPosMin) annotation (Line(points=
         {{119,102},{36,102},{36,-120},{190,-120},{190,-78},{219,-78}}, color={0,
          0,127}));
  connect(TOutCut1.y, enaDis4.TCut) annotation (Line(points={{22,50},{26,50},{
          26,117.8},{119,117.8}},
                           color={0,0,127}));
  connect(TOutBelowCutoff.y, enaDis4.TOut) annotation (Line(points={{76,50},{96,
          50},{96,119.4},{119,119.4}},
                                   color={0,0,127}));
  connect(booPul2.y, TRet.u)
    annotation (Line(points={{-68,116},{-52,116}}, color={255,0,255}));
  connect(TRet.y, enaDis4.TRet)
    annotation (Line(points={{-28,116},{119,116}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/Economizers/Subsequences/Validation/Enable_TOut_hOut.mos"
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
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-180},{260,180}}),
        graphics={Text(
          extent={{-234,168},{346,116}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Example high limit cutoff conditions:
                      ASHRAE 90.1-2013:
                      Device Type: Fixed Drybulb, Fixed Drybulb + Fixed Differential Drybulb, Fixed Enthalpy + Fixed Drybulb,
                      TOut > 75 degF [24 degC]
                      hOut > 28 Btu/lb [65.1 kJ/kg]"),
        Text(
          extent={{-82,-82},{0,-96}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Tests temperature hysteresis"),
        Text(
          extent={{80,-80},{156,-96}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Tests enthalpy hysteresis"),
        Text(
          extent={{208,-82},{260,-100}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="No enthalpy
sensor"),
        Text(
          extent={{116,146},{226,114}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Tests fixed + differential drybulb")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable</a>
for the following control signals: <code>TOut</code>, <code>TOutCut</code>,
<code>hOut</code>, <code>hOutCut</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 30, 2019, by Kun Zhang:<br/>
Added validation for fixed plus differential dry bulb temperature cutoff.
</li>
<li>
June 13, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Enable_TOut_hOut;
