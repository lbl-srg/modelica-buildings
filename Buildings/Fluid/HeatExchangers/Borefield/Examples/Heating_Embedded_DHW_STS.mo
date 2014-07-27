within Buildings.Fluid.HeatExchangers.Borefield.Examples;
model Heating_Embedded_DHW_STS
  "Example and test for heating system with embedded emission, DHW and STS"
  import Buildings;

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
  parameter Data.BorefieldData.SandStone_Bentonite_c8x1_h110_b5_d600_T283
    bfData
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  final parameter Integer lenSim=3600*24*20;
  final parameter Integer nZones=2 "Number of zones";

  // --- Domestic Hot Water (DHW) Parameters
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_DHW=sim.nOcc*dHW.VDayAvg
      *983/(3600*24)*10 "nominal mass flow rate of DHW";
  parameter Modelica.SIunits.Temperature TDHWSet(max=273.15 + 60) = 273.15 + 45
    "DHW temperature setpoint";
  parameter Modelica.SIunits.Temperature TColdWaterNom=273.15 + 10
    "Nominal tap (cold) water temperature";

  // --- Storage Tank Parameters
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_stoHX=
      m_flow_nominal_DHW*(TDHWSet - TColdWaterNom)/dTHPTankSet
    "nominal mass flow rate of HX of storage tank";
  parameter SI.TemperatureDifference dTHPTankSet(min=1) = 2
    "Difference between tank setpoint and heat pump setpoint";
  parameter Modelica.SIunits.Volume volumeTank=0.25;
  parameter Modelica.SIunits.Area AColTot=1 "TOTAL collector area";
  parameter Integer nbrNodes=10 "Number of nodes in the tank";
  parameter Integer posTTop(max=nbrNodes) = 1
    "Position of the top temperature sensor";
  parameter Integer posTBot(max=nbrNodes) = nbrNodes - 2
    "Position of the bottom temperature sensor";
  parameter Integer posOutHP(max=nbrNodes + 1) = if solSys then nbrNodes - 1
     else nbrNodes + 1 "Position of extraction of TES to HP";
  parameter Integer posInSTS(max=nbrNodes) = nbrNodes - 1
    "Position of injection of STS in TES";
  parameter Boolean solSys(fixed=true) = false;

  // --- Paramter: General parameters for the design (nominal) conditions and heat curve
  parameter Modelica.SIunits.Power[nZones] QNom(each min=0) = {8000 for i in 1:nZones}
    "Nominal power, can be seen as the max power of the emission system per zone";
  parameter Boolean minSup=true
    "true to limit the supply temperature on the lower side";
  parameter SI.Temperature TSupMin=273.15 + 30
    "Minimum supply temperature if enabled";
  parameter Modelica.SIunits.Temperature TSupNom=273.15 + 45
    "Nominal supply temperature";
  parameter Modelica.SIunits.TemperatureDifference dTSupRetNom=10
    "Nominal DT in the heating system";
  parameter Modelica.SIunits.Temperature[nZones] TRoomNom={294.15 for i in 1:
      nZones} "Nominal room temperature";
  parameter Modelica.SIunits.TemperatureDifference corFac_val=5
    "correction term for TSet of the heating curve";
  parameter Modelica.SIunits.Time timeFilter=43200
    "Time constant for the filter of ambient temperature for computation of heating curve";
  final parameter Modelica.SIunits.MassFlowRate[nZones] m_flow_nominal=QNom/(4180.6
      *dTSupRetNom) "Nominal mass flow rates";

  parameter
    Buildings.Fluid.HeatExchangers.Examples.BaseClasses.RadSlaCha_ValidationEmpa[
    nZones] radSlaCha_ValidationEmpa(A_Floor=dummyBuilding.AZones)
    annotation (Placement(transformation(extent={{-190,100},{-170,120}})));

  Buildings.HeatingSystems.Examples.DummyBuilding dummyBuilding(
    nZones=nZones,
    AZones=ones(nZones)*40,
    VZones=dummyBuilding.AZones*3,
    UA_building=150)
    annotation (Placement(transformation(extent={{256,34},{224,54}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convectionTabs
    annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={192,58})));
  Buildings.Fluid.HeatExchangers.Examples.BaseClasses.NakedTabs[nZones] nakedTabs(
      radSlaCha=radSlaCha_ValidationEmpa)
    annotation (Placement(transformation(extent={{144,46},{164,66}})));

  Modelica.Blocks.Sources.RealExpression[nZones] realExpression(y=11*
        radSlaCha_ValidationEmpa.A_Floor)
    annotation (Placement(transformation(extent={{244,60},{224,80}})));
  Buildings.Fluid.Movers.Pump[nZones] pumpRad(
    each useInput=true,
    each m=1,
    m_flow_nominal=m_flow_nominal,
    redeclare each package Medium = Medium)
    annotation (Placement(transformation(extent={{82,44},{106,20}})));
  Buildings.Fluid.Valves.Thermostatic3WayValve idealCtrlMixer(m_flow_nominal=sum(
        m_flow_nominal), redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{28,26},{50,50}})));
  Buildings.Fluid.FixedResistances.Pipe_Insulated pipeReturn(
    redeclare package Medium = Medium,
    m=1,
    UA=10,
    m_flow_nominal=sum(m_flow_nominal))
    annotation (Placement(transformation(extent={{-4,-108},{-24,-116}})));
  Buildings.Fluid.FixedResistances.Pipe_Insulated pipeSupply(
    redeclare package Medium = Medium,
    m=1,
    UA=10,
    m_flow_nominal=sum(m_flow_nominal))
    annotation (Placement(transformation(extent={{-22,34},{-2,42}})));
  Buildings.Fluid.FixedResistances.Pipe_Insulated[nZones] pipeReturnEmission(
    redeclare each package Medium = Medium,
    each m=1,
    each UA=10,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{142,-108},{122,-116}})));
  Buildings.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe emission[nZones](
    redeclare each package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    m_flowMin=m_flow_nominal/3,
    RadSlaCha=radSlaCha_ValidationEmpa)
    annotation (Placement(transformation(extent={{114,4},{144,24}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    "fixed temperature to simulate heat losses of hydraulic components"
    annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=-90,
        origin={-133,-41})));
  Buildings.Fluid.Sources.FixedBoundary absolutePressure(
    redeclare package Medium = Medium,
    use_T=false,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-112,-134})));

  Controls.ControlHeating.Ctrl_Heating_DHW ctrl_Heating(
    TDHWSet=TDHWSet,
    TColdWaterNom=TColdWaterNom,
    dTHPTankSet=dTHPTankSet)
    "Controller for the heater and the emission set point "
    annotation (Placement(transformation(extent={{-166,34},{-146,54}})));
  Buildings.Controls.Control_fixme.Hyst_NoEvent_Var[nZones] heatingControl(each
      uLow_val=22, each uHigh_val=20)
    "onoff controller for the pumps of the emission circuits"
    annotation (Placement(transformation(extent={{-146,-100},{-126,-80}})));
  Modelica.Blocks.Sources.RealExpression THigh_val[nZones](y=0.5*ones(nZones))
    "Higher boudary for set point temperature"
    annotation (Placement(transformation(extent={{-180,-82},{-168,-62}})));
  Modelica.Blocks.Sources.RealExpression TLow_val[nZones](y=-0.5*ones(nZones))
    "Lower boundary for set point temperature"
    annotation (Placement(transformation(extent={{-180,-122},{-166,-102}})));
  Modelica.Blocks.Sources.RealExpression TSet_max(y=max(TOpSet.y))
    "maximum value of set point temperature" annotation (Placement(
        transformation(
        extent={{-21,-10},{21,10}},
        rotation=0,
        origin={-212,45})));
  Modelica.Blocks.Math.Add add[nZones](each k1=-1, each k2=+1)
    annotation (Placement(transformation(extent={{-180,-98},{-166,-84}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemEm_in(redeclare package
      Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Inlet temperature of the emission system"
    annotation (Placement(transformation(extent={{56,22},{76,42}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHea_out(redeclare package
      Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Outlet temperature of the heater"
    annotation (Placement(transformation(extent={{-68,28},{-48,48}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemEm_out(redeclare package
      Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Outlet temperature of the emission system" annotation (Placement(
        transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={102,-112})));
  Buildings.Fluid.Movers.Pump_Insulated pumpSto(
    redeclare package Medium = Medium,
    useInput=true,
    UA=1,
    m_flow_nominal=m_flow_nominal_stoHX,
    m=1,
    riseTime=100,
    dpFix=0) "Pump for loading the storage tank"
    annotation (Placement(transformation(extent={{-36,-74},{-50,-62}})));
  Buildings.Fluid.Storage.StorageTank_OneIntHX tesTank(
    port_a(m_flow(start=0)),
    nbrNodes=nbrNodes,
    redeclare package Medium = Medium,
    redeclare package MediumHX = Medium,
    heightTank=1.8,
    volumeTank=volumeTank,
    T_start={323.15 for i in 1:nbrNodes},
    m_flow_nominal_HX=m_flow_nominal_stoHX) annotation (Placement(
        transformation(
        extent={{-14,-20},{14,20}},
        rotation=0,
        origin={-18,-20})));
  Buildings.Fluid.Domestic_Hot_Water.DHW_ProfileReader dHW(
    TDHWSet=TDHWSet,
    TColdWaterNom=TColdWaterNom,
    profileType=3,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal_DHW,
    VDayAvg=sim.nOcc*0.045) annotation (Placement(transformation(
        extent={{-9,5},{9,-5}},
        rotation=-90,
        origin={-53,-19})));
  Buildings.Fluid.FixedResistances.Pipe_Insulated pipeDHW(
    redeclare package Medium = Medium,
    m=1,
    UA=10,
    m_flow_nominal=m_flow_nominal_DHW)
    annotation (Placement(transformation(extent={{-34,-52},{-50,-46}})));
  Buildings.Fluid.Sources.FixedBoundary absolutePressure1(
    redeclare package Medium = Medium,
    use_T=false,
    nPorts=1) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={2,-62})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSto_top(redeclare package
      Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Temperature at the top outlet of the storage tank (port_a)"
    annotation (Placement(transformation(extent={{-30,-2},{-38,6}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSto_bot(redeclare package
      Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Temperature at the bottom inlet of the storage tank (port_b)"
    annotation (Placement(transformation(extent={{-12,-54},{-22,-44}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemStoHX_out(redeclare package
      Medium = Medium, m_flow_nominal=sum(m_flow_nominal))
    "Temperature at the outlet of the storage tank heat exchanger (port_bHX)"
    annotation (Placement(transformation(extent={{-72,-74},{-84,-62}})));
  Modelica.Blocks.Sources.Pulse[nZones] TOpSet(
    each amplitude=4,
    each width=67,
    each period=86400,
    each offset=289,
    startTime={3600*7,3600*9})
    annotation (Placement(transformation(extent={{-228,-130},{-208,-110}})));
  inner Buildings.SimInfoManager sim(nOcc=3)
    annotation (Placement(transformation(extent={{-240,100},{-220,120}})));
  Buildings.Fluid.HeatExchangers.Borefield.MultipleBoreHoles
                    multipleBoreholes(lenSim=lenSim, bfData=bfData,
    redeclare package Medium = Medium) "borefield"
    annotation (Placement(transformation(extent={{-170,-46},{-198,-18}})));
  Buildings.Fluid.Movers.Pump               pum(
    redeclare package Medium = Medium,
    T_start=bfData.gen.T_start,
    m_flow(start=bfData.m_flow_nominal),
    m_flow_nominal=bfData.m_flow_nominal,
    useInput=false)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-218,-10})));
  Modelica.Fluid.Sources.Boundary_pT boundary(          redeclare package
      Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{-234,-60},{-214,-40}})));
  Buildings.Fluid.Production.HeatPumpTset heatPumpTset(
    redeclare package MediumBrine = Medium,
    redeclare package MediumFluid = Medium,
    redeclare Buildings.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA45
      heatPumpData,
    allowFlowReversal=false,
    use_scaling=true,
    P_the_nominal=bfData.PThe_nominal)
    annotation (Placement(transformation(extent={{-164,-14},{-138,18}})));

equation
  connect(nakedTabs.port_a, convectionTabs.solid) annotation (Line(
      points={{154,66},{154,70},{174,70},{174,58},{184,58}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs.port_b, convectionTabs.solid) annotation (Line(
      points={{154,46.2},{154,40},{174,40},{174,58},{184,58}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.heatPortEmb, convectionTabs.fluid) annotation (Line(
      points={{224,50},{216,50},{216,58},{200,58}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(realExpression.y, convectionTabs.Gc) annotation (Line(
      points={{223,70},{192,70},{192,66}},
      color={0,0,127},
      smooth=Smooth.None));

  for i in 1:nZones loop
    connect(pipeReturnEmission[i].heatPort, fixedTemperature.port) annotation (
        Line(
        points={{132,-108},{132,-88},{-108,-88},{-108,-32},{-133,-32},{-133,-34}},
        color={191,0,0},
        smooth=Smooth.None));

    connect(senTemEm_in.port_b, pumpRad[i].port_a) annotation (Line(
        points={{76,32},{82,32}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(pipeReturnEmission[i].port_b, senTemEm_out.port_a) annotation (Line(
        points={{122,-112},{110,-112}},
        color={0,127,255},
        smooth=Smooth.None));
  end for;
  connect(heatingControl.y, pumpRad.m_flowSet) annotation (Line(
      points={{-125,-90},{94,-90},{94,19.52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeSupply.heatPort, fixedTemperature.port) annotation (Line(
      points={{-12,34},{-12,14},{-108,14},{-108,-22},{-133,-22},{-133,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipeSupply.port_b, idealCtrlMixer.port_a1) annotation (Line(
      points={{-2,38},{28,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(emission.port_b, pipeReturnEmission.port_a) annotation (Line(
      points={{144,14},{150,14},{150,-112},{142,-112}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumpRad.port_b, emission.port_a) annotation (Line(
      points={{106,32},{110,32},{110,14},{114,14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSet_max.y, ctrl_Heating.TRoo_in1) annotation (Line(
      points={{-188.9,45},{-188.9,44},{-166.889,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, heatingControl.u) annotation (Line(
      points={{-165.3,-91},{-152,-91},{-152,-90},{-148,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealCtrlMixer.port_b, senTemEm_in.port_a) annotation (Line(
      points={{50,38},{54,38},{54,32},{56,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemHea_out.port_b, pipeSupply.port_a) annotation (Line(
      points={{-48,38},{-22,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemEm_out.port_b, pipeReturn.port_a) annotation (Line(
      points={{94,-112},{-4,-112}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(idealCtrlMixer.port_a2, pipeReturn.port_a) annotation (Line(
      points={{39,26},{39,20},{40,20},{40,14},{86,14},{86,-112},{-4,-112}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ctrl_Heating.THeaCur, idealCtrlMixer.TMixedSet) annotation (Line(
      points={{-145.556,49},{-132,49},{-132,56},{39,56},{39,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(THigh_val.y, heatingControl.uHigh) annotation (Line(
      points={{-167.4,-72},{-158,-72},{-158,-83.2},{-148,-83.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TLow_val.y, heatingControl.uLow) annotation (Line(
      points={{-165.3,-112},{-158,-112},{-158,-97},{-148,-97}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumpSto.port_a, tesTank.portHXLower) annotation (Line(
      points={{-36,-68},{-32,-68},{-32,-33.8462}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeDHW.heatPort, fixedTemperature.port) annotation (Line(
      points={{-42,-52},{-62,-52},{-62,-88},{-108,-88},{-108,-32},{-133,-32},{-133,
          -34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumpSto.heatPort, fixedTemperature.port) annotation (Line(
      points={{-42.3,-74},{-32,-74},{-32,-88},{-108,-88},{-108,-32},{-133,-32},{
          -133,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tesTank.heatExchEnv, fixedTemperature.port) annotation (Line(
      points={{-8.66667,-21.5385},{10,-21.5385},{10,-88},{-108,-88},{-108,-32},
          {-133,-32},{-133,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ctrl_Heating.onOff, pumpSto.m_flowSet) annotation (Line(
      points={{-145.556,36.5},{-128,36.5},{-128,28},{-84,28},{-84,-54},{-43,-54},
          {-43,-60.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHW.port_cold, pipeDHW.port_b) annotation (Line(
      points={{-54.5,-27.3571},{-54.5,-49},{-50,-49}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tesTank.T[posTTop], ctrl_Heating.TTankTop) annotation (Line(
      points={{-4,-15.3846},{12,-15.3846},{12,60},{-182,60},{-182,51.375},{-167,
          51.375}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tesTank.T[posTBot], ctrl_Heating.TTankBot) annotation (Line(
      points={{-4,-15.3846},{4,-15.3846},{4,-16},{12,-16},{12,60},{-182,60},{
          -182,36.5},{-166.889,36.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHW.port_hot, senTemSto_top.port_b) annotation (Line(
      points={{-54.5,-9.35714},{-54.5,2},{-38,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSto_top.port_a, tesTank.port_a) annotation (Line(
      points={{-30,2},{0,2},{0,-3.07692},{-4,-3.07692}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeDHW.port_a, senTemSto_bot.port_b) annotation (Line(
      points={{-34,-49},{-22,-49}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSto_bot.port_a, tesTank.port_b) annotation (Line(
      points={{-12,-49},{-2,-49},{-2,-36.9231},{-4,-36.9231}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(absolutePressure1.ports[1], tesTank.port_b) annotation (Line(
      points={{2,-56},{2,-48},{-2,-48},{-2,-36.9231},{-4,-36.9231}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tesTank.portHXUpper, pipeSupply.port_a) annotation (Line(
      points={{-32,-27.6923},{-36,-27.6923},{-36,-28},{-42,-28},{-42,38},{-22,
          38}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(pumpSto.port_b, senTemStoHX_out.port_a) annotation (Line(
      points={{-50,-68},{-72,-68}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOpSet.y, add.u2) annotation (Line(
      points={{-207,-120},{-196,-120},{-196,-95.2},{-181.4,-95.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyBuilding.TSensor, add.u1) annotation (Line(
      points={{223.36,38},{214,38},{214,24},{268,24},{268,86},{-238,86},{-238,-86},
          {-200,-86},{-200,-86.8},{-181.4,-86.8}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(absolutePressure.ports[1], senTemStoHX_out.port_b) annotation (Line(
      points={{-112,-124},{-114,-124},{-114,-68},{-84,-68}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeReturn.port_b, senTemStoHX_out.port_b) annotation (Line(
      points={{-24,-112},{-114,-112},{-114,-68},{-84,-68}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(emission.heatPortEmb, nakedTabs.portCore) annotation (Line(
      points={{129,24},{129,56},{144,56}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipeReturn.heatPort, fixedTemperature.port) annotation (Line(
      points={{-14,-108},{-14,-88},{-108,-88},{-108,-32},{-133,-32},{-133,-34}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(boundary.ports[1], multipleBoreholes.port_b) annotation (Line(
      points={{-214,-50},{-206,-50},{-206,-32},{-198,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_a, multipleBoreholes.port_b) annotation (Line(
      points={{-218,-20},{-218,-32},{-198,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_b, heatPumpTset.brineIn) annotation (Line(
      points={{-218,0},{-218,14},{-164,14},{-164,8.4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(multipleBoreholes.port_a, heatPumpTset.brineOut) annotation (Line(
      points={{-170,-32},{-164,-32},{-164,-4.4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ctrl_Heating.THeaterSet, heatPumpTset.Tset) annotation (Line(
      points={{-145.556,44},{-138,44},{-138,26},{-153.6,26},{-153.6,19.28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatPumpTset.fluidOut, senTemHea_out.port_a) annotation (Line(
      points={{-138,8.4},{-118,8.4},{-118,38},{-68,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpTset.fluidIn, senTemStoHX_out.port_b) annotation (Line(
      points={{-138,-4.4},{-114,-4.4},{-114,-68},{-84,-68}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpTset.heatLoss, fixedTemperature.port) annotation (Line(
      points={{-147.62,-14},{-146,-14},{-146,-24},{-134,-24},{-133,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-160},{280,
            120}}), graphics={Rectangle(
          extent={{-104,10},{82,-84}},
          lineColor={135,135,135},
          lineThickness=1), Text(
          extent={{30,10},{80,0}},
          lineColor={135,135,135},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Thermal Energy Storage")}),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-240,-160},{280,120}})));
end Heating_Embedded_DHW_STS;
