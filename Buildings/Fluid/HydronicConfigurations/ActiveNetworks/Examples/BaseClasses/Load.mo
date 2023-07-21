within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses;
model Load "Model of a load on a hydronic circuit"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal);

  replaceable package MediumAir = Buildings.Media.Air
    "Medium model for air";
  replaceable package MediumLiq = Buildings.Media.Water
    "Medium model for liquid (CHW or HHW)";

  parameter Buildings.Fluid.HydronicConfigurations.Types.Control typ
    "Load type"
    annotation (Evaluate=true);

  parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal = 1
    "Liquid mass flow rate at design conditions";
  parameter Modelica.Units.SI.PressureDifference dpLiq_nominal=0
    "Liquid pressure drop at design conditions";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=
    abs(Q_flow_nominal) / 10 / cpAir_nominal
    "Air mass flow rate at design conditions";
  parameter Modelica.Units.SI.Temperature TAirEnt_nominal=
    if typ==Buildings.Fluid.HydronicConfigurations.Types.Control.Heating
      then 20+273.15 else 26+273.15
    "Air entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TAirEntChg_nominal=20+273.15
    "Air entering temperature in change-over mode"
    annotation(Dialog(
      enable=typ == Buildings.Fluid.HydronicConfigurations.Types.Control.ChangeOver));
  parameter Modelica.Units.SI.MassFraction phiAirEnt_nominal = 0.5
    "Air entering relative humidity at design conditions"
    annotation(Dialog(
      enable=typ <> Buildings.Fluid.HydronicConfigurations.Types.Control.Heating));
  final parameter Modelica.Units.SI.MassFraction XAirEnt_nominal=
    Buildings.Utilities.Psychrometrics.Functions.X_pTphi(
      MediumAir.p_default, TAirEnt_nominal, phiAirEnt_nominal)
    "Air entering water mass fraction at design conditions (kg/kg air)";
  final parameter Modelica.Units.SI.MassFraction xAirEnt_nominal=
    XAirEnt_nominal / (1 - XAirEnt_nominal)
    "Air entering humidity ratio at design conditions (kg/kg dry air)";
  parameter Modelica.Units.SI.Temperature TLiqEnt_nominal=
    if typ==Buildings.Fluid.HydronicConfigurations.Types.Control.Heating
    then 60+273.15 else 7+273.15
    "Liquid entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqLvg_nominal=TLiqEnt_nominal+(
    if typ==Buildings.Fluid.HydronicConfigurations.Types.Control.Heating
    then -10 else +5)
    "Liquid leaving temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqEntChg_nominal=
    60+273.15
    "Liquid entering temperature in change-over mode"
    annotation(Dialog(
      enable=typ == Buildings.Fluid.HydronicConfigurations.Types.Control.ChangeOver));

  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=
   (MediumLiq.specificEnthalpy_pTX(MediumLiq.p_default, TLiqEnt_nominal, X=MediumLiq.X_default)-
    MediumLiq.specificEnthalpy_pTX(MediumLiq.p_default, TLiqLvg_nominal, X=MediumLiq.X_default))*
    mLiq_flow_nominal
    "Transmitted heat flow rate at design conditions";

  final parameter Modelica.Units.SI.HeatFlowRate QChg_flow_nominal=
    eps_nominal
    * min({mLiq_flow_nominal * cpLiq_nominal, mAir_flow_nominal * cpAirChg_nominal})
    * (TLiqEntChg_nominal - TAirEntChg_nominal)
    "Transmitted heat flow rate in change-over mode";

  final parameter Modelica.Units.SI.Temperature TAirLvgChg_nominal=
    TAirEntChg_nominal + QChg_flow_nominal / cpAirChg_nominal / mAir_flow_nominal
    "Air leaving temperature in change-over mode";

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  parameter Real k(
    min=100*Modelica.Constants.eps)=0.1
    "Gain of controller"
    annotation (Dialog(group="Control gains"));
  parameter Real Ti(unit="s")=60
    "Time constant of integrator block"
    annotation (Dialog(group="Control gains",
      enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
        controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Load modulating signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode "Operating mode"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(final unit="1")
    "Valve demand signal" annotation (Placement(transformation(extent={{100,40},
            {140,80}}), iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput u_s(final unit="K",
      displayUnit="degC") "Controller set point" annotation (Placement(
        transformation(extent={{100,-50},{140,-10}}), iconTransformation(extent=
           {{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput u_m(final unit="K",
      displayUnit="degC") "Controller measured value" annotation (Placement(
        transformation(extent={{100,-70},{140,-30}}), iconTransformation(extent=
           {{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dTLiq(final unit="K",
      displayUnit="K") "Liquid deltaT" annotation (Placement(transformation(
          extent={{100,-90},{140,-50}}), iconTransformation(extent={{100,-90},{
            140,-50}})));
  Sources.Boundary_pT outAir(
    redeclare final package Medium = MediumAir,
    nPorts=2)
    "Pressure boundary condition at coil outlet"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,20})));
  Sensors.TemperatureTwoPort TAirLvg(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mAir_flow_nominal,
    T_start=TAirEnt_nominal)
    "Leaving air temperature sensor"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,12})));
  HeatExchangers.WetCoilEffectivenessNTU coi(
    redeclare final package Medium1 = MediumLiq,
    redeclare final package Medium2 = MediumAir,
    final energyDynamics=energyDynamics,
    final m1_flow_nominal=mLiq_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=dpLiq_nominal,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final use_Q_flow_nominal=true,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=TLiqEnt_nominal,
    final T_a2_nominal=TAirEnt_nominal,
    final w_a2_nominal=xAirEnt_nominal)
    "Coil"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={0,6})));
  Sources.MassFlowSource_T souAir(
    redeclare final package Medium = MediumAir,
    final X={XAirEnt_nominal,1 - XAirEnt_nominal},
    final m_flow=mAir_flow_nominal,
    use_T_in=true,
    nPorts=1) "Source for entering air"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,12})));
  Controls.PIDWithOperatingMode ctl(
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"),
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final reverseActing=typ == Buildings.Fluid.HydronicConfigurations.Types.Control.Heating)
    "Controller for supply air temperature"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Add  TAirSupSet(
    y(final unit="K", displayUnit="degC"))
    "Compute set point as TAirEnt_nominal + u * (TAirLvg_nominal - TAirEnt_nominal)"
    annotation (Placement(transformation(extent={{14,50},{34,70}})));
  HeatExchangers.WetCoilEffectivenessNTU coiNom(
    redeclare final package Medium1 = MediumLiq,
    redeclare final package Medium2 = MediumAir,
    final m1_flow_nominal=mLiq_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final use_Q_flow_nominal=true,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=TLiqEnt_nominal,
    final T_a2_nominal=TAirEnt_nominal,
    final w_a2_nominal=xAirEnt_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Coil operating at design conditions (used for model parameterization)"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={0,-30})));

  Sources.MassFlowSource_T souAirNom(
    redeclare final package Medium = MediumAir,
    final X={XAirEnt_nominal,1 - XAirEnt_nominal},
    final m_flow=mAir_flow_nominal,
    final T=TAirEnt_nominal,
    nPorts=1)
    "Source for entering air"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,-24})));
  Sources.MassFlowSource_T souLiq(
    redeclare final package Medium = MediumLiq,
    final m_flow=mLiq_flow_nominal,
    final T=TLiqEnt_nominal,
    nPorts=1)
    "Source for entering liquid"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-20,-50})));
  Sources.Boundary_pT outLiq(
    redeclare final package Medium = MediumLiq,
    nPorts=1)
    "Pressure boundary condition at liquid outlet"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={20,-50})));
  Sensors.TemperatureTwoPort TLiqEnt(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    T_start=TLiqEnt_nominal)
    "Entering liquid temperature sensor"
    annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-80,0})));
  Sensors.TemperatureTwoPort TLiqLvg(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    T_start=TLiqEnt_nominal)
    "Leaving liquid temperature sensor"
    annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={50,0})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dT
    "Compute deltaT"
    annotation (Placement(transformation(extent={{70,-80},{90,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow(
    final unit="W")
    "Total heat flow rate transferred to the load"
    annotation (Placement(
        transformation(extent={{100,-110},{140,-70}}), iconTransformation(
          extent={{100,-110},{140,-70}})));
  Modelica.Blocks.Sources.RealExpression heaFlo(
    y=coi.Q2_flow)
    "Access coil heat flow rate"
    annotation (Placement(transformation(extent={{70,-100},{90,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yLoa_actual(
    final unit="1")
    "Actual load fraction met"
    annotation (Placement(transformation(extent={{100,
            10},{140,50}}), iconTransformation(extent={{100,20},{140,60}})));
  Modelica.Blocks.Sources.RealExpression loaFra(
    y=Q_flow/(if mode == Buildings.Fluid.HydronicConfigurations.Controls.OperatingModes.heating
      then QChg_flow_nominal else coiNom.Q2_flow))
    "Compute actual load fraction"
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  Sensors.TemperatureTwoPort TAirLvgNom(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mAir_flow_nominal,
    T_start=TAirEnt_nominal)
    "Leaving air temperature sensor"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-50,-20})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub
    "Compute TAirLvg_nominal - TAirEnt_nominal"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-30,102})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro
    "Compute u * (TAirLvg_nominal - TAirEnt_nominal)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-14,60})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TAirEntVal[3](final k=
        {TAirEnt_nominal,TAirEnt_nominal,TAirEntChg_nominal})
    "Values of entering air temperature"
    annotation (Placement(transformation(extent={{-90,130},{-70,150}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor TAirEnt_actual(
    y(final unit="K", displayUnit="degC"), final nin=3)
    "Actual value of entering air temperature"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor TAirLvg_actual(
    y(final unit="K", displayUnit="degC"), final nin=3)
    "Actual value of leaving air temperature"
    annotation (Placement(transformation(extent={{40,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TAirLvgVal(
    final k=TAirLvgChg_nominal) "Values of leaving air temperature"
    annotation (Placement(transformation(extent={{90,130},{70,150}})));

  Buildings.Controls.OBC.CDL.Integers.AddParameter addPar(final p=1)
    "Convert mode index to array index" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,100})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(nout=2)
    "Replicate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,110})));
protected
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpLiq_nominal=
    MediumLiq.specificHeatCapacityCp(MediumLiq.setState_pTX(
      p=MediumLiq.p_default,
      T=TLiqEnt_nominal))
    "Liquid specific heat capacity at design conditions";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpAir_nominal=
    MediumAir.specificHeatCapacityCp(MediumAir.setState_pTX(
      p=MediumAir.p_default,
      T=TLiqEnt_nominal,
      X={XAirEnt_nominal,1 - XAirEnt_nominal}))
    "Air specific heat capacity at design conditions";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpAirChg_nominal=
    MediumAir.specificHeatCapacityCp(MediumAir.setState_pTX(
      p=MediumAir.p_default,
      T=TLiqEntChg_nominal,
      X={XAirEnt_nominal,1 - XAirEnt_nominal}))
    "Air specific heat capacity in change-over mode";
   parameter Real eps_nominal=
     Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_C(
       UA=coiNom.UA_nominal,
       C1_flow=mLiq_flow_nominal * cpLiq_nominal,
       C2_flow=mAir_flow_nominal * cpAir_nominal,
       flowRegime=Integer(Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow),
       CMin_flow_nominal=min({mLiq_flow_nominal * cpLiq_nominal, mAir_flow_nominal * cpAir_nominal}),
       CMax_flow_nominal=max({mLiq_flow_nominal * cpLiq_nominal, mAir_flow_nominal * cpAir_nominal}));

initial equation
  assert(typ<>Buildings.Fluid.HydronicConfigurations.Types.Control.None,
    "In " + getInstanceName() +
    ": The type of built-in controls cannot be None: select any other valid option.");
equation
  connect(souAir.ports[1], coi.port_a2) annotation (Line(points={{20,12},{10,12}},
                            color={0,127,255}));
  connect(outAir.ports[1],TAirLvg. port_b) annotation (Line(points={{-70,19},{
          -70,12},{-40,12}},      color={0,127,255}));
  connect(TAirLvg.port_a, coi.port_b2) annotation (Line(points={{-20,12},{-10,
          12}},               color={0,127,255}));
  connect(ctl.y, yVal)
    annotation (Line(points={{72,60},{120,60}}, color={0,0,127}));
  connect(TAirSupSet.y, ctl.u_s)
    annotation (Line(points={{36,60},{48,60}},              color={0,0,127}));
  connect(souAirNom.ports[1], coiNom.port_a2)
    annotation (Line(points={{20,-24},{10,-24}}, color={0,127,255}));
  connect(souLiq.ports[1], coiNom.port_a1) annotation (Line(points={{-20,-40},{-20,
          -36},{-10,-36}},           color={0,127,255}));
  connect(coiNom.port_b1, outLiq.ports[1]) annotation (Line(points={{10,-36},{
          20,-36},{20,-40}},       color={0,127,255}));
  connect(TAirSupSet.y, u_s) annotation (Line(points={{36,60},{40,60},{40,80},{
          94,80},{94,-30},{120,-30}},
                     color={0,0,127}));
  connect(port_a, TLiqEnt.port_a)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(TLiqEnt.port_b, coi.port_a1)
    annotation (Line(points={{-70,0},{-10,0}}, color={0,127,255}));
  connect(coi.port_b1, TLiqLvg.port_a)
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(TLiqLvg.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(dT.y, dTLiq)
    annotation (Line(points={{92,-70},{120,-70}}, color={0,0,127}));
  connect(TLiqLvg.T, dT.u1)
    annotation (Line(points={{50,-11},{50,-64},{68,-64}}, color={0,0,127}));
  connect(TLiqEnt.T, dT.u2) annotation (Line(points={{-80,-11},{-80,-80},{60,-80},
          {60,-76},{68,-76}}, color={0,0,127}));
  connect(TAirLvg.T, ctl.u_m) annotation (Line(points={{-30,23},{-30,30},{60,30},
          {60,48}}, color={0,0,127}));
  connect(TAirLvg.T, u_m) annotation (Line(points={{-30,23},{-30,30},{60,30},{
          60,-50},{120,-50}},
                           color={0,0,127}));
  connect(heaFlo.y, Q_flow)
    annotation (Line(points={{91,-90},{120,-90}}, color={0,0,127}));
  connect(yLoa_actual, loaFra.y)
    annotation (Line(points={{120,30},{91,30}}, color={0,0,127}));
  connect(coiNom.port_b2, TAirLvgNom.port_a)
    annotation (Line(points={{-10,-24},{-20,-24},{-20,-20},{-40,-20}},
                                                   color={0,127,255}));
  connect(TAirLvgNom.port_b, outAir.ports[2]) annotation (Line(points={{-60,-20},
          {-68,-20},{-68,21},{-70,21}}, color={0,127,255}));
  connect(mode, ctl.mode)
    annotation (Line(points={{-120,40},{54,40},{54,48}}, color={255,127,0}));
  connect(TAirEntVal.y, TAirEnt_actual.u)
    annotation (Line(points={{-68,140},{-62,140}}, color={0,0,127}));
  connect(pro.y, TAirSupSet.u2)
    annotation (Line(points={{-2,60},{8,60},{8,54},{12,54}},color={0,0,127}));
  connect(TAirEnt_actual.y, TAirSupSet.u1) annotation (Line(points={{-38,140},{
          6,140},{6,66},{12,66}},
                               color={0,0,127}));
  connect(sub.y, pro.u1) annotation (Line(points={{-30,90},{-30,66},{-26,66}},
                         color={0,0,127}));
  connect(u, pro.u2) annotation (Line(points={{-120,80},{-60,80},{-60,54},{-26,
          54}},
        color={0,0,127}));
  connect(TAirEnt_actual.y, souAir.T_in) annotation (Line(points={{-38,140},{6,
          140},{6,34},{50,34},{50,8},{42,8}},
                                         color={0,0,127}));
  connect(sub.u1, TAirLvg_actual.y) annotation (Line(points={{-24,114},{-24,132},
          {10,132},{10,140},{18,140}}, color={0,0,127}));
  connect(TAirEnt_actual.y, sub.u2)
    annotation (Line(points={{-38,140},{-36,140},{-36,114}}, color={0,0,127}));
  connect(addPar.y, TAirEnt_actual.index) annotation (Line(points={{-80,112},{
          -80,120},{-50,120},{-50,128}}, color={255,127,0}));
  connect(addPar.y, TAirLvg_actual.index) annotation (Line(points={{-80,112},{
          -80,120},{30,120},{30,128}}, color={255,127,0}));
  connect(mode, addPar.u)
    annotation (Line(points={{-120,40},{-80,40},{-80,88}}, color={255,127,0}));
  connect(TAirLvgNom.T, reaScaRep.u) annotation (Line(points={{-50,-9},{-50,84},
          {50,84},{50,98}}, color={0,0,127}));
  connect(reaScaRep.y, TAirLvg_actual.u[1:2])
    annotation (Line(points={{50,122},{50,140},{42,140}}, color={0,0,127}));
  connect(TAirLvgVal.y, TAirLvg_actual.u[3]) annotation (Line(points={{68,140},
          {56,140},{56,140.667},{42,140.667}}, color={0,0,127}));
  annotation (
  defaultComponentName="loa",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-70,68},{70,-72}},     lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-52,50},{52,-54}}, lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-36,-40},{36,36}},         color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{-10,92},{10,72}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(
          points={{-4,86},{4,86}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{0,78},{0,86}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{0,68},{0,72}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{40,80},{10,80}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot),
        Line(
          points={{40,90},{60,80},{40,70}},
          color={0,0,0},
          thickness=0.5),
        Rectangle(
          extent={{40,90},{80,70}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(points={{-90,0},{-70,0}},           color={0,0,0},
          thickness=0.5),
        Line(points={{70,0},{90,0}},             color={0,0,0},
          thickness=0.5),
        Line(
          points={{100,80},{80,80}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot)}),
    Documentation(info="<html>
<p>
This model represents a thermal load on a hydronic circuit,
typically a terminal unit with recirculating air such as
a fan coil unit.
It takes the fraction of the design load  <code>u</code> as input 
and returns the control valve demand signal <code>yVal</code> as output.
In steady-state conditions, the model provides zero load 
for <code>u=0</code> and the design load for <code>u=1</code>.
However, for a cooling load with condensation, the relationship between 
<code>u</code> and the load is not linear.
The main modeling assumptions are described below.
</p>
<ul>
<li>
The heat exchanger is modeled in steady-state by default
(dynamics may be reintroduced with the parameter 
<code>energyDynamics</code>).
</li>
<li>
No pressure drop is considered, neither on the load side, nor
on the source side
(the design pressure drop on the source side may be 
reset with the parameter <code>dpLiq_nominal</code>).
</li>
<li>
The mass flow rate and the inlet conditions
on the load side are constant.
The load is modulated by varying the supply temperature set point.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-120},{100,160}})));
end Load;
