within Buildings.Utilities.IO.BCVTB.Examples;
model MoistAir
  "Model with interfaces for media with moist air that will be linked to the BCVTB which models the response of the room"
  import Buildings;
// package Medium = Modelica.Media.Air.MoistAir;
  package Medium = Buildings.Media.GasesPTDecoupled.MoistAir;

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
  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate m_flow_nominal
    = 259.2*6/1.2/3600 "Nominal mass flow rate";
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dp1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200,
    from_dp=false,
    allowFlowReversal=false) 
    annotation (Placement(transformation(extent={{278,90},{298,110}})));
  Buildings.Fluid.Sources.Boundary_pT sou1(
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
    annotation (Placement(transformation(extent={{208,0},{228,20}})));
  Buildings.Fluid.MassExchangers.HumidifierPrescribed hum(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200,
    redeclare package Medium = Medium,
    mWat0_flow=0.01*m_flow_nominal,
    from_dp=false,
    allowFlowReversal=false) "Humidifier" 
    annotation (Placement(transformation(extent={{240,90},{260,110}})));
  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hex(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200,
    redeclare package Medium = Medium,
    Q_flow_nominal=m_flow_nominal*50*1006,
    from_dp=false,
    allowFlowReversal=false) "Heat exchanger" 
    annotation (Placement(transformation(extent={{192,90},{212,110}})));
  Modelica.Blocks.Sources.Constant TWat(k=293.15) 
    annotation (Placement(transformation(extent={{200,50},{220,70}})));
  Buildings.Fluid.Sensors.Temperature TRet(redeclare package Medium = Medium)
    "Return air temperature" 
    annotation (Placement(transformation(extent={{310,-40},{330,-20}})));
  Buildings.Fluid.Sensors.MassFraction XiWat(redeclare package Medium = Medium)
    "Measured air humidity" 
    annotation (Placement(transformation(extent={{282,-20},{302,0}})));
  Modelica.Blocks.Sources.Constant XSet(k=0.005) "Set point for humidity" 
    annotation (Placement(transformation(extent={{180,160},{200,180}})));
  Modelica.Blocks.Sources.Constant TRooSet(k=273.15 + 20)
    "Set point for room air temperature" 
    annotation (Placement(transformation(extent={{100,160},{120,180}})));
  Modelica.Blocks.Continuous.LimPID PIDHea(
    yMax=1,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=1,
    k=0.1,
    Ti=600) "Controller for heating" 
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  Modelica.Blocks.Continuous.LimPID PIDHum(
    yMax=1,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=20,
    Ti=60,
    Td=60) "Controller for humidifier" 
    annotation (Placement(transformation(extent={{220,160},{240,180}})));
  Buildings.Utilities.IO.BCVTB.BCVTB bcvtb(
    xmlFileName="socket.cfg",
    nDblRea=4,
    nDblWri=5,
    flaDblWri={1,1,1,1,1},
    uStart={0,0,0,0,20},
    activateInterface=true,
    samplePeriod=60) 
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  Modelica.Blocks.Routing.DeMultiplex4 deMultiplex2_1(
    n1=1,
    n2=1,
    n3=1,
    n4=1) 
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Constant uniCon(k=273.15) "Unit conversion" 
    annotation (Placement(transformation(extent={{-40,106},{-20,126}})));
  Modelica.Blocks.Math.Add add 
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Modelica.Blocks.Math.Add add1 
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotalAir 
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotalAir1 
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Routing.Multiplex5 mul 
    annotation (Placement(transformation(extent={{400,0},{420,20}})));
  Buildings.Fluid.Sensors.Temperature TSup(redeclare package Medium = Medium)
    "Supply air temperature" 
    annotation (Placement(transformation(extent={{310,58},{330,78}})));
  Modelica.Blocks.Math.Add add2(k2=-1) 
    annotation (Placement(transformation(extent={{336,32},{356,52}})));
  Buildings.Fluid.Movers.FlowMachine_y fan(redeclare package Medium = Medium,
      redeclare function flowCharacteristic = 
        Buildings.Fluid.Movers.BaseClasses.Characteristics.linearFlow (
          V_flow_nominal={0,m_flow_nominal/1.2}, dp_nominal={2*400,400})) 
    annotation (Placement(transformation(extent={{140,90},{160,110}})));
  Modelica.Blocks.Sources.Constant yFan(k=1) "Fan control signal" 
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
equation
  connect(dp1.port_b, bouBCVTB.ports[1]) annotation (Line(
      points={{298,100},{310,100},{310,12},{227.8,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp2.port_a, bouBCVTB.ports[2]) annotation (Line(
      points={{252,-50},{240,-50},{240,8},{227.8,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TWat.y, hum.T_in) annotation (Line(
      points={{221,60},{228,60},{228,94},{238,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp1.port_a, hum.port_b) annotation (Line(
      points={{278,100},{260,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(XiWat.port, dp2.port_b) annotation (Line(
      points={{292,-20},{292,-50},{272,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b, hum.port_a) annotation (Line(
      points={{212,100},{240,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PIDHea.u_s, TRooSet.y) annotation (Line(
      points={{138,170},{121,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRet.T, PIDHea.u_m) annotation (Line(
      points={{327,-30},{368,-30},{368,130},{150,130},{150,158}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIDHea.y, hex.u) annotation (Line(
      points={{161,170},{170,170},{170,106},{190,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XSet.y, PIDHum.u_s)  annotation (Line(
      points={{201,170},{218,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIDHum.y, hum.u)  annotation (Line(
      points={{241,170},{260,170},{260,120},{226,120},{226,106},{238,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bcvtb.yR, deMultiplex2_1.u) annotation (Line(
      points={{-49,30},{-42,30}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(uniCon.y, add.u1) annotation (Line(
      points={{-19,116},{38,116}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(add.y, sou1.T_in) annotation (Line(
      points={{61,110},{80,110},{80,74},{94,74}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(deMultiplex2_1.y1[1], add.u2) annotation (Line(
      points={{-19,39},{30,39},{30,104},{38,104}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(deMultiplex2_1.y2[1], add1.u2) annotation (Line(
      points={{-19,33},{14,33},{14,-16},{38,-16}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(uniCon.y, add1.u1) annotation (Line(
      points={{-19,116},{20,116},{20,-4},{38,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add1.y, bouBCVTB.T_in) annotation (Line(
      points={{61,-10},{80,-10},{80,16},{206,16}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(toTotalAir.XiDry, deMultiplex2_1.y4[1]) annotation (Line(
      points={{39,-50},{10,-50},{10,21},{-19,21}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(toTotalAir1.XiTotalAir, sou1.X_in[1]) annotation (Line(
      points={{61,70},{80,70},{80,66},{94,66}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(toTotalAir1.XNonVapor, sou1.X_in[2]) annotation (Line(
      points={{61,66},{94,66}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(mul.y, bcvtb.uR)          annotation (Line(
      points={{421,10},{430,10},{430,-80},{-80,-80},{-80,30},{-72,30}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(PIDHum.y, mul.u4[1])          annotation (Line(
      points={{241,170},{380,170},{380,5},{398,5}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(PIDHea.y, mul.u3[1])          annotation (Line(
      points={{161,170},{170,170},{170,140},{388,140},{388,10},{398,10}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(mul.u1[1], bouBCVTB.HSen_flow)          annotation (Line(
      points={{398,20},{240,20},{240,19},{229,19}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(bouBCVTB.HLat_flow, mul.u2[1])          annotation (Line(
      points={{229,16},{244,16},{244,15},{398,15}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TSup.port, dp1.port_b) annotation (Line(
      points={{320,58},{320,42},{310,42},{310,100},{298,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(add2.u1, TSup.T) annotation (Line(
      points={{334,48},{330,48},{330,68},{327,68}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(uniCon.y, add2.u2) annotation (Line(
      points={{-19,116},{26,116},{26,36},{334,36}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(add2.y, mul.u5[1]) annotation (Line(
      points={{357,42},{374,42},{374,-6.66134e-16},{398,-6.66134e-16}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(toTotalAir.XiTotalAir, bouBCVTB.X[1]) annotation (Line(
      points={{61,-50},{102,-50},{102,4},{206,4}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(toTotalAir.XNonVapor, bouBCVTB.X[2]) annotation (Line(
      points={{61,-54},{104,-54},{104,4},{206,4}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(deMultiplex2_1.y3[1], toTotalAir1.XiDry) annotation (Line(
      points={{-19,27},{-6,27},{-6,70},{39,70}},
      color={0,127,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(dp2.port_b, TRet.port) annotation (Line(
      points={{272,-50},{320,-50},{320,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(XiWat.X, PIDHum.u_m) annotation (Line(
      points={{303,-10},{364,-10},{364,148},{230,148},{230,158}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fan.port_b, hex.port_a) annotation (Line(
      points={{160,100},{192,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan.port_a, sou1.ports[1]) annotation (Line(
      points={{140,100},{130,100},{130,72},{116,72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(yFan.y, fan.y_in) annotation (Line(
      points={{121,120},{150,120},{150,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp2.port_b, sou1.ports[2]) annotation (Line(
      points={{272,-50},{320,-50},{320,-70},{130,-70},{130,68},{116,68}},
      color={0,127,255},
      smooth=Smooth.None));
end MoistAir;
