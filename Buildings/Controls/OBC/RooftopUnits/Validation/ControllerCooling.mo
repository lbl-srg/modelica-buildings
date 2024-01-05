within Buildings.Controls.OBC.RooftopUnits.Validation;
model ControllerCooling
  "Validation of controller in cooling mode operation"

  Buildings.Controls.OBC.RooftopUnits.Controller RTUCon(
    final nCoiHea=3,
    final nCoiCoo=3,
    final TLocOut=273.15 - 12.2,
    final uThrHeaCoi=0.9,
    final have_TFroSen=false,
    final defTri=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.onDemand,
    final TDefLim=273.15,
    final dUHys=0.01,
    final dTHys=273.2,
    final dTHys1=273.65)
    "RTU controller"
    annotation (Placement(transformation(extent={{-76,138},{-56,186}})));

  Buildings.Controls.OBC.RooftopUnits.Controller RTUCon1(
    final nCoiHea=3,
    final nCoiCoo=3,
    final TLocOut=273.15 - 12.2,
    final uThrHeaCoi=0.9,
    final have_TFroSen=false,
    final defTri=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.onDemand,
    final TDefLim=273.15,
    final dUHys=0.01,
    final dTHys=273.2,
    final dTHys1=273.65)
    "RTU controller"
    annotation (Placement(transformation(extent={{80,138},{100,186}})));

  Buildings.Controls.OBC.RooftopUnits.Controller RTUCon2(
    final nCoiHea=3,
    final nCoiCoo=3,
    final TLocOut=273.15 - 12.2,
    final uThrHeaCoi=0.9,
    final have_TFroSen=false,
    final defTri=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.onDemand,
    final TDefLim=273.15,
    final dUHys=0.01,
    final dTHys=273.2,
    final dTHys1=273.65)
    "RTU controller"
    annotation (Placement(transformation(extent={{-80,-162},{-60,-114}})));

  Buildings.Controls.OBC.RooftopUnits.Controller RTUCon3(
    final nCoiHea=3,
    final nCoiCoo=3,
    final TLocOut=273.15 - 12.2,
    final uThrHeaCoi=0.9,
    final have_TFroSen=false,
    final defTri=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.onDemand,
    final TDefLim=273.15,
    final dUHys=0.01,
    final dTHys=273.2,
    final dTHys1=273.65)
    "RTU controller"
    annotation (Placement(transformation(extent={{80,-162},{100,-114}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{-40,156},{-20,176}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{-140,260},{-120,280}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{-140,230},{-120,250}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=0)
    "Constant Integer"
    annotation (Placement(transformation(extent={{-140,200},{-120,220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramCooCoi(
    final height=0.35,
    final duration=3600,
    final offset=0.5,
    final startTime=0)
    "Cooiling coil signal"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHeaCoi(
    final k=0)
    "Heating coil signal"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut(
    final k=273.15 + 30)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Xout(
    final k=0.03) "Outdoor air humidity ratio"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{20,260},{40,280}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{20,230},{40,250}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=0)
    "Constant Integer"
    annotation (Placement(transformation(extent={{20,200},{40,220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramCooCoi1(
    final height=0.35,
    final duration=2800,
    final offset=0.5,
    final startTime=0)
    "Cooiling coil signal"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHeaCoi1(
    final k=0)
    "Heating coil signal"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut1(
    final k=273.15 + 30)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Xout1(
    final k=0.03)
    "Outdoor air humidity ratio"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{120,156},{140,176}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=0)
    "Constant Integer"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramCooCoi2(
    final height=0.5,
    final duration=1200,
    final offset=0.5,
    final startTime=0)
    "Cooiling coil signal"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHeaCoi2(
    final k=0)
    "Heating coil signal"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut2(
    final k=273.15 + 30)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Xout2(
    final k=0.03)
    "Outdoor air humidity ratio"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre4[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=1)
    "Constant Integer"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramCooCoi3(
    final height=0.5,
    final duration=1200,
    final offset=0.5,
    final startTime=0)
    "Cooiling coil signal"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHeaCoi3(
    final k=0)
    "Heating coil signal"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOut3(
    final k=273.15 + 30)
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{20,-190},{40,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Xout3(
    final k=0.03)
    "Outdoor air humidity ratio"
    annotation (Placement(transformation(extent={{20,-220},{40,-200}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre5[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{-40,-144},{-20,-124}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre6[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre7[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{120,-144},{140,-124}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre8[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{120,-180},{140,-160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup[3](
    final height=fill(4,3),
    final duration=fill(1800,3),
    final offset=fill(10,3))
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupSet(
    final k=12)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup1[3](
    final height=fill(4,3),
    final duration=fill(1800,3),
    final offset=fill(10,3))
    "Supply air temperature"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupSet1(
    final k=12)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup2[3](
    final height=fill(4,3),
    final duration=fill(1800,3),
    final offset=fill(10,3))
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-140,-250},{-120,-230}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupSet2(
    final k=12)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-280},{-120,-260}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup3[3](
    final height=fill(4,3),
    final duration=fill(1800,3),
    final offset=fill(10,3))
    "Supply air temperature"
    annotation (Placement(transformation(extent={{20,-250},{40,-230}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupSet3(
    final k=12)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{20,-280},{40,-260}})));

equation
  connect(conInt1.y, RTUCon.uDemLimLev) annotation (Line(points={{-118,210},{-104,
          210},{-104,166},{-78,166}}, color={255,127,0}));
  connect(TOut.y, RTUCon.TOut) annotation (Line(points={{-118,120},{-100,120},{-100,
          156},{-78,156}}, color={0,0,127}));
  connect(conInt3.y, RTUCon1.uDemLimLev) annotation (Line(points={{42,210},{56,210},
          {56,166},{78,166}}, color={255,127,0}));
  connect(ramCooCoi1.y, RTUCon1.uCooCoi) annotation (Line(points={{42,180},{52,180},
          {52,162.2},{78,162.2}},
                              color={0,0,127}));
  connect(conHeaCoi1.y, RTUCon1.uHeaCoi) annotation (Line(points={{42,150},{52,150},
          {52,159},{78,159}}, color={0,0,127}));
  connect(TOut1.y, RTUCon1.TOut) annotation (Line(points={{42,120},{60,120},{60,
          156},{78,156}},
                     color={0,0,127}));
  connect(conInt5.y, RTUCon2.uDemLimLev) annotation (Line(points={{-118,-90},{-104,
          -90},{-104,-134},{-82,-134}},  color={255,127,0}));
  connect(ramCooCoi2.y, RTUCon2.uCooCoi) annotation (Line(points={{-118,-120},{-108,
          -120},{-108,-137.8},{-82,-137.8}},
                                         color={0,0,127}));
  connect(conHeaCoi2.y, RTUCon2.uHeaCoi) annotation (Line(points={{-118,-150},{-108,
          -150},{-108,-141},{-82,-141}}, color={0,0,127}));
  connect(TOut2.y, RTUCon2.TOut) annotation (Line(points={{-118,-180},{-100,-180},
          {-100,-144},{-82,-144}}, color={0,0,127}));
  connect(conInt7.y, RTUCon3.uDemLimLev) annotation (Line(points={{42,-90},{56,-90},
          {56,-134},{78,-134}},       color={255,127,0}));
  connect(ramCooCoi3.y, RTUCon3.uCooCoi) annotation (Line(points={{42,-120},{52,
          -120},{52,-137.8},{78,-137.8}},
                                      color={0,0,127}));
  connect(conHeaCoi3.y, RTUCon3.uHeaCoi) annotation (Line(points={{42,-150},{52,
          -150},{52,-141},{78,-141}}, color={0,0,127}));
  connect(TOut3.y, RTUCon3.TOut) annotation (Line(points={{42,-180},{60,-180},{60,
          -144},{78,-144}}, color={0,0,127}));
  connect(ramCooCoi.y, RTUCon.uCooCoi) annotation (Line(points={{-118,180},{-108,
          180},{-108,162.2},{-78,162.2}},
                                      color={0,0,127}));
  connect(RTUCon.uHeaCoi, conHeaCoi.y) annotation (Line(points={{-78,159},{-108,
          159},{-108,150},{-118,150}}, color={0,0,127}));
  connect(Xout.y, RTUCon.XOut) annotation (Line(points={{-118,90},{-90,90},{-90,
          153},{-78,153}}, color={0,0,127}));
  connect(Xout1.y, RTUCon1.XOut) annotation (Line(points={{42,90},{70,90},{70,153},
          {78,153}}, color={0,0,127}));
  connect(Xout2.y, RTUCon2.XOut) annotation (Line(points={{-118,-210},{-90,-210},
          {-90,-147},{-82,-147}}, color={0,0,127}));
  connect(Xout3.y, RTUCon3.XOut) annotation (Line(points={{42,-210},{70,-210},{70,
          -147},{78,-147}}, color={0,0,127}));
  connect(RTUCon.yDXCooCoi, pre1.u) annotation (Line(points={{-54,180},{-50,180},
          {-50,166},{-42,166}},
          color={255,0,255}));
  connect(RTUCon.yDXHeaCoi, pre2.u) annotation (Line(points={{-54,172.2},{-50,172.2},
          {-50,130},{-42,130}}, color={255,0,255}));
  connect(pre2.y, RTUCon.uDXHeaCoi) annotation (Line(points={{-18,130},{-6,130},
          {-6,200},{-92,200},{-92,181},{-78,181}}, color={255,0,255}));
  connect(RTUCon.uCooCoiAva, con1.y) annotation (Line(points={{-78,178},{-96,178},
          {-96,270},{-118,270}},           color={255,0,255}));
  connect(RTUCon.uHeaCoiAva, con1.y) annotation (Line(points={{-78,175},{-96,175},
          {-96,270},{-118,270}}, color={255,0,255}));
  connect(RTUCon.uHeaCoiSeq, conInt.y) annotation (Line(points={{-78,169},{-78,168},
          {-100,168},{-100,240},{-118,240}},      color={255,127,0}));
  connect(RTUCon.uCooCoiSeq, conInt.y) annotation (Line(points={{-78,172},{-98,172},
          {-98,240},{-118,240}},             color={255,127,0}));
  connect(RTUCon.uDXCooCoi, pre1.y) annotation (Line(points={{-78,184},{-90,184},
          {-90,190},{-12,190},{-12,166},{-18,166}},           color={255,0,255}));
  connect(RTUCon1.yDXCooCoi, pre3.u) annotation (Line(points={{102,180},{110,180},
          {110,166},{118,166}},
          color={255,0,255}));
  connect(pre3.y, RTUCon1.uDXCooCoi) annotation (Line(points={{142,166},{148,166},
          {148,190},{72,190},{72,170},{78,170},{78,184}}, color={255,0,255}));
  connect(RTUCon1.yDXHeaCoi, pre4.u) annotation (Line(points={{102,172.2},{110,172.2},
          {110,130},{118,130}}, color={255,0,255}));
  connect(pre4.y, RTUCon1.uDXHeaCoi) annotation (Line(points={{142,130},{154,130},
          {154,200},{68,200},{68,181},{78,181}}, color={255,0,255}));
  connect(RTUCon1.uCooCoiAva, con2.y) annotation (Line(points={{78,178},{78,162},
          {64,162},{64,270},{42,270}}, color={255,0,255}));
  connect(RTUCon1.uHeaCoiAva, con2.y) annotation (Line(points={{78,175},{64,175},
          {64,270},{42,270}}, color={255,0,255}));
  connect(RTUCon1.uCooCoiSeq, conInt2.y) annotation (Line(points={{78,172},{60,172},
          {60,240},{42,240}}, color={255,127,0}));
  connect(RTUCon1.uHeaCoiSeq, conInt2.y) annotation (Line(points={{78,169},{78,152},
          {60,152},{60,240},{42,240}},      color={255,127,0}));
  connect(RTUCon2.yDXCooCoi, pre5.u) annotation (Line(points={{-58,-120},{-50,-120},
          {-50,-134},{-42,-134}},
          color={255,0,255}));
  connect(pre5.y, RTUCon2.uDXCooCoi) annotation (Line(points={{-18,-134},{-12,-134},
          {-12,-110},{-88,-110},{-88,-130},{-82,-130},{-82,-116}}, color={255,0,255}));
  connect(RTUCon2.yDXHeaCoi, pre6.u) annotation (Line(points={{-58,-127.8},{-50,
          -127.8},{-50,-170},{-42,-170}},
                                  color={255,0,255}));
  connect(pre6.y, RTUCon2.uDXHeaCoi) annotation (Line(points={{-18,-170},{-6,-170},
          {-6,-100},{-92,-100},{-92,-119},{-82,-119}}, color={255,0,255}));
  connect(RTUCon2.uCooCoiAva, con3.y) annotation (Line(points={{-82,-122},{-96,-122},
          {-96,-30},{-118,-30}}, color={255,0,255}));
  connect(RTUCon2.uHeaCoiAva, con3.y) annotation (Line(points={{-82,-125},{-96,-125},
          {-96,-30},{-118,-30}}, color={255,0,255}));
  connect(RTUCon2.uCooCoiSeq, conInt4.y) annotation (Line(points={{-82,-128},{-100,
          -128},{-100,-60},{-118,-60}}, color={255,127,0}));
  connect(RTUCon2.uHeaCoiSeq, conInt4.y) annotation (Line(points={{-82,-131},{-100,
          -131},{-100,-60},{-118,-60}},        color={255,127,0}));
  connect(RTUCon3.yDXCooCoi, pre7.u) annotation (Line(points={{102,-120},{118,-120},
          {118,-134}}, color={255,0,255}));
  connect(pre7.y, RTUCon3.uDXCooCoi) annotation (Line(points={{142,-134},{148,-134},
          {148,-110},{72,-110},{72,-130},{78,-130},{78,-116}}, color={255,0,255}));
  connect(RTUCon3.yDXHeaCoi, pre8.u) annotation (Line(points={{102,-127.8},{110,
          -127.8},{110,-170},{118,-170}},
                                  color={255,0,255}));
  connect(pre8.y, RTUCon3.uDXHeaCoi) annotation (Line(points={{142,-170},{154,-170},
          {154,-100},{68,-100},{68,-119},{78,-119}}, color={255,0,255}));
  connect(RTUCon3.uCooCoiAva, con4.y) annotation (Line(points={{78,-122},{64,-122},
          {64,-30},{42,-30}}, color={255,0,255}));
  connect(RTUCon3.uHeaCoiAva, con4.y) annotation (Line(points={{78,-125},{64,-125},
          {64,-30},{42,-30}}, color={255,0,255}));
  connect(RTUCon3.uCooCoiSeq, conInt6.y) annotation (Line(points={{78,-128},{60,
          -128},{60,-60},{42,-60}}, color={255,127,0}));
  connect(RTUCon3.uHeaCoiSeq, conInt6.y) annotation (Line(points={{78,-131},{70,
          -131},{70,-146},{60,-146},{60,-60},{42,-60}},   color={255,127,0}));

  connect(TSup.y, RTUCon.TSupCoiHea) annotation (Line(points={{-118,60},{-84,60},
          {-84,147},{-78,147}},       color={0,0,127}));
  connect(TSup.y, RTUCon.TSupCoiCoo) annotation (Line(points={{-118,60},{-84,60},
          {-84,144},{-78,144}},     color={0,0,127}));
  connect(TSupSet.y, RTUCon.TSupCoiSet) annotation (Line(points={{-118,30},{-80,
          30},{-80,141},{-78,141}},       color={0,0,127}));
  connect(TSup1.y, RTUCon1.TSupCoiHea) annotation (Line(points={{42,60},{74,60},
          {74,147},{78,147}}, color={0,0,127}));
  connect(TSup1.y, RTUCon1.TSupCoiCoo) annotation (Line(points={{42,60},{74,60},
          {74,144},{78,144}}, color={0,0,127}));
  connect(TSupSet1.y, RTUCon1.TSupCoiSet) annotation (Line(points={{42,30},{76,30},
          {76,141},{78,141}}, color={0,0,127}));
  connect(TSup2.y, RTUCon2.TSupCoiHea) annotation (Line(points={{-118,-240},{-86,
          -240},{-86,-153},{-82,-153}}, color={0,0,127}));
  connect(TSup2.y, RTUCon2.TSupCoiCoo) annotation (Line(points={{-118,-240},{-86,
          -240},{-86,-156},{-82,-156}}, color={0,0,127}));
  connect(TSupSet2.y, RTUCon2.TSupCoiSet) annotation (Line(points={{-118,-270},{
          -84,-270},{-84,-159},{-82,-159}}, color={0,0,127}));
  connect(TSup3.y, RTUCon3.TSupCoiHea) annotation (Line(points={{42,-240},{74,-240},
          {74,-153},{78,-153}}, color={0,0,127}));
  connect(TSup3.y, RTUCon3.TSupCoiCoo) annotation (Line(points={{42,-240},{74,-240},
          {74,-156},{78,-156}}, color={0,0,127}));
  connect(TSupSet3.y, RTUCon3.TSupCoiSet) annotation (Line(points={{42,-270},{76,
          -270},{76,-159},{78,-159}}, color={0,0,127}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/Validation/ControllerCooling.mos"
    "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.Controller\">
    Buildings.Controls.OBC.RooftopUnits.Controller</a>. 
    </p>
    <p>
    Simulation results are observed as follows: 
    <ul>
    <li>
    In Plot[1], when the coil valve position <code>RTUCon.uDXCooCoi</code> exceeds the threshold 
    <code>RTUCon.uThrCoi2</code> set at 0.8 for a duration of <code>RTUCon.timPer2</code> 
    amounting to 300 seconds, the controller initiates enabling the first available DX coil 
    <code>RTUCon.yDXCooCoi[1]=true</code>. 
    </li>
    <li>
    Compared to Plot[1], Plot[2] shows that when <code>RTUCon1.uDXCooCoi</code> surpasses
    0.8 for an additional duration of 480 seconds, the controller initiates staging up the 
    next DX coil <code>RTUCon1.yDXCooCoi[2]=true</code>. 
    </li>
    <li>
    Compared to Plot[2], Plot[3] illustrates that when <code>RTUCon2.uCooCoi</code> continually 
    exceeds 0.8 for an additional duration of 480 seconds, the controller initiates staging up 
    the next DX coil <code>RTUCon2.yDXCooCoi[3]=true</code>. 
    </li>
    <li>
    Compared to Plot[3], Plot[4] represents that upon the activation of the demand limit signal to Level 1 
    <code>RTUCon3.uDemLimLev=1</code>, the controller modifies the compressor speed 
    <code>RTUCon3.yComSpeCoo</code> to operate at 90% of its initial speed. 
    </li>
    </ul>
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    August 14, 2022, by Junke Wang and Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"),
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
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
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-300},{160,300}})));
end ControllerCooling;
