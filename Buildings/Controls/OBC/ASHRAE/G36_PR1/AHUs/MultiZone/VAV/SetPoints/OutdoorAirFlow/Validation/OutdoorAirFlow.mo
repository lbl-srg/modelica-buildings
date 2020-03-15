within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Validation;
model OutdoorAirFlow
  "Validate the sequences of setting minimum outdoor airflow rate"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone zon1(
    AFlo=40,
    have_winSen=false,
    desZonPop=4,
    minZonPriFlo=0.08) "Outdoor airflow related calculations for zone 1"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone zon2(
    AFlo=35,
    desZonPop=4,
    minZonPriFlo=0.08) "Outdoor airflow related calculations for zone 2"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone zon3(
    AFlo=30,
    desZonPop=3,
    minZonPriFlo=0.06) "Outdoor airflow related calculations for zone 3"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.System sys1(
    VPriSysMax_flow=0.6, peaSysPop=12)
    "System level minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{220,140},{240,160}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.System sys2(
    final VPriSysMax_flow=0.6, peaSysPop=12)
    "System level minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{220,70},{240,90}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone zonToSys(
    final numZon=3) "From zone to system"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Add two inputs"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add sumDesZonPop
    "Sum of the design zone population for all zones"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1 "Add two inputs"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add sumDesBreZonPop
    "Sum of the design breathing zone flow rate for population component"
    annotation (Placement(transformation(extent={{140,30},{160,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3 "Add two inputs"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add sumDesBreZonAre
    "Sum of the design breathing zone flow rate for area component"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min "Output smaller input"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Min desSysVenEff
    "Design system ventilation efficiency"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add sysUncOutAir
    "Uncorrected outdoor airflow"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4 "Add two inputs"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max "Output larger input"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Max maxPriOutAirFra
    "Maximum zone outdoor air fraction"
    annotation (Placement(transformation(extent={{140,-140},{160,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add5 "Add two inputs"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Add sysPriAirRate
    "System primary airflow rate"
    annotation (Placement(transformation(extent={{60,-170},{80,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Add zonVenEff1(final k2=-1)
    "Zone ventilation efficiency"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add zonVenEff2(final k2=-1)
    "Zone ventilation efficiency"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add zonVenEff3(final k2=-1)
    "Zone ventilation efficiency"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFan(k=true)
    "Status of supply fan"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc2(
    duration=3600,
    height=3)
    "Occupant number in zone 2"
    annotation (Placement(transformation(extent={{-260,150},{-240,170}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc3(
    duration=3600,
    height=3,
    startTime=900) "Occupant number in zone 3"
    annotation (Placement(transformation(extent={{-260,40},{-240,60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta(k=false)
    "Status of windows"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta1(period=3600)
    "Status of windows"
    annotation (Placement(transformation(extent={{-220,-100},{-200,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc4(
    duration=3600,
    startTime=900,
    height=2) "Occupant number"
    annotation (Placement(transformation(extent={{-260,-70},{-240,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-220,-70},{-200,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    height=6,
    offset=280.15,
    duration=3600) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-260,120},{-240,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis(
    height=4,
    duration=3600,
    offset=281.15) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-220,100},{-200,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonPriFloRat(k=0.1)
    "Measured primary flow rate at VAV box"
    annotation (Placement(transformation(extent={{-260,80},{-240,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonPriFloRat1(k=0.12)
    "Measured primary flow rate at VAV box"
    annotation (Placement(transformation(extent={{-260,-20},{-240,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonPriFloRat2(k=0.09)
    "Measured primary flow rate at VAV box"
    annotation (Placement(transformation(extent={{-260,-130},{-240,-110}})));

equation
  connect(zon1.yDesZonPeaOcc, zonToSys.uDesZonPeaOcc[1]) annotation (Line(
        points={{-78,139},{-60,139},{-60,156.667},{138,156.667}}, color={0,0,127}));
  connect(zon2.yDesZonPeaOcc, zonToSys.uDesZonPeaOcc[2]) annotation (Line(
        points={{-78,29},{-58,29},{-58,158},{138,158}}, color={0,0,127}));
  connect(zon3.yDesZonPeaOcc, zonToSys.uDesZonPeaOcc[3]) annotation (Line(
        points={{-78,-81},{-56,-81},{-56,159.333},{138,159.333}},   color={0,0,127}));
  connect(zon1.VDesPopBreZon_flow, zonToSys.VDesPopBreZon_flow[1]) annotation (
      Line(points={{-78,136},{-54,136},{-54,154.667},{138,154.667}}, color={0,0,127}));
  connect(zon2.VDesPopBreZon_flow, zonToSys.VDesPopBreZon_flow[2]) annotation (
      Line(points={{-78,26},{-52,26},{-52,156},{138,156}}, color={0,0,127}));
  connect(zon3.VDesPopBreZon_flow, zonToSys.VDesPopBreZon_flow[3]) annotation (
      Line(points={{-78,-84},{-50,-84},{-50,157.333},{138,157.333}},   color={0,0,127}));
  connect(zon1.VDesAreBreZon_flow, zonToSys.VDesAreBreZon_flow[1]) annotation (
      Line(points={{-78,133},{-48,133},{-48,152.667},{138,152.667}}, color={0,0,127}));
  connect(zon2.VDesAreBreZon_flow, zonToSys.VDesAreBreZon_flow[2]) annotation (
      Line(points={{-78,23},{-46,23},{-46,154},{138,154}}, color={0,0,127}));
  connect(zon3.VDesAreBreZon_flow, zonToSys.VDesAreBreZon_flow[3]) annotation (
      Line(points={{-78,-87},{-44,-87},{-44,155.333},{138,155.333}},   color={0,0,127}));
  connect(zon1.yDesPriOutAirFra, zonToSys.uDesPriOutAirFra[1]) annotation (Line(
        points={{-78,130},{-42,130},{-42,146.667},{138,146.667}}, color={0,0,127}));
  connect(zon2.yDesPriOutAirFra, zonToSys.uDesPriOutAirFra[2]) annotation (Line(
        points={{-78,20},{-40,20},{-40,148},{138,148}}, color={0,0,127}));
  connect(zon3.yDesPriOutAirFra, zonToSys.uDesPriOutAirFra[3]) annotation (Line(
        points={{-78,-90},{-38,-90},{-38,149.333},{138,149.333}},   color={0,0,127}));
  connect(zon1.VUncOutAir_flow, zonToSys.VUncOutAir_flow[1]) annotation (Line(
        points={{-78,127},{-36,127},{-36,144.667},{138,144.667}}, color={0,0,127}));
  connect(zon2.VUncOutAir_flow, zonToSys.VUncOutAir_flow[2]) annotation (Line(
        points={{-78,17},{-34,17},{-34,146},{138,146}}, color={0,0,127}));
  connect(zon3.VUncOutAir_flow, zonToSys.VUncOutAir_flow[3]) annotation (Line(
        points={{-78,-93},{-32,-93},{-32,147.333},{138,147.333}}, color={0,0,127}));
  connect(zon1.yPriOutAirFra, zonToSys.uPriOutAirFra[1]) annotation (Line(
        points={{-78,124},{-30,124},{-30,142.667},{138,142.667}}, color={0,0,127}));
  connect(zon2.yPriOutAirFra, zonToSys.uPriOutAirFra[2]) annotation (Line(
        points={{-78,14},{-28,14},{-28,144},{138,144}}, color={0,0,127}));
  connect(zon3.yPriOutAirFra, zonToSys.uPriOutAirFra[3]) annotation (Line(
        points={{-78,-96},{-26,-96},{-26,145.333},{138,145.333}}, color={0,0,127}));
  connect(zon1.VPriAir_flow, zonToSys.VPriAir_flow[1]) annotation (Line(points={{-78,121},
          {-24,121},{-24,140.667},{138,140.667}}, color={0,0,127}));
  connect(zon2.VPriAir_flow, zonToSys.VPriAir_flow[2]) annotation (Line(points={{-78,11},
          {-22,11},{-22,142},{138,142}}, color={0,0,127}));
  connect(zon3.VPriAir_flow, zonToSys.VPriAir_flow[3]) annotation (Line(points={{-78,-99},
          {-20,-99},{-20,143.333},{138,143.333}}, color={0,0,127}));
  connect(zonToSys.ySumDesZonPop, sys1.sumDesZonPop)
    annotation (Line(points={{162,159},{218,159}}, color={0,0,127}));
  connect(zonToSys.VSumDesPopBreZon_flow, sys1.VSumDesPopBreZon_flow)
    annotation (Line(points={{162,156},{180,156},{180,157},{218,157}}, color={0,
          0,127}));
  connect(zonToSys.VSumDesAreBreZon_flow, sys1.VSumDesAreBreZon_flow)
    annotation (Line(points={{162,153},{182,153},{182,155},{218,155}}, color={0,
          0,127}));
  connect(zonToSys.yDesSysVenEff, sys1.uDesSysVenEff) annotation (Line(points={{
          162,150},{184,150},{184,153},{218,153}}, color={0,0,127}));
  connect(zonToSys.VSumUncOutAir_flow, sys1.VSumUncOutAir_flow) annotation (
      Line(points={{162,147},{186,147},{186,151},{218,151}}, color={0,0,127}));
  connect(zonToSys.uOutAirFra_max, sys1.uOutAirFra_max) annotation (Line(points=
         {{162,144},{190,144},{190,147},{218,147}}, color={0,0,127}));
  connect(zonToSys.VSumSysPriAir_flow, sys1.VSumSysPriAir_flow) annotation (
      Line(points={{162,141},{188,141},{188,149},{218,149}}, color={0,0,127}));
  connect(add2.y, sumDesZonPop.u1) annotation (Line(points={{42,80},{50,80},{50,
          76},{58,76}}, color={0,0,127}));
  connect(add1.y, sumDesBreZonPop.u1) annotation (Line(points={{122,50},{130,50},
          {130,46},{138,46}}, color={0,0,127}));
  connect(add3.y, sumDesBreZonAre.u1) annotation (Line(points={{42,20},{50,20},{
          50,16},{58,16}}, color={0,0,127}));
  connect(zonVenEff1.y, min.u1) annotation (Line(points={{42,-20},{70,-20},{70,-14},
          {98,-14}}, color={0,0,127}));
  connect(zonVenEff2.y, min.u2) annotation (Line(points={{82,-40},{90,-40},{90,-26},
          {98,-26}}, color={0,0,127}));
  connect(min.y, desSysVenEff.u1) annotation (Line(points={{122,-20},{130,-20},{
          130,-34},{138,-34}}, color={0,0,127}));
  connect(zonVenEff3.y, desSysVenEff.u2) annotation (Line(points={{122,-60},{130,
          -60},{130,-46},{138,-46}}, color={0,0,127}));
  connect(add4.y, sysUncOutAir.u1) annotation (Line(points={{42,-80},{50,-80},{50,
          -84},{58,-84}}, color={0,0,127}));
  connect(max.y, maxPriOutAirFra.u1) annotation (Line(points={{122,-110},{130,-110},
          {130,-124},{138,-124}}, color={0,0,127}));
  connect(add5.y, sysPriAirRate.u1) annotation (Line(points={{42,-150},{50,-150},
          {50,-154},{58,-154}}, color={0,0,127}));
  connect(sumDesZonPop.y, sys2.sumDesZonPop) annotation (Line(points={{82,70},{140,
          70},{140,89},{218,89}}, color={0,0,127}));
  connect(sumDesBreZonPop.y, sys2.VSumDesPopBreZon_flow) annotation (Line(
        points={{162,40},{180,40},{180,87},{218,87}}, color={0,0,127}));
  connect(sumDesBreZonAre.y, sys2.VSumDesAreBreZon_flow) annotation (Line(
        points={{82,10},{182,10},{182,85},{218,85}}, color={0,0,127}));
  connect(desSysVenEff.y, sys2.uDesSysVenEff) annotation (Line(points={{162,-40},
          {184,-40},{184,83},{218,83}}, color={0,0,127}));
  connect(sysUncOutAir.y, sys2.VSumUncOutAir_flow) annotation (Line(points={{82,
          -90},{186,-90},{186,81},{218,81}}, color={0,0,127}));
  connect(maxPriOutAirFra.y, sys2.uOutAirFra_max) annotation (Line(points={{162,
          -130},{192,-130},{192,77},{218,77}}, color={0,0,127}));
  connect(sysPriAirRate.y, sys2.VSumSysPriAir_flow) annotation (Line(points={{82,
          -160},{188,-160},{188,79},{218,79}}, color={0,0,127}));
  connect(zon1.yDesZonPeaOcc, add2.u1) annotation (Line(points={{-78,139},{-60,139},
          {-60,86},{18,86}}, color={0,0,127}));
  connect(zon2.yDesZonPeaOcc, add2.u2) annotation (Line(points={{-78,29},{-58,29},
          {-58,74},{18,74}}, color={0,0,127}));
  connect(zon3.yDesZonPeaOcc, sumDesZonPop.u2) annotation (Line(points={{-78,-81},
          {-56,-81},{-56,64},{58,64}}, color={0,0,127}));
  connect(zon1.VDesPopBreZon_flow, add1.u1) annotation (Line(points={{-78,136},{
          -54,136},{-54,56},{98,56}}, color={0,0,127}));
  connect(zon2.VDesPopBreZon_flow, add1.u2) annotation (Line(points={{-78,26},{-52,
          26},{-52,44},{98,44}}, color={0,0,127}));
  connect(zon3.VDesPopBreZon_flow, sumDesBreZonPop.u2) annotation (Line(points={
          {-78,-84},{-50,-84},{-50,34},{138,34}}, color={0,0,127}));
  connect(zon1.VDesAreBreZon_flow, add3.u1) annotation (Line(points={{-78,133},{
          -48,133},{-48,26},{18,26}}, color={0,0,127}));
  connect(zon2.VDesAreBreZon_flow, add3.u2) annotation (Line(points={{-78,23},{-46,
          23},{-46,14},{18,14}}, color={0,0,127}));
  connect(zon3.VDesAreBreZon_flow, sumDesBreZonAre.u2) annotation (Line(points={
          {-78,-87},{-44,-87},{-44,4},{58,4}}, color={0,0,127}));
  connect(zon1.yDesPriOutAirFra, zonVenEff1.u2) annotation (Line(points={{-78,130},
          {-42,130},{-42,-26},{18,-26}}, color={0,0,127}));
  connect(zon2.yDesPriOutAirFra, zonVenEff2.u2) annotation (Line(points={{-78,20},
          {-40,20},{-40,-46},{58,-46}}, color={0,0,127}));
  connect(zon3.yDesPriOutAirFra, zonVenEff3.u2) annotation (Line(points={{-78,-90},
          {-38,-90},{-38,-66},{98,-66}}, color={0,0,127}));
  connect(zon1.yPriOutAirFra, max.u1) annotation (Line(points={{-78,124},{-30,124},
          {-30,-104},{98,-104}}, color={0,0,127}));
  connect(zon2.yPriOutAirFra, max.u2) annotation (Line(points={{-78,14},{-28,14},
          {-28,-116},{98,-116}}, color={0,0,127}));
  connect(zon3.yPriOutAirFra, maxPriOutAirFra.u2) annotation (Line(points={{-78,
          -96},{-26,-96},{-26,-136},{138,-136}}, color={0,0,127}));
  connect(zon1.VUncOutAir_flow, add4.u1) annotation (Line(points={{-78,127},{-36,
          127},{-36,-74},{18,-74}}, color={0,0,127}));
  connect(zon2.VUncOutAir_flow, add4.u2) annotation (Line(points={{-78,17},{-34,
          17},{-34,-86},{18,-86}}, color={0,0,127}));
  connect(zon3.VUncOutAir_flow, sysUncOutAir.u2) annotation (Line(points={{-78,-93},
          {-32,-93},{-32,-96},{58,-96}}, color={0,0,127}));
  connect(zon1.VPriAir_flow, add5.u1) annotation (Line(points={{-78,121},{-24,121},
          {-24,-144},{18,-144}}, color={0,0,127}));
  connect(zon2.VPriAir_flow, add5.u2) annotation (Line(points={{-78,11},{-22,11},
          {-22,-156},{18,-156}}, color={0,0,127}));
  connect(zon3.VPriAir_flow, sysPriAirRate.u2) annotation (Line(points={{-78,-99},
          {-20,-99},{-20,-166},{58,-166}}, color={0,0,127}));
  connect(sys2.yAveOutAirFraPlu, zonVenEff1.u1) annotation (Line(points={{242,85},
          {250,85},{250,100},{0,100},{0,-14},{18,-14}}, color={0,0,127}));
  connect(sys2.yAveOutAirFraPlu, zonVenEff2.u1) annotation (Line(points={{242,85},
          {250,85},{250,100},{0,100},{0,-34},{58,-34}}, color={0,0,127}));
  connect(sys2.yAveOutAirFraPlu, zonVenEff3.u1) annotation (Line(points={{242,85},
          {250,85},{250,100},{0,100},{0,-54},{98,-54}}, color={0,0,127}));
  connect(sys1.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
        points={{242,155},{250,155},{250,170},{120,170},{120,152},{138,152}},
        color={0,0,127}));
  connect(supFan.y, sys1.uSupFan) annotation (Line(points={{62,120},{80,120},{80,
          136},{200,136},{200,143},{218,143}}, color={255,0,255}));
  connect(supFan.y, sys2.uSupFan) annotation (Line(points={{62,120},{80,120},{80,
          136},{200,136},{200,73},{218,73}}, color={255,0,255}));
  connect(opeMod.y, sys1.uOpeMod) annotation (Line(points={{122,120},{202,120},{
          202,141},{218,141}}, color={255,127,0}));
  connect(opeMod.y, sys2.uOpeMod) annotation (Line(points={{122,120},{202,120},{
          202,71},{218,71}}, color={255,127,0}));
  connect(sys1.yReqOutAir, zon1.uReqOutAir) annotation (Line(points={{242,142},{
          260,142},{260,174},{-120,174},{-120,133},{-102,133}}, color={255,0,255}));
  connect(sys1.yReqOutAir, zon2.uReqOutAir) annotation (Line(points={{242,142},{
          260,142},{260,174},{-120,174},{-120,23},{-102,23}}, color={255,0,255}));
  connect(sys1.yReqOutAir, zon3.uReqOutAir) annotation (Line(points={{242,142},{
          260,142},{260,174},{-120,174},{-120,-87},{-102,-87}}, color={255,0,255}));
  connect(numOfOcc2.y,reaToInt1. u) annotation (Line(points={{-238,160},{-222,160}},
          color={0,0,127}));
  connect(numOfOcc3.y, reaToInt2.u)
    annotation (Line(points={{-238,50},{-222,50}}, color={0,0,127}));
  connect(reaToInt1.y, zon1.nOcc) annotation (Line(points={{-198,160},{-180,160},
          {-180,139},{-102,139}}, color={255,127,0}));
  connect(reaToInt2.y, zon2.nOcc) annotation (Line(points={{-198,50},{-180,50},{
          -180,29},{-102,29}}, color={255,127,0}));
  connect(numOfOcc4.y, reaToInt3.u)
    annotation (Line(points={{-238,-60},{-222,-60}}, color={0,0,127}));
  connect(reaToInt3.y, zon3.nOcc) annotation (Line(points={{-198,-60},{-180,-60},
          {-180,-81},{-102,-81}}, color={255,127,0}));
  connect(winSta1.y, zon3.uWin) annotation (Line(points={{-198,-90},{-180,-90},{
          -180,-84},{-102,-84}}, color={255,0,255}));
  connect(winSta.y, zon2.uWin) annotation (Line(points={{-198,20},{-180,20},{-180,
          26},{-102,26}}, color={255,0,255}));
  connect(TZon.y, zon1.TZon) annotation (Line(points={{-238,130},{-176,130},{-176,
          130},{-102,130}}, color={0,0,127}));
  connect(TZon.y, zon2.TZon) annotation (Line(points={{-238,130},{-174,130},{-174,
          20},{-102,20}}, color={0,0,127}));
  connect(TZon.y, zon3.TZon) annotation (Line(points={{-238,130},{-174,130},{-174,
          -90},{-102,-90}}, color={0,0,127}));
  connect(TDis.y, zon1.TDis) annotation (Line(points={{-198,110},{-170,110},{-170,
          127},{-102,127}}, color={0,0,127}));
  connect(TDis.y, zon2.TDis) annotation (Line(points={{-198,110},{-170,110},{-170,
          17},{-102,17}}, color={0,0,127}));
  connect(TDis.y, zon3.TDis) annotation (Line(points={{-198,110},{-170,110},{-170,
          -93},{-102,-93}}, color={0,0,127}));
  connect(zonPriFloRat2.y, zon3.VDis_flow) annotation (Line(points={{-238,-120},
          {-166,-120},{-166,-96},{-102,-96}}, color={0,0,127}));
  connect(zonPriFloRat1.y, zon2.VDis_flow) annotation (Line(points={{-238,-10},{
          -166,-10},{-166,14},{-102,14}}, color={0,0,127}));
  connect(zonPriFloRat.y, zon1.VDis_flow) annotation (Line(points={{-238,90},{-166,
          90},{-166,124},{-102,124}}, color={0,0,127}));
  connect(sys1.VDesUncOutAir_flow, zon1.VUncOut_flow_nominal) annotation (Line(
        points={{242,158},{246,158},{246,168},{-116,168},{-116,121},{-102,121}},
        color={0,0,127}));
  connect(sys1.VDesUncOutAir_flow, zon2.VUncOut_flow_nominal) annotation (Line(
        points={{242,158},{246,158},{246,168},{-116,168},{-116,11},{-102,11}},
        color={0,0,127}));
  connect(sys1.VDesUncOutAir_flow, zon3.VUncOut_flow_nominal) annotation (Line(
        points={{242,158},{246,158},{246,168},{-116,168},{-116,-99},{-102,-99}},
        color={0,0,127}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/SetPoints/OutdoorAirFlow/Validation/OutdoorAirFlow.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example shows how to compose the subsequences to find the minimum outdoor
airflow rate and validates the implementation.
</p>
</html>", revisions="<html>
<ul>
<li>
March 14, 2020, by Jianjun Hu:<br/>
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
    Diagram(coordinateSystem(extent={{-280,-180},{280,180}})));
end OutdoorAirFlow;
