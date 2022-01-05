within Buildings.Examples.ChillerPlants.RP1711.BaseClasses;
model RP1711_test "Chiller plant model with RP1711 controller"

  extends
    Buildings.Examples.ChillerPlants.RP1711.BaseClasses.PartialChillerPlant(
      mChi_flow_nominal=10,
      mCon_flow_nominal=10);
//   parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal = 10
//     "Nominal mass flow rate in chilled water loop";
//   parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal = 10
//     "Nominal mass flow rate in condenser water loop";
  parameter Modelica.Units.SI.TemperatureDifference dTChi = 7
    "Nominal chilled water supply and return temperature difference";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller chiPlaCon(
    final desCap=2*chiDesCap,
    final chiDesCap={chiDesCap,chiDesCap},
    final chiMinCap={chiDesCap*0.1,chiDesCap*0.1},
    final have_WSE=false,
    final nSenChiWatPum=1,
    final have_fixSpeConWatPum=true,
    final totSta=3,
    final staVec={0,1,2},
    final desConWatPumSpe={0,0.5,0.75},
    final desConWatPumNum={0,2,2},
    final towCelOnSet={0,2,2},
    final nTowCel=2,
    final dpChiWatPumMax={160000})
    annotation (Placement(transformation(extent={{-260,0},{-220,120}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold chiWatIso[2](
    final t=fill(0.025, 2),
    final h=fill(0.005, 2))
    "Chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-400,320},{-380,340}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold conWatIso[2](
    final t=fill(0.025, 2),
    final h=fill(0.005, 2))
    "Condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-400,280},{-380,300}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold chiSta[2](
    final t=fill(1, 2),
    final h=fill(0.5, 2))
    "Chiller status"
    annotation (Placement(transformation(extent={{-400,230},{-380,250}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](
    final k=fill(true, 2))
    "Constant true"
    annotation (Placement(transformation(extent={{-400,110},{-380,130}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold conWatPumSta[2](
    final t=fill(0.01, 2),
    final h=fill(0.005, 2))
    "Condenser water pump status"
    annotation (Placement(transformation(extent={{-400,150},{-380,170}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-570,30},{-550,50}}),
        iconTransformation(extent={{-120,160},{-100,180}})));
  Modelica.Blocks.Routing.RealPassThrough TOut(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0))
    annotation (Placement(transformation(extent={{-520,30},{-500,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[2]
    "Boolean to real"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro2[2]
    "Tower cells isolation valve position setpoint"
    annotation (Placement(transformation(extent={{20,210},{40,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro3[2]
    "Tower fan speed setpoint"
    annotation (Placement(transformation(extent={{20,280},{40,300}})));
  Modelica.Blocks.Routing.RealPassThrough TWetBul(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0)) "Outdoor wet bulb temperature"
    annotation (Placement(transformation(extent={{-520,70},{-500,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold chiWatPumSta[2](
    final t=fill(0.01, 2),
    final h=fill(0.005, 2))
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-400,-110},{-380,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold towSta[2](
    final t=fill(1, 2),
    final h=fill(0.5, 2)) "Cooling tower status"
    annotation (Placement(transformation(extent={{-400,-20},{-380,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conWatLev(
    final k=0.9) "Constant cooling tower water level"
    annotation (Placement(transformation(extent={{-520,-2},{-500,18}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax(
    final nin=2)
    annotation (Placement(transformation(extent={{-400,190},{-380,210}})));
  Modelica.Fluid.Interfaces.FluidPort_b portCooCoiSup(
    redeclare package Medium =MediumW) "Cooling coil loop supply"
    annotation (Placement(transformation(extent={{190,-370},{210,-350}}),
        iconTransformation(extent={{-130,-210},{-110,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_a portCooCoiRet(
    redeclare package Medium =MediumW)
    "Coolin coil loop return"
    annotation (Placement(transformation(extent={{430,-370},{450,-350}}),
        iconTransformation(extent={{110,-210},{130,-190}})));

  Fluid.Sources.MassFlowSource_T outAir(
    redeclare package Medium = Buildings.Media.Water,
    final m_flow=10,
    final use_T_in=false,
    nPorts=1,
    T=283.15) "Outdoor air"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={440,-410})));
  Fluid.Sources.Boundary_pT           sinAir(
    redeclare package Medium = Buildings.Media.Water,
    nPorts=1) "Air sink"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={200,-410})));
  Controls.OBC.CDL.Integers.Sources.Constant conInt4(final k=0) "Constant two"
    annotation (Placement(transformation(extent={{-540,-90},{-520,-70}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{-600,30},{-580,50}})));
  Controls.OBC.CDL.Continuous.Sources.Constant conWatLev1[2](final k=fill(
        273.15 + 7, 2)) "Constant cooling tower water level"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));
  Controls.OBC.CDL.Continuous.Sources.Constant conWatLev2[2](final k=fill(0.5,
        2)) "Constant cooling tower water level"
    annotation (Placement(transformation(extent={{-90,120},{-70,140}})));
  Controls.OBC.CDL.Logical.Sources.Constant           con1
                                                         [2](final k=fill(true,
        2))
    "Constant true"
    annotation (Placement(transformation(extent={{-52,122},{-32,142}})));
  Controls.OBC.CDL.Continuous.Sources.Constant conWatLev3[2](final k=fill(0.5,
        2)) "Constant cooling tower water level"
    annotation (Placement(transformation(extent={{-400,16},{-380,36}})));
  Controls.OBC.CDL.Continuous.Sources.Constant conWatLev4[2](final k=fill(
        273.15 + 7, 2)) "Constant cooling tower water level"
    annotation (Placement(transformation(extent={{-400,50},{-380,70}})));
  Controls.OBC.CDL.Continuous.Sources.Constant conWatLev5(final k=100000)
    "Constant cooling tower water level"
    annotation (Placement(transformation(extent={{-460,80},{-440,100}})));
  Controls.OBC.CDL.Continuous.Sources.Constant conWatLev6(final k=0.5)
    "Constant cooling tower water level"
    annotation (Placement(transformation(extent={{-400,-50},{-380,-30}})));
protected
  final parameter Modelica.Units.SI.SpecificHeatCapacity Cp = 4198
    "Water specific heat capacity";
  final parameter Modelica.Units.SI.HeatFlowRate chiDesCap = mChi_flow_nominal*dTChi*Cp
    "Chiller design capacity";

equation
  connect(chwIsoVal1.y_actual, chiWatIso[1].u) annotation (Line(points={{235,77},
          {100,77},{100,360},{-480,360},{-480,330},{-402,330}},       color={0,
          0,127}));
  connect(chwIsoVal2.y_actual, chiWatIso[2].u) annotation (Line(points={{235,-13},
          {220,-13},{220,-4},{100,-4},{100,360},{-480,360},{-480,330},{-402,330}},
                      color={0,0,127}));
  connect(cwIsoVal1.y_actual, conWatIso[1].u) annotation (Line(points={{385,107},
          {400,107},{400,130},{110,130},{110,370},{-500,370},{-500,290},{-402,290}},
                 color={0,0,127}));
  connect(cwIsoVal2.y_actual, conWatIso[2].u) annotation (Line(points={{385,17},
          {400,17},{400,40},{110,40},{110,370},{-500,370},{-500,290},{-402,290}},
                 color={0,0,127}));
  connect(chi2.P, chiSta[2].u) annotation (Line(points={{341,13},{352,13},{352,30},
          {90,30},{90,268},{-480,268},{-480,240},{-402,240}}, color={0,0,127}));
  connect(con.y, chiPlaCon.uChiAva) annotation (Line(points={{-378,120},{-370,
          120},{-370,54},{-264,54}},   color={255,0,255}));
  connect(conWatPum1.y_actual, conWatPumSta[1].u) annotation (Line(points={{207,189},
          {207,180},{-410,180},{-410,160},{-402,160}},      color={0,0,127}));
  connect(conWatPum2.y_actual, conWatPumSta[2].u) annotation (Line(points={{267,189},
          {267,180},{-410,180},{-410,160},{-402,160}},      color={0,0,127}));
  connect(weaBus.TDryBul, TOut.u)
          annotation (Line(points={{-560,40},{-522,40}},
      color={255,204,51},
      thickness=0.5));
  connect(TOut.y, chiPlaCon.TOut) annotation (Line(points={{-499,40},{-360,40},
          {-360,26},{-264,26}},   color={0,0,127}));
  connect(booToRea2.y, pro2.u2) annotation (Line(points={{-18,200},{0,200},{0,214},
          {18,214}},      color={0,0,127}));
  connect(booToRea2.y, pro3.u2) annotation (Line(points={{-18,200},{0,200},{0,284},
          {18,284}},      color={0,0,127}));
  connect(pro3[1].y, cooTow1.y) annotation (Line(points={{42,290},{70,290},{70,410},
          {350,410},{350,388},{342,388}},      color={0,0,127}));
  connect(pro3[2].y, cooTow2.y) annotation (Line(points={{42,290},{70,290},{70,340},
          {350,340},{350,318},{342,318}},      color={0,0,127}));
  connect(weaBus.TWetBul, TWetBul.u) annotation (Line(
      points={{-560,40},{-540,40},{-540,80},{-522,80}},
      color={255,204,51},
      thickness=0.5));
  connect(TWetBul.y, cooTow2.TAir) annotation (Line(points={{-499,80},{-490,80},
          {-490,350},{360,350},{360,314},{342,314}},      color={0,0,127}));
  connect(chiWatPum1.y_actual, chiWatPumSta[1].u) annotation (Line(points={{207,
          -123},{207,-130},{-410,-130},{-410,-100},{-402,-100}},
                                                            color={0,0,127}));
  connect(chiWatPum2.y_actual, chiWatPumSta[2].u) annotation (Line(points={{267,
          -123},{267,-130},{-410,-130},{-410,-100},{-402,-100}},
                                                            color={0,0,127}));
  connect(chiWatPumSta.y, chiPlaCon.uChiWatPum) annotation (Line(points={{-378,
          -100},{-286,-100},{-286,106},{-264,106}},
                                                  color={255,0,255}));
  connect(cooTow1.PFan, towSta[1].u) annotation (Line(points={{319,388},{-430,388},
          {-430,-10},{-402,-10}},      color={0,0,127}));
  connect(cooTow2.PFan, towSta[2].u) annotation (Line(points={{319,318},{300,318},
          {300,388},{-430,388},{-430,-10},{-402,-10}},      color={0,0,127}));
  connect(conWatLev.y, chiPlaCon.watLev) annotation (Line(points={{-498,8},{
          -380,8},{-380,6},{-264,6}},       color={0,0,127}));
  connect(chi1.P, chiSta[1].u) annotation (Line(points={{341,103},{350,103},{350,
          120},{90,120},{90,268},{-480,268},{-480,240},{-402,240}},     color={
          0,0,127}));
  connect(cooTow1.yFanSpe, mulMax.u[1]) annotation (Line(points={{318,384},{-420,
          384},{-420,201},{-402,201}},                      color={0,0,127}));
  connect(pro2[1].y, towIsoVal1.y) annotation (Line(points={{42,220},{80,220},{80,
          400},{380,400},{380,392}}, color={0,0,127}));
  connect(pro2[2].y, towIsoVal2.y) annotation (Line(points={{42,220},{80,220},{80,
          332},{380,332},{380,322}}, color={0,0,127}));
  connect(TWetBul.y, cooTow1.TAir) annotation (Line(points={{-499,80},{-490,80},
          {-490,350},{360,350},{360,384},{342,384}}, color={0,0,127}));
  connect(cooTow2.yFanSpe, mulMax.u[2]) annotation (Line(points={{318,314},{290,
          314},{290,384},{-420,384},{-420,199},{-402,199}}, color={0,0,127}));
  connect(jun10.port_2, portCooCoiSup) annotation (Line(
      points={{200,-230},{200,-360}},
      color={0,127,255},
      thickness=1));
  connect(res.port_a, portCooCoiRet) annotation (Line(
      points={{440,-310},{440,-360}},
      color={0,127,255},
      thickness=1));
  connect(jun10.port_2, senRelPre.port_a) annotation (Line(
      points={{200,-230},{200,-320},{320,-320}},
      color={0,127,255},
      thickness=1));
  connect(senRelPre.port_b, res.port_a) annotation (Line(
      points={{340,-320},{440,-320},{440,-310}},
      color={0,127,255},
      thickness=1));
  connect(outAir.ports[1], portCooCoiRet)
    annotation (Line(points={{440,-400},{440,-360}}, color={0,127,255}));
  connect(sinAir.ports[1], portCooCoiSup)
    annotation (Line(points={{200,-400},{200,-360}}, color={0,127,255}));
  connect(conInt4.y, chiPlaCon.TChiWatSupResReq) annotation (Line(points={{-518,
          -80},{-280,-80},{-280,42},{-264,42}}, color={255,127,0}));
  connect(conInt4.y, chiPlaCon.chiPlaReq) annotation (Line(points={{-518,-80},{
          -280,-80},{-280,38},{-264,38}}, color={255,127,0}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-580,40},{-560,40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(conWatLev1[1].y, chi1.TSet) annotation (Line(points={{-118,150},{-100,
          150},{-100,91},{318,91}}, color={0,0,127}));
  connect(conWatLev1[2].y, chi2.TSet) annotation (Line(points={{-118,150},{-100,
          150},{-100,1},{318,1}}, color={0,0,127}));
  connect(conWatLev2[1].y, chiWatPum1.y) annotation (Line(points={{-68,130},{
          -60,130},{-60,-96},{220,-96},{220,-112},{212,-112}}, color={0,0,127}));
  connect(conWatLev2[2].y, chiWatPum2.y) annotation (Line(points={{-68,130},{
          -60,130},{-60,-96},{280,-96},{280,-112},{272,-112}}, color={0,0,127}));
  connect(con1[1].y, chi1.on) annotation (Line(points={{-30,132},{-20,132},{-20,
          97},{318,97}}, color={255,0,255}));
  connect(con1[2].y, chi2.on) annotation (Line(points={{-30,132},{-20,132},{-20,
          7},{318,7}}, color={255,0,255}));
  connect(conWatLev2[1].y, cwIsoVal1.y) annotation (Line(points={{-68,130},{-60,
          130},{-60,148},{380,148},{380,112}}, color={0,0,127}));
  connect(conWatLev2[2].y, cwIsoVal2.y) annotation (Line(points={{-68,130},{-60,
          130},{-60,50},{380,50},{380,22}}, color={0,0,127}));
  connect(conWatLev2[1].y, conWatPum1.y) annotation (Line(points={{-68,130},{
          -60,130},{-60,174},{220,174},{220,200},{212,200}}, color={0,0,127}));
  connect(conWatLev2[2].y, conWatPum2.y) annotation (Line(points={{-68,130},{
          -60,130},{-60,174},{280,174},{280,200},{272,200}}, color={0,0,127}));
  connect(conWatLev2[1].y, chwIsoVal1.y) annotation (Line(points={{-68,130},{
          -60,130},{-60,82},{240,82}}, color={0,0,127}));
  connect(conWatLev2[2].y, chwIsoVal2.y) annotation (Line(points={{-68,130},{
          -60,130},{-60,-8},{240,-8}}, color={0,0,127}));
  connect(conWatLev2[1].y, valByp.y) annotation (Line(points={{-68,130},{-60,
          130},{-60,-208},{330,-208}}, color={0,0,127}));
  connect(conWatLev2.y, pro2.u1) annotation (Line(points={{-68,130},{-60,130},{
          -60,226},{18,226}}, color={0,0,127}));
  connect(con1.y, booToRea2.u) annotation (Line(points={{-30,132},{-22,132},{
          -22,166},{-70,166},{-70,200},{-42,200}}, color={255,0,255}));
  connect(conWatLev2.y, pro3.u1) annotation (Line(points={{-68,130},{-60,130},{
          -60,296},{18,296}}, color={0,0,127}));
  connect(con.y, chiPlaCon.uChiIsoVal) annotation (Line(points={{-378,120},{
          -370,120},{-370,102},{-264,102}}, color={255,0,255}));
  connect(con.y, chiPlaCon.uChiWatReq) annotation (Line(points={{-378,120},{
          -370,120},{-370,114},{-264,114}}, color={255,0,255}));
  connect(con.y, chiPlaCon.uConWatReq) annotation (Line(points={{-378,120},{
          -370,120},{-370,110},{-264,110}}, color={255,0,255}));
  connect(con.y, chiPlaCon.uChiConIsoVal) annotation (Line(points={{-378,120},{
          -370,120},{-370,118},{-264,118}}, color={255,0,255}));
  connect(con.y, chiPlaCon.uChiHeaCon) annotation (Line(points={{-378,120},{
          -370,120},{-370,50},{-264,50}}, color={255,0,255}));
  connect(con.y, chiPlaCon.uChi) annotation (Line(points={{-378,120},{-370,120},
          {-370,86},{-264,86}}, color={255,0,255}));
  connect(con.y, chiPlaCon.uConWatPum) annotation (Line(points={{-378,120},{
          -370,120},{-370,30},{-264,30}}, color={255,0,255}));
  connect(con.y, chiPlaCon.uTowSta) annotation (Line(points={{-378,120},{-370,
          120},{-370,2},{-264,2}}, color={255,0,255}));
  connect(conWatLev3.y, chiPlaCon.uIsoVal) annotation (Line(points={{-378,26},{
          -364,26},{-364,10},{-264,10}}, color={0,0,127}));
  connect(conWatLev3.y, chiPlaCon.uConWatPumSpe) annotation (Line(points={{-378,
          26},{-364,26},{-364,34},{-264,34}}, color={0,0,127}));
  connect(conWatLev3.y, chiPlaCon.uChiWatIsoVal) annotation (Line(points={{-378,
          26},{-364,26},{-364,46},{-264,46}}, color={0,0,127}));
  connect(conWatLev4[1].y, chiPlaCon.TChiWatSup) annotation (Line(points={{-378,
          60},{-340,60},{-340,66},{-264,66}}, color={0,0,127}));
  connect(conWatLev4[1].y, chiPlaCon.TConWatRet) annotation (Line(points={{-378,
          60},{-340,60},{-340,70},{-264,70}}, color={0,0,127}));
  connect(conWatLev4[1].y, chiPlaCon.TConWatSup) annotation (Line(points={{-378,
          60},{-340,60},{-340,14},{-264,14}}, color={0,0,127}));
  connect(conWatLev4[1].y, chiPlaCon.TChiWatRet) annotation (Line(points={{-378,
          60},{-340,60},{-340,74},{-264,74}}, color={0,0,127}));
  connect(conWatLev3[1].y, chiPlaCon.uFanSpe) annotation (Line(points={{-378,26},
          {-364,26},{-364,18},{-264,18}}, color={0,0,127}));
  connect(conWatLev5.y, chiPlaCon.dpChiWat_remote[1]) annotation (Line(points={
          {-438,90},{-380,90},{-380,94},{-264,94}}, color={0,0,127}));
  connect(conWatLev6.y, chiPlaCon.VChiWat_flow) annotation (Line(points={{-378,
          -40},{-350,-40},{-350,90},{-264,90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,200},
            {160,-200}}), graphics={
        Rectangle(
          extent={{-160,200},{160,-200}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-110,52},{-110,64},{-110,86},{-90,86},{-90,76}},
          color={238,46,47},
          thickness=0.5),
        Rectangle(extent={{-60,40},{60,0}},  lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(points={{100,34},{60,34}},  color={238,46,47},
          thickness=0.5),
        Polygon(
          points={{-4,7},{-4,1},{4,4},{-4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={75,30}),
        Polygon(
          points={{4,7},{4,1},{-4,4},{4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={83,30}),
        Line(points={{-60,6},{-120,6}},  color={28,108,200},
          thickness=0.5),
        Polygon(
          points={{-4,7},{-4,1},{4,4},{-4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-83,2}),
        Polygon(
          points={{4,7},{4,1},{-4,4},{4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-75,2}),
        Rectangle(extent={{-60,-20},{60,-60}},
                                             lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(points={{100,-26},{60,-26}},color={238,46,47},
          thickness=0.5),
        Polygon(
          points={{-4,7},{-4,1},{4,4},{-4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={75,-30}),
        Polygon(
          points={{4,7},{4,1},{-4,4},{4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={83,-30}),
        Line(points={{-60,-54},{-120,-54}},
                                         color={28,108,200},
          thickness=0.5),
        Polygon(
          points={{-4,7},{-4,1},{4,4},{-4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-83,-58}),
        Polygon(
          points={{4,7},{4,1},{-4,4},{4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-75,-58}),
        Rectangle(
          extent={{-48,178},{-16,120}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-35,178},{-30,171}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-32,172},{-48,168}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-16,172},{-32,168}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-48,130},{-16,130}},
          color={28,108,200},
          smooth=Smooth.Bezier,
          pattern=LinePattern.DashDot),
        Rectangle(
          extent={{16,178},{48,120}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{29,178},{34,171}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{32,172},{16,168}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{48,172},{32,168}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{16,130},{48,130}},
          color={28,108,200},
          smooth=Smooth.Bezier,
          pattern=LinePattern.DashDot),
        Line(
          points={{-48,164},{-58,164}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-58,164},{-58,112}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-60,34},{-100,34}},
          color={238,46,47},
          thickness=0.5),
        Ellipse(
          extent={{-116,76},{-104,64}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,-28},{-100,-28}},
          color={238,46,47},
          thickness=0.5),
        Polygon(
          points={{-116,70},{-104,70},{-110,64},{-116,70}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-96,76},{-84,64}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-96,70},{-84,70},{-90,64},{-96,70}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,102},{32,102}},
          color={238,46,47},
          thickness=0.5),
        Line(points={{32,120},{32,102}}, color={238,46,47},
          thickness=0.5),
        Line(
          points={{-32,120},{-32,102}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-90,64},{-90,52},{-110,52}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-100,86},{-100,102}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-100,52},{-100,10}},
          color={238,46,47},
          thickness=0.5),
        Line(points={{-58,130}}, color={0,0,0}),
        Line(
          points={{100,-26},{100,2}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{120,6},{60,6}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{120,-54},{60,-54}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-130,-104},{-130,-92},{-130,-70},{-110,-70},{-110,-80}},
          color={28,108,200},
          thickness=0.5),
        Ellipse(
          extent={{-136,-80},{-124,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-136,-86},{-124,-86},{-130,-92},{-136,-86}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-116,-80},{-104,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-116,-86},{-104,-86},{-110,-92},{-116,-86}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-110,-92},{-110,-104},{-130,-104}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-120,-70},{-120,-54}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-120,-104},{-120,-200}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-120,6},{-120,-54}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{120,6},{120,-200}},
          color={28,108,200},
          thickness=0.5),
        Line(points={{120,-120},{-120,-120}},
                                         color={28,108,200},
          thickness=0.5),
        Polygon(
          points={{-4,7},{-4,1},{4,4},{-4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-3,-124}),
        Polygon(
          points={{4,7},{4,1},{-4,4},{4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={5,-124}),
        Text(
          extent={{-22,30},{24,12}},
          textColor={0,0,0},
          textString="CH1"),
        Text(
          extent={{-22,-28},{24,-46}},
          textColor={0,0,0},
          textString="CH2"),
        Line(
          points={{-100,-28},{-100,2}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{100,34},{100,10}},
          color={238,46,47},
          thickness=0.5),
        Text(
          extent={{-60,200},{52,264}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{-58,112},{-34,112}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{6,112},{-30,112}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{6,112},{6,164},{16,164}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{6,112},{28,112}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{100,34},{100,112},{34,112}},
          color={238,46,47},
          thickness=0.5)}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-560,-440},{560,440}})));
end RP1711_test;
