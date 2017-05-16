within Buildings.Experimental.ScalableModels.ScalableDemo;
model MultizoneWithVAV
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air(T_default=293.15);
  package MediumW = Buildings.Media.Water "Medium model for water";

  parameter Integer nZon(min=1) = 6 "Number of zones per floor"    annotation(Evaluate=true);
  parameter Integer nFlo(min=1) = 1 "Number of floors"    annotation(Evaluate=true);

  parameter Real VRoo[nZon,nFlo] = {{6*8*2.7 for j in 1:nFlo} for i in 1:nZon} "Room volume";
  constant Real conv=1.2/3600 "Conversion factor for nominal mass flow rate";
  parameter Real m_flow_nominal_each[nZon,nFlo]=
    {{7*conv*VRoo[i,j] for j in 1:nFlo} for i in 1:nZon};
  parameter Real m_flow_nominal = (nZon*nFlo)*(7*conv)*6*8*2.7;

  HVACSystems.VAVBranch vAVBranch[nZon,nFlo](
    redeclare each package MediumA = MediumA,
    redeclare each package MediumW = MediumW,
    m_flow_nominal={{m_flow_nominal_each[i,j] for j in 1:nFlo} for i in 1:nZon},
    VRoo={{VRoo[i,j] for j in 1:nFlo} for i in 1:nZon},
    dpFixed_nominal = {{220 + 20 for j in 1:nFlo} for i in 1:nZon})
    annotation (Placement(transformation(extent={{52,16},{82,46}})));
  ThermalZones.BaseClasses.MultiZoneFluctuatingIHG multiZoneFluctuatingIHG(
    nZon = nZon,
    nFlo = nFlo)
    annotation (Placement(transformation(extent={{48,56},{88,96}})));
  Buildings.Fluid.Movers.FlowControlled_dp fan(
    redeclare package Medium = MediumA,
    constantHead=850,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=10,
    inputType=Buildings.Fluid.Types.InputType.Constant)        "Supply air fan"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Fluid.HeatExchangers.DryEffectivenessNTU hex(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=m_flow_nominal,
    allowFlowReversal2=false,
    m2_flow_nominal=m_flow_nominal*1000*(10 - (-20))/4200/10,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    Q_flow_nominal=m_flow_nominal*1006*(16.7 - 8.5),
    dp1_nominal=0,
    dp2_nominal=0,
    T_a1_nominal=281.65,
    T_a2_nominal=323.15) "Heating coil"
    annotation (Placement(transformation(extent={{-144,-46},{-124,-26}})));
  Fluid.HeatExchangers.WetCoilCounterFlow cooCoi(
    UA_nominal=m_flow_nominal*1000*15/
        Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1=26.2,
        T_b1=12.8,
        T_a2=6,
        T_b2=16),
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=m_flow_nominal*1000*15/4200/10,
    m2_flow_nominal=m_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Cooling coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-66,-36})));
  Fluid.FixedResistances.PressureDrop fil(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = MediumA,
    dp_nominal=200 + 200 + 100,
    from_dp=false,
    linearized=false) "Filter"
    annotation (Placement(transformation(extent={{-176,-36},{-162,-24}})));
  Fluid.Sources.FixedBoundary sinHea(
    redeclare package Medium = MediumW,
    p=300000,
    T=318.15,
    nPorts=1) "Sink for heating coil" annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-148,-74})));
  Fluid.Sources.FixedBoundary souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 12000,
    T=318.15,
    nPorts=1) "Source for heating coil" annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-120,-74})));
  Fluid.Sources.FixedBoundary sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=285.15,
    nPorts=1) "Sink for cooling coil" annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-80,-74})));
  Fluid.Sources.FixedBoundary souCoo(
    redeclare package Medium = MediumW,
    p=3E5 + 12000,
    T=279.15,
    nPorts=1) "Source for cooling coil" annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={-50,-74})));
  Fluid.Sources.Outside amb(redeclare package Medium = MediumA, nPorts=2)
    "Ambient conditions"
    annotation (Placement(transformation(extent={{-318,36},{-304,50}})));
  Fluid.Actuators.Dampers.MixingBox  eco(
    redeclare package Medium = MediumA,
    mOut_flow_nominal=m_flow_nominal,
    mRec_flow_nominal=m_flow_nominal,
    mExh_flow_nominal=m_flow_nominal,
    dpOut_nominal=10,
    dpRec_nominal=10,
    dpExh_nominal=10) "Economizer"
    annotation (Placement(transformation(extent={{-262,50},{-232,20}})));
  Fluid.Sensors.TemperatureTwoPort TMix(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal) "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-208,-38},{-192,-22}})));
  Fluid.Sensors.VolumeFlowRate senSupFlo(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal)
    "Sensor for supply fan flow rate"
    annotation (Placement(transformation(extent={{26,-38},{42,-22}})));
  Fluid.Sensors.TemperatureTwoPort  TRet(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal) "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-182,118},{-196,134}})));
  Fluid.Sensors.VolumeFlowRate  senRetFlo(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal)
    "Sensor for return fan flow rate"
    annotation (Placement(transformation(extent={{28,118},{12,134}})));
  Fluid.Movers.SpeedControlled_y  fanRet(
    redeclare package Medium = MediumA,
    tau=60,
    per(pressure(V_flow=m_flow_nominal/1.2*{0,2}, dp=1.5*110*{2,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Return air fan"
    annotation (Placement(transformation(extent={{-6,116},{-26,136}})));
  Fluid.Actuators.Valves.TwoWayLinear   valHea(
    redeclare package Medium = MediumW,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    dpValve_nominal=6000,
    m_flow_nominal=m_flow_nominal*1000*40/4200/10,
    from_dp=true,
    dpFixed_nominal=6000) "Heating coil valve"
                                       annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={-121,-55})));
  Fluid.Actuators.Valves.TwoWayLinear  valCoo(
    redeclare package Medium = MediumW,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    m_flow_nominal=m_flow_nominal*1000*15/4200/10,
    dpValve_nominal=6000,
    from_dp=true,
    dpFixed_nominal=6000) "Cooling coil valve"
                                       annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={-51,-55})));
  Fluid.Sensors.VolumeFlowRate VOut1(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal) "Outside air volume flow rate"
    annotation (Placement(transformation(extent={{-292,14},{-276,30}})));
  Fluid.Sensors.TemperatureTwoPort TCoiHeaOut(redeclare package Medium =
               MediumA, m_flow_nominal=m_flow_nominal)
    "Heating coil outlet temperature"    annotation (Placement(transformation(extent={{-102,-38},{-88,-22}})));
  Fluid.Sensors.TemperatureTwoPort  TSup(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal)    annotation (Placement(transformation(extent={{0,-38},{16,-22}})));

  Modelica.Blocks.Sources.Constant TSupSetHea(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0), k=273.15 + 10) "Supply air temperature setpoint for heating"
    annotation (Placement(transformation(extent={{-270,-66},{-258,-54}})));
  Buildings.Experimental.ScalableModels.Controls.CoolingCoilTemperatureSetpoint TSetCoo "Setpoint for cooling coil"
    annotation (Placement(transformation(extent={{-238,-94},{-226,-82}})));
  Buildings.Controls.Continuous.LimPID cooCoiCon(
    reverseAction=true,
    Td=60,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    yMax=1,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=600,
    k=0.01) "Controller for cooling coil"
    annotation (Placement(transformation(extent={{-192,-94},{-180,-82}})));
  Buildings.Controls.Continuous.LimPID heaCoiCon(
    yMax=1,
    yMin=0,
    Td=60,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=600,
    k=0.01) "Controller for heating coil"
    annotation (Placement(transformation(extent={{-192,-66},{-180,-54}})));
  Buildings.Experimental.ScalableModels.Controls.ModeSelector modeSelector
    annotation (Placement(transformation(extent={{-178,40},{-162,56}})));
  Buildings.Experimental.ScalableModels.Controls.Economizer conEco(
    dT=1,
    VOut_flow_min=0.3*m_flow_nominal/1.2,
    Ti=600,
    k=0.1) "Controller for economizer"
    annotation (Placement(transformation(extent={{-288,88},{-276,100}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-360,164},{-340,184}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather Data Bus"
    annotation (Placement(transformation(extent={{-334,164},{-314,184}})));
  Modelica.Blocks.Routing.RealPassThrough TOut(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0))
    annotation (Placement(transformation(extent={{-328,142},{-316,154}})));
  Buildings.Utilities.Math.Average ave(nin=nZon*nFlo)
    "Compute average of room temperatures"
    annotation (Placement(transformation(extent={{110,68},{122,80}})));
  Buildings.Utilities.Math.Min min(nin=nZon*nFlo) "Computes lowest room temperature"
    annotation (Placement(transformation(extent={{110,96},{122,108}})));
  Buildings.Experimental.ScalableModels.Controls.FanVFD
                                                 conFanRet(xSet_nominal(displayUnit="m3/s") = m_flow_nominal/
      1.2, r_N_min=0.2) "Controller for fan"
    annotation (Placement(transformation(extent={{12,158},{26,172}})));
  Buildings.Experimental.ScalableModels.Controls.ControlBus controlBus
    annotation (Placement(transformation(extent={{-78,44},{-58,64}})));
  Schedules.HeatSetpoint                                       TSetHea "Heating setpoint"
    annotation (Placement(transformation(extent={{-120,36},{-112,44}})));
  Schedules.CoolSetpoint                                       TSetCoo1
                                                                       "Cooling setpoint"
    annotation (Placement(transformation(extent={{-120,20},{-112,28}})));
equation
  connect(eco.port_Sup, TMix.port_a) annotation (Line(points={{-232,26},{-220,26},
          {-220,-30},{-208,-30}}, color={0,127,255},
      thickness=0.5));
  connect(TMix.port_b, fil.port_a) annotation (Line(points={{-192,-30},{-184,-30},
          {-176,-30}}, color={0,127,255},
      thickness=0.5));
  connect(hex.port_b2, sinHea.ports[1]) annotation (Line(points={{-144,-42},{-148,
          -42},{-148,-66}}, color={0,127,255}));
  for iZon in 1:nZon loop
    for iFlo in 1:nFlo loop
        connect(vAVBranch[iZon, iFlo].port_b, multiZoneFluctuatingIHG.portsIn[iZon, iFlo])  annotation (Line(points={{67,46},
              {68.2,46},{68.2,61.8}},                                                                                                                color={0,127,
              255},
          thickness=0.5));
        connect(multiZoneFluctuatingIHG.portsOut[iZon, iFlo], senRetFlo.port_a) annotation (
     Line(points={{68.2,89.8},{68.2,126},{28,126}}, color={0,127,255},
          thickness=0.5));
        connect(multiZoneFluctuatingIHG.TRooAir[iZon, iFlo], vAVBranch[iZon, iFlo].TRoo) annotation (Line(points={{90,64.8},
              {90,64.8},{90,66},{102,66},{102,50},{44,50},{44,36},{50,36}},
        color={0,0,127},
          pattern=LinePattern.Dash));
    end for;
  end for;
  connect(eco.port_Exh, amb.ports[1]) annotation (Line(points={{-262,44},{-278,44},
          {-278,44.4},{-304,44.4}}, color={0,127,255},
      thickness=0.5));
  connect(senRetFlo.port_b, fanRet.port_a)
    annotation (Line(points={{12,126},{-6,126}}, color={0,127,255},
      thickness=0.5));
  connect(fanRet.port_b, TRet.port_a)
    annotation (Line(points={{-26,126},{-182,126}}, color={0,127,255},
      thickness=0.5));
  connect(TRet.port_b, eco.port_Ret) annotation (Line(points={{-196,126},{-220,126},
          {-220,44},{-232,44}}, color={0,127,255},
      thickness=0.5));
  connect(hex.port_a2, valHea.port_b) annotation (Line(points={{-124,-42},{-121,
          -42},{-121,-50}},
                      color={0,127,255}));
  connect(souHea.ports[1], valHea.port_a) annotation (Line(points={{-120,-66},{-120,
          -60},{-121,-60}},color={0,127,255}));
  connect(valCoo.port_a, souCoo.ports[1]) annotation (Line(points={{-51,-60},{-50,
          -60},{-50,-66}}, color={0,127,255}));
  connect(amb.ports[2], VOut1.port_a) annotation (Line(points={{-304,41.6},{-298,
          41.6},{-298,22},{-292,22}}, color={0,127,255},
      thickness=0.5));
  connect(VOut1.port_b, eco.port_Out) annotation (Line(points={{-276,22},{-270,22},
          {-270,26},{-262,26}},
                      color={0,127,255},
      thickness=0.5));
  connect(fil.port_b, hex.port_a1) annotation (Line(points={{-162,-30},{-162,-30},
          {-144,-30}}, color={0,127,255},
      thickness=0.5));
  connect(hex.port_b1, TCoiHeaOut.port_a) annotation (Line(points={{-124,-30},{-102,
          -30}},            color={0,127,255},
      thickness=0.5));
  connect(fan.port_b, TSup.port_a) annotation (Line(points={{-20,-30},{0,-30}},
                     color={0,127,255},
      thickness=0.5));
  connect(TSup.port_b, senSupFlo.port_a)
    annotation (Line(points={{16,-30},{16,-30},{26,-30}}, color={0,127,255},
      thickness=0.5));
  for iZon in 1:nZon loop
    for iFlo in 1:nFlo loop
      connect(senSupFlo.port_b, vAVBranch[iZon, iFlo].port_a) annotation (Line(points={{42,-30},
              {58,-30},{68,-30},{68,16},{67,16}}, color={0,127,255}));

      connect(controlBus, vAVBranch[iZon, iFlo].controlBus) annotation (Line(
          points={{-68,54},{-42,54},{-12,54},{-12,23.2},{52,23.2}},
          color={255,204,51},
          thickness=0.5));
      connect(multiZoneFluctuatingIHG.TRooAir[iZon, iFlo], ave.u[iZon, iFlo]) annotation (Line(
        points={{90,64.8},{102,64.8},{102,74},{108.8,74}}, color={0,0,127},
      pattern=LinePattern.Dash));
      connect(multiZoneFluctuatingIHG.TRooAir[iZon, iFlo], min.u[iZon, iFlo]) annotation (Line(
        points={{90,64.8},{102,64.8},{102,102},{108.8,102}}, color={0,0,127},
      pattern=LinePattern.Dash));
    end for;
  end for;
  connect(TSupSetHea.y, heaCoiCon.u_s) annotation (Line(points={{-257.4,-60},{-193.2,-60}}, color={0,0,127}));
  connect(TSupSetHea.y, TSetCoo.TSetHea) annotation (Line(points={{-257.4,-60},{
          -248,-60},{-248,-88},{-239.2,-88}}, color={0,0,127}));
  connect(TSetCoo.TSet, cooCoiCon.u_s) annotation (Line(points={{-225.4,-88},{-225.4,
          -88},{-193.2,-88}}, color={0,0,127}));
  connect(TCoiHeaOut.T, heaCoiCon.u_m) annotation (Line(
      points={{-95,-21.2},{-95,-18},{-106,-18},{-106,-84},{-172,-84},{-172,-74},
          {-186,-74},{-186,-67.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TSup.T, cooCoiCon.u_m) annotation (Line(
      points={{8,-21.2},{8,-16},{-12,-16},{-12,-100},{-186,-100},{-186,-95.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(heaCoiCon.y, valHea.y) annotation (Line(
      points={{-179.4,-60},{-172,-60},{-162,-60},{-162,-55},{-127,-55}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(cooCoiCon.y, valCoo.y) annotation (Line(
      points={{-179.4,-88},{-122,-88},{-66,-88},{-66,-55},{-57,-55}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRet.T, conEco.TRet) annotation (Line(
      points={{-189,134.8},{-189,142},{-296,142},{-296,98.4},{-288.8,98.4}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TMix.T, conEco.TMix) annotation (Line(
      points={{-200,-21.2},{-200,-21.2},{-200,106},{-200,114},{-300,114},{-300,96},
          {-288.8,96}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(VOut1.V_flow, conEco.VOut_flow) annotation (Line(
      points={{-284,30.8},{-284,30.8},{-284,56},{-284,66},{-302,66},{-302,93.6},
          {-288.8,93.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TSupSetHea.y, conEco.TSupHeaSet) annotation (Line(
      points={{-257.4,-60},{-216,-60},{-216,68},{-298,68},{-298,91.2},{-288.8,91.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(TSetCoo.TSet, conEco.TSupCooSet) annotation (Line(
      points={{-225.4,-88},{-212,-88},{-212,72},{-294,72},{-294,88.8},{-288.8,88.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(conEco.yOA, eco.y) annotation (Line(
      points={{-275.6,95.2},{-268,95.2},{-268,6},{-247,6},{-247,17}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-340,174},{-324,174}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-324,174},{-326,174},{-326,168},{-334,168},{-334,148},{-329.2,148}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus, amb.weaBus) annotation (Line(
      points={{-324,174},{-308,174},{-308,114},{-346,114},{-346,43.14},{-318,43.14}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(weaBus, multiZoneFluctuatingIHG.weaBus) annotation (Line(
      points={{-324,174},{-324,174},{-58,174},{-58,76},{51.6,76}},
      color={255,204,51},
      thickness=0.5));
  connect(senRetFlo.V_flow, conFanRet.u_m) annotation (Line(
      points={{20,134.8},{20,156.6},{19,156.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conFanRet.u, senSupFlo.V_flow) annotation (Line(
      points={{10.6,165},{2,165},{2,-2},{34,-2},{34,-21.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conFanRet.y, fanRet.y) annotation (Line(
      points={{26.7,165},{36,165},{36,180},{-15.8,180},{-15.8,138}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TCoiHeaOut.port_b, cooCoi.port_a2) annotation (Line(
      points={{-88,-30},{-82,-30},{-76,-30}},
      color={0,127,255},
      thickness=0.5));
  connect(cooCoi.port_b2, fan.port_a) annotation (Line(
      points={{-56,-30},{-48,-30},{-40,-30}},
      color={0,127,255},
      thickness=0.5));
  connect(cooCoi.port_b1, sinCoo.ports[1]) annotation (Line(points={{-76,-42},{-80,
          -42},{-80,-66}}, color={0,127,255}));
  connect(cooCoi.port_a1, valCoo.port_b) annotation (Line(points={{-56,-42},{-51,
          -42},{-51,-50}}, color={0,127,255}));
  connect(modeSelector.cb, TSetCoo.controlBus) annotation (Line(
      points={{-175.455,53.4545},{-206,53.4545},{-206,-92.8},{-233.08,-92.8}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus, conFanRet.controlBus) annotation (Line(
      points={{-68,54},{-50,54},{-36,54},{-36,170.6},{14.1,170.6}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus, conEco.controlBus) annotation (Line(
      points={{-68,54},{-68,54},{-124,54},{-124,104},{-285.6,104},{-285.6,94.4}},
      color={255,204,51},
      thickness=0.5));

  connect(min.y, controlBus.TRooMin) annotation (Line(
      points={{122.6,102},{130,102},{130,10},{-68,10},{-68,54}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ave.y, controlBus.TRooAve) annotation (Line(
      points={{122.6,74},{130,74},{130,10},{-68,10},{-68,54}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(TOut.y, controlBus.TOut) annotation (Line(
      points={{-315.4,148},{-194,148},{-68,148},{-68,54}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(modeSelector.cb, controlBus) annotation (Line(
      points={{-175.455,53.4545},{-121.728,53.4545},{-121.728,54},{-68,54}},
      color={255,204,51},
      thickness=0.5));
  connect(TSetHea.y[1], controlBus.TRooSetHea) annotation (Line(
      points={{-111.6,40},{-92,40},{-92,54},{-68,54}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TSetCoo1.y[1], controlBus.TRooSetCoo) annotation (Line(
      points={{-111.6,24},{-92,24},{-92,54},{-68,54}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (
            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-360,-120},{140,200}})));
end MultizoneWithVAV;
