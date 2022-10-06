within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Validation;
model Controller
  "Validation of model that controls cooling only unit"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Controller cooBoxCon(
    final venStd=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016,
    final VAreBreZon_flow=0.006,
    final VPopBreZon_flow=0.005,
    final VMin_flow=0.5,
    final VCooMax_flow=1.5,
    final have_preIndDam=true,
    final staPreMul=1,
    final floHys=0.01,
    final looHys=0.01,
    final damPosHys=0.01,
    final VOccMin_flow=0,
    final VAreMin_flow=0) "Cooling only unit controller"
    annotation (Placement(transformation(extent={{100,-10},{120,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TZon(
    final freqHz=1/86400,
    final amplitude=4,
    final offset=299.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirTem(
    final height=2,
    final duration=43200,
    final offset=273.15 + 15,
    final startTime=28800)
    "Discharge airflow temperture"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta(
    final width=0.05,
    final period=43200,
    final shift=43200)
    "Window opening status"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSet(
    final k=273.15 + 24)
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSet(
    final k=273.15 + 20)
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse occ(
    final width=0.75,
    final period=43200,
    final shift=28800) "Occupancy status"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp opeMod(
    final offset=1,
    final height=2,
    final duration=28800,
    final startTime=28800)
    "Operation mode"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine CO2(
    final amplitude=400,
    final freqHz=1/28800,
    final offset=600) "CO2 concentration"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp supAirTem(
    final height=2,
    final duration=43200,
    final offset=273.15 + 14)
    "Supply air temperature from air handling unit"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine VDis_flow(
    final offset=1.2,
    final amplitude=0.6,
    final freqHz=1/28800) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp oveFlo(
    final height=2,
    final duration=10000,
    final startTime=35000)
    "Override flow setpoint"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp oveDam(
    final height=2,
    final duration=5000,
    startTime=60000) "Override damper position"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round3(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFanSta(
    final width=0.9,
    final period=73200,
    final shift=18800) "Supply fan status"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant CO2Set(final k=894)
    "CO2 concentration setpoint"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
equation
  connect(TZon.y, cooBoxCon.TZon) annotation (Line(points={{-98,160},{60,160},{60,
          28},{98,28}}, color={0,0,127}));
  connect(cooSet.y, cooBoxCon.TCooSet) annotation (Line(points={{-58,140},{56,
          140},{56,26},{98,26}}, color={0,0,127}));
  connect(heaSet.y, cooBoxCon.THeaSet) annotation (Line(points={{-98,120},{52,
          120},{52,24},{98,24}}, color={0,0,127}));
  connect(winSta.y, cooBoxCon.u1Win) annotation (Line(points={{-58,100},{48,100},
          {48,21},{98,21}}, color={255,0,255}));
  connect(occ.y, cooBoxCon.u1Occ) annotation (Line(points={{-98,80},{44,80},{44,
          19},{98,19}}, color={255,0,255}));
  connect(opeMod.y,round2. u)
    annotation (Line(points={{-58,60},{-42,60}}, color={0,0,127}));
  connect(round2.y,reaToInt2. u)
    annotation (Line(points={{-18,60},{-2,60}},
      color={0,0,127}));
  connect(reaToInt2.y, cooBoxCon.uOpeMod) annotation (Line(points={{22,60},{40,60},
          {40,17},{98,17}},     color={255,127,0}));
  connect(CO2.y, cooBoxCon.ppmCO2) annotation (Line(points={{-58,10},{36,10},{36,
          13},{98,13}}, color={0,0,127}));
  connect(disAirTem.y, cooBoxCon.TDis) annotation (Line(points={{-98,-10},{40,-10},
          {40,11},{98,11}}, color={0,0,127}));
  connect(supAirTem.y, cooBoxCon.TSup) annotation (Line(points={{-58,-30},{44,-30},
          {44,9},{98,9}}, color={0,0,127}));
  connect(VDis_flow.y, cooBoxCon.VDis_flow) annotation (Line(points={{-98,-50},{
          48,-50},{48,7},{98,7}}, color={0,0,127}));
  connect(oveFlo.y,round1. u)
    annotation (Line(points={{-98,-80},{-82,-80}}, color={0,0,127}));
  connect(round1.y,reaToInt1. u)
    annotation (Line(points={{-58,-80},{-42,-80}}, color={0,0,127}));
  connect(oveDam.y, round3.u)
    annotation (Line(points={{-98,-110},{-82,-110}}, color={0,0,127}));
  connect(round3.y,reaToInt3. u)
    annotation (Line(points={{-58,-110},{-42,-110}}, color={0,0,127}));
  connect(reaToInt1.y, cooBoxCon.oveFloSet) annotation (Line(points={{-18,-80},{
          52,-80},{52,2},{98,2}}, color={255,127,0}));
  connect(reaToInt3.y, cooBoxCon.oveDamPos) annotation (Line(points={{-18,-110},
          {56,-110},{56,0},{98,0}}, color={255,127,0}));
  connect(supFanSta.y, cooBoxCon.u1Fan) annotation (Line(points={{-58,-160},{64,
          -160},{64,-8},{98,-8}}, color={255,0,255}));
  connect(CO2Set.y, cooBoxCon.ppmCO2Set) annotation (Line(points={{-98,30},{36,30},
          {36,15},{98,15}}, color={0,0,127}));
annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/CoolingOnly/Validation/Controller.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-180},{140,180}})),
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
