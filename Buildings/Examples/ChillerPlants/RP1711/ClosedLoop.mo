within Buildings.Examples.ChillerPlants.RP1711;
model ClosedLoop
  extends Modelica.Icons.Example;

  package Medium_W = Buildings.Media.Water;
  package Medium_A = Buildings.Media.Air;

  parameter Modelica.Media.Interfaces.Types.Temperature TRet=301.15
    "Room return air temperature";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=10
    "Nominal mass flow rate of air";
  parameter Modelica.Units.SI.MassFlowRate mWater_flow_nominal=6
    "Nominal mass flow rate of water";

  parameter Modelica.Units.SI.ThermalConductance UA_nominal=4748
    "Total thermal conductance at nominal flow, from textbook";

  BaseClasses.RP1711 rP1711_1
    annotation (Placement(transformation(extent={{104,40},{136,80}})));
  Fluid.HeatExchangers.WetCoilEffectivenessNTU hexWetNtu(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    final m1_flow_nominal=mWater_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final show_T=true,
    final UA_nominal=UA_nominal)
    annotation (Placement(transformation(extent={{110,-20},{130,0}})));
  Fluid.Sources.Boundary_pT           sinAir(
    redeclare package Medium = Medium_A,
    use_p_in=false,
    nPorts=1)
    "Air sink"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));

  BoundaryConditions.WeatherData.ReaderTMY3           weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{70,80},{90,100}}),
        iconTransformation(extent={{-70,30},{-50,50}})));
  Fluid.Actuators.Valves.TwoWayLinear           chwIsoVal2(
    redeclare package Medium = Medium_W,
    final m_flow_nominal=mWater_flow_nominal,
    final show_T=true,
    final dpValve_nominal=20000,
    final dpFixed_nominal=60000)
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,20})));
  Fluid.FixedResistances.Junction mixAir(
    redeclare package Medium = Medium_A,
    final m_flow_nominal={0.7*mAir_flow_nominal,mAir_flow_nominal,0.3*
        mAir_flow_nominal},
    final dp_nominal=fill(0, 3)) "Mix return air and outdoor air" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={160,-80})));
  Fluid.Sources.MassFlowSource_T outAir(
    redeclare package Medium = Medium_A,
    final m_flow=0.3*mAir_flow_nominal,
    final use_T_in=true,
    T=T_a2_nominal,
    nPorts=1) "Outdoor air"
    annotation (Placement(transformation(extent={{240,-90},{220,-70}})));
  Fluid.Sources.MassFlowSource_T retAir(
    redeclare package Medium = Medium_A,
    final m_flow=0.7*mAir_flow_nominal,
    T=TRet,
    nPorts=1) "Return air"
    annotation (Placement(transformation(extent={{240,-130},{220,-110}})));


  Fluid.Sensors.TemperatureTwoPort supAirTem(
     redeclare package Medium = Medium_A)
     "Supply air temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,-100})));
  Controls.OBC.CDL.Continuous.Sources.Constant airSupTemSet(final k=273.15 + 18)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-240,-50},{-220,-30}})));
  Controls.OBC.CDL.Continuous.Feedback temDif
    "Difference between supply air temperature and its setpoint"
    annotation (Placement(transformation(extent={{-220,110},{-200,130}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=2.9, uHigh=3.1)
    "Higher than setpoint by 3 degC"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=1.9, uHigh=2.1)
    "Higher than setpoint by 2 degC"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Controls.OBC.CDL.Logical.TrueDelay truDel(delayTime=120)
    "Check if the temperature has been higher than setpoint by sufficient time"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Controls.OBC.CDL.Logical.TrueDelay truDel1(delayTime=120)
    "Check if the temperature has been higher than setpoint by sufficient time"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Controls.OBC.CDL.Integers.Switch chiWatResReq
    "Chilled water setpoint temperature reset request"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=3) "Constant three"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Controls.OBC.CDL.Integers.Switch intSwi1
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Controls.OBC.CDL.Integers.Sources.Constant conInt1(final k=2) "Constant two"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Controls.OBC.CDL.Continuous.PID conPID(final reverseActing=false)
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greThr(t=0.95, h=0.02)
    "Check if the input is greater than threhold"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Controls.OBC.CDL.Integers.Sources.Constant conInt2(final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Controls.OBC.CDL.Integers.Sources.Constant conInt3(final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Controls.OBC.CDL.Integers.Switch intSwi2 "Chiller plant request"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{60,70},{80,70},{80,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(rP1711_1.portCooCoiSup, chwIsoVal2.port_a) annotation (Line(points={{108,40},
          {108,34},{80,34},{80,30}},           color={0,127,255},
      thickness=0.5));
  connect(chwIsoVal2.port_b, hexWetNtu.port_a1)
    annotation (Line(points={{80,10},{80,-4},{110,-4}},   color={0,127,255},
      thickness=0.5));
  connect(rP1711_1.portCooCoiRet, hexWetNtu.port_b1)
    annotation (Line(points={{132,40},{132,-4},{130,-4}},
                                                       color={0,127,255},
      thickness=0.5));
  connect(retAir.ports[1], mixAir.port_1) annotation (Line(points={{220,-120},{160,
          -120},{160,-90}}, color={0,127,255}));
  connect(outAir.ports[1], mixAir.port_3)
    annotation (Line(points={{220,-80},{170,-80}}, color={0,127,255}));
  connect(mixAir.port_2, hexWetNtu.port_a2) annotation (Line(points={{160,-70},{
          160,-16},{130,-16}}, color={0,127,255}));
  connect(weaBus.TDryBul, outAir.T_in) annotation (Line(
      points={{80,90},{250,90},{250,-76},{242,-76}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hexWetNtu.port_b2, supAirTem.port_a)
    annotation (Line(points={{110,-16},{80,-16},{80,-90}}, color={0,127,255}));
  connect(supAirTem.port_b, sinAir.ports[1]) annotation (Line(points={{80,-110},
          {80,-120},{20,-120}}, color={0,127,255}));
  connect(conInt.y, chiWatResReq.u1) annotation (Line(points={{-118,160},{-30,160},
          {-30,128},{-22,128}}, color={255,127,0}));
  connect(truDel.y, chiWatResReq.u2)
    annotation (Line(points={{-118,120},{-22,120}}, color={255,0,255}));
  connect(airSupTemSet.y, temDif.u2) annotation (Line(points={{-218,-40},{-210,-40},
          {-210,108}}, color={0,0,127}));
  connect(temDif.y, hys.u)
    annotation (Line(points={{-198,120},{-182,120}}, color={0,0,127}));
  connect(temDif.y, hys1.u) annotation (Line(points={{-198,120},{-190,120},{-190,
          50},{-182,50}}, color={0,0,127}));
  connect(hys1.y, truDel1.u)
    annotation (Line(points={{-158,50},{-142,50}}, color={255,0,255}));
  connect(hys.y, truDel.u)
    annotation (Line(points={{-158,120},{-142,120}}, color={255,0,255}));
  connect(conInt1.y, intSwi1.u1) annotation (Line(points={{-118,80},{-70,80},{-70,
          68},{-62,68}}, color={255,127,0}));
  connect(truDel1.y, intSwi1.u2) annotation (Line(points={{-118,50},{-100,50},{-100,
          60},{-62,60}}, color={255,0,255}));
  connect(intSwi1.y, chiWatResReq.u3) annotation (Line(points={{-38,60},{-30,60},
          {-30,112},{-22,112}}, color={255,127,0}));
  connect(supAirTem.T, conPID.u_m) annotation (Line(points={{69,-100},{-170,-100},
          {-170,-52}}, color={0,0,127}));
  connect(airSupTemSet.y, conPID.u_s)
    annotation (Line(points={{-218,-40},{-182,-40}}, color={0,0,127}));
  connect(conPID.y, greThr.u)
    annotation (Line(points={{-158,-40},{-142,-40}}, color={0,0,127}));
  connect(greThr.y, intSwi2.u2)
    annotation (Line(points={{-118,-40},{-102,-40}}, color={255,0,255}));
  connect(conInt2.y, intSwi2.u1) annotation (Line(points={{-118,0},{-110,0},{-110,
          -32},{-102,-32}}, color={255,127,0}));
  connect(conInt3.y, intSwi2.u3) annotation (Line(points={{-118,-80},{-110,-80},
          {-110,-48},{-102,-48}}, color={255,127,0}));
  connect(intSwi2.y, intSwi1.u3) annotation (Line(points={{-78,-40},{-70,-40},{-70,
          52},{-62,52}}, color={255,127,0}));
  connect(conPID.y, chwIsoVal2.y) annotation (Line(points={{-158,-40},{-150,-40},
          {-150,20},{68,20}}, color={0,0,127}));
  connect(weaDat.weaBus, rP1711_1.weaBus) annotation (Line(
      points={{60,70},{80,70},{80,77},{109,77}},
      color={255,204,51},
      thickness=0.5));
  connect(chiWatResReq.y, rP1711_1.TChiWatSupResReq) annotation (Line(points={{2,
          120},{20,120},{20,48},{102,48}}, color={255,127,0}));
  connect(intSwi2.y, rP1711_1.chiPlaReq) annotation (Line(points={{-78,-40},{-70,
          -40},{-70,46},{102,46}}, color={255,127,0}));
  connect(supAirTem.T, temDif.u1) annotation (Line(points={{69,-100},{-250,-100},
          {-250,120},{-222,120}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-280,-220},{280,220}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end ClosedLoop;
