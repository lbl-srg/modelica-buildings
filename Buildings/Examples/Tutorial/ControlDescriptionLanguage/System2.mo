within Buildings.Examples.Tutorial.ControlDescriptionLanguage;
model System2 "Open loop model with control architecture implemented"
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
    m_flow_nominal=mRad_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true)
                                      "Pump for radiator"
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
    m_flow_nominal=mBoi_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true)
                                      "Pump for boiler"
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
  Buildings.Fluid.Sensors.TemperatureTwoPort temRet(
    redeclare package Medium = MediumW,
    m_flow_nominal=mBoi_flow_nominal) "Return water temperature"
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

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTOut
    "Outdoor temperature sensor"
    annotation (Placement(transformation(extent={{-316,10},{-296,30}})));
//--------------------------------------------------------------------------------//

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

  Controls.OpenLoopBoilerReturn conBoiRet
    annotation (Placement(transformation(extent={{100,-290},{120,-270}})));
  Controls.OpenLoopSystemOnOff conSysSta
    annotation (Placement(transformation(extent={{-260,-60},{-240,-40}})));
  Controls.OpenLoopRadiatorSupply conRadSup
    annotation (Placement(transformation(extent={{-260,-160},{-240,-140}})));
  Controls.OpenLoopEquipmentOnOff conEquSta
    annotation (Placement(transformation(extent={{-200,-220},{-180,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal radPumCon(realTrue=
        mRad_flow_nominal) "Radiator pump signal"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal boiPumCon(realTrue=
        mBoi_flow_nominal) "Boiler pump signal"
    annotation (Placement(transformation(extent={{-100,-290},{-80,-270}})));
 Buildings.Controls.OBC.CDL.Conversions.BooleanToReal boiSigCon(realTrue=1)
    "Boiler signal"
    annotation (Placement(transformation(extent={{-100,-260},{-80,-240}})));
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
      points={{-240,70},{-220,70},{-220,50},{-340,50},{-340,20},{-316,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conBoiRet.TRet, temRet.T)
    annotation (Line(points={{98,-280},{71,-280}}, color={0,0,127}));
  connect(conBoiRet.yVal, valBoi.y) annotation (Line(points={{122,-280},{130,-280},
          {130,-230},{72,-230}}, color={0,0,127}));
  connect(conSysSta.TOut, senTOut.T) annotation (Line(points={{-262,-44},{-288,-44},
          {-288,20},{-296,20}}, color={0,0,127}));
  connect(conSysSta.TRoo, temRoo.T) annotation (Line(points={{-262,-56},{-280,-56},
          {-280,30},{-50,30},{-50,30}}, color={0,0,127}));
  connect(conRadSup.TRoo, temRoo.T) annotation (Line(points={{-262,-144},{-280,-144},
          {-280,30},{-50,30}}, color={0,0,127}));
  connect(conRadSup.TOut, senTOut.T) annotation (Line(points={{-262,-156},{-288,
          -156},{-288,20},{-296,20}}, color={0,0,127}));
  connect(conRadSup.yVal, valRad.y)
    annotation (Line(points={{-238,-150},{-62,-150}}, color={0,0,127}));
  connect(conEquSta.TBoi, boi.T) annotation (Line(points={{-202,-204},{-230,-204},
          {-230,-302},{-1,-302}}, color={0,0,127}));
  connect(conSysSta.onSys, conEquSta.onSys) annotation (Line(points={{-238,-50},
          {-212,-50},{-212,-216},{-202,-216}}, color={255,0,255}));
  connect(radPumCon.y, pumRad.m_flow_in)
    annotation (Line(points={{-78,-70},{-62,-70}}, color={0,0,127}));
  connect(pumBoi.m_flow_in, boiPumCon.y)
    annotation (Line(points={{-62,-280},{-78,-280}}, color={0,0,127}));
  connect(conEquSta.onPum, boiPumCon.u) annotation (Line(points={{-178,-216},{-120,
          -216},{-120,-280},{-102,-280}}, color={255,0,255}));
  connect(radPumCon.u, conEquSta.onPum) annotation (Line(points={{-102,-70},{-120,
          -70},{-120,-216},{-178,-216}}, color={255,0,255}));
  connect(boiSigCon.u, conEquSta.onBoi) annotation (Line(points={{-102,-250},{-108,
          -250},{-108,-204},{-178,-204}}, color={255,0,255}));
  connect(boiSigCon.y, boi.y) annotation (Line(points={{-78,-250},{32,-250},{32,
          -302},{22,-302}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
In this step, we added the control architecture.
How the control is partitioned into various subcontrollers depends usually on
the need to avoid communication over the network and on how control is distributed to
different field controllers. Here, we
used three controllers, one for switching the pumps and boiler on and off,
one to track the supply water temperature to the room and one to
track the return water temperature into the boiler.
</p>
<h4>Implementation</h4>
<p>
This model was built as follows:
</p>
<ol>
<li>
<p>
The first step is to determine what functionality is in which controller, and what their inputs and outputs are.
In this example, we used these controllers:
</p>
<ul>
<li>
<p>
Boiler return water controller, with input being the return water temperature <code>TRet</code> and output being the valve control signal <code>yVal</code>.
</p>
</li>
<li>
<p>
Radiator loop temperature controller, with input being the measured supply water temperature <code>TSup</code>,
the measure room air temperature <code>TRoo</code> and output being the valve control signal <code>yVal</code>.
</p>
</li>
<li>
<p>
System on/off controller, with inputs being the outdoor temperature <code>TOut</code> and the
room air temperature <code>TRoo</code>, and output being the system on/off signal <code>onSys</code>.
Note that how inputs and outputs are named can simplify usability. For example, we called the output <code>onSys</code>
so that a value of <code>true</code> is clearly understood as the system being on. If we had called it
<code>y</code>, then it would not have been clear what a value of <code>true</code> means.
</p>
</li>
<li>
<p>
Equipment controller, with inputs being the system on/off command and the boiler temperature,
and outputs being
the pump on/off signal <code>onPum</code> and the boiler on/off signal <code>onBoi</code>.
</p>
</li>
</ul>
</li>
<li>
<p>
To organize our code, we created package that we called <code>Controls</code>.
</p>
</li>
<li>
<p>
Next, we added the open loop controller for the boiler return water temperature.
This controller is implemented in
<a href=\"modelica://Buildings.Examples.Tutorial.ControlDescriptionLanguage.Controls.OpenLoopBoilerReturn\">
Buildings.Examples.Tutorial.ControlDescriptionLanguage.Controls.OpenLoopBoilerReturn</a>.
To implement it, we created a Modelica block, and added an input, using a
<a href=\"modelica://Buildings.Controls.OBC.CDL.Interfaces.RealInput\">
Buildings.Controls.OBC.CDL.Interfaces.RealInput</a>, called it <code>TRet</code>
for the measured return water temperature, and an
<a href=\"modelica://Buildings.Controls.OBC.CDL.Interfaces.RealOutput\">
Buildings.Controls.OBC.CDL.Interfaces.RealOutput</a>
for the valve control signal, which we call <code>yVal</code>.
</p>
<p>
To output the valve control signal, which we set for now to a constant value of <i>1</i>,
we used an instance of
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Sources.Constant\">
Buildings.Controls.OBC.CDL.Continuous.Sources.Constant</a>,
set its parameter to <i>1</i>, and connected it to the output.
</p>
<p>
At this stage, because the control is open loop, we leave the input of the controller unconnected.
</p>
<p>
Looking at the Modelica file shows that we also added documentation in an <code>info</code> section,
a <code>defaultComponentName</code>, as well as graphical elements so that it is easily distinguishable
in a schematic diagram.
We also added the <code>unit</code> and <code>displayUnit</code> attributes.
</p>
</li>
<li>
<p>
We did a similar process to add the other three open loop controllers. As before, we added all
inputs and outputs, and set the outputs to a constant.
</p>
</li>
<li>
<p>
Lastly, we instantiated these four controllers in the system model.
Because the pumps and the boiler take as a control input a real-valued signal, we used
<a href=\"modelica://Buildings.Controls.OBC.CDL.Conversions.BooleanToReal\">
Buildings.Controls.OBC.CDL.Conversions.BooleanToReal</a> to convert between the boolean-valued signal
and the real-valued inputs of these components. Whether this conversion is part of the
controller or done outside the controller is an individual design decision.
</p>
</li>
</ol>
<p>
As we have not changed any of the control logic, simulating the system should give the same
response as for
<a href=\"modelica://Buildings.Examples.Tutorial.ControlDescriptionLanguage.System1\">
Buildings.Examples.Tutorial.ControlDescriptionLanguage.System1</a>
and shown below.
</p>
<p align=\"center\">
<img alt=\"Open loop temperatures.\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/ControlDescriptionLanguage/System1/OpenLoopTemperatures.png\" border=\"1\"/>
</p>
</html>",
revisions="<html>
<ul>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-400,-360},{240, 100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/ControlDescriptionLanguage/System2.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end System2;
