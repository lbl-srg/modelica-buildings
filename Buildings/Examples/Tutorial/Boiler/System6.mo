within Buildings.Examples.Tutorial.Boiler;
model System6
  "6th part of the system model, which adds weather data and changes to PI control"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;
  replaceable package MediumW =
      Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 20000
    "Nominal heat flow rate of radiator";
  parameter Modelica.SIunits.Temperature TRadSup_nominal = 273.15+50
    "Radiator nominal supply water temperature";
  parameter Modelica.SIunits.Temperature TRadRet_nominal = 273.15+40
    "Radiator nominal return water temperature";
  parameter Modelica.SIunits.MassFlowRate mRad_flow_nominal=
    Q_flow_nominal/4200/(TRadSup_nominal-TRadRet_nominal)
    "Radiator nominal mass flow rate";

  parameter Modelica.SIunits.Temperature TBoiSup_nominal = 273.15+70
    "Boiler nominal supply water temperature";
  parameter Modelica.SIunits.Temperature TBoiRet_min = 273.15+60
    "Boiler minimum return water temperature";
  parameter Modelica.SIunits.MassFlowRate mBoi_flow_nominal=
    Q_flow_nominal/4200/(TBoiSup_nominal-TBoiRet_min)
    "Boiler nominal mass flow rate";
//------------------------------------------------------------------------------//

//----------------Radiator loop: Three-way valve: mass flow rate----------------//
  parameter Modelica.SIunits.MassFlowRate mRadVal_flow_nominal=
    Q_flow_nominal/4200/(TBoiSup_nominal-TRadRet_nominal)
    "Radiator nominal mass flow rate";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mA_flow_nominal,
    V=V)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal = V*1.2*6/3600
    "Nominal mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow = 4000
    "Internal heat gains of the room";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(C=2*V*1.2*1006)
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTab(
      extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
      smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
      table=[-6, 0;
              8, QRooInt_flow;
             18, 0],
      timeScale=3600) "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal,
    T_a_nominal=TRadSup_nominal,
    T_b_nominal=TRadRet_nominal) "Radiator"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSup(redeclare package Medium = MediumW,
      m_flow_nominal=mRad_flow_nominal) "Supply water temperature"
      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-40})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temRoo
    "Room temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-40,30})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumRad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mRad_flow_nominal) "Pump for radiator"
      annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-50,-70})));

//----------------------------------------------------------------------------//
  Buildings.Fluid.FixedResistances.Junction mix(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mRadVal_flow_nominal,-mRad_flow_nominal,mRad_flow_nominal
         - mRadVal_flow_nominal},
    dp_nominal={100,-8000,6750}) "Mixer between valve and radiators"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-110})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mBoi_flow_nominal,-mRadVal_flow_nominal,-mBoi_flow_nominal},
    dp_nominal={200,-200,-50}) "Splitter of boiler loop bypass" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-190})));

  Buildings.Fluid.FixedResistances.Junction spl2(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,0,0},
    m_flow_nominal={mRad_flow_nominal,-mRadVal_flow_nominal,-mRad_flow_nominal
         + mRadVal_flow_nominal}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-110})));
  Buildings.Fluid.FixedResistances.Junction mix2(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,-200,0},
    m_flow_nominal={mRadVal_flow_nominal,-mBoi_flow_nominal,mBoi_flow_nominal})
    "Mixer" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-190})));
  Buildings.Fluid.FixedResistances.Junction spl4(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mRadVal_flow_nominal*{1,-1,-1},
    dp_nominal=200*{1,-1,-1}) "Splitter for radiator loop valve bypass"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-150})));
//----------------------------------------------------------------------------//

  Buildings.Fluid.Movers.FlowControlled_m_flow pumBoi(
      redeclare package Medium = MediumW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      m_flow_nominal=mBoi_flow_nominal) "Pump for boiler"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-280})));
//----------------------------------------------------------------------------//

  Buildings.Fluid.Boilers.BoilerPolynomial boi(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mBoi_flow_nominal,
    dp_nominal=2000,
    Q_flow_nominal=Q_flow_nominal,
    fue=Buildings.Fluid.Data.Fuels.HeatingOilLowerHeatingValue()) "Boiler"
    annotation (Placement(transformation(extent={{20,-320},{0,-300}})));
//----------------------------------------------------------------------------//

  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valRad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mRadVal_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000) "Three-way valve for radiator loop"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-150})));
//----------------------------------------------------------------------------//

  Buildings.Fluid.Sources.Boundary_pT preSou(redeclare package Medium = MediumW,
      nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{92,-320},{72,-300}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valBoi(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mBoi_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000) "Three-way valve for boiler"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-230})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temRet(redeclare package Medium =
        MediumW, m_flow_nominal=mBoi_flow_nominal) "Return water temperature"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-280})));
  Buildings.Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mBoi_flow_nominal,-mBoi_flow_nominal,-mBoi_flow_nominal},
    dp_nominal={0,0,-200}) "Splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-230})));

//--------------------------------------------------------------------------------//
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTOut(uLow=273.15 + 16, uHigh=273.15 + 17)
    "Hysteresis for on/off based on outside temperature"
    annotation (Placement(transformation(extent={{-260,-200},{-240,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-220,-200},{-200,-180}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTOut
    "Outdoor temperature sensor"
    annotation (Placement(transformation(extent={{-318,20},{-298,40}})));
//--------------------------------------------------------------------------------//
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTBoi(uHigh=273.15 + 90,
                                             uLow=273.15 + 70)
    "Hysteresis for on/off of boiler"
    annotation (Placement(transformation(extent={{-260,-348},{-240,-328}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    annotation (Placement(transformation(extent={{-220,-348},{-200,-328}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{-180,-160},{-160,-140}})));
//--------------------------------------------------------------------------------//

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaRad1(realTrue=mBoi_flow_nominal)
    "Boiler pump signal"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
//--------------------------------------------------------------------------------//

  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-140,-340},{-120,-320}})));

 Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaRad2(realTrue=1)
    "Boiler signal"
    annotation (Placement(transformation(extent={{-100,-340},{-80,-320}})));

//--------------------------------------------------------------------------------//
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysPum(
    uLow=273.15 + 19,
    uHigh=273.15 + 21)
    "Pump hysteresis"
    annotation (Placement(transformation(extent={{-260,-160},{-240,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaRad(realTrue=mRad_flow_nominal)
    "Radiator pump signal"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Negate output of hysteresis"
    annotation (Placement(transformation(extent={{-220,-160},{-200,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetBoiRet(k=TBoiRet_min)
    "Temperature setpoint for boiler return"
    annotation (Placement(transformation(extent={{120,-270},{140,-250}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPIDBoi(
    Td=1,
    Ti=120,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.1,
    reverseActing=false) "Controller for valve in boiler loop"
    annotation (Placement(transformation(extent={{160,-270},{180,-250}})));
//--------------------------------------------------------------------------------//

  Buildings.Controls.OBC.CDL.Continuous.PID conPIDRad(
    Td=1,
    Ti=120,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.1) "Controller for valve in radiator loop"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
//------------------------------------------------------------------------------//
  Buildings.Controls.OBC.CDL.Continuous.Line TSetSup
    "Setpoint for supply water temperature"
    annotation (Placement(transformation(extent={{-220,-90},{-200,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupMin(k=273.15 + 21)
    "Minimum heating supply temperature"
    annotation (Placement(transformation(extent={{-260,-120},{-240,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSupMax(k=273.15 + 50)
    "Maximum heating supply temperature"
    annotation (Placement(transformation(extent={{-260,-60},{-240,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TRooMin(k=273.15 + 19)
    "Minimum room air temperature"
    annotation (Placement(transformation(extent={{-260,-20},{-240,0}})));
//--- Weather data -------------------------------------------------------------//
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-380,60},{-360,80}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-320,60},{-300,80}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));
//------------------------------------------------------------------------------//

equation
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{40,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{40,80},{50,80},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCap.port, vol.heatPort) annotation (Line(
      points={{70,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(timTab.y[1], preHea.Q_flow) annotation (Line(
      points={{2,80},{20,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSup.port_b, rad.port_a) annotation (Line(
      points={{-50,-30},{-50,-10},{-5.55112e-16,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRoo.port, vol.heatPort) annotation (Line(
      points={{-30,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortCon, vol.heatPort) annotation (Line(
      points={{8,-2.8},{8,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortRad, vol.heatPort) annotation (Line(
      points={{12,-2.8},{12,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumRad.port_b, temSup.port_a) annotation (Line(
      points={{-50,-60},{-50,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi.port_b, pumBoi.port_a) annotation (Line(
      points={{-5.55112e-16,-310},{-50,-310},{-50,-290}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumBoi.port_b, spl1.port_1) annotation (Line(
      points={{-50,-270},{-50,-240}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl1.port_2, spl.port_1) annotation (Line(
      points={{-50,-220},{-50,-200}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_2, valRad.port_1)
                                  annotation (Line(
      points={{-50,-180},{-50,-160}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valRad.port_2, mix.port_1)
                                  annotation (Line(
      points={{-50,-140},{-50,-120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl1.port_3, valBoi.port_3)
                                    annotation (Line(
      points={{-40,-230},{50,-230}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valBoi.port_2, temRet.port_a)
                                      annotation (Line(
      points={{60,-240},{60,-270}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRet.port_b, boi.port_a) annotation (Line(
      points={{60,-290},{60,-310},{20,-310}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi.port_a, preSou.ports[1]) annotation (Line(
      points={{20,-310},{72,-310}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix2.port_2, valBoi.port_1)
                                    annotation (Line(
      points={{60,-200},{60,-220}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl4.port_2, mix2.port_1) annotation (Line(
      points={{60,-160},{60,-180}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl2.port_2, spl4.port_1) annotation (Line(
      points={{60,-120},{60,-140}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valRad.port_3, spl4.port_3)
                                   annotation (Line(
      points={{-40,-150},{50,-150}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_3, mix2.port_3) annotation (Line(
      points={{-40,-190},{50,-190}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix.port_3, spl2.port_3) annotation (Line(
      points={{-40,-110},{50,-110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix.port_2, pumRad.port_a) annotation (Line(
      points={{-50,-100},{-50,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rad.port_b, spl2.port_1) annotation (Line(
      points={{20,-10},{60,-10},{60,-100}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(hysTOut.y, not2.u) annotation (Line(
      points={{-238,-190},{-222,-190}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(hysTBoi.y, not3.u) annotation (Line(
      points={{-238,-338},{-222,-338}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not2.y, and1.u2) annotation (Line(
      points={{-198,-190},{-192,-190},{-192,-158},{-182,-158}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(boi.T, hysTBoi.u) annotation (Line(
      points={{-1,-302},{-280,-302},{-280,-338},{-262,-338}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTOut.T, hysTOut.u) annotation (Line(
      points={{-298,30},{-292,30},{-292,-190},{-262,-190}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(and1.y, booToReaRad1.u) annotation (Line(
      points={{-158,-150},{-152,-150},{-152,-170},{-142,-170}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and1.y, and2.u1) annotation (Line(
      points={{-158,-150},{-152,-150},{-152,-330},{-142,-330}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not3.y, and2.u2) annotation (Line(
      points={{-198,-338},{-142,-338}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and2.y, booToReaRad2.u) annotation (Line(
      points={{-118,-330},{-102,-330}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booToReaRad2.y, boi.y) annotation (Line(
      points={{-78,-330},{40,-330},{40,-302},{22,-302}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temRoo.T,hysPum. u) annotation (Line(
      points={{-50,30},{-270,30},{-270,-150},{-262,-150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hysPum.y,not1. u) annotation (Line(
      points={{-238,-150},{-222,-150}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not1.y, and1.u1) annotation (Line(
      points={{-198,-150},{-182,-150}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and1.y, booToReaRad.u) annotation (Line(
      points={{-158,-150},{-152,-150},{-152,-130},{-142,-130}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(temSup.T, conPIDRad.u_m) annotation (Line(
      points={{-61,-40},{-170,-40},{-170,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-360,70},{-310,70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, TOut.T) annotation (Line(
      points={{-310,70},{-262,70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{-240,70},{-220,70},{-220,50},{20,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOut.port, senTOut.port) annotation (Line(
      points={{-240,70},{-220,70},{-220,50},{-340,50},{-340,30},{-318,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(booToReaRad.y, pumRad.m_flow_in) annotation (Line(
      points={{-118,-130},{-100,-130},{-100,-70},{-62,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conPIDRad.y, valRad.y) annotation (Line(
      points={{-158,-10},{-90,-10},{-90,-150},{-62,-150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToReaRad1.y, pumBoi.m_flow_in) annotation (Line(
      points={{-118,-170},{-100,-170},{-100,-280},{-62,-280}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conPIDBoi.y, valBoi.y) annotation (Line(
      points={{182,-260},{200,-260},{200,-230},{72,-230}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetBoiRet.y, conPIDBoi.u_s) annotation (Line(points={{142,-260},{142,
          -260},{158,-260}},       color={0,0,127}));
  connect(temRet.T, conPIDBoi.u_m) annotation (Line(points={{71,-280},{114,-280},
          {170,-280},{170,-272}}, color={0,0,127}));
  connect(TSetSup.x1,TRooMin. y) annotation (Line(points={{-222,-72},{-230,-72},
          {-230,-10},{-238,-10}},
                              color={0,0,127}));
  connect(TSupMax.y,TSetSup. f1) annotation (Line(points={{-238,-50},{-234,-50},
          {-234,-76},{-222,-76}}, color={0,0,127}));
  connect(TSupMin.y,TSetSup. f2) annotation (Line(points={{-238,-110},{-230,-110},
          {-230,-88},{-222,-88}}, color={0,0,127}));
  connect(TSupMin.y,TSetSup. x2) annotation (Line(points={{-238,-110},{-230,-110},
          {-230,-84},{-222,-84}}, color={0,0,127}));
  connect(TSetSup.u, temRoo.T) annotation (Line(points={{-222,-80},{-270,-80},{-270,
          30},{-50,30}}, color={0,0,127}));
  connect(conPIDRad.u_s,TSetSup. y) annotation (Line(points={{-182,-10},{-190,-10},
          {-190,-80},{-198,-80}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This part of the system model adds to the model that is implemented in
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System5\">
Buildings.Examples.Tutorial.Boiler.System5</a>
weather data, and it changes the control to PI control.
</p>
<h4>Implementation</h4>
<p>
This model was built as follows:
</p>
<ol>
<li>
<p>
First, we copied the model
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System5\">
Buildings.Examples.Tutorial.Boiler.System5</a>
and called it
<code>Buildings.Examples.Tutorial.Boiler.System6</code>.
</p>
</li>
<li>
<p>
Next, we added the weather data as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System6Weather.png\" border=\"1\"/>
</p>
<p>
The weather data reader is implemented using
</p>
<pre>
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=\"modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos\")
    \"Weather data reader\";
</pre>
<p>
The yellow icon in the middle of the figure is an instance of
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.Bus\">
Buildings.BoundaryConditions.WeatherData.Bus</a>.
This is required to extract the dry bulb temperature from the weather data bus.
</p>
<p>
Note that we changed the instance <code>TOut</code> from
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.FixedTemperature\">
Modelica.Thermal.HeatTransfer.Sources.FixedTemperature</a>
to
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature</a>
in order to use the dry-bulb temperature as an input signal.
</p>
</li>
</ol>
<!-- ============================================== -->
<p>
This completes the closed loop control.
When simulating the model
for <i>2</i> days, or <i>172800</i> seconds, the
response shown below should be seen.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System6Temperatures1.png\" border=\"1\"/>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System6Temperatures2.png\" border=\"1\"/>
</p>
<p>
The figure shows that the boiler temperature is regulated between
<i>70</i>&deg;C and
<i>90</i>&deg;C,
that
the boiler inlet temperature is above
<i>60</i>&deg;C,
and that the room temperature and the supply water temperature are
maintained at their set point.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2017, by Michael Wetter:<br/>
Added missing density to computation of air mass flow rate.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/673\">#673</a>.
</li>
<li>
July 2, 2015, by Michael Wetter:<br/>
Changed control input for <code>conPIDBoi</code> and set
<code>reverseActing=false</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/436\">#436</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
March 1, 2013, by Michael Wetter:<br/>
Added nominal pressure drop for valves as
this parameter no longer has a default value.
</li>
<li>
January 27, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-400,-360},{240,
            100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/Boiler/System6.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=172800));
end System6;
