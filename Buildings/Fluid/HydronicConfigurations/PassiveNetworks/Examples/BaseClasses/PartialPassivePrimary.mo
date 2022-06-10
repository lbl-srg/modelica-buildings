within Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples.BaseClasses;
model PartialPassivePrimary
  "Partial model of passive primary network"
  extends Modelica.Icons.Example;

  package MediumLiq = Buildings.Media.Water
    "Medium model for hot water";

  parameter Boolean is_bal=false
    "Set to true for a primary balancing valve"
    annotation(Dialog(group="Configuration"), Evaluate=true);

  parameter Integer nTer = 2
    "Number of terminal units";
  parameter Modelica.Units.SI.MassFlowRate mTer_flow_nominal = 1
    "Terminal unit mass flow rate at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal(final min=0)=
    m2_flow_nominal
    "Mass flow rate in primary branch at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(final min=0)=
    nTer * mTer_flow_nominal
    "Mass flow rate in consumer circuit at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp2_nominal(displayUnit="Pa")
    "Consumer circuit pressure differential at design conditions"
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

  parameter Modelica.Units.SI.Temperature TLiqEnt_nominal=55+273.15
    "Liquid entering temperature at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TLiqLvg_nominal=TLiqEnt_nominal-8
    "Liquid leaving temperature at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TLiqSup_nominal=60+273.15
    "Liquid primary supply temperature at design conditions"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Sources.Boundary_pT ref(
    redeclare final package Medium = MediumLiq,
    final p=p_min,
    final T=TLiqSup_nominal,
    nPorts=2)
    "Pressure and temperature boundary condition"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,-120})));
  Sensors.TemperatureTwoPort TRet(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=m1_flow_nominal,
    T_start=TLiqSup_nominal)
    "Return temperature sensor"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-20,-120})));
  Sensors.TemperatureTwoPort TSup(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=m1_flow_nominal,
    T_start=TLiqSup_nominal)
    "Supply temperature sensor"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-40,-100})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract delT(y(final unit="K"))
    "Primary delta-T"
    annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mod(
    table=[0,0; 6,0; 6,1; 22,1; 22,0; 24,0],
    timeScale=3600,
    period=86400) "Operating mode (time schedule)"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Delays.DelayFirstOrder del1(
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=m1_flow_nominal,
    tau=10,
    nPorts=1)
    "Fluid transport delay"
    annotation (Placement(transformation(extent={{30,-120},{50,-140}})));


equation
  connect(TRet.port_b,ref. ports[1])
    annotation (Line(points={{-30,-120},{-80,-120},{-80,-119}},
                                                   color={0,127,255}));
  connect(TRet.T,delT. u1)
    annotation (Line(points={{-20,-131},{-20,-134},{-12,-134}},
                                                            color={0,0,127}));
  connect(TSup.T,delT. u2)
    annotation (Line(points={{-40,-111},{-40,-146},{-12,-146}},
                                                            color={0,0,127}));
  connect(del1.ports[1], TRet.port_a)
    annotation (Line(points={{40,-120},{-10,-120}}, color={0,127,255}));

  connect(ref.ports[2], TSup.port_a) annotation (Line(points={{-80,-121},{-80,-100},
          {-50,-100}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-160},{160,160}})));
end PartialPassivePrimary;
