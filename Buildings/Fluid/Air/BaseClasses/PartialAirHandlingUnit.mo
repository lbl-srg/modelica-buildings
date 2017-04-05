within Buildings.Fluid.Air.BaseClasses;
partial model PartialAirHandlingUnit "Paritial Model for Air Handling Unit"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;
  extends Buildings.Fluid.Air.BaseClasses.EssentialParameter;

  HeatExchangers.WetCoilCounterFlow cooCoi(
    m1_flow_nominal=dat.nomVal.m1_flow_nominal,
    m2_flow_nominal=dat.nomVal.m2_flow_nominal,
    dp1_nominal=dat.nomVal.dp1_coil_nominal,
    dp2_nominal=dat.nomVal.dp2_coil_nominal,
    UA_nominal=dat.nomVal.UA_nominal,
    r_nominal=dat.nomVal.r_nominal,
    nEle=dat.nomVal.nEle,
    tau1=dat.nomVal.tau1,
    tau2=dat.nomVal.tau2,
    tau_m=dat.nomVal.tau_m,
    m1_flow_small=dat.m1_flow_small,
    m2_flow_small=dat.m2_flow_small)
    annotation (Placement(transformation(extent={{22,-12},{42,8}})));
  replaceable Movers.SpeedControlled_y fan(per=dat.perCur) constrainedby
    Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine
    annotation (Placement(transformation(extent={{-38,-70},{-58,-50}})));
  replaceable Actuators.Valves.TwoWayEqualPercentage watVal(
    m_flow_nominal=dat.nomVal.m1_flow_nominal,
    dpValve_nominal=dat.nomVal.dp_valve_nominal,
    dpFixed_nominal=0) constrainedby
    Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={60,28})));

  MassExchangers.Humidifier_u hum(
    use_T_in=false,
    m_flow_nominal=dat.nomVal.m2_flow_nominal,
    dp_nominal=dat.nomVal.dp_humidifier_nominal,
    mWat_flow_nominal=dat.nomVal.mWat_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-18,-60})));
  Modelica.Blocks.Interfaces.RealOutput P
    "Electrical power consumed by the fan" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-110})));
  ElectricHeater eleHea(
    m_flow_nominal=dat.nomVal.m2_flow_nominal,
    dp_nominal=dat.nomVal.dp_heater_nominal,
    Q_flow_nominal=dat.nomVal.Q_heater_nominal) "Electric heater" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={12,-34})));
  Modelica.Blocks.Interfaces.RealInput uWatVal
    "Actuator position (0: closed, 1: open) on water side"
    annotation (Placement(transformation(extent={{-128,26},{-100,54}})));
  Modelica.Blocks.Interfaces.RealInput uEleHea
    "Control input of electric heater"
    annotation (Placement(transformation(extent={{-128,6},{-100,34}})));
  Modelica.Blocks.Interfaces.RealInput uHum "Control input of humidifier"
    annotation (Placement(transformation(extent={{-128,-14},{-100,14}})));
  Modelica.Blocks.Interfaces.RealInput uFan "Input signal for the fan"
    annotation (Placement(transformation(extent={{-128,-34},{-100,-6}})));
equation
  connect(port_a1, cooCoi.port_a1) annotation (Line(points={{-100,60},{-60,60},{
          12,60},{12,4},{22,4}},    color={0,127,255}));
  connect(cooCoi.port_a2, port_a2) annotation (Line(points={{42,-8},{42,-8},{60,
          -8},{60,-60},{100,-60}}, color={0,127,255}));
  connect(cooCoi.port_b1, watVal.port_a)
    annotation (Line(points={{42,4},{60,4},{60,18}}, color={0,127,255}));
  connect(watVal.port_b, port_b1) annotation (Line(points={{60,38},{60,38},{60,60},
          {100,60}}, color={0,127,255}));
  connect(hum.port_b, fan.port_a) annotation (Line(points={{-28,-60},{-28,-60},{
          -38,-60}}, color={0,127,255}));
  connect(fan.P, P) annotation (Line(points={{-59,-52},{-72,-52},{-72,-80},{-20,
          -80},{-20,-110}}, color={0,0,127}));
  connect(fan.port_b, port_b2)
    annotation (Line(points={{-58,-60},{-100,-60}}, color={0,127,255}));
  connect(cooCoi.port_b2, eleHea.port_a)
    annotation (Line(points={{22,-8},{12,-8},{12,-24}}, color={0,127,255}));
  connect(eleHea.port_b, hum.port_a)
    annotation (Line(points={{12,-44},{12,-60},{-8,-60}}, color={0,127,255}));
  connect(watVal.y, uWatVal) annotation (Line(points={{48,28},{20,28},{20,40},{
          -114,40}}, color={0,0,127}));
  connect(eleHea.u, uEleHea)
    annotation (Line(points={{6,-22},{6,20},{-114,20}}, color={0,0,127}));
  connect(hum.u, uHum) annotation (Line(points={{-6,-54},{0,-54},{0,1.77636e-15},
          {-114,1.77636e-15}}, color={0,0,127}));
  connect(fan.y, uFan) annotation (Line(points={{-47.8,-48},{-47.8,-20},{-114,
          -20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-46,70},{-16,60}},
          lineColor={28,108,200},
          textString="Waterside"), Text(
          extent={{0,-64},{28,-72}},
          lineColor={28,108,200},
          textString="Airside")}));
end PartialAirHandlingUnit;
