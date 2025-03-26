within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Validation;
model Controller
  "Validation of model that controls terminal unit with reheat"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Controller rehBoxCon(
    final venStd=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
    final VAreBreZon_flow=0.006,
    final VPopBreZon_flow=0.005,
    final VMin_flow=0.5,
    final VCooMax_flow=1.5,
    final VHeaMin_flow=0.5,
    final VHeaMax_flow=1.2,
    final controllerTypeVal=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final staPreMul=1,
    final hotWatRes=1,
    final floHys=0.01,
    final looHys=0.01,
    final damPosHys=0.01,
    final valPosHys=0.01,
    final VOccMin_flow=0,
    final VAreMin_flow=0)
    "Reheat unit controller"
    annotation (Placement(transformation(extent={{100,70},{120,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TZon(
    final freqHz=1/86400,
    final amplitude=4,
    final offset=299.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-120,230},{-100,250}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp disAirTem(
    final height=2,
    final duration=43200,
    final offset=273.15 + 15,
    final startTime=28800)
    "Discharge airflow temperture"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta(
    final width=0.05,
    final period=43200,
    final shift=43200)
    "Window opening status"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooSet(
    final k=273.15 + 24)
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaSet(
    final k=273.15 + 20)
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse occ(
    final width=0.75,
    final period=43200,
    final shift=28800) "Occupancy status"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp opeMod(
    final offset=1,
    final height=2,
    final duration=28800,
    final startTime=28800)
    "Operation mode"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Buildings.Controls.OBC.CDL.Reals.Round round2(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin CO2(
    final amplitude=400,
    final freqHz=1/28800,
    final offset=600) "CO2 concentration"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin parFanFlo(
    final offset=1.2,
    final amplitude=0.6,
    final freqHz=1/28800) "Parallel fan flow"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp oveFlo(
    final height=2,
    final duration=10000,
    final startTime=35000)
    "Override flow setpoint"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Round round1(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp oveDam(
    final height=2,
    final duration=5000,
    startTime=60000) "Override damper position"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Round round3(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TSup(
    final offset=273.15 + 13,
    final amplitude=1,
    final freqHz=1/28800) "Supply air temperature from air handling unit"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse heaOff(
    final width=0.75,
    final period=3600)
    "Close heating valve"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse hotPla(
    final width=0.9,
    final period=7500)
    "Hot water plant status"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFan(
    final width=0.75,
    final period=7500)
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSet(
    final k=273.15 + 13)
    "AHU supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin disFlo(
    final offset=1.3,
    final amplitude=0.6,
    final freqHz=1/28800) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant CO2Set(
    final k=894)
    "CO2 concentration setpoint"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
equation
  connect(TZon.y,rehBoxCon. TZon) annotation (Line(points={{-98,240},{52,240},{52,
          109},{98,109}}, color={0,0,127}));
  connect(cooSet.y,rehBoxCon. TCooSet) annotation (Line(points={{-58,220},{48,
          220},{48,107},{98,107}}, color={0,0,127}));
  connect(heaSet.y,rehBoxCon. THeaSet) annotation (Line(points={{-98,200},{44,
          200},{44,105},{98,105}}, color={0,0,127}));
  connect(occ.y, rehBoxCon.u1Occ) annotation (Line(points={{-98,160},{36,160},{
          36,100},{98,100}}, color={255,0,255}));
  connect(opeMod.y,round2. u)
    annotation (Line(points={{-98,130},{-82,130}}, color={0,0,127}));
  connect(round2.y,reaToInt2. u)
    annotation (Line(points={{-58,130},{-42,130}},
      color={0,0,127}));
  connect(reaToInt2.y,rehBoxCon. uOpeMod) annotation (Line(points={{-18,130},{32,
          130},{32,98},{98,98}},   color={255,127,0}));
  connect(CO2.y,rehBoxCon. ppmCO2) annotation (Line(points={{-58,70},{36,70},{36,
          94},{98,94}}, color={0,0,127}));
  connect(oveFlo.y,round1. u)
    annotation (Line(points={{-98,-60},{-82,-60}}, color={0,0,127}));
  connect(round1.y,reaToInt1. u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={0,0,127}));
  connect(oveDam.y, round3.u)
    annotation (Line(points={{-98,-100},{-82,-100}}, color={0,0,127}));
  connect(round3.y,reaToInt3. u)
    annotation (Line(points={{-58,-100},{-42,-100}},color={0,0,127}));
  connect(reaToInt1.y,rehBoxCon. oveFloSet) annotation (Line(points={{-18,-60},{
          56,-60},{56,84},{98,84}},   color={255,127,0}));
  connect(disAirTem.y,rehBoxCon. TDis) annotation (Line(points={{-58,30},{40,30},
          {40,92},{98,92}}, color={0,0,127}));
  connect(reaToInt3.y,rehBoxCon. oveDamPos) annotation (Line(points={{-18,-100},
          {60,-100},{60,82},{98,82}}, color={255,127,0}));
  connect(heaOff.y, not1.u)
    annotation (Line(points={{-98,-140},{-42,-140}}, color={255,0,255}));
  connect(not1.y,rehBoxCon. uHeaOff) annotation (Line(points={{-18,-140},{64,-140},
          {64,80},{98,80}}, color={255,0,255}));
  connect(supFan.y, rehBoxCon.u1Fan) annotation (Line(points={{-58,-200},{68,
          -200},{68,73.2},{98,73.2}}, color={255,0,255}));
  connect(hotPla.y, rehBoxCon.u1HotPla) annotation (Line(points={{-58,-240},{72,
          -240},{72,71.2},{98,71.2}}, color={255,0,255}));
  connect(TSupSet.y,rehBoxCon. TSupSet) annotation (Line(points={{-98,-30},{52,-30},
          {52,86},{98,86}}, color={0,0,127}));
  connect(TSup.y,rehBoxCon. TSup) annotation (Line(points={{-58,-10},{48,-10},{48,
          88},{98,88}}, color={0,0,127}));
  connect(disFlo.y,rehBoxCon. VDis_flow) annotation (Line(points={{-98,10},{44,10},
          {44,90},{98,90}}, color={0,0,127}));
  connect(CO2Set.y, rehBoxCon.ppmCO2Set) annotation (Line(points={{-98,90},{0,
          90},{0,96},{98,96}},   color={0,0,127}));
  connect(winSta.y, not2.u)
    annotation (Line(points={{-58,180},{-42,180}}, color={255,0,255}));
  connect(not2.y, rehBoxCon.u1Win) annotation (Line(points={{-18,180},{40,180},{
          40,102},{98,102}}, color={255,0,255}));
annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/Reheat/Validation/Controller.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-260},{140,260}})),
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
