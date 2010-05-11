within Buildings.Utilities.IO.BCVTB.Examples;
model MoistAir
  "Model with interfaces for media with moist air that will be linked to the BCVTB which models the response of the room"
  import Buildings;
// package Medium = Modelica.Media.Air.MoistAir;
  package Medium = Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated;

  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate m_flow_nominal
    = 259.2*6/1.2/3600 "Nominal mass flow rate";
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dp1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200,
    from_dp=false,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{278,62},{298,82}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    nPorts=2,
    redeclare package Medium = Medium,
    use_T_in=true,
    use_X_in=true,
    p(displayUnit="Pa") = 101325,
    T=293.15)             annotation (Placement(transformation(extent={{96,60},
            {116,80}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dp2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200,
    from_dp=false,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={262,-50})));
  Buildings.Utilities.IO.BCVTB.MoistAirInterface bouBCVTB(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow=0,
    use_m_flow_in=false)
    annotation (Placement(transformation(extent={{204,-4},{224,16}})));
  Buildings.Fluid.MassExchangers.HumidifierPrescribed hum(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200,
    redeclare package Medium = Medium,
    mWat0_flow=0.01*m_flow_nominal,
    from_dp=false,
    allowFlowReversal=false,
    use_T_in=false) "Humidifier"
    annotation (Placement(transformation(extent={{240,62},{260,82}})));
  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hex(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200,
    redeclare package Medium = Medium,
    Q_flow_nominal=m_flow_nominal*50*1006,
    from_dp=false,
    allowFlowReversal=false) "Heat exchanger"
    annotation (Placement(transformation(extent={{192,62},{212,82}})));
  Buildings.Fluid.Sensors.Temperature TRet(redeclare package Medium = Medium)
    "Return air temperature"
    annotation (Placement(transformation(extent={{310,-40},{330,-20}})));
  Buildings.Fluid.Sensors.MassFraction Xi_w(redeclare package Medium = Medium)
    "Measured air humidity"
    annotation (Placement(transformation(extent={{282,-20},{302,0}})));
  Modelica.Blocks.Sources.Constant XSet(k=0.005) "Set point for humidity"
    annotation (Placement(transformation(extent={{180,150},{200,170}})));
  Modelica.Blocks.Sources.Constant TRooSetNig(k=273.15 + 16)
    "Set point for room air temperature"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.Continuous.LimPID PIDHea(
    yMax=1,
    yMin=0,
    Td=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=600) "Controller for heating"
    annotation (Placement(transformation(extent={{140,150},{160,170}})));
  Buildings.Controls.Continuous.LimPID PIDHum(
    yMax=1,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=20,
    Td=60,
    Ti=600) "Controller for humidifier"
    annotation (Placement(transformation(extent={{220,150},{240,170}})));
  Buildings.Utilities.IO.BCVTB.BCVTB bcvtb(
    xmlFileName="socket.cfg",
    nDblRea=4,
    nDblWri=5,
    flaDblWri={1,1,1,1,1},
    uStart={0,0,0,0,20},
    activateInterface=true,
    timeStep=60)
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  Modelica.Blocks.Routing.DeMultiplex4 deMultiplex2_1(
    n1=1,
    n2=1,
    n3=1,
    n4=1)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Routing.Multiplex5 mul
    annotation (Placement(transformation(extent={{420,0},{440,20}})));
  Buildings.Fluid.Sensors.Temperature TSup(redeclare package Medium = Medium)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{310,58},{330,78}})));
  Buildings.Fluid.Movers.FlowMachine_y fan(redeclare package Medium = Medium,
      redeclare function flowCharacteristic =
        Buildings.Fluid.Movers.BaseClasses.Characteristics.linearFlow (
          V_flow_nominal={0,m_flow_nominal/1.2}, dp_nominal={2*400,400}),
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{140,62},{160,82}})));
  Modelica.Blocks.Sources.Constant yFan(k=1) "Fan control signal"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Modelica.Blocks.Math.Gain perToRel(k=0.01) "Converts 0...100 to 0...1"
    annotation (Placement(transformation(extent={{22,-10},{42,10}})));
  Modelica.Blocks.Math.Gain perToRel1(
                                     k=0.01) "Converts 0...100 to 0...1"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Utilities.Psychrometrics.X_pTphi masFra(
                                           use_p_in=false, redeclare package
      Medium = Medium) "Mass fraction"
    annotation (Placement(transformation(extent={{50,56},{70,76}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
    annotation (Placement(transformation(extent={{0,156},{20,176}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{84,150},{104,170}})));
  Modelica.Blocks.Sources.Constant TRooSetDay(k=273.15 + 20)
    "Set point for room air temperature"
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
  Buildings.Utilities.IO.BCVTB.From_degC from_degC
    annotation (Placement(transformation(extent={{20,18},{40,38}})));
  Buildings.Utilities.IO.BCVTB.To_degC to_degC
    annotation (Placement(transformation(extent={{360,58},{380,78}})));
  Buildings.Utilities.IO.BCVTB.From_degC from_degC1
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
equation
  connect(dp1.port_b, bouBCVTB.ports[1]) annotation (Line(
      points={{298,72},{310,72},{310,8},{223.8,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp2.port_a, bouBCVTB.ports[2]) annotation (Line(
      points={{252,-50},{240,-50},{240,4},{223.8,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp1.port_a, hum.port_b) annotation (Line(
      points={{278,72},{260,72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(Xi_w.port, dp2.port_b) annotation (Line(
      points={{292,-20},{292,-50},{272,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b, hum.port_a) annotation (Line(
      points={{212,72},{240,72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TRet.T, PIDHea.u_m) annotation (Line(
      points={{327,-30},{348,-30},{348,120},{150,120},{150,148}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIDHea.y, hex.u) annotation (Line(
      points={{161,160},{170,160},{170,78},{190,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XSet.y, PIDHum.u_s)  annotation (Line(
      points={{201,160},{218,160}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIDHum.y, hum.u)  annotation (Line(
      points={{241,160},{260,160},{260,110},{226,110},{226,78},{238,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bcvtb.yR, deMultiplex2_1.u) annotation (Line(
      points={{-49,30},{-42,30}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(mul.y, bcvtb.uR)          annotation (Line(
      points={{441,10},{450,10},{450,-80},{-72,-80},{-72,30}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(PIDHum.y, mul.u4[1])          annotation (Line(
      points={{241,160},{400,160},{400,5},{418,5}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(PIDHea.y, mul.u3[1])          annotation (Line(
      points={{161,160},{170,160},{170,130},{408,130},{408,10},{418,10}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(mul.u1[1], bouBCVTB.HSen_flow)          annotation (Line(
      points={{418,20},{260,20},{260,15},{225,15}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(bouBCVTB.HLat_flow, mul.u2[1])          annotation (Line(
      points={{225,12},{264,12},{264,15},{418,15}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TSup.port, dp1.port_b) annotation (Line(
      points={{320,58},{320,42},{310,42},{310,72},{298,72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp2.port_b, TRet.port) annotation (Line(
      points={{272,-50},{320,-50},{320,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(Xi_w.X, PIDHum.u_m) annotation (Line(
      points={{303,-10},{340,-10},{340,140},{230,140},{230,148}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fan.port_b, hex.port_a) annotation (Line(
      points={{160,72},{192,72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan.port_a, sou.ports[1])  annotation (Line(
      points={{140,72},{116,72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp2.port_b, sou.ports[2])  annotation (Line(
      points={{272,-50},{320,-50},{320,-70},{130,-70},{130,68},{116,68}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(perToRel.y, bouBCVTB.phi) annotation (Line(
      points={{43,6.10623e-16},{100,6.10623e-16},{100,5.55112e-16},{202,
          5.55112e-16}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(deMultiplex2_1.y4[1], perToRel.u) annotation (Line(
      points={{-19,21},{-8,21},{-8,6.66134e-16},{20,6.66134e-16}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(perToRel1.u, deMultiplex2_1.y3[1]) annotation (Line(
      points={{-2,60},{-6,60},{-6,27},{-19,27}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(masFra.phi, perToRel1.y) annotation (Line(
      points={{48,60},{21,60}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(masFra.X, sou.X_in)  annotation (Line(
      points={{71,66},{94,66}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(yFan.y, fan.y) annotation (Line(
      points={{141,110},{150,110},{150,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occSch.occupied, switch1.u2) annotation (Line(
      points={{21,160},{82,160}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TRooSetNig.y, switch1.u3) annotation (Line(
      points={{61,140},{70,140},{70,152},{82,152}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRooSetDay.y, switch1.u1) annotation (Line(
      points={{61,180},{72,180},{72,168},{82,168}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.y, PIDHea.u_s) annotation (Line(
      points={{105,160},{138,160}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(from_degC.Kelvin, bouBCVTB.T_in) annotation (Line(
      points={{41,27.8},{80,27.8},{80,12},{202,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSup.T, to_degC.Kelvin) annotation (Line(
      points={{327,68},{330,68},{330,67.6},{358,67.6}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(to_degC.Celsius, mul.u5[1]) annotation (Line(
      points={{381,67.8},{392,67.8},{392,-6.66134e-16},{418,-6.66134e-16}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(from_degC1.Kelvin, sou.T_in) annotation (Line(
      points={{21,89.8},{80,89.8},{80,74},{94,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(from_degC1.Celsius, deMultiplex2_1.y1[1]) annotation (Line(
      points={{-2,89.6},{-10,89.6},{-10,39},{-19,39}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(deMultiplex2_1.y2[1], from_degC.Celsius) annotation (Line(
      points={{-19,33},{0,33},{0,27.6},{18,27.6}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(from_degC1.Kelvin, masFra.T) annotation (Line(
      points={{21,89.8},{40,89.8},{40,66},{48,66}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{460,200}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{460,
            200}})),
    Documentation(info="<html>
This example illustrates the use of Modelica with the Building Controls Virtual Test Bed.
</p>
<p>
The model represents an air-based heating system with an ideal heater and an ideal humidifier
in the supply duct. The heater and humidifier are controlled with a feedback loop that 
tracks the room air temperature and room air humidity. These quantities are simulated
in the EnergyPlus simulation program through the Building Controls Virtual Test Bed.
The component <code>bouBCVTB</code> models the boundary between the domain that models the air
system (in Modelica) and the room response (in EnergyPlus).
</p>
<p>
This model is implemented in <tt>bcvtb\\examples\\dymolaEPlusXY-singleZone</tt>,
where <code>XY</code> denotes the EnergyPlus version number.
</html>", revisions="<html>
<ul>
<li>
January 21, by Michael Wetter:<br>
Changed model to include fan instead of having flow driven by two reservoirs at 
different pressure.
</li>
<li>
September 11, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      Tolerance=1e-05,
      Algorithm="Lsodar"),
    experimentSetupOutput);
end MoistAir;
