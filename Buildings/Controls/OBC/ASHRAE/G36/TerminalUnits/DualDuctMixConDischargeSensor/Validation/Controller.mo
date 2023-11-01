within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConDischargeSensor.Validation;
model Controller
  "Validation of model that controls dual-duct unit using mixing control with discharge flow sensor"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConDischargeSensor.Controller duaDucCon(
    final venStd=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
    final VAreBreZon_flow=0.006,
    final VPopBreZon_flow=0.005,
    final VMin_flow=0.5,
    final VCooMax_flow=1.5,
    final VHeaMax_flow=1.2,
    final staPreMul=1,
    final floHys=0.01,
    final looHys=0.01,
    final damPosHys=0.01,
    final VOccMin_flow=0,
    final VAreMin_flow=0)
    "Dual duct unit controller"
    annotation (Placement(transformation(extent={{100,40},{120,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TZon(
    final freqHz=1/86400,
    final amplitude=4,
    final offset=299.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp disAirTem(
    final height=2,
    final duration=43200,
    final offset=273.15 + 15,
    final startTime=28800)
    "Discharge airflow temperture"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta(
    final width=0.05,
    final period=43200,
    final shift=43200)
    "Window opening status"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooSet(
    final k=273.15 + 24)
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-80,190},{-60,210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaSet(
    final k=273.15 + 20)
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse occ(
    final width=0.75,
    final period=43200,
    final shift=28800) "Occupancy status"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp opeMod(
    final offset=1,
    final height=2,
    final duration=28800,
    final startTime=28800)
    "Operation mode"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Reals.Round round2(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin CO2(
    final amplitude=400,
    final freqHz=1/28800,
    final offset=600) "CO2 concentration"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp colSupAirTem(
    final height=2,
    final duration=43200,
    final offset=273.15 + 14)
    "Cold-duct supply air temperature from air handling unit"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin VDis_flow(
    final offset=1.2,
    final amplitude=0.6,
    final freqHz=1/28800) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp oveFlo(
    final height=2,
    final duration=10000,
    final startTime=35000)
    "Override flow setpoint"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Round round1(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp oveColDam(
    final height=2,
    final duration=5000,
    startTime=60000) "Override cold-duct damper position"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Round round3(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse cooSupFanSta(
    final width=0.9,
    final period=73200,
    final shift=18800) "Cooling supply fan status"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp oveHotDam(
    final height=2,
    final duration=5000,
    final startTime=60000) "Override hot-duct damper position"
    annotation (Placement(transformation(extent={{-120,-180},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt4
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Round round4(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse heaSupFanSta(
    final width=0.9,
    final period=73200,
    final shift=18800) "Heating supply fan status"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp hotSupAirTem(
    final height=2,
    final duration=43200,
    final offset=273.15 + 24)
    "Hot-duct supply air temperature from air handling unit"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant CO2Set(final k=894)
    "CO2 concentration setpoint"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
equation
  connect(TZon.y,duaDucCon. TZon) annotation (Line(points={{-98,220},{60,220},{60,
          79},{98,79}}, color={0,0,127}));
  connect(cooSet.y, duaDucCon.TCooSet) annotation (Line(points={{-58,200},{56,
          200},{56,77},{98,77}}, color={0,0,127}));
  connect(heaSet.y, duaDucCon.THeaSet) annotation (Line(points={{-98,180},{52,
          180},{52,75},{98,75}}, color={0,0,127}));
  connect(occ.y, duaDucCon.u1Occ) annotation (Line(points={{-98,140},{44,140},{
          44,68},{98,68}}, color={255,0,255}));
  connect(opeMod.y,round2. u)
    annotation (Line(points={{-98,110},{-82,110}}, color={0,0,127}));
  connect(round2.y,reaToInt2. u)
    annotation (Line(points={{-58,110},{-42,110}},
      color={0,0,127}));
  connect(reaToInt2.y,duaDucCon. uOpeMod) annotation (Line(points={{-18,110},{
          40,110},{40,66},{98,66}}, color={255,127,0}));
  connect(CO2.y,duaDucCon. ppmCO2) annotation (Line(points={{-58,60},{32,60},{
          32,62},{98,62}}, color={0,0,127}));
  connect(oveFlo.y,round1. u)
    annotation (Line(points={{-98,-110},{-82,-110}}, color={0,0,127}));
  connect(round1.y,reaToInt1. u)
    annotation (Line(points={{-58,-110},{-42,-110}}, color={0,0,127}));
  connect(oveColDam.y, round3.u)
    annotation (Line(points={{-98,-140},{-82,-140}}, color={0,0,127}));
  connect(round3.y,reaToInt3. u)
    annotation (Line(points={{-58,-140},{-42,-140}}, color={0,0,127}));
  connect(reaToInt1.y,duaDucCon. oveFloSet) annotation (Line(points={{-18,-110},
          {64,-110},{64,45},{98,45}}, color={255,127,0}));
  connect(reaToInt3.y, duaDucCon.oveCooDamPos) annotation (Line(points={{-18,
          -140},{68,-140},{68,43},{98,43}}, color={255,127,0}));
  connect(oveHotDam.y, round4.u)
    annotation (Line(points={{-98,-170},{-82,-170}}, color={0,0,127}));
  connect(round4.y,reaToInt4. u)
    annotation (Line(points={{-58,-170},{-42,-170}}, color={0,0,127}));
  connect(reaToInt4.y, duaDucCon.oveHeaDamPos) annotation (Line(points={{-18,
          -170},{72,-170},{72,41},{98,41}}, color={255,127,0}));
  connect(disAirTem.y, duaDucCon.TDis) annotation (Line(points={{-98,40},{36,40},
          {36,60},{98,60}}, color={0,0,127}));
  connect(colSupAirTem.y, duaDucCon.TColSup) annotation (Line(points={{-58,20},
          {40,20},{40,58},{98,58}},color={0,0,127}));
  connect(cooSupFanSta.y, duaDucCon.u1CooAHU) annotation (Line(points={{-58,-20},
          {48,-20},{48,54},{98,54}}, color={255,0,255}));
  connect(hotSupAirTem.y, duaDucCon.THotSup) annotation (Line(points={{-98,-40},
          {52,-40},{52,52},{98,52}}, color={0,0,127}));
  connect(heaSupFanSta.y, duaDucCon.u1HeaAHU) annotation (Line(points={{-98,-80},
          {60,-80},{60,50},{98,50}}, color={255,0,255}));
  connect(VDis_flow.y, duaDucCon.VDis_flow) annotation (Line(points={{-98,0},{
          44,0},{44,56},{98,56}}, color={0,0,127}));
  connect(CO2Set.y, duaDucCon.ppmCO2Set) annotation (Line(points={{-98,80},{36,
          80},{36,64},{98,64}}, color={0,0,127}));
  connect(winSta.y, not2.u)
    annotation (Line(points={{-58,160},{-42,160}}, color={255,0,255}));
  connect(not2.y, duaDucCon.u1Win) annotation (Line(points={{-18,160},{48,160},{
          48,70},{98,70}}, color={255,0,255}));
annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/DualDuctMixConDischargeSensor/Validation/Controller.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConDischargeSensor.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConDischargeSensor.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-240},{140,240}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}));
end Controller;
