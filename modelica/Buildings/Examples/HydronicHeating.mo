within Buildings.Examples;
model HydronicHeating "Test model"
// package Medium = Buildings.Media.ConstantPropertyLiquidWater "Medium model";
 package Medium = Buildings.Media.ConstantPropertyLiquidWater "Medium model";
 //package Medium = Modelica.Media.Air.SimpleAir "Medium model";
 //package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir "Medium model";

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{500,460}}), graphics),
          Commands(file=
          "HydronicHeating.mos" "run"),
    experiment(
      StopTime=172800,
      Tolerance=1e-006,
      Algorithm="radau"),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{500,
            460}})));

 parameter Integer nRoo = 2 "Number of rooms";
 parameter Modelica.SIunits.Volume VRoo = 8*5*3 "Volume of one room";
 parameter Real ACH = 0.5 "Outside air exchange per hour";
 parameter Modelica.SIunits.Area AHeaTra=(8+5)*3
    "Heat transfer area of one room";
 parameter Modelica.SIunits.Power Q_flow_nominal = 1500 "Nominal power";
 parameter Modelica.SIunits.Temperature dT_nominal = 20
    "Nominal temperature difference";
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/dT_nominal/4200
    "Nominal mass flow rate";
 parameter Modelica.SIunits.Pressure dpPip_nominal = 10000
    "Pressure difference of pipe (without valve)";
 parameter Modelica.SIunits.Pressure dpVal_nominal = 1000
    "Pressure difference of valve";

 parameter Modelica.SIunits.Pressure dpRoo_nominal = 6000
    "Pressure difference of flow leg that serves a room";
 parameter Modelica.SIunits.Pressure dpThrWayVal_nominal = 6000
    "Pressure difference of three-way valve";
 parameter Modelica.SIunits.Pressure dp_nominal = dpPip_nominal + dpVal_nominal + dpRoo_nominal
    "Pressure difference of loop";
  Buildings.Fluid.Boilers.BoilerPolynomial boi(
    a={0.9},
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    Q_flow_nominal=Q_flow_nominal,
    dT_nominal=dT_nominal,
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    dp_nominal=3000,
    T_start=293.15) "Boiler" 
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  inner Modelica.Fluid.System system 
    annotation (Placement(transformation(extent={{-60,400},{-40,420}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAmb(T=288.15)
    "Ambient temperature in boiler room" 
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Fluid.Movers.FlowMachine_y pumRad(
    redeclare package Medium = Medium,
    V=0.01,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    allowFlowReversal=true,
    checkValve=false,
    redeclare function flowCharacteristic = 
        Buildings.Fluid.Movers.BaseClasses.Characteristics.linearFlow (
          V_flow_nominal=m_flow_nominal/1000*{0,2}, dp_nominal=dp_nominal*{2,0}))
    "Pump that serves the radiators" 
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,44})));

  Buildings.Fluid.FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dpPip_nominal/2,
    from_dp=true) 
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={220,102})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dpPip_nominal/2,
    from_dp=true) 
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={240,90})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo2 
    annotation (Placement(transformation(extent={{420,170},{440,190}})));
  Modelica.Blocks.Sources.Constant dpSet(k=dp_nominal) "Pressure set point" 
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Controls.Continuous.PIDHysteresisTimer conPum(
    Ti=60,
    yMax=1,
    yMin=0.3,
    eOn=1,
    k=0.1,
    Td=60,
    controllerType=Modelica.Blocks.Types.SimpleController.P)
    "Controller for pump" 
    annotation (Placement(transformation(extent={{160,100},{180,120}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor roo2(T(fixed=true), C=
        10*30*1006) "Heat capacity of room" 
    annotation (Placement(transformation(extent={{390,180},{410,200}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut2
    "Outside temperature boundary condition" 
    annotation (Placement(transformation(extent={{260,170},{280,190}})));
  Modelica.Blocks.Sources.Sine TOutBC(
    freqHz=1/86400,
    offset=283.15,
    amplitude=5,
    phase=-1.5707963267949) "Outside air temperature" 
    annotation (Placement(transformation(extent={{-20,350},{0,370}})));
  Buildings.Fluid.Sensors.RelativePressure dpSen(redeclare package Medium = 
        Medium) 
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={186,44})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = Medium,
    dp_nominal(displayUnit="Pa") = dpVal_nominal,
    Kv_SI=m_flow_nominal/nRoo/sqrt(dpVal_nominal),
    m_flow_nominal=m_flow_nominal/2,
    l=0.0001,
    from_dp=true) "Radiator valve" 
    annotation (Placement(transformation(extent={{320,118},{340,138}})));
  Modelica.Blocks.Continuous.LimPID conRoo2(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=1,
    yMin=0,
    k=2,
    Ti=60,
    Td=60) "Controller for room temperature" 
    annotation (Placement(transformation(extent={{460,210},{480,230}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo1 
    annotation (Placement(transformation(extent={{420,350},{440,370}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor roo1(             T(
        fixed=true), C=VRoo*1006) "Heat capacity of room" 
    annotation (Placement(transformation(extent={{390,360},{410,380}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut1
    "Outside temperature boundary condition" 
    annotation (Placement(transformation(extent={{260,350},{280,370}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium,
    dp_nominal(displayUnit="Pa") = dpVal_nominal,
    Kv_SI=m_flow_nominal/nRoo/sqrt(dpVal_nominal),
    m_flow_nominal=m_flow_nominal/2,
    l=0.0001,
    from_dp=true) "Radiator valve" 
    annotation (Placement(transformation(extent={{320,298},{340,318}})));
  Modelica.Blocks.Continuous.LimPID conRoo1(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=1,
    yMin=0,
    k=2,
    Ti=60,
    Td=60) "Controller for room temperature" 
    annotation (Placement(transformation(extent={{460,390},{480,410}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad1(
    Q_flow_nominal=Q_flow_nominal/nRoo,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal/nRoo,
    dT_nominal=(60 + 40)/2 - 20) "Radiator" 
    annotation (Placement(transformation(extent={{392,298},{412,318}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad2(
    Q_flow_nominal=Q_flow_nominal/nRoo,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal/nRoo,
    dT_nominal=(60 + 40)/2 - 20) "Radiator" 
    annotation (Placement(transformation(extent={{392,118},{412,138}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear thrWayVal(
                                            redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
    dp_nominal=dpThrWayVal_nominal,
    l={0.01,0.01},
    tau=10) "Three-way valve"        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,0})));
  Modelica.Blocks.Continuous.LimPID conVal(
    k=1,
    Ti=60,
    yMax=1,
    yMin=0,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    xi_start=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    Td=60) "Controller for pump" 
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Fluid.Storage.StratifiedEnhanced tan(
    m_flow_nominal=m_flow_nominal,
    dIns=0.3,
    redeclare package Medium = Medium,
    hTan=2,
    VTan=0.1,
    nSeg=5) "Storage tank" 
    annotation (Placement(transformation(extent={{220,-80},{260,-40}})));
  Fluid.Movers.FlowMachine_y pumBoi(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    redeclare function flowCharacteristic = 
        Buildings.Fluid.Movers.BaseClasses.Characteristics.linearFlow (
          dp_nominal=1.5*5000*{1,2}, V_flow_nominal=2*{
            m_flow_nominal/1000,0.5*m_flow_nominal/1000}),
    checkValve=false,
    V=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial) 
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={66,-60})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tanTemBot
    "Tank temperature" 
    annotation (Placement(transformation(extent={{286,-84},{306,-64}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tanTemTop
    "Tank temperature" 
    annotation (Placement(transformation(extent={{286,-56},{306,-36}})));
  Modelica.Blocks.Logical.GreaterThreshold greThr(threshold=273.15 + 52) 
    annotation (Placement(transformation(extent={{332,-84},{352,-64}})));
  Modelica.Blocks.Math.BooleanToReal booToRea 
    annotation (Placement(transformation(extent={{80,10},{60,30}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res3(
    redeclare package Medium = Medium,
    m_flow_nominal=2*m_flow_nominal,
    dp_nominal=2000) 
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={124,-60})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res4(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=100) 
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={260,-22})));
  Modelica.StateGraph.InitialStepWithSignal iniSte 
    annotation (Placement(transformation(extent={{320,30},{340,50}})));
  Modelica.StateGraph.TransitionWithSignal transition(enableTimer=false,
      waitTime=0) 
    annotation (Placement(transformation(extent={{350,30},{370,50}})));
  Modelica.StateGraph.StepWithSignal onSta(nIn=2) "State for furnace on" 
    annotation (Placement(transformation(extent={{392,30},{412,50}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot 
    annotation (Placement(transformation(extent={{460,80},{480,100}})));
  Modelica.Blocks.Logical.LessThreshold lesThr(threshold=273.15 + 50) 
    annotation (Placement(transformation(extent={{332,-56},{352,-36}})));
  Modelica.StateGraph.TransitionWithSignal toOff(enableTimer=false) 
    annotation (Placement(transformation(extent={{420,30},{440,50}})));
  Modelica.StateGraph.StepWithSignal offSta(nIn=1) "State for furnace off" 
    annotation (Placement(transformation(extent={{446,30},{466,50}})));
  Modelica.StateGraph.TransitionWithSignal toOn(enableTimer=false) 
    annotation (Placement(transformation(extent={{470,30},{490,50}})));
  Buildings.Fluid.Sensors.Temperature temSup(redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{130,62},{150,82}})));
  Buildings.Fluid.Sensors.Temperature temRet(redeclare package Medium = Medium) 
    annotation (Placement(transformation(extent={{264,62},{284,82}})));
  Buildings.Controls.SetPoints.HotWaterTemperatureReset heaCha(
    use_TRoo_in=false,
    dTOutHeaBal=0,
    TSup_nominal=333.15,
    TRet_nominal=313.15,
    TOut_nominal=268.15) 
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.HeatTransfer.ConductorSingleLayer conExt1(
    n=3,
    mat=Buildings.HeatTransfer.Data.Brick(),
    A=AHeaTra,
    x=0.24) "Conduction through exterior facing layer" 
    annotation (Placement(transformation(extent={{300,350},{320,370}})));

  Buildings.HeatTransfer.ConductorSingleLayer conInt1(
    n=3,
    A=AHeaTra,
    mat=Buildings.HeatTransfer.Data.InsulationBoard(),
    x=0.2) "Conduction through interior facing layer" 
    annotation (Placement(transformation(extent={{328,350},{348,370}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor venLos1(G=VRoo*ACH/
        3600*1.2*1006) "Ventilation heat loss" 
    annotation (Placement(transformation(extent={{320,390},{340,410}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor venLos2(G=VRoo*ACH/
        3600*1.2*1006) "Ventilation heat loss" 
    annotation (Placement(transformation(extent={{320,210},{340,230}})));
  Controls.SetPoints.OccupancySchedule occSch1(occupancy=3600*{7,8,10,11,11.5,
        15,19,21}) "Occupancy schedule" 
    annotation (Placement(transformation(extent={{260,426},{280,446}})));
  Modelica.Blocks.Logical.Switch switch1 
    annotation (Placement(transformation(extent={{320,420},{340,440}})));
  Modelica.Blocks.Sources.RealExpression occ1(y=200)
    "Heat gain if occupied in room 1" 
    annotation (Placement(transformation(extent={{288,428},{308,448}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo1
    "Prescribed heat flow to model occupancy" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={388,416})));
  Modelica.Blocks.Sources.Constant zer(k=0) "Outputs zero" 
    annotation (Placement(transformation(extent={{220,410},{240,430}})));
  Controls.SetPoints.OccupancySchedule occSch2(
      firstEntryOccupied=false, occupancy=3600*{7,10,12,22})
    "Occupancy schedule" 
    annotation (Placement(transformation(extent={{260,246},{280,266}})));
  Modelica.Blocks.Logical.Switch switch2 
    annotation (Placement(transformation(extent={{320,240},{340,260}})));
  Modelica.Blocks.Sources.RealExpression occ2(y=200)
    "Heat gain if occupied in room 2" 
    annotation (Placement(transformation(extent={{288,248},{308,268}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo2
    "Prescribed heat flow to model occupancy" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={388,236})));
  Buildings.HeatTransfer.ConductorSingleLayer conExt2(
    n=3,
    mat=Buildings.HeatTransfer.Data.Brick(),
    A=AHeaTra,
    x=0.24) "Conduction through exterior facing layer" 
    annotation (Placement(transformation(extent={{300,170},{320,190}})));
  Buildings.HeatTransfer.ConductorSingleLayer conInt2(
    n=3,
    A=AHeaTra,
    mat=Buildings.HeatTransfer.Data.InsulationBoard(),
    x=0.2) "Conduction through interior facing layer" 
    annotation (Placement(transformation(extent={{328,170},{348,190}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM resRoo1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal/nRoo,
    dp_nominal=dpRoo_nominal,
    from_dp=true) "Resistance of pipe leg that serves the room" 
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={290,290})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM resRoo2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal/nRoo,
    dp_nominal=dpRoo_nominal,
    from_dp=true) "Resistance of pipe leg that serves the room" 
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={290,110})));
  Modelica.Thermal.HeatTransfer.Components.Convection con1
    "Convective heat transfer" 
    annotation (Placement(transformation(extent={{360,350},{380,370}})));
  Modelica.Thermal.HeatTransfer.Components.Convection con2
    "Convective heat transfer" 
    annotation (Placement(transformation(extent={{360,170},{380,190}})));
  Modelica.Blocks.Sources.RealExpression hACon1(y=8*AHeaTra)
    "Convective heat transfer" 
    annotation (Placement(transformation(extent={{340,370},{360,390}})));
  Modelica.Blocks.Sources.RealExpression hACon2(y=8*AHeaTra)
    "Convective heat transfer" 
    annotation (Placement(transformation(extent={{340,190},{360,210}})));
  Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule" 
    annotation (Placement(transformation(extent={{60,410},{80,430}})));
  Modelica.Blocks.Logical.Switch switch3 
    annotation (Placement(transformation(extent={{142,410},{162,430}})));
  Modelica.Blocks.Sources.Constant TRooNig(k=273.15 + 16)
    "Room temperature set point at night" 
    annotation (Placement(transformation(extent={{100,380},{120,400}})));
  Modelica.Blocks.Sources.Constant TRooSet(k=273.15 + 20) 
    annotation (Placement(transformation(extent={{100,430},{120,450}})));
  Fluid.Storage.ExpansionVessel expVes(redeclare package Medium = Medium, VTot=
        1) "Expansion vessel" 
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
equation
  connect(TAmb.port,boi. heatPort) annotation (Line(
      points={{-20,-10},{-10,-10},{-10,-52.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dpSet.y, conPum.u_s) annotation (Line(
      points={{141,110},{158,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOutBC.y, TOut2.T) 
                            annotation (Line(
      points={{1,360},{200,360},{200,180},{258,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo2.port, TRoo2.port) 
                               annotation (Line(
      points={{400,180},{420,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRoo2.T, conRoo2.u_m) 
                              annotation (Line(
      points={{440,180},{470,180},{470,208}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumRad.port_b, dpSen.port_a) 
                                     annotation (Line(
      points={{220,54},{186,54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo1.port, TRoo1.port) 
                               annotation (Line(
      points={{400,360},{420,360}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TRoo1.T, conRoo1.u_m) 
                              annotation (Line(
      points={{440,360},{470,360},{470,388}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rad1.heatPortCon, roo1.port) annotation (Line(
      points={{400,315.2},{400,360}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dpSen.port_b, pumRad.port_a) 
                                     annotation (Line(
      points={{186,34},{220,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpSen.p_rel, conPum.u_m) annotation (Line(
      points={{177,44},{170,44},{170,98}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(val1.port_b, rad1.port_a) annotation (Line(
      points={{340,308},{392,308}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val2.port_b, rad2.port_a) annotation (Line(
      points={{340,128},{392,128}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(conRoo1.y, val1.y) annotation (Line(
      points={{481,400},{494,400},{494,332},{330,332},{330,316}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRoo2.y, val2.y) 
                            annotation (Line(
      points={{481,220},{492,220},{492,150},{330,150},{330,136}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumRad.port_a, thrWayVal.port_2) 
                                         annotation (Line(
      points={{220,34},{220,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi.port_b,pumBoi. port_a) annotation (Line(
      points={{5.55112e-16,-60},{56,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.heaPorVol[1], tanTemTop.port) annotation (Line(
      points={{240,-60.96},{272,-60.96},{272,-46},{286,-46}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tanTemBot.port, tan.heaPorVol[tan.nSeg]) annotation (Line(
      points={{286,-74},{272,-74},{272,-60},{240,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tanTemBot.T, greThr.u)        annotation (Line(
      points={{306,-74},{330,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumBoi.port_b, res3.port_a) annotation (Line(
      points={{76,-60},{114,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res4.port_b, tan.port_b) annotation (Line(
      points={{260,-32},{260,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tanTemTop.T, lesThr.u) annotation (Line(
      points={{306,-46},{330,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(iniSte.outPort[1], transition.inPort) annotation (Line(
      points={{340.5,40},{356,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(transition.outPort, onSta.inPort[1]) annotation (Line(
      points={{361.5,40},{366.25,40},{366.25,40.5},{391,40.5}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(onSta.outPort[1], toOff.inPort) annotation (Line(
      points={{412.5,40},{426,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(toOff.outPort, offSta.inPort[1]) annotation (Line(
      points={{431.5,40},{445,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(toOn.outPort, onSta.inPort[2]) annotation (Line(
      points={{481.5,40},{488,40},{488,66},{378,66},{378,39.5},{391,39.5}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(offSta.outPort[1], toOn.inPort) annotation (Line(
      points={{466.5,40},{476,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(lesThr.y, toOn.condition) annotation (Line(
      points={{353,-46},{480,-46},{480,28}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(pumRad.port_b, res1.port_a) annotation (Line(
      points={{220,54},{220,92}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumRad.port_b, temSup.port) annotation (Line(
      points={{220,54},{220,60},{140,60},{140,62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSup.T, conVal.u_m) annotation (Line(
      points={{147,72},{160,72},{160,-20},{190,-20},{190,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(res2.port_b, temRet.port) annotation (Line(
      points={{240,80},{240,60},{274,60},{274,62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(conVal.y, thrWayVal.y) annotation (Line(
      points={{201,6.10623e-16},{212,6.10623e-16},{212,1.15598e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onSta.active, booToRea.u) annotation (Line(
      points={{402,29},{402,20},{82,20}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(lesThr.y, transition.condition) annotation (Line(
      points={{353,-46},{360,-46},{360,28}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(greThr.y, toOff.condition) annotation (Line(
      points={{353,-74},{430,-74},{430,28}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(heaCha.TSup, conVal.u_s) annotation (Line(
      points={{81,76},{110,76},{110,6.66134e-16},{178,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOutBC.y, heaCha.TOut) annotation (Line(
      points={{1,360},{27.5,360},{27.5,76},{58,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOutBC.y, TOut1.T) annotation (Line(
      points={{1,360},{258,360}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToRea.y,boi. y) annotation (Line(
      points={{59,20},{-50,20},{-50,-52},{-22,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tan.port_b, boi.port_a) annotation (Line(
      points={{260,-60},{260,-92},{-28,-92},{-28,-60},{-20,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.port_a, thrWayVal.port_1) annotation (Line(
      points={{220,-60},{220,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res3.port_b, tan.port_a) annotation (Line(
      points={{134,-60},{220,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res4.port_a, res2.port_b) annotation (Line(
      points={{260,-12},{260,-6},{240,-6},{240,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_b, thrWayVal.port_3) annotation (Line(
      points={{240,80},{240,-1.68051e-18},{230,-1.68051e-18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(venLos1.port_a, TOut1.port) annotation (Line(
      points={{320,400},{290,400},{290,360},{280,360}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(venLos1.port_b, roo1.port) annotation (Line(
      points={{340,400},{388,400},{388,360},{400,360}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(venLos2.port_a, TOut2.port) 
                                     annotation (Line(
      points={{320,220},{290,220},{290,180},{280,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(venLos2.port_b, roo2.port) annotation (Line(
      points={{340,220},{388,220},{388,180},{400,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOut1.port, conExt1.port_a) 
                                     annotation (Line(
      points={{280,360},{300,360}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExt1.port_b, conInt1.port_a) 
                                         annotation (Line(
      points={{320,360},{328,360}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(occSch1.occupied, switch1.u2) annotation (Line(
      points={{281,430},{318,430}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(occ1.y, switch1.u1) annotation (Line(
      points={{309,438},{318,438}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.y, preHeaFlo1.Q_flow) annotation (Line(
      points={{341,430},{388,430},{388,426}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zer.y, switch1.u3) annotation (Line(
      points={{241,420},{300,420},{300,422},{318,422}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occSch2.occupied, switch2.u2) annotation (Line(
      points={{281,250},{318,250}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(switch2.y, preHeaFlo2.Q_flow) annotation (Line(
      points={{341,250},{388,250},{388,246}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ2.y, switch2.u1) annotation (Line(
      points={{309,258},{318,258}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zer.y, switch2.u3) annotation (Line(
      points={{241,420},{250,420},{250,232},{300,232},{300,242},{318,242}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExt2.port_b, conInt2.port_a) 
                                         annotation (Line(
      points={{320,180},{328,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOut2.port, conExt2.port_a) 
                                     annotation (Line(
      points={{280,180},{300,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad1.port_b, resRoo1.port_a) annotation (Line(
      points={{412,308},{420,308},{420,290},{300,290}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rad2.port_b, resRoo2.port_a) annotation (Line(
      points={{412,128},{420,128},{420,110},{300,110}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(conInt1.port_b, con1.solid) annotation (Line(
      points={{348,360},{360,360}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con1.fluid, roo1.port) annotation (Line(
      points={{380,360},{400,360}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conInt2.port_b, con2.solid) annotation (Line(
      points={{348,180},{360,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con2.fluid, roo2.port) annotation (Line(
      points={{380,180},{400,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(hACon1.y, con1.Gc) annotation (Line(
      points={{361,380},{370,380},{370,370}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hACon2.y, con2.Gc) annotation (Line(
      points={{361,200},{370,200},{370,190}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFlo2.port, roo2.port) annotation (Line(
      points={{388,226},{388,180},{400,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHeaFlo1.port, roo1.port) annotation (Line(
      points={{388,406},{388,360},{400,360}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad2.heatPortCon, roo2.port) annotation (Line(
      points={{400,135.2},{400,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad2.heatPortRad, conInt2.port_b) annotation (Line(
      points={{404,135.2},{404,160},{354,160},{354,180},{348,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad1.heatPortRad, conInt1.port_b) annotation (Line(
      points={{404,315.2},{404,340},{354,340},{354,360},{348,360}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(booToRea.y, pumBoi.y_in) annotation (Line(
      points={{59,20},{46,20},{46,-22},{66,-22},{66,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(res2.port_a, resRoo2.port_b) annotation (Line(
      points={{240,100},{238,100},{238,110},{280,110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_a, resRoo1.port_b) annotation (Line(
      points={{240,100},{240,290},{280,290}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, val2.port_a) annotation (Line(
      points={{220,112},{220,128},{320,128}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val1.port_a, res1.port_b) annotation (Line(
      points={{320,308},{220,308},{220,112}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TRooSet.y, switch3.u1) annotation (Line(
      points={{121,440},{130,440},{130,428},{140,428}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occSch.occupied, switch3.u2) annotation (Line(
      points={{81,414},{110,414},{110,420},{140,420}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TRooNig.y, switch3.u3) annotation (Line(
      points={{121,390},{128,390},{128,412},{140,412}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch3.y, conRoo1.u_s) annotation (Line(
      points={{163,420},{192,420},{192,452},{446,452},{446,400},{458,400}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch3.y, conRoo2.u_s) annotation (Line(
      points={{163,420},{192,420},{192,450},{446,450},{446,220},{458,220}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumRad.y_in, conPum.y) annotation (Line(
      points={{210,44},{200,44},{200,110},{181,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(expVes.port_a, boi.port_a) annotation (Line(
      points={{-80,-40},{-80,-60},{-20,-60}},
      color={0,127,255},
      smooth=Smooth.None));
end HydronicHeating;
