within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Validation;
model OutdoorAirFlow
  "Validate the sequences of setting AHU level minimum outdoor airflow rate"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone zon1(
    AFlo=40,
    have_winSen=false,
    desZonPop=4,
    minZonPriFlo=0.08) "Outdoor airflow related calculations for zone 1"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone zon2(
    AFlo=35,
    desZonPop=4,
    minZonPriFlo=0.08) "Outdoor airflow related calculations for zone 2"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone zon3(
    AFlo=30,
    desZonPop=3,
    minZonPriFlo=0.06) "Outdoor airflow related calculations for zone 3"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU
    ahu1(VPriSysMax_flow=0.6, peaSysPop=12)
    "AHU level minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{220,220},{240,240}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU
    ahu2(final VPriSysMax_flow=0.6, peaSysPop=12)
    "AHU level minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{220,60},{240,80}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone zonToAhu(
    final numZon=3) "From zone level to AHU level"
    annotation (Placement(transformation(extent={{140,220},{160,240}})));

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
    annotation (Placement(transformation(extent={{40,150},{60,170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{100,150},{120,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc2(
    duration=3600,
    height=3)
    "Occupant number in zone 2"
    annotation (Placement(transformation(extent={{-260,190},{-240,210}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc3(
    duration=3600,
    height=3,
    startTime=900) "Occupant number in zone 3"
    annotation (Placement(transformation(extent={{-260,50},{-240,70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-220,50},{-200,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta(k=false)
    "Status of windows"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta1(period=3600)
    "Status of windows"
    annotation (Placement(transformation(extent={{-220,-120},{-200,-100}})));
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
    annotation (Placement(transformation(extent={{-260,150},{-240,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis(
    height=4,
    duration=3600,
    offset=281.15) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-220,130},{-200,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonPriFloRat(k=0.1)
    "Measured primary flow rate at VAV box"
    annotation (Placement(transformation(extent={{-260,100},{-240,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonPriFloRat1(k=0.12)
    "Measured primary flow rate at VAV box"
    annotation (Placement(transformation(extent={{-260,-20},{-240,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonPriFloRat2(k=0.09)
    "Measured primary flow rate at VAV box"
    annotation (Placement(transformation(extent={{-260,-150},{-240,-130}})));

equation
  connect(zon1.yDesZonPeaOcc,zonToAhu. uDesZonPeaOcc[1]) annotation (Line(
        points={{-98,139},{-80,139},{-80,236.667},{138,236.667}}, color={0,0,127}));
  connect(zon2.yDesZonPeaOcc,zonToAhu. uDesZonPeaOcc[2]) annotation (Line(
        points={{-98,29},{-74,29},{-74,238},{138,238}}, color={0,0,127}));
  connect(zon3.yDesZonPeaOcc,zonToAhu. uDesZonPeaOcc[3]) annotation (Line(
        points={{-98,-81},{-68,-81},{-68,239.333},{138,239.333}},   color={0,0,127}));
  connect(zon1.VDesPopBreZon_flow,zonToAhu. VDesPopBreZon_flow[1]) annotation (
      Line(points={{-98,136},{-64,136},{-64,234.667},{138,234.667}}, color={0,0,127}));
  connect(zon2.VDesPopBreZon_flow,zonToAhu. VDesPopBreZon_flow[2]) annotation (
      Line(points={{-98,26},{-60,26},{-60,236},{138,236}}, color={0,0,127}));
  connect(zon3.VDesPopBreZon_flow,zonToAhu. VDesPopBreZon_flow[3]) annotation (
      Line(points={{-98,-84},{-56,-84},{-56,237.333},{138,237.333}},   color={0,0,127}));
  connect(zon1.VDesAreBreZon_flow,zonToAhu. VDesAreBreZon_flow[1]) annotation (
      Line(points={{-98,133},{-52,133},{-52,232.667},{138,232.667}}, color={0,0,127}));
  connect(zon2.VDesAreBreZon_flow,zonToAhu. VDesAreBreZon_flow[2]) annotation (
      Line(points={{-98,23},{-48,23},{-48,234},{138,234}}, color={0,0,127}));
  connect(zon3.VDesAreBreZon_flow,zonToAhu. VDesAreBreZon_flow[3]) annotation (
      Line(points={{-98,-87},{-44,-87},{-44,235.333},{138,235.333}},   color={0,0,127}));
  connect(zon1.yDesPriOutAirFra,zonToAhu. uDesPriOutAirFra[1]) annotation (Line(
        points={{-98,130},{-42,130},{-42,226.667},{138,226.667}}, color={0,0,127}));
  connect(zon2.yDesPriOutAirFra,zonToAhu. uDesPriOutAirFra[2]) annotation (Line(
        points={{-98,20},{-40,20},{-40,228},{138,228}}, color={0,0,127}));
  connect(zon3.yDesPriOutAirFra,zonToAhu. uDesPriOutAirFra[3]) annotation (Line(
        points={{-98,-90},{-38,-90},{-38,229.333},{138,229.333}},   color={0,0,127}));
  connect(zon1.VUncOutAir_flow,zonToAhu. VUncOutAir_flow[1]) annotation (Line(
        points={{-98,127},{-36,127},{-36,224.667},{138,224.667}}, color={0,0,127}));
  connect(zon2.VUncOutAir_flow,zonToAhu. VUncOutAir_flow[2]) annotation (Line(
        points={{-98,17},{-34,17},{-34,226},{138,226}}, color={0,0,127}));
  connect(zon3.VUncOutAir_flow,zonToAhu. VUncOutAir_flow[3]) annotation (Line(
        points={{-98,-93},{-32,-93},{-32,227.333},{138,227.333}}, color={0,0,127}));
  connect(zon1.yPriOutAirFra,zonToAhu. uPriOutAirFra[1]) annotation (Line(
        points={{-98,124},{-30,124},{-30,222.667},{138,222.667}}, color={0,0,127}));
  connect(zon2.yPriOutAirFra,zonToAhu. uPriOutAirFra[2]) annotation (Line(
        points={{-98,14},{-26,14},{-26,224},{138,224}}, color={0,0,127}));
  connect(zon3.yPriOutAirFra,zonToAhu. uPriOutAirFra[3]) annotation (Line(
        points={{-98,-96},{-22,-96},{-22,225.333},{138,225.333}}, color={0,0,127}));
  connect(zon1.VPriAir_flow,zonToAhu. VPriAir_flow[1]) annotation (Line(points={{-98,121},
          {-18,121},{-18,220.667},{138,220.667}}, color={0,0,127}));
  connect(zon2.VPriAir_flow,zonToAhu. VPriAir_flow[2]) annotation (Line(points={{-98,11},
          {-14,11},{-14,222},{138,222}}, color={0,0,127}));
  connect(zon3.VPriAir_flow,zonToAhu. VPriAir_flow[3]) annotation (Line(points={{-98,-99},
          {-10,-99},{-10,223.333},{138,223.333}}, color={0,0,127}));
  connect(zonToAhu.ySumDesZonPop,ahu1. sumDesZonPop)
    annotation (Line(points={{162,239},{218,239}}, color={0,0,127}));
  connect(zonToAhu.VSumDesPopBreZon_flow,ahu1. VSumDesPopBreZon_flow)
    annotation (Line(points={{162,236},{180,236},{180,237},{218,237}}, color={0,
          0,127}));
  connect(zonToAhu.VSumDesAreBreZon_flow,ahu1. VSumDesAreBreZon_flow)
    annotation (Line(points={{162,233},{182,233},{182,235},{218,235}}, color={0,
          0,127}));
  connect(zonToAhu.yDesSysVenEff,ahu1. uDesSysVenEff) annotation (Line(points={{162,230},
          {184,230},{184,233},{218,233}},          color={0,0,127}));
  connect(zonToAhu.VSumUncOutAir_flow,ahu1. VSumUncOutAir_flow) annotation (
      Line(points={{162,227},{186,227},{186,231},{218,231}}, color={0,0,127}));
  connect(zonToAhu.uOutAirFra_max,ahu1. uOutAirFra_max) annotation (Line(points={{162,224},
          {190,224},{190,227},{218,227}},           color={0,0,127}));
  connect(zonToAhu.VSumSysPriAir_flow,ahu1. VSumSysPriAir_flow) annotation (
      Line(points={{162,221},{188,221},{188,229},{218,229}}, color={0,0,127}));
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
  connect(sumDesZonPop.y,ahu2. sumDesZonPop) annotation (Line(points={{82,70},{
          100,70},{100,79},{218,79}},
                                  color={0,0,127}));
  connect(sumDesBreZonPop.y,ahu2. VSumDesPopBreZon_flow) annotation (Line(
        points={{162,40},{180,40},{180,77},{218,77}}, color={0,0,127}));
  connect(sumDesBreZonAre.y,ahu2. VSumDesAreBreZon_flow) annotation (Line(
        points={{82,10},{182,10},{182,75},{218,75}}, color={0,0,127}));
  connect(desSysVenEff.y,ahu2. uDesSysVenEff) annotation (Line(points={{162,-40},
          {184,-40},{184,73},{218,73}}, color={0,0,127}));
  connect(sysUncOutAir.y,ahu2. VSumUncOutAir_flow) annotation (Line(points={{82,-90},
          {186,-90},{186,71},{218,71}},      color={0,0,127}));
  connect(maxPriOutAirFra.y,ahu2. uOutAirFra_max) annotation (Line(points={{162,
          -130},{192,-130},{192,67},{218,67}}, color={0,0,127}));
  connect(sysPriAirRate.y,ahu2. VSumSysPriAir_flow) annotation (Line(points={{82,-160},
          {188,-160},{188,69},{218,69}},       color={0,0,127}));
  connect(zon1.yDesZonPeaOcc, add2.u1) annotation (Line(points={{-98,139},{-80,139},
          {-80,86},{18,86}}, color={0,0,127}));
  connect(zon2.yDesZonPeaOcc, add2.u2) annotation (Line(points={{-98,29},{-74,29},
          {-74,74},{18,74}}, color={0,0,127}));
  connect(zon3.yDesZonPeaOcc, sumDesZonPop.u2) annotation (Line(points={{-98,-81},
          {-68,-81},{-68,64},{58,64}}, color={0,0,127}));
  connect(zon1.VDesPopBreZon_flow, add1.u1) annotation (Line(points={{-98,136},{
          -64,136},{-64,56},{98,56}}, color={0,0,127}));
  connect(zon2.VDesPopBreZon_flow, add1.u2) annotation (Line(points={{-98,26},{-60,
          26},{-60,44},{98,44}}, color={0,0,127}));
  connect(zon3.VDesPopBreZon_flow, sumDesBreZonPop.u2) annotation (Line(points={{-98,-84},
          {-56,-84},{-56,34},{138,34}},           color={0,0,127}));
  connect(zon1.VDesAreBreZon_flow, add3.u1) annotation (Line(points={{-98,133},{
          -52,133},{-52,26},{18,26}}, color={0,0,127}));
  connect(zon2.VDesAreBreZon_flow, add3.u2) annotation (Line(points={{-98,23},{-48,
          23},{-48,14},{18,14}}, color={0,0,127}));
  connect(zon3.VDesAreBreZon_flow, sumDesBreZonAre.u2) annotation (Line(points={{-98,-87},
          {-44,-87},{-44,4},{58,4}},           color={0,0,127}));
  connect(zon1.yDesPriOutAirFra, zonVenEff1.u2) annotation (Line(points={{-98,130},
          {-42,130},{-42,-26},{18,-26}}, color={0,0,127}));
  connect(zon2.yDesPriOutAirFra, zonVenEff2.u2) annotation (Line(points={{-98,20},
          {-40,20},{-40,-46},{58,-46}}, color={0,0,127}));
  connect(zon3.yDesPriOutAirFra, zonVenEff3.u2) annotation (Line(points={{-98,-90},
          {-38,-90},{-38,-66},{98,-66}}, color={0,0,127}));
  connect(zon1.yPriOutAirFra, max.u1) annotation (Line(points={{-98,124},{-30,124},
          {-30,-104},{98,-104}}, color={0,0,127}));
  connect(zon2.yPriOutAirFra, max.u2) annotation (Line(points={{-98,14},{-26,14},
          {-26,-116},{98,-116}}, color={0,0,127}));
  connect(zon3.yPriOutAirFra, maxPriOutAirFra.u2) annotation (Line(points={{-98,-96},
          {-22,-96},{-22,-136},{138,-136}},      color={0,0,127}));
  connect(zon1.VUncOutAir_flow, add4.u1) annotation (Line(points={{-98,127},{-36,
          127},{-36,-74},{18,-74}}, color={0,0,127}));
  connect(zon2.VUncOutAir_flow, add4.u2) annotation (Line(points={{-98,17},{-34,
          17},{-34,-86},{18,-86}}, color={0,0,127}));
  connect(zon3.VUncOutAir_flow, sysUncOutAir.u2) annotation (Line(points={{-98,-93},
          {-32,-93},{-32,-96},{58,-96}}, color={0,0,127}));
  connect(zon1.VPriAir_flow, add5.u1) annotation (Line(points={{-98,121},{-18,121},
          {-18,-144},{18,-144}}, color={0,0,127}));
  connect(zon2.VPriAir_flow, add5.u2) annotation (Line(points={{-98,11},{-14,11},
          {-14,-156},{18,-156}}, color={0,0,127}));
  connect(zon3.VPriAir_flow, sysPriAirRate.u2) annotation (Line(points={{-98,-99},
          {-10,-99},{-10,-166},{58,-166}}, color={0,0,127}));
  connect(ahu2.yAveOutAirFraPlu, zonVenEff1.u1) annotation (Line(points={{242,75},
          {250,75},{250,100},{0,100},{0,-14},{18,-14}}, color={0,0,127}));
  connect(ahu2.yAveOutAirFraPlu, zonVenEff2.u1) annotation (Line(points={{242,75},
          {250,75},{250,100},{0,100},{0,-34},{58,-34}}, color={0,0,127}));
  connect(ahu2.yAveOutAirFraPlu, zonVenEff3.u1) annotation (Line(points={{242,75},
          {250,75},{250,100},{0,100},{0,-54},{98,-54}}, color={0,0,127}));
  connect(ahu1.yAveOutAirFraPlu,zonToAhu. yAveOutAirFraPlu) annotation (Line(
        points={{242,235},{250,235},{250,250},{120,250},{120,232},{138,232}},
        color={0,0,127}));
  connect(supFan.y,ahu1. uSupFan) annotation (Line(points={{62,160},{80,160},{
          80,180},{200,180},{200,223},{218,223}},
                                               color={255,0,255}));
  connect(supFan.y,ahu2. uSupFan) annotation (Line(points={{62,160},{80,160},{
          80,180},{200,180},{200,63},{218,63}},
                                             color={255,0,255}));
  connect(opeMod.y,ahu1. uOpeMod) annotation (Line(points={{122,160},{202,160},
          {202,221},{218,221}},color={255,127,0}));
  connect(opeMod.y,ahu2. uOpeMod) annotation (Line(points={{122,160},{202,160},
          {202,61},{218,61}},color={255,127,0}));
  connect(ahu1.yReqOutAir, zon1.uReqOutAir) annotation (Line(points={{242,222},{
          260,222},{260,254},{-160,254},{-160,133},{-122,133}}, color={255,0,255}));
  connect(ahu1.yReqOutAir, zon2.uReqOutAir) annotation (Line(points={{242,222},{
          260,222},{260,254},{-160,254},{-160,23},{-122,23}}, color={255,0,255}));
  connect(ahu1.yReqOutAir, zon3.uReqOutAir) annotation (Line(points={{242,222},{
          260,222},{260,254},{-160,254},{-160,-87},{-122,-87}}, color={255,0,255}));
  connect(numOfOcc2.y,reaToInt1. u) annotation (Line(points={{-238,200},{-222,
          200}},
          color={0,0,127}));
  connect(numOfOcc3.y, reaToInt2.u)
    annotation (Line(points={{-238,60},{-222,60}}, color={0,0,127}));
  connect(reaToInt1.y, zon1.nOcc) annotation (Line(points={{-198,200},{-166,200},
          {-166,139},{-122,139}}, color={255,127,0}));
  connect(reaToInt2.y, zon2.nOcc) annotation (Line(points={{-198,60},{-180,60},
          {-180,29},{-122,29}},color={255,127,0}));
  connect(numOfOcc4.y, reaToInt3.u)
    annotation (Line(points={{-238,-60},{-222,-60}}, color={0,0,127}));
  connect(reaToInt3.y, zon3.nOcc) annotation (Line(points={{-198,-60},{-180,-60},
          {-180,-81},{-122,-81}}, color={255,127,0}));
  connect(winSta1.y, zon3.uWin) annotation (Line(points={{-198,-110},{-180,-110},
          {-180,-84},{-122,-84}},color={255,0,255}));
  connect(winSta.y, zon2.uWin) annotation (Line(points={{-198,20},{-180,20},{-180,
          26},{-122,26}}, color={255,0,255}));
  connect(TZon.y, zon1.TZon) annotation (Line(points={{-238,160},{-174,160},{
          -174,130},{-122,130}},
                            color={0,0,127}));
  connect(TZon.y, zon2.TZon) annotation (Line(points={{-238,160},{-174,160},{
          -174,20},{-122,20}},
                          color={0,0,127}));
  connect(TZon.y, zon3.TZon) annotation (Line(points={{-238,160},{-174,160},{
          -174,-90},{-122,-90}},
                            color={0,0,127}));
  connect(TDis.y, zon1.TDis) annotation (Line(points={{-198,140},{-170,140},{
          -170,127},{-122,127}},
                            color={0,0,127}));
  connect(TDis.y, zon2.TDis) annotation (Line(points={{-198,140},{-170,140},{
          -170,17},{-122,17}},
                          color={0,0,127}));
  connect(TDis.y, zon3.TDis) annotation (Line(points={{-198,140},{-170,140},{
          -170,-93},{-122,-93}},
                            color={0,0,127}));
  connect(zonPriFloRat2.y, zon3.VDis_flow) annotation (Line(points={{-238,-140},
          {-166,-140},{-166,-96},{-122,-96}}, color={0,0,127}));
  connect(zonPriFloRat1.y, zon2.VDis_flow) annotation (Line(points={{-238,-10},{
          -166,-10},{-166,14},{-122,14}}, color={0,0,127}));
  connect(zonPriFloRat.y, zon1.VDis_flow) annotation (Line(points={{-238,110},{
          -166,110},{-166,124},{-122,124}},
                                      color={0,0,127}));
  connect(ahu1.VDesUncOutAir_flow, zon1.VUncOut_flow_nominal) annotation (Line(
        points={{242,238},{246,238},{246,248},{-154,248},{-154,121},{-122,121}},
        color={0,0,127}));
  connect(ahu1.VDesUncOutAir_flow, zon2.VUncOut_flow_nominal) annotation (Line(
        points={{242,238},{246,238},{246,248},{-154,248},{-154,11},{-122,11}},
        color={0,0,127}));
  connect(ahu1.VDesUncOutAir_flow, zon3.VUncOut_flow_nominal) annotation (Line(
        points={{242,238},{246,238},{246,248},{-154,248},{-154,-99},{-122,-99}},
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
    Diagram(coordinateSystem(extent={{-280,-260},{280,260}}), graphics={
        Rectangle(
          extent={{2,118},{198,-238}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{4,-178},{190,-192}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Demonstrate how to use the outputs from zone level calculation
as the inputs for the AHU level calculation."),
        Text(
          extent={{4,-218},{190,-232}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="This explicitly shows the implemetation of class
AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone")}));
end OutdoorAirFlow;
