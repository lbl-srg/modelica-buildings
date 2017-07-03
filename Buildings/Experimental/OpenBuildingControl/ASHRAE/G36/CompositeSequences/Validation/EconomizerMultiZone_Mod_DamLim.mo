within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences.Validation;
model EconomizerMultiZone_Mod_DamLim
  "Validates multizone VAV AHU economizer model damper modulation and minimum ooutdoor air requirement damper position limits"
                                    //fixme: add mos file
  extends Modelica.Icons.Example;

  parameter Real TOutCutoff(unit="K", quantity="TermodynamicTemperature")=297 "Outdoor temperature high limit cutoff";
  parameter Real hOutCutoff(unit="J/kg", quantity="SpecificEnergy")=65100 "Outdoor air enthalpy high limit cutoff";
  parameter Real TSupSet(unit="K", quantity="TermodynamicTemperature")=291 "Supply air temperature cooling setpoint";
  parameter Real TSup(unit="K", quantity="TermodynamicTemperature")=290 "Measured supply air temperature";

  parameter Real minVOutSet(unit="m3/s")=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  parameter Real minVOut(unit="m3/s")=0.705
    "Minimal measured volumetric airflow";
  parameter Real VOutIncrease(unit="m3/s")=0.03
    "Maximum volumetric airflow increase during the example simulation";

  parameter Types.FreezeProtectionStage freProDisabled = Types.FreezeProtectionStage.stage0
    "Indicates that the freeze protection is disabled";
  parameter Integer freProDisabledNum = Integer(freProDisabled)-1
    "Numerical value for freeze protection stage 0 (=0)";
  parameter Types.OperationMode occupied = Types.OperationMode.occupied
    "AHU operation mode is \"Occupied\"";
  parameter Integer occupiedNum = Integer(occupied)
    "Numerical value for \"Occupied\" AHU operation mode";
  parameter Types.ZoneState deadband = Types.ZoneState.deadband
    "Zone state is deadband";
  parameter Integer deadbandNum = Integer(deadband)
    "Numerical value for deadband zone state (=2)";

  EconomizerMultiZone economizer(fixEnt=true) "Multizone VAV AHU economizer "
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  CDL.Logical.Constant FanStatus(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  CDL.Integers.Constant FreProSta(k=freProDisabledNum) "Freeze protection status is 0"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  CDL.Integers.Constant ZoneState(k=deadbandNum) "Zone State is deadband"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  CDL.Integers.Constant OperationMode(k=occupiedNum)
                                           "AHU System Mode (1 = Occupied)"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  CDL.Continuous.Constant hOutBelowCutoff(k=hOutCutoff - 10000)
    "Outdoor air enthalpy is slightly below the cufoff"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
                                                    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  CDL.Continuous.Constant TOutBellowCutoff(k=TOutCutoff - 5)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  CDL.Continuous.Constant TOutCut1(
                                  k=TOutCutoff) annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  CDL.Continuous.Constant VOutMinSet(k=minVOutSet)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Ramp VOut(
    duration=1800,
    offset=minVOut,
    height=VOutIncrease)
    "TSup falls below 38 F and remains there for longer than 5 min."
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  CDL.Continuous.Constant TSupSetSig(k=TSupSet) "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  CDL.Continuous.Constant TSupSig(k=TSup) "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
equation
  connect(FanStatus.y, economizer.uSupFan) annotation (Line(points={{-59,-80},{-10,-80},{-10,6},{19,6}},
                                   color={255,0,255}));
  connect(FreProSta.y, economizer.uFreProSta) annotation (Line(points={{-59,-120},{0,-120},{0,0},{19,0}},
                                      color={255,127,0}));
  connect(OperationMode.y, economizer.uOperationMode) annotation (Line(points={{-99,-100},{-50,-100},{-50,-30},{-4,-30},
          {-4,4},{19,4}},                             color={255,127,0}));
  connect(ZoneState.y, economizer.uZoneState) annotation (Line(points={{-99,-60},{-48,-60},{-48,-32},{-2,-32},{-2,2},{
          19,2}},                      color={255,127,0}));
  connect(TOutBellowCutoff.y, economizer.TOut) annotation (Line(points={{-99,110},{-6,110},{-6,22},{19,22}},
                                 color={0,0,127}));
  connect(TOutCut1.y, economizer.TOutCut) annotation (Line(points={{-99,70},{-10,70},{-10,70},{-10,20},{19,20}},
                                               color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer.hOut) annotation (Line(points={{-99,20},{-60,20},{-60,18},{-4,18},{19,18}},
                                                      color={0,0,127}));
  connect(hOutCut.y, economizer.hOutCut) annotation (Line(points={{-99,-20},{-60,-20},{-60,2},{-60,16},{19,16}},
                                                      color={0,0,127}));
  connect(VOut.y, economizer.uVOut) annotation (Line(points={{-19,90},{-8,90},{-8,10},{19,10}},
                          color={0,0,127}));
  connect(VOutMinSet.y, economizer.uVOutMinSet) annotation (Line(points={{-19,50},{-12,50},{-12,8},{19,8}},
                                      color={0,0,127}));
  connect(TSupSetSig.y, economizer.TCooSet) annotation (Line(points={{-59,50},{-52,50},{-52,12},{19,12}},
                                 color={0,0,127}));
  connect(TSupSig.y, economizer.TSup) annotation (Line(points={{-59,90},{-50,90},{-50,14},{19,14}}, color={0,0,127}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/CompositeSequences/Validation/EconomizerMultiZone_Mod_DamLim.mos"
    "Simulate and plot"),
  Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,160}}),
        graphics={
        Rectangle(
          extent={{-136,-44},{-44,-156}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                  Text(
          extent={{52,106},{86,84}},
          lineColor={28,108,200}),
        Text(
          extent={{-128,-130},{-44,-158}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=9,
          textString="Enable damper limit 
control and modulation"),
        Text(
          extent={{102,156},{138,136}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="Validate damper modulation"),
        Text(
          extent={{2,158},{38,138}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=8,
          textString="Economizer fully enabled - 
validate damper position limits")}),
  experiment(StopTime=1800.0),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences.EconomizerMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences.EconomizerMultiZone</a>
for control signals which disable minimum outdoor airflow control loop <code><\code>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 12, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconomizerMultiZone_Mod_DamLim;
