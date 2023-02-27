within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Validation;
model Setpoints "Validate the outdoor airflow setpoint according to the ASHRAE 62.1"

  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    noSenZon(
    final VAreBreZon_flow=0.009,
    final VPopBreZon_flow=0.005,
    final VMin_flow=0.018) "Setpoints of zone without any sensors"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    winSenZon(
    final have_winSen=true,
    final VAreBreZon_flow=0.009,
    final VPopBreZon_flow=0.005,
    final VMin_flow=0.018) "Setpoints of a zone with window sensor"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    occSenZon(
    final have_occSen=true,
    final VAreBreZon_flow=0.009,
    final VPopBreZon_flow=0.005,
    final VMin_flow=0.018) "Setpoints of a zone with occupancy sensor"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    co2SenZon(
    final have_CO2Sen=true,
    have_typTerUni=true,
    final VAreBreZon_flow=0.009,
    final VPopBreZon_flow=0.005,
    final VMin_flow=0.018)
    "Setpoints of a zone with  CO2 sensor and typical terminal unit"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    co2SenZonParFan(
    final have_CO2Sen=true,
    have_parFanPowUni=true,
    final VAreBreZon_flow=0.009,
    final VPopBreZon_flow=0.005,
    final VMin_flow=0.018)
    "Setpoints of a zone with  CO2 sensor and parallel fan-powered terminal unit"
    annotation (Placement(transformation(extent={{180,120},{200,140}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    co2SenSZVAV(
    final have_CO2Sen=true,
    have_SZVAV=true,
    final VAreBreZon_flow=0.009,
    final VPopBreZon_flow=0.005,
    final VMin_flow=0.018)
    "Setpoints of a zone with  CO2 sensor and single zone VAV AHU"
    annotation (Placement(transformation(extent={{180,-20},{200,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final duration=7200)
    "Generate ramp output"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.75)
    "Check if input is greater than 0.75"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(
    final integerTrue=1,
    final integerFalse=2)
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine zonTem(
    final amplitude=8,
    final freqHz=1/7200,
    final offset=273.15 + 15) "Zone temperature"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine disTem(
    final amplitude=-5,
    final freqHz=1/7200,
    final offset=273.15 + 20) "Discharge air temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta(
    final period=7200,
    final width=0.2) "Window operating status"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse occSta(
    final period=7200,
    final width=0.8)
    "Occupancy status"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp co2Con(
    final height=300,
    final duration=7200,
    offset=800) "CO2 concentration"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram1(
    final height=2.6,
    final duration=7200,
    offset=0.6) "Generate ramp output"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine parFanFlo(
    final amplitude=0.01,
    final freqHz=1/7200,
    final offset=0.008) "Parallel fan flow rate"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant CO2Set(
    final k=894)
    "CO2 concentration setpoint"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(ram.y, greThr.u)
    annotation (Line(points={{-178,110},{-162,110}}, color={0,0,127}));
  connect(greThr.y, not1.u)
    annotation (Line(points={{-138,110},{-122,110}}, color={255,0,255}));
  connect(not1.y, booToInt.u)
    annotation (Line(points={{-98,110},{-82,110}},   color={255,0,255}));
  connect(booToInt.y, noSenZon.uOpeMod) annotation (Line(points={{-58,110},{-40,
          110},{-40,135},{-2,135}},  color={255,127,0}));
  connect(zonTem.y, noSenZon.TZon) annotation (Line(points={{-58,70},{-30,70},{-30,
          123},{-2,123}}, color={0,0,127}));
  connect(disTem.y, noSenZon.TDis) annotation (Line(points={{-58,30},{-20,30},{-20,
          121},{-2,121}},  color={0,0,127}));
  connect(booToInt.y, winSenZon.uOpeMod) annotation (Line(points={{-58,110},{
          -40,110},{-40,-45},{-2,-45}}, color={255,127,0}));
  connect(zonTem.y, winSenZon.TZon) annotation (Line(points={{-58,70},{-30,70},{
          -30,-57},{-2,-57}},   color={0,0,127}));
  connect(disTem.y, winSenZon.TDis) annotation (Line(points={{-58,30},{-20,30},{
          -20,-59},{-2,-59}},  color={0,0,127}));
  connect(booToInt.y, occSenZon.uOpeMod) annotation (Line(points={{-58,110},{
          -40,110},{-40,-95},{-2,-95}}, color={255,127,0}));
  connect(zonTem.y, occSenZon.TZon) annotation (Line(points={{-58,70},{-30,70},{
          -30,-107},{-2,-107}}, color={0,0,127}));
  connect(disTem.y, occSenZon.TDis) annotation (Line(points={{-58,30},{-20,30},{
          -20,-109},{-2,-109}},color={0,0,127}));
  connect(occSta.y, occSenZon.u1Occ) annotation (Line(points={{-58,-80},{-10,-80},
          {-10,-93},{-2,-93}}, color={255,0,255}));
  connect(booToInt.y, co2SenZon.uOpeMod) annotation (Line(points={{-58,110},{
          -40,110},{-40,-145},{-2,-145}}, color={255,127,0}));
  connect(zonTem.y, co2SenZon.TZon) annotation (Line(points={{-58,70},{-30,70},{
          -30,-157},{-2,-157}},   color={0,0,127}));
  connect(disTem.y, co2SenZon.TDis) annotation (Line(points={{-58,30},{-20,30},{
          -20,-159},{-2,-159}},  color={0,0,127}));
  connect(co2Con.y, co2SenZon.ppmCO2) annotation (Line(points={{-58,-130},{-10,-130},
          {-10,-149},{-2,-149}},  color={0,0,127}));
  connect(booToInt.y, co2SenZonParFan.uOpeMod) annotation (Line(points={{-58,110},
          {120,110},{120,135},{178,135}}, color={255,127,0}));
  connect(ram1.y, reaToInt.u)
    annotation (Line(points={{62,130},{78,130}}, color={0,0,127}));
  connect(reaToInt.y, co2SenZonParFan.uZonSta) annotation (Line(points={{102,130},
          {130,130},{130,129},{178,129}}, color={255,127,0}));
  connect(co2Con.y, co2SenZonParFan.ppmCO2) annotation (Line(points={{-58,-130},
          {140,-130},{140,131},{178,131}}, color={0,0,127}));
  connect(parFanFlo.y, co2SenZonParFan.VParFan_flow) annotation (Line(points={{102,90},
          {130,90},{130,126},{178,126}},       color={0,0,127}));
  connect(zonTem.y, co2SenZonParFan.TZon) annotation (Line(points={{-58,70},{150,
          70},{150,123},{178,123}},  color={0,0,127}));
  connect(disTem.y, co2SenZonParFan.TDis) annotation (Line(points={{-58,30},{160,
          30},{160,121},{178,121}}, color={0,0,127}));
  connect(booToInt.y, co2SenSZVAV.uOpeMod) annotation (Line(points={{-58,110},{
          120,110},{120,-5},{178,-5}}, color={255,127,0}));
  connect(co2Con.y, co2SenSZVAV.ppmCO2) annotation (Line(points={{-58,-130},{140,
          -130},{140,-9},{178,-9}},color={0,0,127}));
  connect(zonTem.y, co2SenSZVAV.TZon) annotation (Line(points={{-58,70},{150,70},
          {150,-17},{178,-17}}, color={0,0,127}));
  connect(disTem.y, co2SenSZVAV.TDis) annotation (Line(points={{-58,30},{160,30},
          {160,-19},{178,-19}}, color={0,0,127}));
  connect(CO2Set.y, co2SenZonParFan.ppmCO2Set) annotation (Line(points={{-98,0},
          {170,0},{170,133},{178,133}}, color={0,0,127}));
  connect(CO2Set.y, co2SenSZVAV.ppmCO2Set) annotation (Line(points={{-98,0},{
          170,0},{170,-7},{178,-7}}, color={0,0,127}));
  connect(CO2Set.y, co2SenZon.ppmCO2Set) annotation (Line(points={{-98,0},{-50,
          0},{-50,-147},{-2,-147}}, color={0,0,127}));
  connect(winSta.y, not2.u)
    annotation (Line(points={{-138,-30},{-82,-30}}, color={255,0,255}));
  connect(not2.y, winSenZon.u1Win) annotation (Line(points={{-58,-30},{-10,-30},
          {-10,-41},{-2,-41}}, color={255,0,255}));
annotation (experiment(StopTime=7200.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/VentilationZones/ASHRAE62_1/Validation/Setpoints.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints\">
Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 13, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
        Ellipse(lineColor={75,138,73},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor={0,0,255},
                fillColor={75,138,73},
                pattern=LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(extent={{-220,-200},{220,200}})));
end Setpoints;
