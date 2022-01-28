within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly;
block Controller "Controller for cooling only VAV box"


  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-220,230},{-180,270}}),
        iconTransformation(extent={{-140,160},{-100,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-220,200},{-180,240}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-220,160},{-180,200}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc if have_occSen
    "Occupancy status, true if it is occupied, false if it is not occupied"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-220,70},{-180,110}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 concentration"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured supply air temperature after heating coil"
    annotation (Placement(transformation(extent={{-220,0},{-180,40}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-220,-100},{-180,-60}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-220,-64},{-180,-24}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-220,-130},{-180,-90}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveDamPos
    "Index of overriding damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-220,-160},{-180,-120}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final max=1,
    final unit="1")
    "Actual damper position"
    annotation (Placement(transformation(extent={{-220,-200},{-180,-160}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-220,-260},{-180,-220}}),
        iconTransformation(extent={{-140,-200},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{200,0},{240,40}}),
        iconTransformation(extent={{100,140},{140,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDamSet(
    final min=0,
    final unit="1")
    "Damper position setpoint after considering override"
    annotation (Placement(transformation(extent={{200,-40},{240,0}}),
        iconTransformation(extent={{100,110},{140,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{200,-100},{240,-60}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{200,-140},{240,-100}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{200,-190},{240,-150}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{200,-230},{240,-190}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    "Leaking damper alarm"
    annotation (Placement(transformation(extent={{200,-270},{240,-230}}),
        iconTransformation(extent={{100,-170},{140,-130}})));

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.ActiveAirFlow actAirSet
    "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.SystemRequests sysReq
    "Specify system requests "
    annotation (Placement(transformation(extent={{120,-160},{140,-140}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ControlLoops conLoo
    "Heating and cooling control loop"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Alarms ala
    "Generate alarms"
    annotation (Placement(transformation(extent={{120,-220},{140,-200}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Overrides setOve
    "Override setpoints"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TimeSuppression timSup
    "Specify suppresion time due to the setpoint change and check if it has passed the suppresion period"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints setPoi(
      have_CO2Sen=false, have_parFanPowUniWitCO2=false)
    "Minimum outdoor air and minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Damper
    dam "Damper control"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  ThermalZones.ZoneStates zonSta
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
equation
  connect(TZon, timSup.TZon) annotation (Line(points={{-200,250},{-152,250},{-152,
          216},{-122,216}}, color={0,0,127}));
  connect(TZonCooSet, timSup.TSet) annotation (Line(points={{-200,220},{-156,220},
          {-156,224},{-122,224}}, color={0,0,127}));
  connect(TZonCooSet, conLoo.TZonCooSet) annotation (Line(points={{-200,220},{-156,
          220},{-156,186},{-122,186}}, color={0,0,127}));
  connect(TZon, conLoo.TZon) annotation (Line(points={{-200,250},{-152,250},{-152,
          180},{-122,180}}, color={0,0,127}));
  connect(TZonHeaSet, conLoo.TZonHeaSet) annotation (Line(points={{-200,180},{-160,
          180},{-160,174},{-122,174}}, color={0,0,127}));
  connect(uWin, setPoi.uWin) annotation (Line(points={{-200,150},{-140,150},{-140,
          119},{-122,119}}, color={255,0,255}));
  connect(uOcc, setPoi.uOcc) annotation (Line(points={{-200,120},{-144,120},{-144,
          117},{-122,117}}, color={255,0,255}));
  connect(uOpeMod, setPoi.uOpeMod) annotation (Line(points={{-200,90},{-148,90},
          {-148,114},{-122,114}}, color={255,127,0}));
  connect(ppmCO2, setPoi.ppmCO2) annotation (Line(points={{-200,60},{-144,60},{-144,
          111},{-122,111}}, color={0,0,127}));
  connect(TZon, setPoi.TZon) annotation (Line(points={{-200,250},{-152,250},{-152,
          103},{-122,103}}, color={0,0,127}));
  connect(TDis, setPoi.TDis) annotation (Line(points={{-200,20},{-140,20},{-140,
          101},{-122,101}}, color={0,0,127}));
  connect(uOpeMod, actAirSet.uOpeMod) annotation (Line(points={{-200,90},{-148,90},
          {-148,30},{-62,30}},      color={255,127,0}));
  connect(setPoi.VOccZonMin_flow, actAirSet.VOccZonMin_flow) annotation (Line(
        points={{-98,114},{-82,114},{-82,24},{-62,24}}, color={0,0,127}));
  connect(VDis_flow, dam.VDis_flow) annotation (Line(points={{-200,-80},{-148,-80},
          {-148,-59},{-2,-59}}, color={0,0,127}));
  connect(conLoo.yCoo, dam.uCoo) annotation (Line(points={{-98,186},{-76,186},{-76,
          -50},{-2,-50}}, color={0,0,127}));
  connect(actAirSet.VActCooMax_flow, dam.VActCooMax_flow) annotation (Line(
        points={{-38,36},{-16,36},{-16,-53},{-2,-53}}, color={0,0,127}));
  connect(TSup, dam.TSup)
    annotation (Line(points={{-200,-44},{-2,-44}}, color={0,0,127}));
  connect(actAirSet.VActMin_flow, dam.VActMin_flow) annotation (Line(points={{-38,30},
          {-20,30},{-20,-41},{-2,-41}},     color={0,0,127}));
  connect(TZon, dam.TZon) annotation (Line(points={{-200,250},{-152,250},{-152,-47},
          {-2,-47}}, color={0,0,127}));
  connect(oveFloSet, setOve.oveFloSet) annotation (Line(points={{-200,-110},{36,
          -110},{36,-82},{58,-82}},
                              color={255,127,0}));
  connect(oveDamPos, setOve.oveDamPos) annotation (Line(points={{-200,-140},{40,
          -140},{40,-94},{58,-94}}, color={255,127,0}));
  connect(dam.yDamSet, setOve.uDamSet) annotation (Line(points={{22,-50},{44,-50},
          {44,-98},{58,-98}}, color={0,0,127}));
  connect(timSup.yAftSup, sysReq.uAftSup) annotation (Line(points={{-98,220},{100,
          220},{100,-141},{118,-141}}, color={255,0,255}));
  connect(TZonCooSet, sysReq.TZonCooSet) annotation (Line(points={{-200,220},{-156,
          220},{-156,-144},{118,-144}}, color={0,0,127}));
  connect(TZon, sysReq.TZon) annotation (Line(points={{-200,250},{-152,250},{-152,
          -146},{118,-146}}, color={0,0,127}));
  connect(conLoo.yCoo, sysReq.uCoo) annotation (Line(points={{-98,186},{-76,186},
          {-76,-148},{118,-148}}, color={0,0,127}));
  connect(setOve.VSet_flow, sysReq.VSet_flow) annotation (Line(points={{82,-86},
          {106,-86},{106,-153},{118,-153}},
                                          color={0,0,127}));
  connect(VDis_flow, sysReq.VDis_flow) annotation (Line(points={{-200,-80},{-148,
          -80},{-148,-156},{118,-156}},
                                  color={0,0,127}));
  connect(uDam, sysReq.uDam) annotation (Line(points={{-200,-180},{-144,-180},{-144,
          -159},{118,-159}}, color={0,0,127}));
  connect(VDis_flow, ala.VDis_flow) annotation (Line(points={{-200,-80},{-148,-80},
          {-148,-202},{118,-202}},color={0,0,127}));
  connect(setOve.VSet_flow, ala.VActSet_flow) annotation (Line(points={{82,-86},
          {106,-86},{106,-206},{118,-206}},
                                          color={0,0,127}));
  connect(uFan, ala.uFan) annotation (Line(points={{-200,-240},{100,-240},{100,-214},
          {118,-214}}, color={255,0,255}));
  connect(uDam, ala.uDam) annotation (Line(points={{-200,-180},{-144,-180},{-144,
          -218},{118,-218}},
                       color={0,0,127}));
  connect(setOve.VSet_flow, VSet_flow) annotation (Line(points={{82,-86},{140,-86},
          {140,20},{220,20}},  color={0,0,127}));
  connect(setOve.yDamSet, yDamSet) annotation (Line(points={{82,-94},{146,-94},{
          146,-20},{220,-20}},
                           color={0,0,127}));
  connect(sysReq.yZonTemResReq, yZonTemResReq) annotation (Line(points={{142,-144},
          {174,-144},{174,-80},{220,-80}}, color={255,127,0}));
  connect(sysReq.yZonPreResReq, yZonPreResReq) annotation (Line(points={{142,-156},
          {180,-156},{180,-120},{220,-120}},
                                         color={255,127,0}));
  connect(ala.yLowFloAla, yLowFloAla) annotation (Line(points={{142,-204},{180,-204},
          {180,-170},{220,-170}},
                                color={255,127,0}));
  connect(ala.yFloSenAla, yFloSenAla) annotation (Line(points={{142,-210},{220,-210}},
                                  color={255,127,0}));
  connect(ala.yLeaDamAla, yLeaDamAla) annotation (Line(points={{142,-216},{180,-216},
          {180,-250},{220,-250}}, color={255,127,0}));
  connect(conLoo.yHea, zonSta.uHea) annotation (Line(points={{-98,174},{-70,174},
          {-70,134},{-62,134}}, color={0,0,127}));
  connect(conLoo.yCoo, zonSta.uCoo) annotation (Line(points={{-98,186},{-76,186},
          {-76,126},{-62,126}}, color={0,0,127}));
  connect(zonSta.yZonSta, dam.uZonSta) annotation (Line(points={{-38,130},{-12,130},
          {-12,-56},{-2,-56}}, color={255,127,0}));
  connect(dam.VActSet_flow, setOve.VActSet_flow) annotation (Line(points={{22,-44},
          {48,-44},{48,-86},{58,-86}}, color={0,0,127}));

annotation (defaultComponentName="cooBoxCon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},
            {100,200}}), graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,240},{100,200}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,-4},{-54,-16}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-98,16},{-72,4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          visible=have_CO2Sen,
          extent={{-96,56},{-54,44}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2"),
        Text(
          extent={{-98,-22},{-72,-34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-98,-134},{-72,-146}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-98,188},{-72,176}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-98,168},{-40,154}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSet"),
        Text(
          extent={{-98,148},{-40,134}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonHeaSet"),
        Text(
          visible=have_winSen,
          extent={{-98,118},{-72,106}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWin"),
        Text(
          visible=have_occSen,
          extent={{-98,98},{-72,86}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOcc"),
        Text(
          extent={{-100,-170},{-74,-182}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uFan"),
        Text(
          extent={{-96,78},{-50,62}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,-70},{-52,-86}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{-98,-90},{-40,-106}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveDamPos"),
        Text(
          extent={{54,168},{96,156}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VSet_flow"),
        Text(
          extent={{56,138},{98,126}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDamSet"),
        Text(
          extent={{18,62},{96,44}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yZonTemResReq"),
        Text(
          extent={{18,32},{96,14}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yZonPreResReq"),
        Text(
          extent={{42,-80},{98,-98}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{40,-108},{98,-126}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla"),
        Text(
          extent={{40,-138},{98,-156}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-280},{200,280}})),
  Documentation(info="<html>
<p>
Controller for terminal box of VAV system with reheat according to Section 5.6 of ASHRAE
Guideline 36, May 2020. It outputs discharge airflow setpoint <code>VSet_flow</code>,
damper position setpoint <code>yDamSet</code>, hot water valve position setpoint
<code>yValSet</code>, AHU cooling supply temperature
setpoint reset request <code>yZonTemResReq</code>, and static pressure setpoint
reset request <code>yZonPreResReq</code>, hot water reset request <code>yHeaValResReq</code>
and <code>yHotWatPlaReq</code>. It also outputs the alarms about the low airflow
<code>yLowFloAla</code>, low discharge temperature <code>yLowTemAla</code>,
leaking damper <code>yLeaDamAla</code> and valve <code>yLeaValAla</code>, and
airflow sensor calibration alarm <code>yFloSenAla</code>.
</p>
<p>The sequence consists of four subsequences. </p>
<h4>a. Heating and cooling control loop</h4>
<p>
The subsequence is implementd according to Section 5.3.4. The measured zone
temperature <code>TZon</code>, zone setpoints temperatures <code>TZonHeaSet</code> and
<code>TZonCooSet</code> are inputs to the instance of class 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ZoneStates\">
Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ZoneStates</a> to generate the
heating and cooling control loop signal. 
</p>
<h4>b. Active airflow setpoint calculation</h4>
<p>
This sequence sets the active maximum and minimum airflow according to
Section 5.6.4. Depending on operation modes <code>uOpeMod</code>, it sets the
airflow rate limits for cooling and heating supply. 
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.ActiveAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.ActiveAirFlow</a>.
</p>
<h4>c. Damper and valve control</h4>
<p>
This sequence sets the damper and valve position setpoints for VAV reheat terminal unit.
The implementation is according to Section 5.6.5. According to heating and cooling
control loop signal, it calculates the discharge air temperature setpoint
<code>TDisSet</code>. Along with the active maximum and minimum airflow setpoint, measured
zone temperature, the sequence outputs <code>yDamSet</code>, <code>yValSet</code>,
<code>TDisSet</code> and discharge airflow rate setpoint <code>VDisSet_flow</code>.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.DamperValves\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.DamperValves</a>.
</p>
<h4>d. System reset requests generation</h4>
<p>
According to Section 5.6.8, this sequence outputs the system reset requests, i.e.
cooling supply air temperature reset requests <code>yZonTemResReq</code>,
static pressure reset requests <code>yZonPreResReq</code>, hot water reset
requests <code>yHeaValResReq</code>, and the hot water plant reset requests
<code>yHotWatPlaReq</code>. 
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.SystemRequests</a>.
</p>
<h4>e. Alarms</h4>
<p>
According to Section 5.6.6, this sequence outputs the alarms of low discharge flow,
low discharge temperature, leaking damper, leaking valve, and airflow sensor calibration
alarm.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Alarms\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Alarms</a>.
</p>
<h4>f. Testing and commissioning overrides</h4>
<p>
According to Section 5.6.7, this sequence allows the override the aiflow setpoints,
damper and valve position setpoints.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Overrides\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Overrides</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
