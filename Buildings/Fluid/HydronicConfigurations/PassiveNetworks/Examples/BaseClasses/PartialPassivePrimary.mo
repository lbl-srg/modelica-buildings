within Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples.BaseClasses;
model PartialPassivePrimary
  "Partial model of passive primary network"
  extends Modelica.Icons.Example;

  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";

  parameter Buildings.Fluid.HydronicConfigurations.Types.Control typ
    "Load type" annotation (Evaluate=true);

  parameter Integer nTer = 2
    "Number of terminal units";
  parameter Modelica.Units.SI.MassFlowRate mTer_flow_nominal = 1
    "Terminal unit mass flow rate at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(final min=0)=
    nTer * mTer_flow_nominal
    "Mass flow rate in primary circuit at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpTer_nominal(displayUnit="Pa")=
    3E4
    "Terminal unit pressure drop at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpPip_nominal(displayUnit="Pa")=
    0.5E4
    "Pipe section pressure drop at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Pressure p_min=200000
    "Circuit minimum pressure";

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

  parameter Modelica.Units.SI.Temperature TLiqSup_nominal=TLiqEnt_nominal
    "Liquid primary supply temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqSupChg_nominal=TLiqEntChg_nominal
    "Liquid primary supply temperature in change-over mode"
    annotation (Dialog(
    enable=typ == Buildings.Fluid.HydronicConfigurations.Types.Control.ChangeOver));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Conservation equations"));

  Sources.Boundary_pT ref(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    T=TLiqSup_nominal,
    nPorts=2)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,-70})));
  Sensors.TemperatureTwoPort T1Ret(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=m1_flow_nominal,
    final tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState
         then 0 else 1,
    T_start=TLiqSup_nominal) "Return temperature sensor" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-40,-80})));
  Sensors.TemperatureTwoPort T1Sup(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=m1_flow_nominal,
    final tau=if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState
         then 0 else 1,
    T_start=TLiqSup_nominal) "Supply temperature sensor" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-60,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dT1(y(final unit="K"))
    "Primary Delta-T"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-110})));
  Delays.DelayFirstOrder del1(
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=m1_flow_nominal,
    tau=10,
    nPorts=1)
    "Fluid transport delay"
    annotation (Placement(transformation(extent={{10,-80},{30,-100}})));
  FixedResistances.PressureDrop res1(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=m1_flow_nominal,
    dp_nominal=0)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  Sensors.MassFlowRate m1_flow(
    redeclare final package Medium = MediumLiq)
    "Mass flow rate in primary circuit"
    annotation (Placement(transformation(extent={{10,-70},{-10,-90}})));
equation
  connect(T1Ret.port_b, ref.ports[1]) annotation (Line(points={{-50,-80},{-80,-80},
          {-80,-69}}, color={0,127,255}));
  connect(T1Ret.T, dT1.u1)
    annotation (Line(points={{-40,-91},{-40,-98},{-44,-98}}, color={0,0,127}));
  connect(T1Sup.T, dT1.u2)
    annotation (Line(points={{-60,-71},{-60,-98},{-56,-98}}, color={0,0,127}));

  connect(ref.ports[2], T1Sup.port_a) annotation (Line(points={{-80,-71},{-80,-60},
          {-70,-60}}, color={0,127,255}));
  connect(T1Sup.port_b, res1.port_a)
    annotation (Line(points={{-50,-60},{-30,-60}}, color={0,127,255}));
  connect(m1_flow.port_b, T1Ret.port_a)
    annotation (Line(points={{-10,-80},{-30,-80}}, color={0,127,255}));
  connect(m1_flow.port_a, del1.ports[1])
    annotation (Line(points={{10,-80},{20,-80}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-140,-140},{140,140}})),
      Documentation(info="<html>
<p>
This is a partial model of a passive primary network.
That model is used to construct the various example models within
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples</a>.
It can be configured to represent either a heating or a cooling system.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPassivePrimary;
