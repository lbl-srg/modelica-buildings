within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.Validation;
model OutsideAirFlow
  "Validate the model of calculating minimum outdoor airflow setpoint"

  parameter Integer numZon = 5 "Total number of zones that the system serves";

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow
    outAirSet_MulZon(
    numZon=numZon,
    AFlo=fill(40, numZon),
    VPriSysMax_flow=1,
    minZonPriFlo=fill(0.08, numZon),
    peaSysPop=20)
    "Block to output minimum outdoor airflow rate for system with multiple zones "
    annotation (Placement(transformation(extent={{0,70},{40,110}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow
    outAirSet_MulZon1(
    numZon=numZon,
    AFlo=fill(40, numZon),
    have_occSen=false,
    VPriSysMax_flow=1,
    minZonPriFlo=fill(0.08, numZon),
    peaSysPop=20)
    "Block to output minimum outdoor airflow rate for system with multiple zones "
    annotation (Placement(transformation(extent={{0,10},{40,50}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow
    outAirSet_MulZon2(
    numZon=numZon,
    AFlo=fill(40, numZon),
    have_occSen=false,
    VPriSysMax_flow=1,
    minZonPriFlo=fill(0.08, numZon),
    peaSysPop=20)
    "Block to output minimum outdoor airflow rate for system with multiple zones "
    annotation (Placement(transformation(extent={{0,-50},{40,-10}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow
    outAirSet_MulZon3(
    numZon=numZon,
    AFlo=fill(40, numZon),
    have_occSen=false,
    VPriSysMax_flow=1,
    minZonPriFlo=fill(0.08, numZon),
    peaSysPop=20)
    "Block to output minimum outdoor airflow rate for system with multiple zones "
    annotation (Placement(transformation(extent={{0,-110},{40,-70}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow
    outAirSet_MulZon4(
    numZon=numZon,
    AFlo=fill(40, numZon),
    VPriSysMax_flow=1,
    minZonPriFlo=fill(0.08, numZon),
    peaSysPop=20,
    have_occSen=false,
    have_winSen=false)
    "Block to output minimum outdoor airflow rate for system with multiple zones "
    annotation (Placement(transformation(extent={{0,-170},{40,-130}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow
    outAirSet_MulZon5(
    numZon=numZon,
    AFlo=fill(40, numZon),
    VPriSysMax_flow=1,
    minZonPriFlo=fill(0.08, numZon),
    peaSysPop=20,
    have_occSen=true,
    have_winSen=false)
    "Block to output minimum outdoor airflow rate for system with multiple zones "
    annotation (Placement(transformation(extent={{0,-232},{40,-192}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonPriFloRat[numZon](
    k={0.1,0.12,0.2,0.09,0.1})
    "Measured primary flow rate in each zone at VAV box"
    annotation (Placement(transformation(extent={{-120,-270},{-100,-250}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc1(
    height=2,
    duration=3600)
    "Occupant number in zone 1"
    annotation (Placement(transformation(extent={{-140,200},{-120,220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc2(
    duration=3600,
    height=3)
    "Occupant number in zone 2"
    annotation (Placement(transformation(extent={{-100,200},{-80,220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc3(
    duration=3600,
    height=3,
    startTime=900) "Occupant number in zone 3"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc4(
    duration=3600,
    startTime=900,
    height=2) "Occupant number in zone 4"
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc5(
    duration=3600,
    startTime=0,
    height=-3,
    offset=3) "Occupant number in zone 4"
    annotation (Placement(transformation(extent={{20,200},{40,220}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    annotation (Placement(transformation(extent={{20,160},{40,180}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt4
    annotation (Placement(transformation(extent={{60,160},{80,180}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta[numZon](
    k=fill(false,numZon))
    "Status of windows in each zone"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFan(
    k=true) "Status of supply fan"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon[numZon](
    height=fill(6,numZon),
    offset=fill(273.15 + 17,numZon),
    duration=fill(3600,numZon)) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis[numZon](
    height=fill(4,numZon),
    duration=fill(3600,numZon),
    offset=fill(273.15 + 18,numZon)) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-120,-200},{-100,-180}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta1[numZon](
    final k=fill(true, numZon))
    "Status of windows in each zone"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta2[numZon](
    final k={true,true, false,false,false})
    "Status of windows in each zone"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod1(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.warmUp)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-118,-234},{-98,-214}})));

equation
  connect(winSta.y, outAirSet_MulZon.uWin)
    annotation (Line(points={{-99,40},{-80,40},{-80,50},{-30,50},{-30,86},{-2,
          86}},
      color={255,0,255}));
  connect(supFan.y, outAirSet_MulZon.uSupFan)
    annotation (Line(points={{-99,-120},{-26,-120},{-26,82},{-2,82}},
      color={255,0,255}));
  connect(zonPriFloRat.y,outAirSet_MulZon.VDis_flow)
    annotation (Line(points={{-99,-260},{-10,-260},{-10,72},{-2,72}},
      color={0,0, 127}));
  connect(TZon.y, outAirSet_MulZon.TZon)
    annotation (Line(points={{-99,110},{-60,110},{-60,100},{-2,100}},
      color={0,0,127}));
  connect(TDis.y,outAirSet_MulZon.TDis)
    annotation (Line(points={{-99,80},{-40,80},{-40,94},{-2,94}},
      color={0,0,127}));
  connect(opeMod.y, outAirSet_MulZon.uOpeMod)
    annotation (Line(points={{-99,-190},{-70,-190},{-70,78},{-2,78}},
      color={255,127,0}));
  connect(zonPriFloRat.y, outAirSet_MulZon4.VDis_flow) annotation (Line(points={{-99,
          -260},{-10,-260},{-10,-168},{-2,-168}},      color={0,0,127}));
  connect(opeMod.y, outAirSet_MulZon4.uOpeMod) annotation (Line(points={{-99,
          -190},{-70,-190},{-70,-162},{-2,-162}},
                                            color={255,127,0}));
  connect(supFan.y, outAirSet_MulZon4.uSupFan) annotation (Line(points={{-99,
          -120},{-26,-120},{-26,-158},{-2,-158}},
                                            color={255,0,255}));
  connect(TDis.y, outAirSet_MulZon4.TDis) annotation (Line(points={{-99,80},{
          -40,80},{-40,-146},{-2,-146}},
                                     color={0,0,127}));
  connect(TZon.y, outAirSet_MulZon4.TZon) annotation (Line(points={{-99,110},{
          -60,110},{-60,-140},{-2,-140}},
                                      color={0,0,127}));

  connect(TZon.y, outAirSet_MulZon2.TZon) annotation (Line(points={{-99,110},{
          -60,110},{-60,-20},{-2,-20}},
                                    color={0,0,127}));
  connect(TZon.y, outAirSet_MulZon1.TZon) annotation (Line(points={{-99,110},{
          -60,110},{-60,40},{-2,40}},
                                  color={0,0,127}));
  connect(TDis.y, outAirSet_MulZon1.TDis) annotation (Line(points={{-99,80},{
          -40,80},{-40,34},{-2,34}},
                                 color={0,0,127}));
  connect(TDis.y, outAirSet_MulZon2.TDis) annotation (Line(points={{-99,80},{
          -40,80},{-40,-26},{-2,-26}},
                                   color={0,0,127}));
  connect(winSta.y, outAirSet_MulZon1.uWin) annotation (Line(points={{-99,40},{
          -80,40},{-80,26},{-2,26}},
                                 color={255,0,255}));
  connect(supFan.y, outAirSet_MulZon1.uSupFan) annotation (Line(points={{-99,
          -120},{-26,-120},{-26,22},{-2,22}},
                                        color={255,0,255}));
  connect(opeMod.y, outAirSet_MulZon1.uOpeMod) annotation (Line(points={{-99,
          -190},{-70,-190},{-70,18},{-2,18}},
                                        color={255,127,0}));
  connect(opeMod.y, outAirSet_MulZon2.uOpeMod) annotation (Line(points={{-99,
          -190},{-70,-190},{-70,-42},{-2,-42}},
                                          color={255,127,0}));
  connect(supFan.y, outAirSet_MulZon2.uSupFan) annotation (Line(points={{-99,
          -120},{-26,-120},{-26,-38},{-2,-38}},
                                          color={255,0,255}));
  connect(zonPriFloRat.y, outAirSet_MulZon2.VDis_flow) annotation (Line(points={{-99,
          -260},{-10,-260},{-10,-48},{-2,-48}},      color={0,0,127}));
  connect(zonPriFloRat.y, outAirSet_MulZon1.VDis_flow) annotation (Line(points={{-99,
          -260},{-10,-260},{-10,12},{-2,12}},      color={0,0,127}));
  connect(TZon.y, outAirSet_MulZon3.TZon) annotation (Line(points={{-99,110},{
          -60,110},{-60,-80},{-2,-80}},
                                    color={0,0,127}));
  connect(winSta1.y, outAirSet_MulZon2.uWin) annotation (Line(points={{-99,-20},
          {-80,-20},{-80,-34},{-2,-34}}, color={255,0,255}));
  connect(winSta2.y, outAirSet_MulZon3.uWin) annotation (Line(points={{-99,-70},
          {-80,-70},{-80,-94},{-2,-94}}, color={255,0,255}));
  connect(supFan.y, outAirSet_MulZon3.uSupFan) annotation (Line(points={{-99,
          -120},{-26,-120},{-26,-98},{-2,-98}},
                                          color={255,0,255}));
  connect(TZon.y, outAirSet_MulZon5.TZon) annotation (Line(points={{-99,110},{-60,
          110},{-60,-202},{-2,-202}},                    color={0,0,127}));
  connect(TDis.y, outAirSet_MulZon5.TDis) annotation (Line(points={{-99,80},{-40,
          80},{-40,-208},{-2,-208}},                  color={0,0,127}));
  connect(supFan.y, outAirSet_MulZon5.uSupFan) annotation (Line(points={{-99,-120},
          {-26,-120},{-26,-220},{-2,-220}},                  color={255,0,255}));
  connect(outAirSet_MulZon5.uOpeMod, opeMod1.y) annotation (Line(points={{-2,-224},
          {-97,-224}},                 color={255,127,0}));
  connect(zonPriFloRat.y, outAirSet_MulZon5.VDis_flow) annotation (Line(points={{-99,
          -260},{-10,-260},{-10,-230},{-2,-230}},   color={0,0,127}));
  connect(opeMod.y, outAirSet_MulZon3.uOpeMod) annotation (Line(points={{-99,
          -190},{-70,-190},{-70,-102},{-2,-102}}, color={255,127,0}));
  connect(TDis.y, outAirSet_MulZon3.TDis) annotation (Line(points={{-99,80},{
          -40,80},{-40,-86},{-2,-86}}, color={0,0,127}));
  connect(zonPriFloRat.y, outAirSet_MulZon3.VDis_flow) annotation (Line(points={{-99,
          -260},{-10,-260},{-10,-108},{-2,-108}},       color={0,0,127}));
  connect(numOfOcc1.y, reaToInt.u) annotation (Line(points={{-119,210},{-110,
          210},{-110,170},{-102,170}}, color={0,0,127}));
  connect(numOfOcc2.y, reaToInt1.u) annotation (Line(points={{-79,210},{-68,210},
          {-68,170},{-62,170}}, color={0,0,127}));
  connect(numOfOcc3.y, reaToInt2.u) annotation (Line(points={{-39,210},{-28,210},
          {-28,170},{-22,170}}, color={0,0,127}));
  connect(numOfOcc4.y, reaToInt3.u) annotation (Line(points={{1,210},{12,210},{
          12,170},{18,170}}, color={0,0,127}));
  connect(numOfOcc5.y, reaToInt4.u) annotation (Line(points={{41,210},{50,210},
          {50,170},{58,170}}, color={0,0,127}));
  connect(reaToInt.y, outAirSet_MulZon5.nOcc[1]) annotation (Line(points={{-79,170},
          {-72,170},{-72,-196},{-2,-196}},                    color={255,127,0}));
  connect(reaToInt1.y, outAirSet_MulZon5.nOcc[2]) annotation (Line(points={{-39,170},
          {-32,170},{-32,140},{-72,140},{-72,-196},{-2,-196}},     color={255,127,
          0}));
  connect(reaToInt3.y, outAirSet_MulZon5.nOcc[4]) annotation (Line(points={{41,170},
          {46,170},{46,140},{-72,140},{-72,-196},{-2,-196}},color={255,127,0}));
  connect(reaToInt4.y, outAirSet_MulZon5.nOcc[5]) annotation (Line(points={{81,170},
          {88,170},{88,140},{-72,140},{-72,-196},{-2,-196}},color={255,127,0}));
  connect(reaToInt.y, outAirSet_MulZon.nOcc[1]) annotation (Line(points={{-79,170},
          {-72,170},{-72,106},{-2,106}}, color={255,127,0}));
  connect(reaToInt1.y, outAirSet_MulZon.nOcc[2]) annotation (Line(points={{-39,170},
          {-32,170},{-32,140},{-72,140},{-72,106},{-2,106}},
                                         color={255,127,0}));
  connect(reaToInt2.y, outAirSet_MulZon.nOcc[3]) annotation (Line(points={{1,170},
          {6,170},{6,140},{-72,140},{-72,106},{-2,106}}, color={255,127,0}));
  connect(reaToInt3.y, outAirSet_MulZon.nOcc[4]) annotation (Line(points={{41,170},
          {46,170},{46,140},{-72,140},{-72,106},{-2,106}}, color={255,127,0}));
  connect(reaToInt4.y, outAirSet_MulZon.nOcc[5]) annotation (Line(points={{81,170},
          {88,170},{88,140},{-72,140},{-72,106},{-2,106}}, color={255,127,0}));
  connect(reaToInt2.y, outAirSet_MulZon5.nOcc[3]) annotation (Line(points={{1,170},
          {6,170},{6,140},{-72,140},{-72,-196},{-2,-196}},color={255,127,0}));
  annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/SetPoints/Validation/OutsideAirFlow.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2019, by Milica Grahovac:<br/>
Added test cases.
</li>
<li>
July 6, 2017, by Jianjun Hu:<br/>
Revised implementation.
</li>
<li>
May 12, 2017, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-180,-300},{180,240}})));
end OutsideAirFlow;
