within Buildings.Fluid.HydronicConfigurations.Examples.BaseClasses;
model Load "Model of a load on hydronic circuit"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal);

  replaceable package MediumAir = Buildings.Media.Air
    "Medium model for air";
  replaceable package MediumLiq = Buildings.Media.Water
    "Medium model for liquid (CHW or HHW)";
  parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal = 1
    "Liquid mass flow rate at design conditions";

  parameter Modelica.Units.SI.PressureDifference dpLiq_nominal=0
    "Liquid pressure drop at design conditions"
    annotation(Evaluate=true);

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=
    Q_flow_nominal / 10 / 1015
    "Air mass flow rate at design conditions";
  parameter Modelica.Units.SI.Temperature TAirEnt_nominal=293.15
    "Air entering temperature at design conditions";
  final parameter Modelica.Units.SI.Temperature TAirLvg_nominal(
    fixed=false,
    start=TAirEnt_nominal+Q_flow_nominal/mAir_flow_nominal/1015)
    "Air leaving temperature at design conditions";
  parameter Modelica.Units.SI.MassFraction phiAirEnt_nominal = 0.5
    "Air entering relative humidity at design conditions";
  final parameter Modelica.Units.SI.MassFraction XAirEnt_nominal=
    Buildings.Utilities.Psychrometrics.Functions.X_pTphi(
      MediumAir.p_default, TAirEnt_nominal, phiAirEnt_nominal)
    "Air entering water mass fraction at design conditions (kg/kg air)";
  final parameter Modelica.Units.SI.MassFraction xAirEnt_nominal=
    XAirEnt_nominal / (1 - XAirEnt_nominal)
    "Air entering humidity ratio at design conditions (kg/kg dry air)";
  parameter Modelica.Units.SI.Temperature TLiqEnt_nominal=333.15
    "Hot water entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqLvg_nominal=323.15
    "Hot water leaving temperature at design conditions";

  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=
    (TLiqEnt_nominal - TLiqLvg_nominal) * mLiq_flow_nominal * 4186
    "Coil capacity at design conditions"
    annotation(Evaluate=true);

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

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));


  .Buildings.Controls.OBC.CDL.Interfaces.RealInput u "Load modulating signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  .Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(final unit="1")
    "Valve demand signal" annotation (Placement(transformation(extent={{100,40},
            {140,80}}), iconTransformation(extent={{100,40},{140,80}})));
  .Buildings.Controls.OBC.CDL.Interfaces.RealOutput u_s(final unit="K",
      displayUnit="degC") "Controller set point" annotation (Placement(
        transformation(extent={{100,-50},{140,-10}}), iconTransformation(extent=
           {{100,-50},{140,-10}})));
  .Buildings.Controls.OBC.CDL.Interfaces.RealOutput u_m(final unit="K",
      displayUnit="degC") "Controller measured value" annotation (Placement(
        transformation(extent={{100,-70},{140,-30}}), iconTransformation(extent=
           {{100,-70},{140,-30}})));
  .Buildings.Controls.OBC.CDL.Interfaces.RealOutput dTLiq(final unit="K",
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
        origin={-80,40})));
  Sensors.TemperatureTwoPort TAirSup(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mAir_flow_nominal,
    T_start=TAirEnt_nominal) "Supply air temperature sensor" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,20})));
  HeatExchangers.WetCoilEffectivenessNTU coi(
    redeclare final package Medium1 = MediumLiq,
    redeclare final package Medium2 = MediumAir,
    final energyDynamics=energyDynamics,
    final m1_flow_nominal=mLiq_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=dpLiq_nominal,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    use_Q_flow_nominal=true,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=TLiqEnt_nominal,
    final T_a2_nominal=TAirEnt_nominal,
    w_a2_nominal=xAirEnt_nominal) "Coil"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={0,6})));
  Sources.MassFlowSource_T souAir(
    redeclare final package Medium = MediumAir,
    X={XAirEnt_nominal,1 - XAirEnt_nominal},
    final m_flow=mAir_flow_nominal,
    T=TAirEnt_nominal,
    nPorts=1) "Source for entering air"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,20})));
  .Buildings.Controls.OBC.CDL.Continuous.PID ctl(
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC"),
    final controllerType=controllerType,
    final k=k,
    final Ti=120,
    final reverseActing=Q_flow_nominal > 0)
    "Controller for supply air temperature"
    annotation (Placement(transformation(extent={{10,50},{30,70}})));

  .Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(k=
    TAirLvg_nominal - TAirEnt_nominal)
    "Scale load signal"
    annotation (Placement(transformation(extent={{-68,70},{-48,90}})));
  .Buildings.Controls.OBC.CDL.Continuous.AddParameter set(p=TAirEnt_nominal)
    "Compute set point"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  HeatExchangers.WetCoilEffectivenessNTU coiNom(
    redeclare final package Medium1 = MediumLiq,
    redeclare final package Medium2 = MediumAir,
    final m1_flow_nominal=mLiq_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    use_Q_flow_nominal=true,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=TLiqEnt_nominal,
    final T_a2_nominal=TAirEnt_nominal,
    w_a2_nominal=xAirEnt_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Coil operating at design conditions (used for model parameterization)"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={0,-30})));

  Sources.MassFlowSource_T souAirNom(
    redeclare final package Medium = MediumAir,
    X={XAirEnt_nominal,1 - XAirEnt_nominal},
    final m_flow=mAir_flow_nominal,
    T=TAirEnt_nominal,
    nPorts=1) "Source for entering air" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,-20})));
  Sources.MassFlowSource_T souLiq(
    redeclare final package Medium = MediumLiq,
    final m_flow=mLiq_flow_nominal,
    T=TLiqEnt_nominal,
    nPorts=1) "Source for entering liquid" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-40,-60})));
  Sources.Boundary_pT outLiq(
    redeclare final package Medium = MediumLiq,
    nPorts=1) "Pressure boundary condition at liquid outlet"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,-60})));

  Sensors.TemperatureTwoPort TLiqEnt(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    T_start=TLiqEnt_nominal) "Entering liquid temperature sensor" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-80,0})));
  Sensors.TemperatureTwoPort TLiqLvg(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    T_start=TLiqEnt_nominal) "Leaving liquid temperature sensor" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={60,0})));
  .Buildings.Controls.OBC.CDL.Continuous.Subtract dT "Compute deltaT"
    annotation (Placement(transformation(extent={{70,-80},{90,-60}})));
  .Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow(final unit="W")
    "Total heat flow rate transferred to the load" annotation (Placement(
        transformation(extent={{100,-110},{140,-70}}), iconTransformation(
          extent={{100,-110},{140,-70}})));
  Modelica.Blocks.Sources.RealExpression heaFlo(y=coi.Q2_flow)
    "Access coil heat flow rate"
    annotation (Placement(transformation(extent={{70,-100},{90,-80}})));
protected
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpAir_nominal=
    MediumAir.specificHeatCapacityCp(MediumAir.setState_pTX(
    p=MediumAir.p_default,
    T=TAirEnt_nominal,
    X={XAirEnt_nominal,1 - XAirEnt_nominal}))
    "Air specific heat capacity at design conditions";
initial equation
  TAirLvg_nominal = TAirEnt_nominal + coiNom.QSen2_flow / mAir_flow_nominal / cpAir_nominal;
equation
  connect(souAir.ports[1], coi.port_a2) annotation (Line(points={{30,20},{20,20},
          {20,12},{10,12}}, color={0,127,255}));
  connect(outAir.ports[1], TAirSup.port_b) annotation (Line(points={{-70,39},{-60,
          39},{-60,20},{-50,20}}, color={0,127,255}));
  connect(TAirSup.port_a, coi.port_b2) annotation (Line(points={{-30,20},{-20,20},
          {-20,12},{-10,12}}, color={0,127,255}));
  connect(ctl.y, y)
    annotation (Line(points={{32,60},{120,60}},  color={0,0,127}));
  connect(gai.y, set.u)
    annotation (Line(points={{-46,80},{-32,80}}, color={0,0,127}));
  connect(u, gai.u)
    annotation (Line(points={{-120,60},{-80,60},{-80,80},{-70,80}},
                                                  color={0,0,127}));
  connect(set.y, ctl.u_s)
    annotation (Line(points={{-8,80},{0,80},{0,60},{8,60}},
                                              color={0,0,127}));
  connect(souAirNom.ports[1], coiNom.port_a2)
    annotation (Line(points={{30,-20},{20,-20},{20,-24},{10,-24}},
                                                 color={0,127,255}));
  connect(souLiq.ports[1], coiNom.port_a1) annotation (Line(points={{-30,-60},{-20,
          -60},{-20,-36},{-10,-36}}, color={0,127,255}));
  connect(coiNom.port_b1, outLiq.ports[1]) annotation (Line(points={{10,-36},{20,
          -36},{20,-60},{30,-60}}, color={0,127,255}));
  connect(coiNom.port_b2, outAir.ports[2]) annotation (Line(points={{-10,-24},{-20,
          -24},{-20,-20},{-60,-20},{-60,40},{-70,40},{-70,41}},
                          color={0,127,255}));
  connect(set.y, u_s) annotation (Line(points={{-8,80},{80,80},{80,-30},{120,-30}},
                           color={0,0,127}));
  connect(port_a, TLiqEnt.port_a)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(TLiqEnt.port_b, coi.port_a1)
    annotation (Line(points={{-70,0},{-10,0}}, color={0,127,255}));
  connect(coi.port_b1, TLiqLvg.port_a)
    annotation (Line(points={{10,0},{50,0}}, color={0,127,255}));
  connect(TLiqLvg.port_b, port_b)
    annotation (Line(points={{70,0},{100,0}}, color={0,127,255}));
  connect(dT.y, dTLiq)
    annotation (Line(points={{92,-70},{120,-70}}, color={0,0,127}));
  connect(TLiqLvg.T, dT.u1)
    annotation (Line(points={{60,-11},{60,-64},{68,-64}}, color={0,0,127}));
  connect(TLiqEnt.T, dT.u2) annotation (Line(points={{-80,-11},{-80,-80},{60,-80},
          {60,-76},{68,-76}}, color={0,0,127}));
  connect(TAirSup.T, ctl.u_m) annotation (Line(points={{-40,31},{-40,40},{20,40},
          {20,48}}, color={0,0,127}));
  connect(TAirSup.T, u_m) annotation (Line(points={{-40,31},{-40,40},{76,40},{76,
          -50},{120,-50}}, color={0,0,127}));
  connect(heaFlo.y, Q_flow)
    annotation (Line(points={{91,-90},{120,-90}}, color={0,0,127}));
  annotation (
  defaultComponentName="loa",
  Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-90,90},{90,-90}},     lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-70,70},{70,-70}}, lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-49.5,-49.5},{49.5,49.5}}, color={0,0,0},
          thickness=0.5)}),
    Documentation(info="<html>
<ul>
<li>
Heat exchanger modeled in steady-state by default
(dynamics may be reintroduced with the parameter 
<code>energyDynamics</code>)
</li>
<li>
Zero pressure drop on load side and source side
</li>
<li>
Constant flow rate on load side
</li>
<li>
Constant load side inlet conditions: load modulated by set point variation.
In steady-state conditions, the model provides zero load for <code>u = 0</code>
and the design load for <code>u = 1</code>.
However, for a cooling load with condensation, the relationship between 
<code>u</code> and the load is not linear.
</li>
</ul>
</html>"));
end Load;
