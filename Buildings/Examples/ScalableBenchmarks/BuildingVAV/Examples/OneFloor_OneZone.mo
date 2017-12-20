within Buildings.Examples.ScalableBenchmarks.BuildingVAV.Examples;
model OneFloor_OneZone "Closed-loop model with 1 zone in 1 floor"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air(T_default=293.15);
  package MediumW = Buildings.Media.Water "Medium model for water";
  parameter Integer nZon(min=1) = 1  "Number of zones per floor"
     annotation(Evaluate=true);
  parameter Integer nFlo(min=1) = 1  "Number of floors"
     annotation(Evaluate=true);
  parameter Modelica.SIunits.PressureDifference dP_pre=850
    "Prescribed pressure difference";
  parameter Modelica.SIunits.Volume VRoo[nZon,nFlo] = {{6*8*2.7 for j in 1:nFlo} for i in 1:nZon}
    "Room volume";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_each[nZon,nFlo]=
    {{7*conv*VRoo[i,j] for j in 1:nFlo} for i in 1:nZon}
    "Nominal flow rate to each zone";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = nZon*(7*conv)*6*8*2.7
    "Nominal system flow rate";
  constant Real conv=1.2/3600
    "Conversion factor for nominal mass flow rate";

  Buildings.Examples.ScalableBenchmarks.BuildingVAV.BaseClasses.VAVBranch vavTer[nZon,nFlo](
    redeclare each package MediumA = MediumA,
    redeclare each package MediumW = MediumW,
    m_flow_nominal={{m_flow_nominal_each[i, j] for j in 1:nFlo} for i in 1:nZon},
    VRoo={{VRoo[i, j] for j in 1:nFlo} for i in 1:nZon},
    dpFixed_nominal={{220 + 20 for j in 1:nFlo} for i in 1:nZon})
    "Supply branch of VAV system"
    annotation (Placement(transformation(extent={{52,12},{82,42}})));

  Buildings.Examples.ScalableBenchmarks.BuildingVAV.ThermalZones.MultiZone buiZon(
    nZon=nZon,
    nFlo=nFlo) "Multizone model with scalable number of zones"
    annotation (Placement(transformation(extent={{48,60},{88,100}})));
  Buildings.Fluid.Movers.FlowControlled_dp fan[nFlo](
    redeclare each package Medium = MediumA,
    each constantHead=850,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each m_flow_nominal=10,
    each inputType=Buildings.Fluid.Types.InputType.Continuous,
    each nominalValuesDefineDefaultPressureCurve=true)
      "Supply air fan"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU hex[nFlo](
    redeclare each package Medium1 = MediumA,
    redeclare each package Medium2 = MediumW,
    each m1_flow_nominal=m_flow_nominal,
    each allowFlowReversal2=false,
    each m2_flow_nominal=m_flow_nominal*1000*(10 - (-20))/4200/10,
    each configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    each Q_flow_nominal=m_flow_nominal*1006*(16.7 - 8.5),
    each dp1_nominal=0,
    each dp2_nominal=0,
    each T_a1_nominal=281.65,
    each T_a2_nominal=323.15) "Heating coil"
    annotation (Placement(transformation(extent={{-144,-46},{-124,-26}})));
  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow cooCoi[nFlo](
    redeclare each package Medium1 = MediumW,
    redeclare each package Medium2 = MediumA,
    each UA_nominal=m_flow_nominal*1000*15/
        Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1=26.2,
        T_b1=12.8,
        T_a2=6,
        T_b2=16),
    each m1_flow_nominal=m_flow_nominal*1000*15/4200/10,
    each m2_flow_nominal=m_flow_nominal,
    each dp2_nominal=0,
    each dp1_nominal=0,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
      "Cooling coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=180, origin={-66,-36})));
  Buildings.Fluid.FixedResistances.PressureDrop fil[nFlo](
    redeclare each package Medium = MediumA,
    each m_flow_nominal=m_flow_nominal,
    each dp_nominal=200 + 200 + 100,
    each from_dp=false,
    each linearized=false) "Filter"
    annotation (Placement(transformation(extent={{-176,-36},{-162,-24}})));
  Buildings.Fluid.Sources.FixedBoundary sinHea[nFlo](
    redeclare each package Medium = MediumW,
    each p=300000,
    each T=318.15,
    each nPorts=1) "Sink for heating coil"
    annotation (Placement(transformation(extent={{-8,-8},{8,8}},
      rotation=90, origin={-148,-74})));
  Buildings.Fluid.Sources.FixedBoundary souHea[nFlo](
    redeclare each package Medium = MediumW,
    each p(displayUnit="Pa") = 300000 + 12000,
    each T=318.15,
    each nPorts=1) "Source for heating coil"
    annotation (Placement(transformation(extent={{-8,-8},{8,8}},
      rotation=90, origin={-120,-74})));
  Buildings.Fluid.Sources.FixedBoundary sinCoo[nFlo](
    redeclare each package Medium = MediumW,
    each p=300000,
    each T=285.15,
    each nPorts=1) "Sink for cooling coil"
    annotation (Placement(transformation(extent={{-8,-8},{8,8}},
      rotation=90, origin={-80,-74})));
  Buildings.Fluid.Sources.FixedBoundary souCoo[nFlo](
    redeclare each package Medium = MediumW,
    each p=3E5 + 12000,
    each T=279.15,
    each nPorts=1) "Source for cooling coil"
    annotation (Placement(transformation(extent={{-8,-8},{8,8}},
      rotation=90, origin={-50,-74})));
  Buildings.Fluid.Sources.Outside amb[nFlo](
    redeclare each package Medium = MediumA,
    each nPorts=2) "Ambient conditions"
    annotation (Placement(transformation(extent={{-320,32},{-306,46}})));
  Buildings.Fluid.Actuators.Dampers.MixingBox  eco[nFlo](
    redeclare each package Medium = MediumA,
    each mOut_flow_nominal=m_flow_nominal,
    each mRec_flow_nominal=m_flow_nominal,
    each mExh_flow_nominal=m_flow_nominal,
    each dpOut_nominal=10,
    each dpRec_nominal=10,
    each dpExh_nominal=10) "Economizer"
    annotation (Placement(transformation(extent={{-262,46},{-232,16}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TMix[nFlo](
    redeclare each package Medium = MediumA,
    each m_flow_nominal=m_flow_nominal) "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-208,-38},{-192,-22}})));
  Buildings.Fluid.Sensors.VolumeFlowRate senSupFlo[nFlo](
    redeclare each package Medium = MediumA,
    each m_flow_nominal=m_flow_nominal)  "Sensor for supply fan flow rate"
    annotation (Placement(transformation(extent={{32,-38},{48,-22}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TRet[nFlo](
    redeclare each package Medium = MediumA,
    each m_flow_nominal=m_flow_nominal) "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-182,118},{-196,134}})));
  Buildings.Fluid.Sensors.VolumeFlowRate senRetFlo[nFlo](
    redeclare each package Medium = MediumA,
    each m_flow_nominal=m_flow_nominal)  "Sensor for return fan flow rate"
    annotation (Placement(transformation(extent={{28,118},{12,134}})));
  Buildings.Fluid.Movers.SpeedControlled_y fanRet[nFlo](
    redeclare each package Medium = MediumA,
    each tau=60,
    each per(pressure(V_flow=m_flow_nominal/1.2*{0,2}, dp=1.5*110*{2,0})),
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
      "Return air fan"
    annotation (Placement(transformation(extent={{-10,116},{-30,136}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valHea[nFlo](
    redeclare each package Medium = MediumW,
    each CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each dpValve_nominal=6000,
    each m_flow_nominal=m_flow_nominal*1000*40/4200/10,
    each from_dp=true,
    each dpFixed_nominal=6000) "Heating coil valve"
    annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=90, origin={-121,-55})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear  valCoo[nFlo](
    redeclare each package Medium = MediumW,
    each CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each m_flow_nominal=m_flow_nominal*1000*15/4200/10,
    each dpValve_nominal=6000,
    each from_dp=true,
    each dpFixed_nominal=6000) "Cooling coil valve"
    annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=90, origin={-51,-55})));
  Buildings.Fluid.Sensors.VolumeFlowRate VOut1[nFlo](
    redeclare each package Medium = MediumA,
    each m_flow_nominal=m_flow_nominal) "Outside air volume flow rate"
    annotation (Placement(transformation(extent={{-292,14},{-276,30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCoiHeaOut[nFlo](
    redeclare each package Medium = MediumA,
    each m_flow_nominal=m_flow_nominal) "Heating coil outlet temperature"
    annotation (Placement(transformation(extent={{-102,-38},{-88,-22}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup[nFlo](
    redeclare each package Medium = MediumA,
    each m_flow_nominal=m_flow_nominal) "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{4,-38},{20,-22}})));
  Modelica.Blocks.Sources.Constant TSupSetHea(
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0),
    k=273.15 + 10) "Supply air temperature setpoint for heating"
    annotation (Placement(transformation(extent={{-270,-66},{-258,-54}})));
  Buildings.Examples.VAVReheat.Controls.CoolingCoilTemperatureSetpoint TSetCoo[nFlo]
    "Setpoint for cooling coil"
    annotation (Placement(transformation(extent={{-238,-94},{-226,-82}})));
  Buildings.Controls.Continuous.LimPID cooCoiCon[nFlo](
    each reverseAction=true,
    each Td=60,
    each initType=Modelica.Blocks.Types.InitPID.InitialState,
    each yMax=1,
    each yMin=0,
    each controllerType=Modelica.Blocks.Types.SimpleController.PI,
    each Ti=600,
    each k=0.1) "Controller for cooling coil"
    annotation (Placement(transformation(extent={{-192,-94},{-180,-82}})));
  Buildings.Controls.Continuous.LimPID heaCoiCon[nFlo](
    each yMax=1,
    each yMin=0,
    each Td=60,
    each initType=Modelica.Blocks.Types.InitPID.InitialState,
    each controllerType=Modelica.Blocks.Types.SimpleController.PI,
    each Ti=600,
    each k=0.1)   "Controller for heating coil"
    annotation (Placement(transformation(extent={{-192,-66},{-180,-54}})));
  Buildings.Examples.VAVReheat.Controls.ModeSelector modeSelector[nFlo]
    "Finite State Machine for the operational modes"
    annotation (Placement(transformation(extent={{-178,40},{-162,56}})));
  Buildings.Examples.VAVReheat.Controls.Economizer conEco[nFlo](
    each dT=1,
    each VOut_flow_min=0.3*m_flow_nominal/1.2,
    each Ti=600,
    each k=0.1) "Controller for economizer"
    annotation (Placement(transformation(extent={{-288,88},{-276,100}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-360,160},{-340,180}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather Data Bus"
    annotation (Placement(transformation(extent={{-334,160},{-314,180}})));
  Modelica.Blocks.Routing.RealPassThrough TOut(
    y(final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0)) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-328,140},{-316,152}})));
  Buildings.Utilities.Math.Average ave[nFlo](each nin=nZon)
    "Compute average of room temperatures"
    annotation (Placement(transformation(extent={{108,68},{120,80}})));
  Buildings.Utilities.Math.Min min1[nFlo](each nin=nZon)
    "Computes lowest room temperature"
    annotation (Placement(transformation(extent={{108,94},{120,106}})));
  Buildings.Examples.VAVReheat.Controls.FanVFD conFanRet[nFlo](
    each xSet_nominal(displayUnit="m3/s") = m_flow_nominal/1.2,
    each r_N_min=0.2) "Controller for fan"
    annotation (Placement(transformation(extent={{14,152},{28,166}})));
  Buildings.Examples.ScalableBenchmarks.BuildingVAV.BaseClasses.ControlBus controlBus[nFlo]
    "Control bus for each floor"
    annotation (Placement(transformation(extent={{-78,44},{-58,64}}),
      iconTransformation(extent={{-128,136},{-108,156}})));
  Buildings.Examples.ScalableBenchmarks.BuildingVAV.BaseClasses.HeatSetpoint
    TSetHea "Heating setpoint"
    annotation (Placement(transformation(extent={{-130,30},{-118,42}})));
  Buildings.Examples.ScalableBenchmarks.BuildingVAV.BaseClasses.CoolSetpoint
    TSetCoo1 "Cooling setpoint"
    annotation (Placement(transformation(extent={{-130,10},{-118,22}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-128,70},{-116,82}})));
  Buildings.Examples.ScalableBenchmarks.BuildingVAV.BaseClasses.FanOnOffWithDP
    fan_dP_On_Off[nFlo](each preRis=dP_pre)
    "controller outputs fan on or off"
    annotation (Placement(transformation(extent={{-70,-14},{-56,0}})));

equation
  for iFlo in 1:nFlo loop
    connect(eco[iFlo].port_Sup, TMix[iFlo].port_a)
      annotation (Line(points={{-232,22},{-220,22},{-220,-30},{-208,-30}},
        color={0,127,255}, thickness=0.5));
    connect(TMix[iFlo].port_b, fil[iFlo].port_a)
      annotation (Line(points={{-192,-30},{-184,-30},{-176,-30}},
        color={0,127,255}, thickness=0.5));
    connect(hex[iFlo].port_b2, sinHea[iFlo].ports[1])
      annotation (Line(points={{-144,-42},{-148,-42},{-148,-66}},
        color={0,127,255}));
    connect(TSupSetHea.y, heaCoiCon[iFlo].u_s)
      annotation (Line(points={{-257.4,-60},{-193.2,-60}},
        color={0,0,127}));
    connect(TSupSetHea.y, TSetCoo[iFlo].TSetHea)
      annotation (Line(points={{-257.4,-60},{-248,-60},{-248,-88},{-239.2,-88}},
        color={0,0,127}));
    connect(TSetCoo[iFlo].TSet, cooCoiCon[iFlo].u_s)
      annotation (Line(points={{-225.4,-88},{-225.4,-88},{-193.2,-88}},
        color={0,0,127}));
    connect(TCoiHeaOut[iFlo].T, heaCoiCon[iFlo].u_m)
      annotation (Line(points={{-95,-21.2},{-95,-18},{-106,-18},{-106,-84},
        {-172,-84},{-172,-74},{-186,-74},{-186,-67.2}},
        color={0,0,127}, pattern=LinePattern.Dash));
    connect(TSup[iFlo].T, cooCoiCon[iFlo].u_m)
      annotation (Line(points={{12,-21.2},{12,-16},{0,-16},{0,-100},{-186,-100},
        {-186,-95.2}}, color={0,0,127}, pattern=LinePattern.Dash));
    connect(heaCoiCon[iFlo].y, valHea[iFlo].y)
      annotation (Line(points={{-179.4,-60},{-172,-60},{-162,-60},{-162,-55},{-127,-55}},
        color={0,0,127}, pattern=LinePattern.Dash));
    connect(cooCoiCon[iFlo].y, valCoo[iFlo].y)
      annotation (Line(points={{-179.4,-88},{-122,-88},{-66,-88},{-66,-55},{-57,-55}},
        color={0,0,127}, pattern=LinePattern.Dash));
    connect(TRet[iFlo].T, conEco[iFlo].TRet)
      annotation (Line(points={{-189,134.8},{-189,142},{-294,142},{-294,98.4},
        {-288.8,98.4}}, color={0,0,127}, pattern=LinePattern.Dash));
    connect(TMix[iFlo].T, conEco[iFlo].TMix)
      annotation (Line(points={{-200,-21.2},{-200,-21.2},{-200,106},{-200,114},
        {-298,114},{-298,96},{-288.8,96}}, color={0,0,127}, pattern=LinePattern.Dash));
    connect(VOut1[iFlo].V_flow, conEco[iFlo].VOut_flow)
      annotation (Line(points={{-284,30.8},{-284,30.8},{-284,54},{-284,64},{-302,64},
        {-302,93.6}, {-288.8,93.6}}, color={0,0,127}, pattern=LinePattern.Dash));
    connect(TSupSetHea.y, conEco[iFlo].TSupHeaSet)
      annotation (Line(points={{-257.4,-60},{-216,-60},{-216,68},{-298,68},{-298,91.2},
        {-288.8,91.2}}, color={0,0,127}, pattern=LinePattern.Dash));
    connect(TSetCoo[iFlo].TSet, conEco[iFlo].TSupCooSet)
      annotation (Line(points={{-225.4,-88},{-212,-88},{-212,72},{-294,72},{-294,88.8},
        {-288.8,88.8}}, color={0,0,127}, pattern=LinePattern.Dash));
    connect(conEco[iFlo].yOA, eco[iFlo].y)
      annotation (Line(points={{-275.6,95.2},{-268,95.2},{-268,6},{-247,6},{-247,13}},
        color={0,0,127}, pattern=LinePattern.Dash));
    connect(weaBus, amb[iFlo].weaBus)
      annotation (Line(points={{-324,170},{-300,170},{-300,120},{-340,120},{-340,39.14},
        {-320,39.14}}, color={255,204,51}, thickness=0.5),
        Text(string="%first", index=-1, extent={{-6,3},{-6,3}}));
    connect(senRetFlo[iFlo].V_flow, conFanRet[iFlo].u_m)
      annotation (Line(points={{20,134.8},{20,150.6},{21,150.6}},
        color={0,0,127}, pattern=LinePattern.Dash));
    connect(conFanRet[iFlo].u, senSupFlo[iFlo].V_flow)
      annotation (Line(points={{12.6,159},{0,159},{0,0},{40,0},{40,-21.2}},
        color={0,0,127}, pattern=LinePattern.Dash));
    connect(conFanRet[iFlo].y, fanRet[iFlo].y)
      annotation (Line(points={{28.7,159},{36,159},{36,180},{-20,180},{-20,138}},
        color={0,0,127}, pattern=LinePattern.Dash));
    connect(TCoiHeaOut[iFlo].port_b, cooCoi[iFlo].port_a2)
      annotation (Line(points={{-88,-30},{-82,-30},{-76,-30}},
        color={0,127,255}, thickness=0.5));
    connect(cooCoi[iFlo].port_b2, fan[iFlo].port_a)
      annotation (Line(points={{-56,-30},{-48,-30},{-40,-30}},
        color={0,127,255}, thickness=0.5));
    connect(cooCoi[iFlo].port_b1, sinCoo[iFlo].ports[1])
      annotation (Line(points={{-76,-42},{-80,-42},{-80,-66}},
        color={0,127,255}));
    connect(cooCoi[iFlo].port_a1, valCoo[iFlo].port_b)
      annotation (Line(points={{-56,-42},{-51,-42},{-51,-50}},
        color={0,127,255}));
    connect(modeSelector[iFlo].cb, TSetCoo[iFlo].controlBus)
      annotation (Line(points={{-175.455,53.4545},{-206,53.4545},{-206,-92.8},{
            -233.08,-92.8}},
        color={255,204,51}, thickness=0.5));
    connect(controlBus[iFlo], conEco[iFlo].controlBus)
      annotation (Line(points={{-68,54},{-68,54},{-134,54},{-134,104},{-285.6,104},
        {-285.6,94.4}}, color={255,204,51}, thickness=0.5));
    connect(controlBus[iFlo], modeSelector[iFlo].cb)
      annotation (Line(points={{-68,54},{-121.728,54},{-121.728,53.4545},{
            -175.455,53.4545}},
        color={255,204,51}, thickness=0.5));
    connect(controlBus[iFlo], fan_dP_On_Off[iFlo].controlBus)
      annotation (Line(points={{-68,54},{-68,54},{-68,-1.4},{-67.2,-1.4}},
        color={255,204,51}, thickness=0.5),
        Text(string="%first", index=-1, extent={{-6,3},{-6,3}}));
    connect(min1[iFlo].y, controlBus[iFlo].TRooMin)
      annotation (Line(points={{120.6,100},{130,100},{130,6},{-67.95,6},{-67.95,54.05}},
        color={0,0,127}, pattern=LinePattern.Dash));
    connect(ave[iFlo].y, controlBus[iFlo].TRooAve)
      annotation (Line(points={{120.6,74},{130,74},{130,6},{-67.95,6},{-67.95,54.05}},
        color={0,0,127}, pattern=LinePattern.Dash));
    connect(TOut.y, controlBus[iFlo].TOut)
      annotation (Line(points={{-315.4,146},{-315.4,148},{-67.95,148},{-67.95,54.05}},
        color={0,0,127}, pattern=LinePattern.Dash));
    connect(TSetHea.y[1], controlBus[iFlo].TRooSetHea)
      annotation (Line(points={{-117.4,36},{-92,36},{-92,54.05},{-67.95,54.05}},
        color={255,204,51}, thickness=0.5),
        Text(string="%second", index=1, extent={{6,3},{6,3}}));
    connect(TSetCoo1.y[1], controlBus[iFlo].TRooSetCoo)
      annotation (Line(points={{-117.4,16},{-92,16},{-92,54.05},{-67.95,54.05}},
        color={255,204,51}, thickness=0.5),
        Text(string="%second", index=1, extent={{6,3},{6,3}}));
    connect(occSch.tNexOcc, controlBus[iFlo].dTNexOcc)
      annotation (Line(points={{-115.4,79.6},{-92,79.6},{-92,54.05},{-67.95,54.05}},
        color={255,204,57}, thickness=0.5),
        Text(string="%second", index=1, extent={{6,3},{6,3}}));
    connect(occSch.occupied, controlBus[iFlo].occupied)
      annotation (Line(points={{-115.4,72.4},{-92,72.4},{-92,54.05},{-67.95,54.05}},
        color={255,204,51}, thickness=0.5),
        Text(string="%second", index=1, extent={{6,3},{6,3}}));
    connect(eco[iFlo].port_Exh, amb[iFlo].ports[1])
      annotation (Line(points={{-262,40},{-278,40},{-278,40.4},{-306,40.4}},
        color={0,127,255}, thickness=0.5));
    connect(senRetFlo[iFlo].port_b, fanRet[iFlo].port_a)
      annotation (Line(points={{12,126},{-10,126}},color={0,127,255}, thickness=0.5));
    connect(fanRet[iFlo].port_b, TRet[iFlo].port_a)
      annotation (Line(points={{-30,126},{-182,126}},
        color={0,127,255}, thickness=0.5));
    connect(TRet[iFlo].port_b, eco[iFlo].port_Ret)
      annotation (Line(points={{-196,126},{-220,126},{-220,40},{-232,40}},
        color={0,127,255}, thickness=0.5));
    connect(hex[iFlo].port_a2, valHea[iFlo].port_b)
      annotation (Line( points={{-124,-42},{-121,-42},{-121,-50}},
        color={0,127,255}));
    connect(souHea[iFlo].ports[1], valHea[iFlo].port_a)
      annotation (Line(points={{-120,-66},{-120,-60},{-121,-60}},
        color={0,127,255}));
    connect(valCoo[iFlo].port_a, souCoo[iFlo].ports[1])
      annotation (Line(points={{-51,-60},{-50,-60},{-50,-66}},
        color={0,127,255}));
    connect(amb[iFlo].ports[2], VOut1[iFlo].port_a)
      annotation (Line(points={{-306,37.6},{-300,37.6},{-300,22},{-292,22}},
        color={0,127,255}, thickness=0.5));
    connect(VOut1[iFlo].port_b, eco[iFlo].port_Out)
      annotation (Line(points={{-276,22},{-270,22},{-262,22}},
        color={0,127,255}, thickness=0.5));
    connect(fil[iFlo].port_b, hex[iFlo].port_a1)
      annotation (Line(points={{-162,-30},{-162,-30},{-144,-30}},
        color={0,127,255}, thickness=0.5));
    connect(hex[iFlo].port_b1, TCoiHeaOut[iFlo].port_a)
      annotation (Line(points={{-124,-30},{-102,-30}},
        color={0,127,255}, thickness=0.5));
    connect(fan[iFlo].port_b, TSup[iFlo].port_a)
      annotation (Line(points={{-20,-30},{4,-30}},
        color={0,127,255}, thickness=0.5));
    connect(TSup[iFlo].port_b, senSupFlo[iFlo].port_a)
      annotation (Line(points={{20,-30},{20,-30},{32,-30}},
        color={0,127,255}, thickness=0.5));
    connect(fan_dP_On_Off[iFlo].y, fan[iFlo].dp_in)
      annotation (Line(points={{-55.3,-7},{-30,-7},{-30,-18}}, color={0,0,127}));
  end for;

  for iFlo in 1:nFlo loop
    for iZon in 1:nZon loop
      connect(vavTer[iZon, iFlo].port_b, buiZon.portsIn[iZon, iFlo])
        annotation (Line(points={{67,42},{68.2,42},{68.2,65.8}},
          color={0,127,255}, thickness=0.5));
      connect(buiZon.portsOut[iZon, iFlo], senRetFlo[iFlo].port_a)
        annotation (Line(points={{68.2,93.8},{68.2,126},{28,126}},
          color={0,127,255}, thickness=0.5));
      connect(buiZon.TRooAir[iZon, iFlo], vavTer[iZon, iFlo].TRoo)
        annotation (Line(points={{90,68},{100,68},{100,52},{40,52},{40,18},{50,18}},
          color={0,0,127}, pattern=LinePattern.Dash));
      connect(senSupFlo[iFlo].port_b, vavTer[iZon, iFlo].port_a)
        annotation (Line(points={{48,-30},{48,-30},{68,-30},{68,12},{67,12}},
          color={0,127,255}, thickness=0.5));
      connect(buiZon.TRooAir[iZon, iFlo], ave[iFlo].u[iZon])
        annotation (Line(points={{90,68},{100,68},{100,74},{106.8,74}},
          color={0,0,127}, pattern=LinePattern.Dash));
      connect(buiZon.TRooAir[iZon, iFlo], min1[iFlo].u[iZon])
        annotation (Line(points={{90,68},{100,68},{100,100},{106.8,100}},
          color={0,0,127}, pattern=LinePattern.Dash));
      connect(vavTer[iZon, iFlo].TRooHeaSet, controlBus[iFlo].TRooSetHea) annotation (Line(
        points={{50,30},{-68,30},{-68,30},{-67.95,30},{-67.95,54.05}}, color={0,
          0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
      connect(vavTer[iZon, iFlo].TRooCooSet, controlBus[iFlo].TRooSetCoo) annotation (Line(
        points={{50,26},{-68,26},{-68,28},{-67.95,28},{-67.95,54.05}}, color={0,
          0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    end for;
  end for;

  connect(weaDat.weaBus, weaBus)
    annotation (Line(points={{-340,170},{-336,170},{-324,170}},
      color={255,204,51}, thickness=0.5));
  connect(weaBus.TDryBul, TOut.u)
    annotation (Line(points={{-324,170},{-326,170},{-334,170},{-334,146},{-329.2,146}},
      color={255,204,51}, thickness=0.5),
      Text(string="%first", index=-1, extent={{-6,3},{-6,3}}));
  connect(weaBus, buiZon.weaBus)
    annotation (Line(points={{-324,170},{-324,170},{-44,170},{-44,80},{51.6,80}},
      color={255,204,51}, thickness=0.5));


  connect(modeSelector.yFan, conFanRet.uFan) annotation (Line(points={{-161.636,
          48},{-161.636,48},{-146,48},{-146,163.2},{12.6,163.2}}, color={255,0,
          255}));
annotation (
  experiment(StopTime=604800, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/ScalableBenchmarks/BuildingVAV/Examples/OneFloor_OneZone.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-360,-120},{140,200}})),
  Documentation(info="<html>
<p>
Model an buiding that has multiple thermal zones on each floor,
and an HVAC system on each floor.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each zone inlet branches. Each floor has one VAV
AHU system.
The figure below shows the schematic diagram of the HVAC system
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/ScalableBenchmarks/vavSchematics.png\" border=\"1\"/>
</p>
<p>
The control sequence regulates the supply fan speed to ensure a
prescribed pressure rise of <code>850 Pa</code> when the supply fan runs
during operation modes <i>occupied</i>, <i>unoccupied night set back</i>,
<i>unoccupied warm-up</i> and <i>unoccupied pre-cool</i>.
The economizer dampers are modulated to track the setpoint for the
mixed air dry bulb temperature.
Priority is given to maintain a minimum outside air volume flow rate.
In each zone, the VAV damper is adjusted to meet the room temperature
setpoint for cooling, or fully opened during heating.
The room temperature setpoint for heating is tracked by varying
the water flow rate through the reheat coil. There is also a
finite state machine that transitions the mode of operation of
the HVAC system between the modes
<i>occupied</i>, <i>unoccupied off</i>, <i>unoccupied night set back</i>,
<i>unoccupied warm-up</i> and <i>unoccupied pre-cool</i>.
Local loop control is implemented using proportional and proportional-integral
controllers, while the supervisory control is implemented
using a finite state machine.
</p>

<p>
The thermal room model computes transient heat conduction through
walls, floors and ceilings and long-wave radiative heat exchange between
surfaces. The convective heat transfer coefficient is computed based
on the temperature difference between the surface and the room air.
There is also a layer-by-layer short-wave radiation,
long-wave radiation, convection and conduction heat transfer model for the
windows. The model is similar to the Window 5 model and described in
TARCOG 2006.
</p>
<p>
Each thermal zone can have air flow from the HVAC system, through leakages of
the building envelope.
</p>
<h4>References</h4>
<p>
ASHRAE.
<i>Sequences of Operation for Common HVAC Systems</i>.
ASHRAE, Atlanta, GA, 2006.
</p>
<p>
Deru M., K. Field, D. Studer, K. Benne, B. Griffith, P. Torcellini,
 M. Halverson, D. Winiarski, B. Liu, M. Rosenberg, J. Huang, M. Yazdanian,
 and D. Crawley.
<i>DOE commercial building research benchmarks for commercial buildings</i>.
Technical report, U.S. Department of Energy, Energy Efficiency and
Renewable Energy, Office of Building Technologies, Washington, DC, 2009.
</p>
<p>
TARCOG 2006: Carli, Inc., TARCOG: Mathematical models for calculation
of thermal performance of glazing systems with our without
shading devices, Technical Report, Oct. 17, 2006.
</p>
</html>", revisions="<html>
<ul>
<li>
October 24, 2017, by Michael Wetter:<br/>
Updated model for new fan controller that takes the on/off signal
as an input.
</li>
<li>
June 6, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OneFloor_OneZone;
