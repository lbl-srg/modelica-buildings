within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Validation;
model Enable_TOut_hOut
  "Model validates economizer disable in case outdoor air conditions are above cutoff"


  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable
    enaDis "Single zone VAV AHU economizer enable disable sequence"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable
    enaDis1 "Single zone VAV AHU economizer enable disable sequence"
    annotation (Placement(transformation(extent={{88,-80},{108,-60}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable
    enaDis2(use_enthalpy=false)
    "Single zone VAV AHU economizer enable disable sequence"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOutCut(
    final k=TOutCutoff) "Outdoor air temperature cutoff"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hOutCut1(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TOut(
    final amplitude=4,
    final freqHz=1/3600,
    final offset=TOutCutoff - 2,
    final startTime=10) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin hOut(
    final amplitude=4000,
    final freqHz=1/3600,
    final offset=hOutCutoff - 2200,
    final startTime=10) "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-40,38},{-20,58}})));

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
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hOutCut(
    final k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-240,0},{-220,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOutCut1(
    final k=TOutCutoff) "Outdoor air temperature cutoff"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hOutBelowCutoff(
    final k=hOutCutoff - 1000)
    "Outdoor air enthalpy is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-240,40},{-220,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOutBelowCutoff(
    final k=TOutCutoff - 2)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{54,40},{74,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zoneState(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.deadband)
    "Zone State is deadband"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant outDamPosMaxSig(
    final k=outDamPosMax)
    "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-240,-120},{-220,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant outDamPosMinSig(
    final k=outDamPosMin)
    "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-240,-160},{-220,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant freProSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage0)
    "Freeze Protection Status - Disabled"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFanSta(
    final k=true) "Supply fan status signal"
      annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));

equation
  connect(TOutCut.y, enaDis.TCut) annotation (Line(points={{-138,50},{-112,50},{
          -112,-63},{-82,-63}}, color={0,0,127}));
  connect(hOutCut.y, enaDis.hCut) annotation (Line(points={{-218,10},{-150,10},
          {-150,-67},{-82,-67}},color={0,0,127}));
  connect(freProSta.y, enaDis.uFreProSta)
    annotation (Line(points={{-178,-10},{-120,-10},{-120,-73},{-82,-73}}, color={255,127,0}));
  connect(outDamPosMaxSig.y, enaDis.uOutDam_max) annotation (Line(points={{-218,
          -110},{-150,-110},{-150,-77},{-82,-77}}, color={0,0,127}));
  connect(outDamPosMinSig.y, enaDis.uOutDam_min) annotation (Line(points={{-218,
          -150},{-180,-150},{-180,-120},{-140,-120},{-140,-79},{-82,-79}},
        color={0,0,127}));
  connect(enaDis.uZonSta, zoneState.y)
    annotation (Line(points={{-82,-75},{-140,-75},{-140,-40},{-178,-40}}, color={255,127,0}));
  connect(TOutCut1.y, enaDis1.TCut) annotation (Line(points={{22,50},{30,50},{30,
          -63},{86,-63}}, color={0,0,127}));
  connect(hOutCut1.y, enaDis1.hCut) annotation (Line(points={{-58,10},{10,10},{
          10,-67},{86,-67}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, enaDis.hOut)
    annotation (Line(points={{-218,50},{-180,50},{-180,26},{-130,26},{-130,-65},
          {-82,-65}}, color={0,0,127}));
  connect(TOutBelowCutoff.y, enaDis1.TOut)
    annotation (Line(points={{76,50},{80,50},{80,-61},{86,-61}},  color={0,0,127}));
  connect(freProSta.y, enaDis1.uFreProSta)
    annotation (Line(points={{-178,-10},{-30,-10},{-30,-73},{86,-73}}, color={255,127,0}));
  connect(zoneState.y, enaDis1.uZonSta)
    annotation (Line(points={{-178,-40},{-160,-40},{-160,-26},{4,-26},{4,-75},{
          86,-75}}, color={255,127,0}));
  connect(outDamPosMaxSig.y, enaDis1.uOutDam_max) annotation (Line(points={{-218,
          -110},{60,-110},{60,-77},{86,-77}}, color={0,0,127}));
  connect(outDamPosMinSig.y, enaDis1.uOutDam_min) annotation (Line(points={{-218,
          -150},{-180,-150},{-180,-120},{70,-120},{70,-79},{86,-79}}, color={0,
          0,127}));
  connect(TOutCut.y, enaDis2.TCut) annotation (Line(points={{-138,50},{-112,50},
          {-112,80},{188,80},{188,-63},{218,-63}}, color={0,0,127}));
  connect(freProSta.y, enaDis2.uFreProSta)
    annotation (Line(points={{-178,-10},{170,-10},{170,-73},{218,-73}}, color={255,127,0}));
  connect(zoneState.y, enaDis2.uZonSta)
    annotation (Line(points={{-178,-40},{-170,-40},{-170,-20},{150,-20},{150,
          -75},{218,-75}}, color={255,127,0}));
  connect(outDamPosMaxSig.y, enaDis2.uOutDam_max) annotation (Line(points={{-218,
          -110},{180,-110},{180,-77},{218,-77}}, color={0,0,127}));
  connect(outDamPosMinSig.y, enaDis2.uOutDam_min) annotation (Line(points={{-218,
          -150},{-180,-150},{-180,-120},{190,-120},{190,-79},{218,-79}}, color=
          {0,0,127}));
  connect(supFanSta.y, enaDis.u1SupFan) annotation (Line(points={{-178,-70},{-150,
          -70},{-150,-70},{-82,-70}}, color={255,0,255}));
  connect(supFanSta.y, enaDis1.u1SupFan) annotation (Line(points={{-178,-70},{-160,
          -70},{-160,-54},{-40,-54},{-40,-70},{86,-70}}, color={255,0,255}));
  connect(supFanSta.y, enaDis2.u1SupFan) annotation (Line(points={{-178,-70},{-170,
          -70},{-170,-50},{140,-50},{140,-70},{218,-70}}, color={255,0,255}));
  connect(TOut.y, enaDis.TOut) annotation (Line(points={{-138,90},{-106,90},{-106,
          -61},{-82,-61}}, color={0,0,127}));
  connect(TOut.y, enaDis2.TOut) annotation (Line(points={{-138,90},{194,90},{194,
          -61},{218,-61}}, color={0,0,127}));
  connect(hOut.y, enaDis1.hOut) annotation (Line(points={{-18,48},{-10,48},{-10,
          20},{20,20},{20,-65},{86,-65}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/Economizers/Subsequences/Validation/Enable_TOut_hOut.mos"
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
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Example high limit cutoff conditions:
                      ASHRAE 90.1-2013:
                      Device Type: Fixed Drybulb, Fixed Enthalpy + Fixed Drybulb,
                      TOut > 75 degF [24 degC]
                      hOut > 28 Btu/lb [65.1 kJ/kg]"),
        Text(
          extent={{-82,-82},{0,-96}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Tests temperature hysteresis"),
        Text(
          extent={{80,-80},{156,-96}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Tests enthalpy hysteresis"),
        Text(
          extent={{208,-82},{260,-100}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="No enthalpy
sensor")}),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable</a>
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
