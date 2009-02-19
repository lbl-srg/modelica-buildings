within Buildings.Fluids.Boilers.Examples;
model HeatingSystem "Test model"
 package Medium = Buildings.Media.ConstantPropertyLiquidWater "Medium model";

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{300,360}}), graphics),
          Commands(file=
          "HeatingSystem.mos" "run"),
    experiment(StopTime=86400),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{300,
            360}})));

 parameter Integer nRoo = 2 "Number of rooms";
 parameter Modelica.SIunits.Power Q0_flow = 3000 "Nominal power";
 parameter Modelica.SIunits.Temperature dT0 = 20
    "Nominal temperature difference";
 parameter Modelica.SIunits.MassFlowRate m0_flow = Q0_flow/dT0/4200
    "Nominal mass flow rate";
 parameter Modelica.SIunits.Pressure dp0Pip = 5000
    "Pressure difference of pipe (without valve)";
 parameter Modelica.SIunits.Pressure dp0Val = 1000
    "Pressure difference of valve";

 parameter Modelica.SIunits.Pressure dp0 = dp0Pip + dp0Val
    "Pressure difference of loop";
  Buildings.Fluids.Boilers.BoilerPolynomial fur(
    a={0.9},
    effCur=Buildings.Fluids.Types.EfficiencyCurves.Constant,
    Q0_flow=Q0_flow,
    dT0=dT0,
    T_start=293.15,
    redeclare package Medium = Medium) "Boiler" 
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  inner Modelica_Fluid.System system 
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAmb(T=288.15)
    "Ambient temperature in boiler room" 
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica_Fluid.Machines.PrescribedPump pump(
    N_nominal=3000,
    use_N_in=true,
    redeclare package Medium = Medium,
    redeclare function flowCharacteristic = 
        Modelica_Fluid.Machines.BaseClasses.PumpCharacteristics.linearFlow (
          V_flow_nominal={m0_flow/1000,0.5*m0_flow/1000}, head_nominal=1.5*dp0/
            9.81/1000*{1,2})) 
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));

  Modelica_Fluid.Vessels.OpenTank tank(
    height=2,
    crossArea=1,
    level_start=1,
    nPorts=1,
    use_portsData=false,
    redeclare package Medium = Medium,
    p_ambient=100000) "Tank, used to set static pressure in water loop" 
    annotation (Placement(transformation(extent={{-78,-46},{-58,-26}})));
  MixingVolumes.MixingVolume hea(
    nPorts=2,
    use_HeatTransfer=true,
    redeclare package Medium = Medium,
    V=0.1) "Heater" 
                 annotation (Placement(transformation(extent={{100,100},{120,
            120}},
          rotation=0)));
  FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = Medium,
    m0_flow=m0_flow,
    dp0=dp0Pip/2) 
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={208,70})));
  FixedResistances.FixedResistanceDpM res2(
    redeclare package Medium = Medium,
    m0_flow=m0_flow,
    dp0=dp0Pip/2) 
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-50,70})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo 
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
  Modelica.Blocks.Sources.Constant dpSet(k=dp0) "Pressure set point" 
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Modelica.Blocks.Continuous.LimPID conPum(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=3000,
    yMin=0.3*3000,
    k=1) "Controller for pump" 
    annotation (Placement(transformation(extent={{160,-80},{180,-60}})));
  Modelica.Blocks.Sources.Constant TFurSet(k=273.15 + 60) 
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Continuous.LimPID conFur(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=1,
    yMin=0,
    k=0.1) "Controller for boiler" 
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor con(G=1000/20/nRoo)
    "Thermal conductor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,130})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor roo(C=10*30*1000, T(
        fixed=true)) "Heat capacity of room" 
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conWal(G=1000/30/
        nRoo) "Thermal conductance of wall to outside" 
    annotation (Placement(transformation(extent={{50,140},{70,160}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature boundary condition" 
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  Modelica.Blocks.Sources.Sine TOutBC(
    amplitude=10,
    freqHz=1/86400,
    offset=273.15,
    phase=-1.5707963267949) "Outside air temperature" 
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Modelica_Fluid.Sensors.RelativePressure dpSen(redeclare package Medium = 
        Medium) 
    annotation (Placement(transformation(extent={{80,-94},{60,-74}})));
  Actuators.Valves.TwoWayLinear val(
    redeclare package Medium = Medium,
    dp0(displayUnit="Pa") = dp0Val,
    Kv_SI=m0_flow/nRoo/sqrt(dp0Val),
    m0_flow=m0_flow/2) "Radiator valve" 
    annotation (Placement(transformation(extent={{160,90},{140,110}})));
  Modelica.Blocks.Continuous.LimPID conRoo(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=1,
    yMin=0,
    k=2) "Controller for room temperature" 
    annotation (Placement(transformation(extent={{160,170},{180,190}})));
  Modelica.Blocks.Sources.Constant TRooSet(k=273.15 + 20) 
    annotation (Placement(transformation(extent={{120,170},{140,190}})));
  Modelica.Blocks.Logical.Switch switch1 
    annotation (Placement(transformation(extent={{82,20},{102,40}})));
  Modelica.Blocks.Sources.Constant zer(k=0) "Zero signal" 
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Modelica.Blocks.Logical.Hysteresis hys(
    uLow=0.3,
    uHigh=0.9,
    pre_y_start=false) "Hysteresis" 
    annotation (Placement(transformation(extent={{32,20},{52,40}})));
  MixingVolumes.MixingVolume hea1(
    nPorts=2,
    use_HeatTransfer=true,
    redeclare package Medium = Medium,
    V=0.1/2) "Heater" 
                 annotation (Placement(transformation(extent={{100,220},{120,
            240}},
          rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo1 
    annotation (Placement(transformation(extent={{120,262},{140,282}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor con1(G=1000/20/nRoo)
    "Thermal conductor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,252})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor roo1(
                                                             C=10*30*1000, T(
        fixed=true)) "Heat capacity of room" 
    annotation (Placement(transformation(extent={{80,272},{100,292}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conWal1(G=1000/30/
        nRoo) "Thermal conductance of wall to outside" 
    annotation (Placement(transformation(extent={{50,262},{70,282}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut1
    "Outside temperature boundary condition" 
    annotation (Placement(transformation(extent={{20,262},{40,282}})));
  Modelica.Blocks.Sources.Sine TOutBC1(
    amplitude=10,
    freqHz=1/86400,
    offset=273.15,
    phase=-1.5707963267949) "Outside air temperature" 
    annotation (Placement(transformation(extent={{-20,262},{0,282}})));
  Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = Medium,
    dp0(displayUnit="Pa") = dp0Val,
    Kv_SI=m0_flow/nRoo/sqrt(dp0Val),
    m0_flow=m0_flow/2) "Radiator valve" 
    annotation (Placement(transformation(extent={{160,210},{140,230}})));
  Modelica.Blocks.Continuous.LimPID conRoo1(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=1,
    yMin=0,
    k=2) "Controller for room temperature" 
    annotation (Placement(transformation(extent={{160,292},{180,312}})));
  Modelica.Blocks.Sources.Constant TRooSet1(
                                           k=273.15 + 20) 
    annotation (Placement(transformation(extent={{120,292},{140,312}})));
equation
  connect(TAmb.port, fur.heatPort) annotation (Line(
      points={{-20,-10},{-10,-10},{-10,-52.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dpSet.y, conPum.u_s) annotation (Line(
      points={{141,-70},{158,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TFurSet.y, conFur.u_s) annotation (Line(
      points={{-19,30},{-2,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fur.T, conFur.u_m) annotation (Line(
      points={{1,-52},{10,-52},{10,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hea.ports[2], res2.port_a) annotation (Line(
      points={{112,100},{-50,100},{-50,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port, conWal.port_a) annotation (Line(
      points={{40,150},{50,150}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conWal.port_b, roo.port) annotation (Line(
      points={{70,150},{90,150}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roo.port, con.port_b) annotation (Line(
      points={{90,150},{90,140}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con.port_a, hea.heatPort) annotation (Line(
      points={{90,120},{90,110},{100,110}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOutBC.y, TOut.T) annotation (Line(
      points={{1,150},{18,150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo.port, TRoo.port) annotation (Line(
      points={{90,150},{120,150}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fur.port_b, pump.port_a) annotation (Line(
      points={{0,-60},{60,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, res1.port_a) annotation (Line(
      points={{80,-60},{96,-60},{96,-48},{208,-48},{208,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_b, fur.port_a) annotation (Line(
      points={{-50,60},{-50,-60},{-20,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpSen.p_rel, conPum.u_m) annotation (Line(
      points={{70,-93},{70,-96},{170,-96},{170,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(val.port_a, res1.port_b) annotation (Line(
      points={{160,100},{208,100},{208,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val.port_b, hea.ports[1]) annotation (Line(
      points={{140,100},{108,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TRooSet.y, conRoo.u_s) annotation (Line(
      points={{141,180},{158,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo.T, conRoo.u_m) annotation (Line(
      points={{140,150},{170,150},{170,168}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRoo.y, val.y) annotation (Line(
      points={{181,180},{190,180},{190,108},{162,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tank.ports[1], fur.port_a) annotation (Line(
      points={{-68,-46},{-68,-60},{-20,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(conPum.y, pump.N_in) annotation (Line(
      points={{181,-70},{188,-70},{188,-40},{70,-40},{70,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.y, fur.y) annotation (Line(
      points={{103,30},{120,30},{120,-36},{6,-36},{6,-52},{-22,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conFur.y, hys.u) annotation (Line(
      points={{21,30},{30,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conFur.y, switch1.u1) annotation (Line(
      points={{21,30},{28,30},{28,52},{60,52},{60,38},{80,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.port_b, dpSen.port_a) annotation (Line(
      points={{80,-60},{80,-84}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_a, dpSen.port_b) annotation (Line(
      points={{60,-60},{60,-84}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zer.y, switch1.u3) annotation (Line(
      points={{61,-10},{66,-10},{66,22},{80,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hys.y, switch1.u2) annotation (Line(
      points={{53,30},{80,30}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TOut1.port, conWal1.port_a) 
                                    annotation (Line(
      points={{40,272},{50,272}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conWal1.port_b, roo1.port) 
                                   annotation (Line(
      points={{70,272},{90,272}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roo1.port, con1.port_b) 
                                annotation (Line(
      points={{90,272},{90,262}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con1.port_a, hea1.heatPort) 
                                    annotation (Line(
      points={{90,242},{90,230},{100,230}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOutBC1.y, TOut1.T) 
                            annotation (Line(
      points={{1,272},{18,272}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo1.port, TRoo1.port) 
                               annotation (Line(
      points={{90,272},{120,272}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRooSet1.y, conRoo1.u_s) 
                                 annotation (Line(
      points={{141,302},{158,302}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo1.T, conRoo1.u_m) 
                              annotation (Line(
      points={{140,272},{170,272},{170,290}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRoo1.y, val1.y) 
                           annotation (Line(
      points={{181,302},{190,302},{190,228},{162,228}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hea1.ports[2], res2.port_a) 
                                     annotation (Line(
      points={{112,220},{-50,220},{-50,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val1.port_a, res1.port_b) 
                                   annotation (Line(
      points={{160,220},{208,220},{208,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val1.port_b, hea1.ports[1]) annotation (Line(
      points={{140,220},{108,220}},
      color={0,127,255},
      smooth=Smooth.None));
end HeatingSystem;
