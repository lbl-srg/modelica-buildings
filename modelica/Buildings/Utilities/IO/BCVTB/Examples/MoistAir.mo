within Buildings.Utilities.IO.BCVTB.Examples;
model MoistAir
  "Model with interfaces for media with moist air that will be linked to the BCVTB which models the response of the room"
  import Buildings;
 package Medium = Modelica.Media.Air.MoistAir;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{400,200}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{400,
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
September 11, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  parameter Modelica.Media.Interfaces.PartialMedium.MassFlowRate m_flow_nominal
    = 259.2*6/1.2/3600 "Nominal mass flow rate";
  Buildings.Fluids.FixedResistances.FixedResistanceDpM dp1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200) 
    annotation (Placement(transformation(extent={{218,90},{238,110}})));
  Modelica.Fluid.Sources.Boundary_pT sou1(
    nPorts=1,
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325 + 4*200,
    use_T_in=true,
    use_X_in=true,
    T=293.15)             annotation (Placement(transformation(extent={{100,90},
            {120,110}},rotation=0)));
  inner Modelica.Fluid.System system 
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Modelica.Fluid.Sources.Boundary_pT sou2(
    nPorts=1,
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15)             annotation (Placement(transformation(extent={{-10,-10},
            {10,10}},  rotation=180,
        origin={290,-50})));
  Buildings.Fluids.FixedResistances.FixedResistanceDpM dp2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200) 
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={208,-60})));
  Buildings.Utilities.IO.BCVTB.MoistAirInterface bouBCVTB(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow=0,
    use_m_flow_in=false) 
    annotation (Placement(transformation(extent={{148,-58},{168,-38}})));
  Buildings.Fluids.MassExchangers.HumidifierPrescribed hum(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200,
    redeclare package Medium = Medium,
    mWat0_flow=0.01*m_flow_nominal) "Humidifier" 
    annotation (Placement(transformation(extent={{192,90},{212,110}})));
  Buildings.Fluids.HeatExchangers.HeaterCoolerPrescribed hex(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200,
    redeclare package Medium = Medium,
    Q_flow_nominal=m_flow_nominal*50*1006) "Heat exchanger" 
    annotation (Placement(transformation(extent={{140,90},{160,110}})));
  Modelica.Blocks.Sources.Constant TWat(k=293.15) 
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  Modelica.Fluid.Sensors.Temperature TRet(redeclare package Medium = Medium)
    "Return air temperature" 
    annotation (Placement(transformation(extent={{250,-40},{270,-20}})));
  Buildings.Fluids.Sensors.MassFraction XiWat(redeclare package Medium = Medium)
    "Measured air humidity" 
    annotation (Placement(transformation(extent={{220,-20},{240,0}})));
  Modelica.Blocks.Sources.Constant XSet(k=0.005) "Set point for humidity" 
    annotation (Placement(transformation(extent={{180,160},{200,180}})));
  Modelica.Blocks.Sources.Constant TRooSet(k=273.15 + 20)
    "Set point for room air temperature" 
    annotation (Placement(transformation(extent={{100,160},{120,180}})));
  Modelica.Blocks.Continuous.LimPID PIDHea(
    yMax=1,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=600,
    Td=1,
    k=0.1) "Controller for heating" 
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  Modelica.Blocks.Continuous.LimPID PIDHum(
    yMax=1,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=20,
    Ti=60) "Controller for humidifier" 
    annotation (Placement(transformation(extent={{220,160},{240,180}})));
  Buildings.Utilities.IO.BCVTB.BCVTB bcvtb(
    samplePeriod=60,
    xmlFileName="socket.cfg",
    nDblRea=4,
    nDblWri=5,
    flaDblWri={1,1,1,1,1}) 
    annotation (Placement(transformation(extent={{-74,20},{-54,40}})));
  Modelica.Blocks.Routing.DeMultiplex4 deMultiplex2_1(
    n1=1,
    n2=1,
    n3=1,
    n4=1) 
    annotation (Placement(transformation(extent={{-40,26},{-20,46}})));
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
    annotation (Placement(transformation(extent={{340,0},{360,20}})));
  Modelica.Fluid.Sensors.Temperature TSup(redeclare package Medium = Medium)
    "Supply air temperature" 
    annotation (Placement(transformation(extent={{250,60},{270,80}})));
  Modelica.Blocks.Math.Add add2(k2=-1) 
    annotation (Placement(transformation(extent={{276,32},{296,52}})));
equation
  connect(sou2.ports[1], dp2.port_b) annotation (Line(
      points={{280,-50},{250,-50},{250,-60},{218,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp1.port_b, bouBCVTB.ports[1]) annotation (Line(
      points={{238,100},{252,100},{252,-46},{167.8,-46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp2.port_a, bouBCVTB.ports[2]) annotation (Line(
      points={{198,-60},{184,-60},{184,-50},{167.8,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TWat.y, hum.T_in) annotation (Line(
      points={{161,60},{168,60},{168,94},{190,94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou1.ports[1], hex.port_a) annotation (Line(
      points={{120,100},{140,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp1.port_a, hum.port_b) annotation (Line(
      points={{218,100},{212,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TRet.port, dp2.port_b) annotation (Line(
      points={{260,-40},{260,-60},{218,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(XiWat.port, dp2.port_b) annotation (Line(
      points={{230,-20},{230,-60},{218,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b, hum.port_a) annotation (Line(
      points={{160,100},{192,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PIDHea.u_s, TRooSet.y) annotation (Line(
      points={{138,170},{121,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRet.T, PIDHea.u_m) annotation (Line(
      points={{267,-30},{308,-30},{308,130},{150,130},{150,158}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIDHea.y, hex.u) annotation (Line(
      points={{161,170},{170,170},{170,140},{130,140},{130,106},{138,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XSet.y, PIDHum.u_s)  annotation (Line(
      points={{201,170},{218,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XiWat.X, PIDHum.u_m)  annotation (Line(
      points={{241,-10},{300,-10},{300,134},{230,134},{230,158}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIDHum.y, hum.u)  annotation (Line(
      points={{241,170},{252,170},{252,126},{180,126},{180,106},{190,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bcvtb.yR, deMultiplex2_1.u) annotation (Line(
      points={{-53,36},{-42,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uniCon.y, add.u1) annotation (Line(
      points={{-19,116},{38,116}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, sou1.T_in) annotation (Line(
      points={{61,110},{80,110},{80,104},{98,104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deMultiplex2_1.y1[1], add.u2) annotation (Line(
      points={{-19,45},{30,45},{30,104},{38,104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deMultiplex2_1.y2[1], add1.u2) annotation (Line(
      points={{-19,39},{14,39},{14,-16},{38,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uniCon.y, add1.u1) annotation (Line(
      points={{-19,116},{20,116},{20,-4},{38,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add1.y, bouBCVTB.T_in) annotation (Line(
      points={{61,-10},{80,-10},{80,-42},{146,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toTotalAir.XiTotalAir, bouBCVTB.XWat_totAir) annotation (Line(
      points={{61,-50},{80,-50},{80,-54},{146,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toTotalAir.XiDry, deMultiplex2_1.y4[1]) annotation (Line(
      points={{39,-50},{10,-50},{10,27},{-19,27}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toTotalAir1.XiTotalAir, sou1.X_in[1]) annotation (Line(
      points={{61,70},{80,70},{80,96},{98,96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toTotalAir1.XNonVapor, sou1.X_in[2]) annotation (Line(
      points={{61,76},{78,76},{78,96},{98,96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(toTotalAir1.XiDry, deMultiplex2_1.y3[1]) annotation (Line(
      points={{39,70},{-8,70},{-8,34},{-19,33}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.y, bcvtb.uR)          annotation (Line(
      points={{361,10},{370,10},{370,-80},{-80,-80},{-80,36},{-76,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIDHum.y, mul.u4[1])          annotation (Line(
      points={{241,170},{320,170},{320,5},{338,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PIDHea.y, mul.u3[1])          annotation (Line(
      points={{161,170},{170,170},{170,140},{328,140},{328,10},{338,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mul.u1[1], bouBCVTB.HSen_flow)          annotation (Line(
      points={{338,20},{180,20},{180,-39},{169,-39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bouBCVTB.HLat_flow, mul.u2[1])          annotation (Line(
      points={{169,-42},{184,-42},{184,15},{338,15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSup.port, dp1.port_b) annotation (Line(
      points={{260,60},{260,52},{250,52},{250,100},{238,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(add2.u1, TSup.T) annotation (Line(
      points={{274,48},{270,48},{270,70},{267,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uniCon.y, add2.u2) annotation (Line(
      points={{-19,116},{20,116},{20,36},{274,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add2.y, mul.u5[1]) annotation (Line(
      points={{297,42},{314,42},{314,0},{338,0}},
      color={0,0,127},
      smooth=Smooth.None));
end MoistAir;
