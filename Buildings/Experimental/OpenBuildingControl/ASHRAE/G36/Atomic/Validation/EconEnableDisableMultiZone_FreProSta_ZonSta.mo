within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model EconEnableDisableMultiZone_FreProSta_ZonSta
  "Model validates economizer disable for heating zone state and activated freeze protection"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.Temperature TOutCutoff=297
    "Outdoor temperature high limit cutoff";
  parameter Real hOutCutoff(final unit="J/kg", quantity="SpecificEnergy")=65100
    "Outdoor air enthalpy high limit cutoff";
  parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
    "Indicates that the freeze protection is disabled";
  parameter Integer freProDisabledNum = Integer(freProDisabled)-1
    "Numerical value for freeze protection stage 0 (=0)";
  parameter Types.ZoneState heating = Types.ZoneState.heating
    "Zone state is heating";
  parameter Integer heatingNum = Integer(heating)
    "Numerical value for heating zone state (=1)";
  parameter Types.FreezeProtectionStage freProEnabled = Types.FreezeProtectionStage.stage2
    "Indicates that the freeze protection is eanbled";
  parameter Integer freProEnabledNum = Integer(freProEnabled)-1
    "Numerical value for freeze protection stage 0 (=0)";
  parameter Types.ZoneState cooling = Types.ZoneState.cooling
    "Zone state is cooling";
  parameter Integer coolingNum = Integer(cooling)
    "Numerical value for cooling zone state (=2)";

  EconEnableDisableMultiZone econEnableDisableMultiZone "Multizone VAV AHU enable disable sequence"
    annotation (Placement(transformation(extent={{82,40},{102,60}})));
  EconEnableDisableMultiZone econEnableDisableMultiZone1 "Multizone VAV AHU enable disable sequence"
    annotation (Placement(transformation(extent={{82,-40},{102,-20}})));

protected
  CDL.Continuous.Constant TOutBelowCutoff(k=TOutCutoff - 2)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  CDL.Continuous.Constant TOutCut(k=TOutCutoff)
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  CDL.Continuous.Constant hOutBelowCutoff(k=hOutCutoff - 1000)
    "Outdoor air enthalpy is slightly below the cufoff"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  CDL.Integers.Constant freProSta(k=freProDisabledNum) "Freeze Protection Status (Deactivated = 0)"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  CDL.Integers.Constant zoneState(k=heatingNum) "Zone State is heating (heating = 1)"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  CDL.Integers.Constant freProSta1(k=freProEnabledNum) "Freeze Protection Status (Activated > 0)"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  CDL.Integers.Constant zoneState1(k=coolingNum) "Zone State is not heating (heating = 1)"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  CDL.Continuous.Constant outDamPosMax(k=0.9) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  CDL.Continuous.Constant outDamPosMin(k=0.1) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  CDL.Continuous.Constant retDamPhyPosMax(k=1) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  CDL.Continuous.Constant retDamPosMax(k=0.8) "Maximal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  CDL.Continuous.Constant retDamPosMin(k=0) "Minimal allowed economizer damper position"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  CDL.Logical.Constant SupFanSta(k=true)
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));

equation
  connect(TOutBelowCutoff.y, econEnableDisableMultiZone.TOut) annotation (Line(
        points={{-19,150},{32,150},{32,60},{81,60}}, color={0,0,127}));
  connect(TOutCut.y, econEnableDisableMultiZone.TOutCut) annotation (Line(
        points={{-19,110},{31.5,110},{31.5,58},{81,58}}, color={0,0,127}));
  connect(TOutCut.y, econEnableDisableMultiZone1.TOutCut) annotation (Line(
        points={{-19,110},{32,110},{32,-22},{81,-22}}, color={0,0,127}));
  connect(TOutBelowCutoff.y, econEnableDisableMultiZone1.TOut) annotation (
      Line(points={{-19,150},{32,150},{32,-20},{81,-20}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, econEnableDisableMultiZone.hOut) annotation (Line(
        points={{-79,110},{-60,110},{-60,56},{81,56}}, color={0,0,127}));
  connect(hOutCut.y, econEnableDisableMultiZone.hOutCut) annotation (Line(
        points={{-79,70},{-70,70},{-70,54},{81,54}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, econEnableDisableMultiZone1.hOut) annotation (Line(
        points={{-79,110},{-60,110},{-60,56},{10,56},{10,-24},{81,-24}}, color={0,0,127}));
  connect(hOutCut.y, econEnableDisableMultiZone1.hOutCut) annotation (Line(
        points={{-79,70},{-70,70},{-70,54},{6,54},{6,-26},{81,-26}}, color={0,0,127}));
  connect(zoneState.y, econEnableDisableMultiZone.uZoneState) annotation (Line(
        points={{-139,10},{-120,10},{-120,50},{81,50}}, color={255,127,0}));
  connect(freProSta.y, econEnableDisableMultiZone.uFreProSta)
    annotation (Line(points={{-139,50},{-130,50},{-130,52},{81,52}}, color={255,127,0}));
  connect(freProSta1.y, econEnableDisableMultiZone1.uFreProSta)
    annotation (Line(points={{61,-110},{70,-110},{70,-28},{81,-28}}, color={255,127,0}));
  connect(zoneState1.y, econEnableDisableMultiZone1.uZoneState) annotation (
      Line(points={{61,-70},{72,-70},{72,-30},{81,-30}}, color={255,127,0}));
  connect(retDamPosMax.y, econEnableDisableMultiZone.uRetDamPosMax) annotation (
     Line(points={{-79,-50},{-68,-50},{-68,40},{81,40}}, color={0,0,127}));
  connect(retDamPhyPosMax.y, econEnableDisableMultiZone.uRetDamPhyPosMax)
    annotation (Line(points={{-79,-10},{-70,-10},{-70,42},{81,42}}, color={0,0,127}));
  connect(retDamPosMin.y, econEnableDisableMultiZone.uRetDamPosMin) annotation (
     Line(points={{-79,-90},{-66,-90},{-66,38},{8,38},{81,38}},        color={0,0,127}));
  connect(outDamPosMax.y, econEnableDisableMultiZone.uOutDamPosMax) annotation (
     Line(points={{-39,-110},{-30,-110},{-30,46},{81,46}}, color={0,0,127}));
  connect(outDamPosMin.y, econEnableDisableMultiZone.uOutDamPosMin) annotation (
     Line(points={{-39,-150},{-28,-150},{-28,44},{81,44}}, color={0,0,127}));
  connect(outDamPosMin.y, econEnableDisableMultiZone1.uOutDamPosMin)
    annotation (Line(points={{-39,-150},{22,-150},{22,-36},{81,-36}}, color={0,0,127}));
  connect(outDamPosMax.y, econEnableDisableMultiZone1.uOutDamPosMax)
    annotation (Line(points={{-39,-110},{20,-110},{20,-34},{81,-34}}, color={0,0,127}));
  connect(retDamPosMin.y, econEnableDisableMultiZone1.uRetDamPosMin)
    annotation (Line(points={{-79,-90},{30,-90},{30,-42},{81,-42}}, color={0,0,127}));
  connect(retDamPosMax.y, econEnableDisableMultiZone1.uRetDamPosMax)
    annotation (Line(points={{-79,-50},{0,-50},{0,-40},{81,-40}}, color={0,0,127}));
  connect(retDamPhyPosMax.y, econEnableDisableMultiZone1.uRetDamPhyPosMax)
    annotation (Line(points={{-79,-10},{0,-10},{0,-38},{81,-38}}, color={0,0,127}));
  connect(SupFanSta.y, econEnableDisableMultiZone.uSupFan) annotation (Line(
        points={{-139,-30},{-34,-30},{-34,48},{81,48}}, color={255,0,255}));
  connect(SupFanSta.y, econEnableDisableMultiZone1.uSupFan) annotation (Line(
        points={{-139,-30},{-34,-30},{-34,-32},{81,-32}}, color={255,0,255}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/EconEnableDisableMultiZone_FreProSta_ZonSta.mos"
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
  <a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconEnableDisableMultiZone\">
  Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.EconEnableDisableMultiZone</a>
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
end EconEnableDisableMultiZone_FreProSta_ZonSta;
