within Buildings.Examples.Tutorial.Boiler;
model System5
  "5th part of the system model, which adds closed-loop control for the valves"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;
  replaceable package MediumW =
      Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=20000
    "Nominal heat flow rate of radiator";
  parameter Modelica.Units.SI.Temperature TRadSup_nominal=273.15 + 50
    "Radiator nominal supply water temperature";
  parameter Modelica.Units.SI.Temperature TRadRet_nominal=273.15 + 40
    "Radiator nominal return water temperature";
  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal=Q_flow_nominal/
      4200/(TRadSup_nominal - TRadRet_nominal)
    "Radiator nominal mass flow rate";

//-------------------------Step 4: Boiler design values-------------------------//
  parameter Modelica.Units.SI.Temperature TBoiSup_nominal=273.15 + 70
    "Boiler nominal supply water temperature";
  parameter Modelica.Units.SI.Temperature TBoiRet_min=273.15 + 60
    "Boiler minimum return water temperature";
  parameter Modelica.Units.SI.MassFlowRate mBoi_flow_nominal=Q_flow_nominal/
      4200/(TBoiSup_nominal - TBoiRet_min) "Boiler nominal mass flow rate";
//------------------------------------------------------------------------------//

//----------------Radiator loop: Three-way valve: mass flow rate----------------//
  parameter Modelica.Units.SI.MassFlowRate mRadVal_flow_nominal=Q_flow_nominal/
      4200/(TBoiSup_nominal - TRadRet_nominal)
    "Radiator nominal mass flow rate";
//------------------------------------------------------------------------------//

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mA_flow_nominal,
    V=V)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  parameter Modelica.Units.SI.Volume V=6*10*3 "Room volume";
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=V*1.2*6/3600
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=4000
    "Internal heat gains of the room";
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TOut(T=263.15)
    "Outside temperature"
    annotation (Placement(transformation(extent={{-360,40},{-340,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(C=2*V*1.2*1006)
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable timTab(
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
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mRad_flow_nominal) "Pump for radiator"
      annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-50,-70})));

//-------------------------Step 3: Splitter and mixers------------------------//
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
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mBoi_flow_nominal) "Pump for boiler"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-280})));

//-------------------------------Step 3: Boiler-------------------------------//
  Buildings.Fluid.Boilers.BoilerPolynomial boi(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mBoi_flow_nominal,
    dp_nominal=2000,
    Q_flow_nominal=Q_flow_nominal,
    fue=Buildings.Fluid.Data.Fuels.HeatingOilLowerHeatingValue()) "Boiler"
    annotation (Placement(transformation(extent={{20,-320},{0,-300}})));
//----------------------------------------------------------------------------//

//--------------------------Step 3: Three-way Valve---------------------------//
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

//---------------------Step 2: Outdoor temperature sensor and control------------------//
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysTOut(uLow=273.15 + 16, uHigh=273.15 + 17)
    "Hysteresis for on/off based on outside temperature"
    annotation (Placement(transformation(extent={{-260,-200},{-240,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-220,-200},{-200,-180}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTOut
    "Outdoor temperature sensor"
    annotation (Placement(transformation(extent={{-318,20},{-298,40}})));
//------------------------------------------------------------------------------------//

//-------------------------------Step 4: Boiler hysteresis----------------------------//
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysTBoi(uHigh=273.15 + 90,
                                             uLow=273.15 + 70)
    "Hysteresis for on/off of boiler"
    annotation (Placement(transformation(extent={{-260,-348},{-240,-328}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    annotation (Placement(transformation(extent={{-220,-348},{-200,-328}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{-180,-160},{-160,-140}})));
//------------------------------------------------------------------------------------//

//-------------------------Step 3: Boolean to real: Boiler Pump-----------------------//
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaRad1(realTrue=mBoi_flow_nominal)
    "Boiler pump signal"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
//------------------------------------------------------------------------------------//

  Buildings.Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{-140,-340},{-120,-320}})));

//---------------------------------Step 4: Boiler signal------------------------------//
 Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaRad2(realTrue=1) "Boiler signal"
    annotation (Placement(transformation(extent={{-100,-340},{-80,-320}})));
//------------------------------------------------------------------------------------//

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysPum(
    uLow=273.15 + 19,
    uHigh=273.15 + 21)
    "Pump hysteresis"
    annotation (Placement(transformation(extent={{-260,-160},{-240,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaRad(realTrue=mRad_flow_nominal)
    "Radiator pump signal"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Negate output of hysteresis"
    annotation (Placement(transformation(extent={{-220,-160},{-200,-140}})));

//------------------------Step 2: Boiler loop valve control-----------------------//
 Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetBoiRet(k=TBoiRet_min)
    "Temperature setpoint for boiler return"
    annotation (Placement(transformation(extent={{120,-270},{140,-250}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPIDBoi(
    Td=1,
    Ti=120,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.1,
    reverseActing=false) "Controller for valve in boiler loop"
    annotation (Placement(transformation(extent={{160,-270},{180,-250}})));
//--------------------------------------------------------------------------------//

//----------------------Step 3: Radiator loop valve control-----------------------//
  Buildings.Controls.OBC.CDL.Reals.PID conPIDRad(
    Td=1,
    Ti=120,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.1) "Controller for valve in radiator loop"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
//--------------------------------------------------------------------------------//
  Buildings.Controls.OBC.CDL.Reals.Line TSetSup
    "Setpoint for supply water temperature"
    annotation (Placement(transformation(extent={{-220,-90},{-200,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupMin(k=273.15 + 21)
    "Minimum heating supply temperature"
    annotation (Placement(transformation(extent={{-260,-120},{-240,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupMax(k=273.15 + 50)
    "Maximum heating supply temperature"
    annotation (Placement(transformation(extent={{-260,-60},{-240,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooMin(k=273.15 + 19)
    "Minimum room air temperature"
    annotation (Placement(transformation(extent={{-260,-20},{-240,0}})));
equation
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{-340,50},{20,50}},
      color={191,0,0},
      smooth=Smooth.None));
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
  connect(senTOut.port, TOut.port) annotation (Line(
      points={{-318,30},{-330,30},{-330,50},{-340,50}},
      color={191,0,0},
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
  connect(conPIDRad.y, valRad.y) annotation (Line(
      points={{-158,-10},{-90,-10},{-90,-150},{-62,-150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToReaRad.y, pumRad.m_flow_in) annotation (Line(
      points={{-118,-130},{-100,-130},{-100,-70},{-62,-70}},
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
          -260},{158,-260}}, color={0,0,127}));
  connect(temRet.T, conPIDBoi.u_m) annotation (Line(points={{71,-280},{110,-280},
          {170,-280},{170,-272}}, color={0,0,127}));
  connect(conPIDRad.u_s, TSetSup.y) annotation (Line(points={{-182,-10},{-190,-10},{-190,
          -80},{-198,-80}},       color={0,0,127}));
  connect(TSetSup.x1, TRooMin.y) annotation (Line(points={{-222,-72},{-230,-72},{-230,
          -10},{-238,-10}},   color={0,0,127}));
  connect(TSupMax.y, TSetSup.f1) annotation (Line(points={{-238,-50},{-234,-50},{-234,
          -76},{-222,-76}},       color={0,0,127}));
  connect(TSupMin.y, TSetSup.f2) annotation (Line(points={{-238,-110},{-230,-110},{-230,
          -88},{-222,-88}},       color={0,0,127}));
  connect(TSupMin.y, TSetSup.x2) annotation (Line(points={{-238,-110},{-230,-110},{-230,
          -84},{-222,-84}},       color={0,0,127}));
  connect(TSetSup.u, temRoo.T) annotation (Line(points={{-222,-80},{-270,-80},{-270,30},
          {-50,30}},     color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This part of the system model adds to the model that is implemented in
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System4\">
Buildings.Examples.Tutorial.Boiler.System4</a>
closed loop control for the valves.
</p>
<h4>Implementation</h4>
<p>
This model was built as follows:
</p>
<ol>
<li>
<p>
First, we copied the model
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System4\">
Buildings.Examples.Tutorial.Boiler.System4</a>
and called it
<code>Buildings.Examples.Tutorial.Boiler.System5</code>.
</p>
</li>
<li>
<p>
Next, we added closed loop control for the boiler valve as
shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System5BoilerValveControl.png\" border=\"1\"/>
</p>
<p>
This is implemented using the constant block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Sources.Constant\">
Buildings.Controls.OBC.CDL.Reals.Sources.Constant</a> for the set point,
the PID controller with output limitation
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.PID\">
Buildings.Controls.OBC.CDL.Reals.PID</a>.
We configured the controller as
</p>
<pre>
  Buildings.Controls.OBC.CDL.Reals.PID conPIDBoi(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=0.1,
    Ti=120,
    Td=1,
    reverseActing=false) \"Controller for valve in boiler loop\";
</pre>
<p>
We set the proportional band to <i>10</i> Kelvin, hence <code>k=0.1</code>.
We set the integral time constant to <i>120</i> seconds, which is
the same time as is required to open or close the valve.
These settings turn out to give satisfactory closed loop control performance.
Otherwise, we would need to retune the controller, which is
usually easiest by configuring the controller as a P-controller, then tuning the
proportional gain, and finally changing it to a PI-controller and tuning the
integral time constant.
</p>
<p>
Note that we also set <code>reverseActing=false</code> because
if, for a constant set point, the measured
temperature increases, the valve control signal needs to decrease towards <i>y=0</i>,
because in this condition, the boiler inlet temperature is not yet high enough.
Once it is high enough, the control error will be negative and the valve
can open.
</p>
</li>
<li>
<p>
The valve control for the radiator loop is implemented similar to
the boiler loop, with the exception that the setpoint is computed
using the model
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Line\">
Buildings.Controls.OBC.CDL.Reals.Line</a> to implement
a set point that shifts as a function of the room temperature.
This instance is called <code>TSetSup</code> in the
control sequence shown in the figure below, and takes as an input
the room temperature, and the points for the
<i>(x<sub>1</sub>, f<sub>1</sub>)</i> and
<i>(x<sub>2</sub>, f<sub>2</sub>)</i> coordinates through which the setpoint
goes.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System5RadiatorValve.png\" border=\"1\"/>
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
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System5Temperatures.png\" border=\"1\"/>
</p>
<p>
The figure shows that the return water temperature
<code>temRet.T</code>
quickly raises to <i>50</i>&deg;C and the supply water temperature
<code>temSup.T</code>
has smaller oscillations compared to
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System4\">
Buildings.Examples.Tutorial.Boiler.System4</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 9, 2024, by Hongxiang Fu:<br/>
Added nominal curve specification to suppress warning.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
</li>
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
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/Boiler/System5.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=172800));
end System5;
