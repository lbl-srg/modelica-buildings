within Buildings.Examples.Tutorial.Boiler;
model System5
  "5th part of the system model, which adds closed-loop control for the valves"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated;
  replaceable package MediumW =
      Buildings.Media.ConstantPropertyLiquidWater "Medium model";

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

  parameter Modelica.SIunits.MassFlowRate mRadVal_flow_nominal=
    Q_flow_nominal/4200/(TBoiSup_nominal-TRadRet_nominal)
    "Boiler nominal mass flow rate";

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal = V*6/3600
    "Nominal mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow = 4000
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
  Modelica.Blocks.Sources.CombiTimeTable timTab(
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      table=[      0, 0;
              8*3600, 0;
              8*3600, QRooInt_flow;
             18*3600, QRooInt_flow;
             18*3600, 0;
             24*3600, 0]) "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
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
        rotation=0,
        origin={-40,30})));
  Buildings.Fluid.Movers.FlowMachine_m_flow pumRad(m_flow_nominal=mRad_flow_nominal,
      redeclare package Medium = MediumW) "Pump for radiator"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-70})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM mix(
    redeclare package Medium =MediumW,
    m_flow_nominal={mRadVal_flow_nominal,
                   -mRad_flow_nominal,
                   mRad_flow_nominal-mRadVal_flow_nominal},
    dp_nominal={100,-8000,6750}) "Mixer between valve and radiators"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-110})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl(
    redeclare package Medium = MediumW,
    m_flow_nominal={mBoi_flow_nominal,
                   -mRadVal_flow_nominal,
                   -mBoi_flow_nominal},
    dp_nominal={200,-200,-50}) "Splitter of boiler loop bypass"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-190})));

  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl2(redeclare
      package Medium =
               MediumW,
    dp_nominal={0,0,0},
    m_flow_nominal={mRad_flow_nominal,-mRadVal_flow_nominal,-mRad_flow_nominal +
        mRadVal_flow_nominal})
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-110})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM mix2(redeclare
      package Medium =
               MediumW,
    dp_nominal={0,-200,0},
    m_flow_nominal={mRadVal_flow_nominal,-mBoi_flow_nominal,mBoi_flow_nominal}) "Mixer"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-190})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl4(redeclare
      package Medium =
               MediumW,
    m_flow_nominal=mRadVal_flow_nominal*{1,-1,-1},
    dp_nominal=200*{1,-1,-1}) "Splitter for radiator loop valve bypass"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-150})));
  Buildings.Fluid.Movers.FlowMachine_m_flow pumBoi(
      redeclare package Medium = MediumW,
      m_flow_nominal=mBoi_flow_nominal) "Pump for boiler"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-280})));
  Buildings.Fluid.Boilers.BoilerPolynomial boi(
    redeclare package Medium = MediumW,
    m_flow_nominal=mBoi_flow_nominal,
    dp_nominal=2000,
    Q_flow_nominal=Q_flow_nominal,
    fue=Buildings.Fluid.Data.Fuels.HeatingOilLowerHeatingValue()) "Boiler"
    annotation (Placement(transformation(extent={{20,-320},{0,-300}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valRad(
    redeclare package Medium = MediumW,
    m_flow_nominal=mRadVal_flow_nominal,
    l={0.01,0.01}) "Three-way valve"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-150})));
  Buildings.Fluid.Sources.FixedBoundary preSou(redeclare package Medium = MediumW,
      nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{92,-320},{72,-300}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valBoi(
    redeclare package Medium = MediumW,
    m_flow_nominal=mBoi_flow_nominal,
    l={0.01,0.01}) "Three-way valve for boiler"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-250})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temRet(redeclare package Medium =
        MediumW, m_flow_nominal=mBoi_flow_nominal) "Return water temperature"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-280})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM spl1(redeclare
      package Medium =
               MediumW,
    m_flow_nominal={mBoi_flow_nominal,-mBoi_flow_nominal,-mBoi_flow_nominal},
    dp_nominal={0,0,-200}) "Splitter"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-250})));
  Modelica.Blocks.Logical.Hysteresis hysTOut(uLow=273.15 + 16, uHigh=273.15 + 17)
    "Hysteresis for on/off based on outside temperature"
    annotation (Placement(transformation(extent={{-260,-200},{-240,-180}})));
  Modelica.Blocks.Logical.Not not2
    annotation (Placement(transformation(extent={{-220,-200},{-200,-180}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTOut
    "Outdoor temperature sensor"
    annotation (Placement(transformation(extent={{-318,20},{-298,40}})));
  Modelica.Blocks.Logical.Hysteresis hysTBoi(uLow=273.15 + 70, uHigh=273.15 +
        90) "Hysteresis for on/off of boiler"
    annotation (Placement(transformation(extent={{-260,-348},{-240,-328}})));
  Modelica.Blocks.Logical.Not not3
    annotation (Placement(transformation(extent={{-220,-348},{-200,-328}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-180,-160},{-160,-140}})));
  Modelica.Blocks.Math.BooleanToReal booToReaRad1(realTrue=mBoi_flow_nominal)
    "Radiator pump signal"
    annotation (Placement(transformation(extent={{-140,-290},{-120,-270}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{-140,-340},{-120,-320}})));
  Modelica.Blocks.Math.BooleanToReal booToReaRad2(realTrue=1)
    "Radiator pump signal"
    annotation (Placement(transformation(extent={{-100,-340},{-80,-320}})));
  Modelica.Blocks.Logical.Hysteresis hysPum(uLow=273.15 + 19,
                                            uHigh=273.15 + 21)
    "Pump hysteresis"
    annotation (Placement(transformation(extent={{-260,-82},{-240,-62}})));
  Modelica.Blocks.Math.BooleanToReal booToReaRad(realTrue=mRad_flow_nominal)
    "Radiator pump signal"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Modelica.Blocks.Logical.Not not1 "Negate output of hysteresis"
    annotation (Placement(transformation(extent={{-220,-82},{-200,-62}})));
  Modelica.Blocks.Continuous.FirstOrder firOrdPumRad(
    T=5,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    y(stateSelect=StateSelect.always))
    "First order filter to avoid step change for pump mass flow rate"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Continuous.FirstOrder firOrdPumBoi(
    T=5,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    y(stateSelect=StateSelect.always))
    "First order filter to avoid step change for pump mass flow rate"
    annotation (Placement(transformation(extent={{-100,-290},{-80,-270}})));

//------------------------Step 2: Boiler loop valve control-----------------------//	
	Modelica.Blocks.Sources.Constant TSetBoiRet(k=TBoiRet_min)
    "Temperature setpoint for boiler return"
    annotation (Placement(transformation(extent={{120,-320},{140,-300}})));
  Buildings.Controls.Continuous.LimPID conPIDBoi(
    Td=1,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=0.25) "Controller for valve in boiler loop"
    annotation (Placement(transformation(extent={{160,-290},{180,-270}})));
  Modelica.Blocks.Continuous.FirstOrder firOrdValBoi(
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    y(stateSelect=StateSelect.always),
    T=5) "First order filter to avoid step change for valve position"
    annotation (Placement(transformation(extent={{200,-290},{220,-270}})));
//--------------------------------------------------------------------------------//

//----------------------Step 3: Radiator loop valve control-----------------------//	
  Controls.SetPoints.Table TSetSup(table=[273.15 + 19, 273.15 + 50;
                                          273.15 + 21, 273.15 + 21])
    "Setpoint for supply water temperature"
    annotation (Placement(transformation(extent={{-220,-20},{-200,0}})));
  Buildings.Controls.Continuous.LimPID conPIDRad(
    Td=1,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=0.25) "Controller for valve in radiator loop"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Modelica.Blocks.Continuous.FirstOrder firOrdValRad(
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    y(stateSelect=StateSelect.always),
    T=5) "First order filter to avoid step change for valve position"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
//--------------------------------------------------------------------------------//
	
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
      points={{1,80},{20,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSup.port_b, rad.port_a) annotation (Line(
      points={{-50,-30},{-50,-10},{0,-10}},
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
      points={{0,-310},{-50,-310},{-50,-290}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumBoi.port_b, spl1.port_1) annotation (Line(
      points={{-50,-270},{-50,-260}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl1.port_2, spl.port_1) annotation (Line(
      points={{-50,-240},{-50,-200}},
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
      points={{-40,-250},{50,-250}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valBoi.port_2, temRet.port_a)
                                      annotation (Line(
      points={{60,-260},{60,-270}},
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
      points={{60,-200},{60,-240}},
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
      points={{-239,-190},{-222,-190}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(senTOut.port, TOut.port) annotation (Line(
      points={{-318,30},{-330,30},{-330,50},{-340,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(hysTBoi.y, not3.u) annotation (Line(
      points={{-239,-338},{-222,-338}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not2.y, and1.u2) annotation (Line(
      points={{-199,-190},{-192,-190},{-192,-158},{-182,-158}},
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
      points={{-159,-150},{-152,-150},{-152,-280},{-142,-280}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and1.y, and2.u1) annotation (Line(
      points={{-159,-150},{-152,-150},{-152,-330},{-142,-330}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not3.y, and2.u2) annotation (Line(
      points={{-199,-338},{-142,-338}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and2.y, booToReaRad2.u) annotation (Line(
      points={{-119,-330},{-102,-330}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booToReaRad2.y, boi.y) annotation (Line(
      points={{-79,-330},{40,-330},{40,-302},{22,-302}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temRoo.T,hysPum. u) annotation (Line(
      points={{-50,30},{-270,30},{-270,-72},{-262,-72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hysPum.y,not1. u) annotation (Line(
      points={{-239,-72},{-222,-72}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booToReaRad.y,firOrdPumRad. u)
                                   annotation (Line(
      points={{-119,-70},{-102,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firOrdPumRad.y, pumRad.m_flow_in)
                                      annotation (Line(
      points={{-79,-70},{-70,-70},{-70,-75},{-58.2,-75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(not1.y, and1.u1) annotation (Line(
      points={{-199,-72},{-192,-72},{-192,-150},{-182,-150}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and1.y, booToReaRad.u) annotation (Line(
      points={{-159,-150},{-152,-150},{-152,-70},{-142,-70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booToReaRad1.y, firOrdPumBoi.u) annotation (Line(
      points={{-119,-280},{-102,-280}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firOrdPumBoi.y, pumBoi.m_flow_in) annotation (Line(
      points={{-79,-280},{-68.5,-280},{-68.5,-285},{-58.2,-285}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temRet.T,conPIDBoi. u_s) annotation (Line(
      points={{71,-280},{158,-280}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetBoiRet.y,conPIDBoi. u_m) annotation (Line(
      points={{141,-310},{170,-310},{170,-292}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conPIDBoi.y,firOrdValBoi. u) annotation (Line(
      points={{181,-280},{198,-280}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firOrdValBoi.y, valBoi.y) annotation (Line(
      points={{221,-280},{232,-280},{232,-250},{68,-250}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temRoo.T, TSetSup.u) annotation (Line(
      points={{-50,30},{-270,30},{-270,-10},{-222,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conPIDRad.y, firOrdValRad.u) annotation (Line(
      points={{-159,-10},{-142,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetSup.y, conPIDRad.u_s) annotation (Line(
      points={{-199,-10},{-182,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSup.T, conPIDRad.u_m) annotation (Line(
      points={{-61,-40},{-170,-40},{-170,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firOrdValRad.y, valRad.y) annotation (Line(
      points={{-119,-10},{-110,-10},{-110,-150},{-58,-150}},
      color={0,0,127},
      smooth=Smooth.None));
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
<img src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System5BoilerValveControl.png\" border=\"1\">
</p>
<p>
This is implemented using the constant block
<a href=\"modelica://Modelica.Blocks.Sources.Constant\">
Modelica.Blocks.Sources.Constant</a> for the set point,
the PID controller with output limitation
<a href=\"modelica://Buildings.Controls.Continuous.LimPID\">
Buildings.Controls.Continuous.LimPID</a>, followed by
a first order filter
<a href=\"modelica://Modelica.Blocks.Continuous.FirstOrder\">
Modelica.Blocks.Continuous.FirstOrder</a>.
As for the pumps, the first order filter avoids a sudden change in
the valve position.
We configured the controller as
</p>
<pre>
  Buildings.Controls.Continuous.LimPID conPIDBoi(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=0.25,
    Ti=1,    
    Td=1) \"Controller for valve in boiler loop\";
</pre>
Thus, we use it as a P-controller, which we will later 
change to a PI-controller. We used the P-controller because 
the gain of the P-controller is easier to tune compared to a PI-controller.
We set the proportional band to <i>4</i> Kelvin, hence <code>k=0.25</code>.
Although <i>4</i> Kelvin may lead to a large steady-state control error,
this is not a concerns as we will later change the controller to a PI-controller.
</p>
<p>
Similar than for the pumps, we parameterized the first order filter
as
</p>
<pre>
  Modelica.Blocks.Continuous.FirstOrder firOrdValBoi(
    T=5,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) \"First order filter to avoid step change for valve position\";
</pre>
<p>
Note that we forced the output signal <code>y</code> 
to be zero at the start of the simulation.
This ensures that the valve input signal is within the allowed 
range of <i>[0,&nbsp;1]</i>.
</p>
</li>
<li>
<p>
When an earlier development version of this model
was simulated in Dymola 2012 FD01, then the simulation
stopped with the following error message:
</p>
<pre>
ERROR: Failed to solve non-linear system using Newton solver.To get more information: Turn on Simulation/Setup/Debug/Nonlinear solver diagnostics/DetailsSolution to systems of equations not found at time = 6780.96   Nonlinear system of equations number = 4   Infinity-norm of residue = 0.0449558   Iteration is not making good progress.   Accumulated number of residue       calc.: 147649   Accumulated number of symbolic Jacobian calc.: 20994   Last values of solution vector:spl.port_2.p = 311569
firOrdPumRad.y = 0.478238
spl2.vol.dynBal.medium.p = 311848
pumRad.vol.dynBal.medium.p = 300653
mix.vol.dynBal.medium.p = 305696
spl1.vol.dynBal.medium.p = 311759
spl.vol.dynBal.medium.p = 311762
firOrdValBoi.y = -0.00917415
pumBoi.vol.dynBal.medium.p = 298044
firOrdPumBoi.y = 0.235443
   Last values of residual vector:{ -9.69976E-08, -8.10579E-06, -0.000155234, -2.37278E-07, -4.21349E-05,
  7.96656E-06, 0.000129487, -0.0329536, 0.000654838, -0.0110041 }
 Solver will attempt to handle this problem.


... Error message from dymosim
At time T = 6.780958e+03 and stepsize
H = 1.249713e-07 the corrector could not
converge because IRES was equal to minus one.
Integration will be terminated.
</pre>
<p>
In the above output, we see that <code>firOrdValBoi.y = -0.00917415</code>, 
which means that the input signal to the valve
is negative. Clearly, this numerical error is undesired.
To fix this, we can select in the simulation pane <code>Simulation -> Setup</code> and then select to report the selected state variables:
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System5SimulationSetup.png\" border=\"1\">
</p>
<p>
After this change, the following message was shown after the model was translated:
</p>
<pre>
There is one set of dynamic state selection.
There are 3 states to be selected from:
  firOrdPumBoi.y
  firOrdPumRad.y
  firOrdValBoi.y
  mix.vol.dynBal.medium.p
  pumBoi.vol.dynBal.medium.p
  pumRad.vol.dynBal.medium.p
  spl.port_2.p
  spl.vol.dynBal.medium.p
  spl1.vol.dynBal.medium.p
  spl2.vol.dynBal.medium.p
</pre>
<p>
This means that Dymola was able to choose three of these variables as state variables.
Because one of the first order elements was negative when the solver failed to converge,
and because the first order elements are easy to integrate, we selected
these as state variables.
Hence, in the model, we set for all first order elements the <code>stateSelect</code> attribute as
</p>
<pre>
  Modelica.Blocks.Continuous.FirstOrder firOrdValBoi(
    T=5,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    y(stateSelect=StateSelect.always)) 
    \"First order filter to avoid step change for valve position\";
</pre>
<p>
After this change, the model run without problems.
</p>
<p>
Note that in this version of the model, setting the <code>stateSelect</code>
attribute is not required for convergence. However, by setting
<code>stateSelect=StateSelect.always</code> for the outputs of the
first order filters, the model simulates about twice as fast.
</p>
</li>
<li>
<p>
The valve control for the radiator loop is implemented similar to
the boiler loop, with the exception that the setpoint is computed
using the model
<a href=\"modelica://Buildings.Controls.SetPoints.Table\">
Buildings.Controls.SetPoints.Table</a> to implement
a set point that shifts as a function of the room temperature.
This instance is called <code>TSetSup</code> in the 
control sequence shown in the figure below
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System5RadiatorValve.png\" border=\"1\">
</p>
<p>
Its configuration is
</p>
<pre>
  Controls.SetPoints.Table TSetSup(table=[273.15 + 19, 273.15 + 50; 
                                          273.15 + 21, 273.15 + 21]) 
                                          \"Setpoint for supply water temperature\";
</pre>
</li>
</ol>
<!-- ----------------------- -->
<p>
This completes the closed loop control.
When simulating the model
for <i>2</i> days, or <i>172800</i> seconds, the
response shown below should be seen.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System5Temperatures.png\" border=\"1\">
</p>
<p>
The figure shows that the return water temperature
<code>temRet.T</code>
quickly raises to <i>50</i>&deg;C.
</p>
</html>", revisions="<html>
<ul>
<li>
January 27, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-400,-360},{240,
            100}}),
            graphics),
    Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/Boiler/System5.mos"
        "Simulate and plot"),
    experiment(StopTime=172800));
end System5;
