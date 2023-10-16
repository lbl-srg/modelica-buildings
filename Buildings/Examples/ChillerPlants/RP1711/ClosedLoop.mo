within Buildings.Examples.ChillerPlants.RP1711;
model ClosedLoop
  extends Modelica.Icons.Example;

  package MediumW = Buildings.Media.Water;
  package MediumA = Buildings.Media.Air;

  parameter Modelica.Media.Interfaces.Types.Temperature TRet=301.15
    "Room return air temperature";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=10
    "Nominal mass flow rate of air";
  parameter Modelica.Units.SI.MassFlowRate mWater_flow_nominal=6
    "Nominal mass flow rate of water";

  parameter Modelica.Units.SI.ThermalConductance UA_nominal=4748
    "Total thermal conductance at nominal flow, from textbook";

  Buildings.Examples.ChillerPlants.RP1711.BaseClasses.RP1711 chiPla(
    final mChi_flow_nominal=mWater_flow_nominal,
    final mCon_flow_nominal=mWater_flow_nominal,
    final dTChi=7) "Chiller plant with controller"
    annotation (Placement(transformation(extent={{104,40},{136,80}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    final m1_flow_nominal=mWater_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final show_T=true,
    final dp1_nominal=3000,
    final dp2_nominal=600,
    final UA_nominal=UA_nominal) "Air handler unit cooling coil"
    annotation (Placement(transformation(extent={{110,-20},{130,0}})));
  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumA,
    nPorts=1) "Air sink"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=true)
                                     "Weather data reader"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{70,80},{90,100}}),
        iconTransformation(extent={{-70,30},{-50,50}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear cooCoiVal(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mWater_flow_nominal,
    final show_T=true,
    final dpValve_nominal=20000,
    final dpFixed_nominal=60000) "Cooling coil valve"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},rotation=90,origin={80,20})));
  Buildings.Fluid.FixedResistances.Junction mixAir(
    redeclare package Medium = MediumA,
    final m_flow_nominal={0.7*mAir_flow_nominal,mAir_flow_nominal,0.3*mAir_flow_nominal},
    final dp_nominal=fill(0, 3))
    "Mix return air and outdoor air"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=-90,origin={160,-80})));
  Buildings.Fluid.Sources.MassFlowSource_T outAir(
    redeclare package Medium = MediumA,
    final m_flow=0.3*mAir_flow_nominal,
    final use_T_in=true,
    nPorts=1) "Outdoor air"
    annotation (Placement(transformation(extent={{240,-90},{220,-70}})));
  Buildings.Fluid.Sources.MassFlowSource_T retAir(
    redeclare package Medium = MediumA,
    final m_flow=0.7*mAir_flow_nominal,
    final T=TRet,
    nPorts=1) "Return air"
    annotation (Placement(transformation(extent={{240,-130},{220,-110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort supAirTem(
     redeclare package Medium = MediumA,
     final m_flow_nominal=mAir_flow_nominal)
     "Supply air temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,origin={80,-100})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant airSupTemSet(
    final k=273.15 + 18)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-240,-50},{-220,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract temDif
    "Difference between supply air temperature and its setpoint"
    annotation (Placement(transformation(extent={{-220,110},{-200,130}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    uLow=2.9,
    uHigh=3.1)
    "Higher than setpoint by 3 degC"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys1(
    uLow=1.9,
    uHigh=2.1)
    "Higher than setpoint by 2 degC"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    delayTime=120)
    "Check if the temperature has been higher than setpoint by sufficient time"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    delayTime=120)
    "Check if the temperature has been higher than setpoint by sufficient time"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Buildings.Controls.OBC.CDL.Integers.Switch chiWatResReq
    "Chilled water reset request"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=3) "Constant three"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Chilled water reset request"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=2) "Constant two"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPID(
    final reverseActing=false)
    "Chilled water valve control"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    t=0.95,
    h=0.1)
    "Send one request when the input is greater than threshold unit it is less than threshold minus hysteresis"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi2
    "Chilled water reset request"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = MediumW, nPorts=1)
    "Reference pressure"
    annotation (Placement(transformation(extent={{200,-14},{180,6}})));
  Buildings.Controls.OBC.CDL.Integers.Switch chiPlaReq
    "Chiller plant request"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(
    t=0.95,
    h=0.85)
    "Send one request when the input is greater than threshold unit it is less than threshold minus hysteresis"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{60,70},{80,70},{80,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(chiPla.portCooCoiSup, cooCoiVal.port_a) annotation (Line(
      points={{108,40},{108,34},{80,34},{80,30}},
      color={0,127,255},
      thickness=0.5));
  connect(cooCoiVal.port_b, cooCoi.port_a1) annotation (Line(
      points={{80,10},{80,-4},{110,-4}},
      color={0,127,255},
      thickness=0.5));
  connect(chiPla.portCooCoiRet, cooCoi.port_b1) annotation (Line(
      points={{132,40},{132,-4},{130,-4}},
      color={0,127,255},
      thickness=0.5));
  connect(retAir.ports[1], mixAir.port_1) annotation (Line(points={{220,-120},{160,
          -120},{160,-90}}, color={0,127,255},
      thickness=0.5));
  connect(outAir.ports[1], mixAir.port_3)
    annotation (Line(points={{220,-80},{170,-80}}, color={0,127,255},
      thickness=0.5));
  connect(mixAir.port_2, cooCoi.port_a2) annotation (Line(
      points={{160,-70},{160,-16},{130,-16}},
      color={0,127,255},
      thickness=0.5));
  connect(weaBus.TDryBul, outAir.T_in) annotation (Line(
      points={{80,90},{250,90},{250,-76},{242,-76}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(cooCoi.port_b2, supAirTem.port_a) annotation (Line(
      points={{110,-16},{80,-16},{80,-90}},
      color={0,127,255},
      thickness=0.5));
  connect(supAirTem.port_b, sinAir.ports[1]) annotation (Line(points={{80,-110},
          {80,-120},{20,-120}}, color={0,127,255},
      thickness=0.5));
  connect(conInt.y, chiWatResReq.u1) annotation (Line(points={{-118,160},{-30,160},
          {-30,128},{-22,128}}, color={255,127,0}));
  connect(truDel.y, chiWatResReq.u2)
    annotation (Line(points={{-118,120},{-22,120}}, color={255,0,255}));
  connect(temDif.y, hys.u)
    annotation (Line(points={{-198,120},{-182,120}}, color={0,0,127}));
  connect(temDif.y, hys1.u) annotation (Line(points={{-198,120},{-190,120},{-190,
          50},{-182,50}}, color={0,0,127}));
  connect(hys1.y, truDel1.u)
    annotation (Line(points={{-158,50},{-142,50}}, color={255,0,255}));
  connect(hys.y, truDel.u)
    annotation (Line(points={{-158,120},{-142,120}}, color={255,0,255}));
  connect(conInt1.y, intSwi1.u1) annotation (Line(points={{-118,80},{-70,80},{
          -70,58},{-62,58}},
                         color={255,127,0}));
  connect(truDel1.y, intSwi1.u2) annotation (Line(points={{-118,50},{-62,50}},
                         color={255,0,255}));
  connect(intSwi1.y, chiWatResReq.u3) annotation (Line(points={{-38,50},{-30,50},
          {-30,112},{-22,112}}, color={255,127,0}));
  connect(airSupTemSet.y, conPID.u_s)
    annotation (Line(points={{-218,-40},{-202,-40}}, color={0,0,127}));
  connect(conPID.y, greThr.u)
    annotation (Line(points={{-178,-40},{-142,-40}}, color={0,0,127}));
  connect(greThr.y, intSwi2.u2)
    annotation (Line(points={{-118,-40},{-102,-40}}, color={255,0,255}));
  connect(conInt2.y, intSwi2.u1) annotation (Line(points={{-118,0},{-110,0},{-110,
          -32},{-102,-32}}, color={255,127,0}));
  connect(conInt3.y, intSwi2.u3) annotation (Line(points={{-118,-80},{-110,-80},
          {-110,-48},{-102,-48}}, color={255,127,0}));
  connect(intSwi2.y, intSwi1.u3) annotation (Line(points={{-78,-40},{-70,-40},{
          -70,42},{-62,42}},
                         color={255,127,0}));
  connect(weaDat.weaBus, chiPla.weaBus) annotation (Line(
      points={{60,70},{80,70},{80,77},{109,77}},
      color={255,204,51},
      thickness=0.5));
  connect(cooCoi.port_b1, bou.ports[1])
    annotation (Line(points={{130,-4},{180,-4}}, color={0,127,255},
      thickness=0.5));
  connect(airSupTemSet.y, temDif.u2) annotation (Line(points={{-218,-40},{-210,
          -40},{-210,40},{-240,40},{-240,114},{-222,114}}, color={0,0,127}));
  connect(supAirTem.T, conPID.u_m) annotation (Line(points={{69,-100},{-190,
          -100},{-190,-52}}, color={0,0,127}));
  connect(supAirTem.T, temDif.u1) annotation (Line(points={{69,-100},{-250,-100},
          {-250,126},{-222,126}}, color={0,0,127}));
  connect(conPID.y, cooCoiVal.y) annotation (Line(points={{-178,-40},{-160,-40},
          {-160,20},{68,20}}, color={0,0,127}));
  connect(conPID.y, greThr1.u) annotation (Line(points={{-178,-40},{-160,-40},{
          -160,-20},{-62,-20}}, color={0,0,127}));
  connect(greThr1.y, chiPlaReq.u2)
    annotation (Line(points={{-38,-20},{-22,-20}}, color={255,0,255}));
  connect(conInt2.y, chiPlaReq.u1) annotation (Line(points={{-118,0},{-30,0},{
          -30,-12},{-22,-12}}, color={255,127,0}));
  connect(conInt3.y, chiPlaReq.u3) annotation (Line(points={{-118,-80},{-30,-80},
          {-30,-28},{-22,-28}}, color={255,127,0}));

  connect(chiWatResReq.y, chiPla.TChiWatSupResReq) annotation (Line(points={{2,
          120},{20,120},{20,47},{102,47}}, color={255,127,0}));
  connect(chiPlaReq.y, chiPla.chiPlaReq) annotation (Line(points={{2,-20},{20,
          -20},{20,43},{102,43}}, color={255,127,0}));
annotation (experiment(
      StartTime=15638400,
      StopTime=15897600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlants/RP1711/ClosedLoop.mos"
    "Simulate and plot"),
  Diagram(coordinateSystem(extent={{-280,-220},{280,220}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end ClosedLoop;
