within Buildings.Fluid.HeatPumps.Examples;
model EquationFitWaterToWater_OneRoomRadiator "Example of one room equipped with a radiator and served by a water to water heat pump"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air "Air medium model";
  replaceable package MediumW =
      Buildings.Media.Water "Water medium model";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 20000
    "Nominal heat flow rate of radiator";
  parameter Modelica.SIunits.Temperature TRadSup_nominal = 273.15+55
    "Radiator nominal supply water temperature";
  parameter Modelica.SIunits.Temperature TRadRet_nominal = 273.15+45
    "Radiator nominal return water temperature";
  parameter Modelica.SIunits.Temperature TConSup_nominal = 273.15+60
    "Condenser nominal supply water temperature";
  parameter Modelica.SIunits.MassFlowRate mRad_flow_nominal=
    Q_flow_nominal/4200/(TRadSup_nominal-TRadRet_nominal)
    "Radiator nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mRadVal_flow_nominal=
    Q_flow_nominal/4200/(TConSup_nominal-TRadRet_nominal)
    "Radiator nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal = per.mCon_flow_nominal*SF
    "Condenser nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal = per.mEva_flow_nominal*SF
    "Evaporator nominal mass flow rate";
  parameter Modelica.SIunits.Volume V=6*10*3
    "Room volume";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal = V*1.2*6/3600
    "Nominal mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow=4000
    "Internal heat gains of the room";
  parameter Data.EquationFitWaterToWater.Trane_Axiom_EXW240 per
    "HeatPump performance data"
    annotation (Placement(transformation(extent={{112,-100},{132,-80}})));
  parameter Real SF=0.5
   "Load scale factor for the heatpump";
  parameter Boolean show_T=true
   "= true, if actual temperature at port is computed";

  MediumW.ThermodynamicState sta_port_1=
      MediumW.setState_phX(valRad.port_1.p,
                           noEvent(actualStream(valRad.port_1.h_outflow)),
                           noEvent(actualStream(valRad.port_1.Xi_outflow))) if
         show_T "Medium properties in valve port_1";
  MediumW.ThermodynamicState sta_port_2=
     MediumW.setState_phX(valRad.port_2.p,
                           noEvent(actualStream(valRad.port_2.h_outflow)),
                           noEvent(actualStream(valRad.port_2.Xi_outflow))) if
         show_T "Medium properties in valve port_2";
  MediumW.ThermodynamicState sta_port_3=
      MediumW.setState_phX(valRad.port_3.p,
                           noEvent(actualStream(valRad.port_3.h_outflow)),
                           noEvent(actualStream(valRad.port_3.Xi_outflow))) if
         show_T "Medium properties in valve port_3";
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mA_flow_nominal,
    V=V)
    "room air volume"
     annotation (Placement(transformation(extent={{92,18},{112,38}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/30)
    "Thermal conductance with the ambient"
     annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
     annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(C=2*V*1.2*1006)
    "Heat capacity for furniture and walls"
     annotation (Placement(transformation(extent={{94,50},{114,70}})));
  Modelica.Blocks.Sources.CombiTimeTable timTab(
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      table=[-6, 0;
              8, QRooInt_flow;
             18, 0], timeScale=3600)
    "Time table for internal heat gain"
     annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal,
    T_a_nominal=TRadSup_nominal,
    T_b_nominal=TRadRet_nominal)
    "Radiator"
     annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSup1(redeclare package Medium =
        MediumW, m_flow_nominal=mRad_flow_nominal)
    "Supply water temperature for the radiator" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-40})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temRoo
    "Room temperature"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-40,28})));
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
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCon(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mCon_flow_nominal,
    redeclare Movers.Data.Generic per,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=true,
    riseTime=30,
    m_flow_start=mCon_flow_nominal)
    "Pump for heatpump condenser"
     annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-50,-260})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumEva(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mEva_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=true,
    riseTime=30,
    m_flow_start=mEva_flow_nominal)
    "Pump for heat pump source side"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
                                         origin={-34,-324})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valRad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mRadVal_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000)
    "Three-way valve for radiator loop"
     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-180})));
  Buildings.Fluid.Sources.Boundary_pT preSou(
    redeclare package Medium = MediumW,
      nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{92,-306},{72,-286}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temRet(
    redeclare package Medium =
    MediumW, m_flow_nominal=mCon_flow_nominal)
    "Return water temperature"
     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-274})));
  Modelica.Blocks.Logical.Hysteresis hysTOut(uLow=273.15 + 16, uHigh=273.15 + 17)
    "Hysteresis for on/off based on outside temperature"
    annotation (Placement(transformation(extent={{-320,-200},{-300,-180}})));
  Modelica.Blocks.Logical.Not not2
    annotation (Placement(transformation(extent={{-280,-200},{-260,-180}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTOut
    "Outdoor temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
                                         origin={-346,-114})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-230,-160},{-210,-140}})));
  Modelica.Blocks.Math.BooleanToReal booToReaRad1(
     realTrue=mCon_flow_nominal)
   "Radiator pump signal"
    annotation (Placement(transformation(extent={{-140,-290},{-120,-270}})));
  Modelica.Blocks.Math.BooleanToInteger heaPumCon(
     integerTrue=1,
     integerFalse=0)
    "Heatpump signal"
    annotation (Placement(transformation(extent={{-140,-370},{-120,-350}})));
  Modelica.Blocks.Logical.Hysteresis hysPum(uLow=273.15 + 19, uHigh=273.15 + 21)
    "Pump hysteresis"
    annotation (Placement(transformation(extent={{-320,-80},{-300,-60}})));
  Modelica.Blocks.Math.BooleanToReal booToReaRad(realTrue=mRad_flow_nominal)
   "Radiator pump signal"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-280,-80},{-260,-60}})));
  Controls.SetPoints.Table TSetSup(table=[273.15 + 19,273.15 + 55;
                                          273.15 + 21,273.15+ 21])
   "Setpoint for supply water temperature"
    annotation (Placement(transformation(extent={{-260,-20},{-240,0}})));
  Buildings.Controls.Continuous.LimPID conPIDRad(
    Td=1,
    Ti=120,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    reverseAction=false)
    "Controller for valve in radiator loop"
    annotation (Placement(transformation(extent={{-206,-20},{-186,0}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
     "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-376,72},{-356,92}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-320,60},{-300,80}}),
        iconTransformation(extent={{-230,68},{-210,88}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
   "Outside temperature"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));
  Buildings.Fluid.HeatPumps.EquationFitWaterToWater heaPum(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p1_start(displayUnit="Pa"),
    T1_start=313.15,
    p2_start(displayUnit="Pa"),
    T2_start=293.15,
    per=per,
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    dp1_nominal=2000,
    dp2_nominal=2000,
    tau1=30,
    tau2=30,
    show_T=true,
    m1_flow_nominal=mCon_flow_nominal,
    m2_flow_nominal=mEva_flow_nominal,
    SF=SF)
    "Heat pump"
    annotation (Placement(transformation(extent={{10,-318},{-10,-298}})));
  Sources.Boundary_pT sou(
    redeclare package Medium = MediumW,
    nPorts=1,
    T=283.15)
    "Fluid source on evaporator side"
    annotation (Placement(transformation(extent={{-72,-350},{-52,-330}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = MediumW,
      nPorts=1)
    "Fluid sink on on evaporator side"
    annotation (Placement(transformation(extent={{90,-350},{70,-330}})));
  Modelica.Blocks.Sources.Constant TEvaSet(k=15 + 273.15)
    "Evaporator setpoint temperature"
    annotation (Placement(transformation(extent={{182,-364},{162,-344}})));
    Controls.OBC.CDL.Continuous.Sources.Constant TConSet(k=55 + 273.15)
    "Condenser setpoint water temperature"
    annotation (Placement(transformation(extent={{180,-262},{160,-242}})));
  FixedResistances.Junction spl1(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mCon_flow_nominal,-mRadVal_flow_nominal,-mCon_flow_nominal},
    dp_nominal={200,-200,0})
    "Splitter of heatpump loop bypass"
     annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-228})));
  Buildings.Fluid.FixedResistances.Junction spl2(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mRadVal_flow_nominal*{1,-1,-1},
    dp_nominal=200*{1,-1,-1})
    "Splitter for radiator loop valve bypass"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-180})));
   FixedResistances.Junction mix1(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,-200,200},
    m_flow_nominal={mRadVal_flow_nominal,-mCon_flow_nominal,mCon_flow_nominal})
    "Mixer"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-228})));
  Sensors.TemperatureTwoPort temSup2(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCon_flow_nominal)
   "Supply water temperature"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-36,-292})));
equation
  connect(theCon.port_b, vol.heatPort)
   annotation (Line(
      points={{40,50},{54,50},{54,28},{92,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort)
   annotation (Line(
      points={{40,80},{66,80},{66,28},{92,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCap.port, vol.heatPort)
   annotation (Line(
      points={{104,50},{82,50},{82,28},{92,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(timTab.y[1], preHea.Q_flow)
   annotation (Line(
      points={{1,80},{20,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSup1.port_b, rad.port_a)
   annotation (Line(
      points={{-50,-30},{-50,-10},{-5.55112e-16,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRoo.port, vol.heatPort)
   annotation (Line(
      points={{-30,28},{92,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortCon, vol.heatPort)
   annotation (Line(
      points={{8,-2.8},{8,28},{92,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortRad, vol.heatPort)
   annotation (Line(
      points={{12,-2.8},{12,28},{92,28}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumRad.port_b, temSup1.port_a)
   annotation (Line(
      points={{-50,-60},{-50,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valRad.port_3,spl2. port_3)
   annotation (Line(
      points={{-40,-180},{50,-180}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hysTOut.y, not2.u)
   annotation (Line(
      points={{-299,-190},{-282,-190}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not2.y, and1.u2)
   annotation (Line(
      points={{-259,-190},{-244,-190},{-244,-158},{-232,-158}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(senTOut.T, hysTOut.u)
   annotation (Line(
      points={{-346,-124},{-346,-190},{-322,-190}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(and1.y, booToReaRad1.u)
   annotation (Line(
      points={{-209,-150},{-180,-150},{-180,-280},{-142,-280}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(temRoo.T,hysPum. u)
   annotation (Line(
      points={{-50,28},{-334,28},{-334,-70},{-322,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hysPum.y,not1. u)
   annotation (Line(
      points={{-299,-70},{-282,-70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not1.y, and1.u1)
   annotation (Line(
      points={{-259,-70},{-244,-70},{-244,-150},{-232,-150}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and1.y, booToReaRad.u)
   annotation (Line(
      points={{-209,-150},{-180,-150},{-180,-70},{-142,-70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(temRoo.T, TSetSup.u)
   annotation (Line(
      points={{-50,28},{-280,28},{-280,-10},{-262,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetSup.y, conPIDRad.u_s)
   annotation (Line(
      points={{-239,-10},{-208,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSup1.T, conPIDRad.u_m) annotation (Line(
      points={{-61,-40},{-196,-40},{-196,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus)
   annotation (Line(
      points={{-356,82},{-336,82},{-336,70},{-310,70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, TOut.T)
   annotation (Line(
      points={{-310,70},{-262,70}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TOut.port, theCon.port_a)
   annotation (Line(
      points={{-240,70},{-220,70},{-220,50},{20,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TOut.port, senTOut.port)
   annotation (Line(
      points={{-240,70},{-220,70},{-220,50},{-346,50},{-346,-104}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(booToReaRad.y, pumRad.m_flow_in)
   annotation (Line(
      points={{-119,-70},{-62,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conPIDRad.y, valRad.y)
   annotation (Line(
      points={{-185,-10},{-98,-10},{-98,-180},{-62,-180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToReaRad1.y,pumCon. m_flow_in)
   annotation (Line(
      points={{-119,-280},{-90,-280},{-90,-260},{-62,-260}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], pumEva.port_a)
   annotation (Line(points={{-52,-340},{-34,-340},{-34,-334}},
                     color={0,127,255}));
  connect(temRet.port_b, preSou.ports[1])
   annotation (Line(points={{60,-284},{60,
          -296},{72,-296}}, color={0,127,255}));
  connect(heaPum.port_a1, temRet.port_b)
   annotation (Line(points={{6.66667,-302},
          {60,-302},{60,-284}}, color={0,127,255}));
  connect(heaPum.port_b2, sin.ports[1])
   annotation (Line(points={{6.66667,-314},
          {38,-314},{38,-340},{70,-340}},color={0,127,255}));
  connect(heaPum.port_a2, pumEva.port_b)
   annotation (Line(points={{-10,-314},{-34,-314}}, color={0,127,255}));
  connect(booToReaRad1.y, pumEva.m_flow_in)
   annotation (Line(points={{-119,-280},
          {-76,-280},{-76,-324},{-46,-324}}, color={0,0,127}));
  connect(heaPumCon.y, heaPum.uMod)
   annotation (Line(points={{-119,-360},{94,-360},{94,-308},{7.83333,-308}},
                                     color={255,127,0}));
  connect(heaPum.TEvaSet, TEvaSet.y)
   annotation (Line(
      points={{7.83333,-317},{20,-317},{20,-354},{161,-354}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(heaPum.TConSet, TConSet.y)
   annotation (Line(
      points={{7.83333,-299},{12,-299},{12,-300},{18,-300},{18,-252},{158,-252}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(valRad.port_2, pumRad.port_a)
    annotation (Line(points={{-50,-170},{-50,-80}}, color={0,127,255}));
  connect(spl2.port_1, rad.port_b)
    annotation (Line(points={{60,-170},{60,-10},{20,-10}}, color={0,127,255}));
  connect(pumCon.port_b, spl1.port_1)
    annotation (Line(points={{-50,-250},{-50,-238}}, color={0,127,255}));
  connect(valRad.port_1, spl1.port_2)
    annotation (Line(points={{-50,-190},{-50,-218}}, color={0,127,255}));
  connect(spl2.port_2,mix1. port_1)
    annotation (Line(points={{60,-190},{60,-218}}, color={0,127,255}));
  connect(temRet.port_a,mix1. port_2)
    annotation (Line(points={{60,-264},{60,-238}}, color={0,127,255}));
  connect(spl1.port_3, mix1.port_3)
    annotation (Line(points={{-40,-228},{50,-228}}, color={0,127,255}));
  connect(heaPum.port_b1,temSup2. port_a)
    annotation (Line(points={{-10,-302},{-18,
          -302},{-18,-292},{-26,-292}}, color={0,127,255}));
  connect(temSup2.port_b, pumCon.port_a)
    annotation (Line(points={{-46,-292},{-50,
          -292},{-50,-270}}, color={0,127,255}));
  connect(and1.y, heaPumCon.u) annotation (Line(points={{-209,-150},{-180,-150},
          {-180,-360},{-142,-360}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
Example that simulates one room equipped with a radiator. Hot water is produced
by a water to water heat pump <a href=\"Buildings.Fluid.HeatPumps.EquationFitWaterToWater\">
Buildings.Fluid.HeatPumps.EquationFitWaterToWater</a>.
</p>
<p>
The heat pump is turned on when the room temperature falls below
<i>19</i>&deg;C and turned
off when the room temperature rises above <i>21</i>&deg;C.
</p>
<p>
The valve control for the radiator loop is implemented so that the setpoint is computed
using the model
<a href=\"modelica://Buildings.Controls.SetPoints.Table\">
Buildings.Controls.SetPoints.Table</a> to implement
a set point that shifts as a function of the room temperature.
This explains the drop in the supply heating water temperature to the radiator, once the room temperature is higher than <i>19</i>&deg;C.
</p>
<p>
A scale factor <code>SF</code> equals to 0.5 was used to scale down the heatpump of a nominal heating capacity of 77kW to suit the heating loads required by the room.
</p>
</html>", revisions="<html>
<ul>
<li>
August 6, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-380},{200,
            100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/EquationFitWaterToWater_OneRoomRadiator.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=172800),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end EquationFitWaterToWater_OneRoomRadiator;
