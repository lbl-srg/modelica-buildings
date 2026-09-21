within Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Examples.BaseClasses;
partial model PartialExample
  "Partial example model for a rear door heat exchanger"
  extends Modelica.Icons.Example;

  package MediumCoo = Buildings.Media.Water
    "Coolant medium";

  package MediumAir = Buildings.Media.Air
    "Air medium";

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal = -10000
  "Nominal cooling duty (negative = heat removed from air)";

  parameter Modelica.Units.SI.Temperature TAirIn_nominal = 273.15 + 40
    "Nominal air inlet temperature (warm server exhaust)";

  parameter Modelica.Units.SI.Temperature TAirOut_nominal = 273.15 + 30
    "Nominal air outlet temperature of rear door heat exchanger";

  parameter Modelica.Units.SI.Temperature TCooIn_nominal = 273.15 + 20
    "Nominal coolant inlet temperature";

  parameter Modelica.Units.SI.Temperature TCooOut_nominal = 273.15 + 30
    "Nominal coolant outlet temperature";

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal =
    Q_flow_nominal/(TAirOut_nominal-TAirIn_nominal)/cpAir_default
  "Nominal air mass flow rate";

  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal =
    -Q_flow_nominal/(TCooOut_nominal-TCooIn_nominal)/cpCoo_default
    "Nominal coolant mass flow rate";

  final parameter Modelica.Units.SI.SpecificHeatCapacity cpAir_default=
    MediumAir.specificHeatCapacityCp(
      MediumAir.setState_pTX(
        T=MediumAir.T_default,
        p=MediumAir.p_default,
        X=MediumAir.X_default[1:MediumAir.nXi]))
    "Specific heat capacity of air";

  final parameter Modelica.Units.SI.SpecificHeatCapacity cpCoo_default=
    MediumCoo.specificHeatCapacityCp(
      MediumCoo.setState_pTX(
        T=MediumCoo.T_default,
        p=MediumCoo.p_default,
        X=MediumCoo.X_default[1:MediumCoo.nXi]))
    "Specific heat capacity of the coolant fluid";

  Buildings.Fluid.Sources.Boundary_pT airSin(
    redeclare package Medium = MediumAir,
    nPorts=1)
    "Air pressure reference"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Fluid.Sources.MassFlowSource_T cooSou(
    redeclare package Medium = MediumCoo,
    nPorts=1,
    use_m_flow_in=false,
    m_flow=mCoo_flow_nominal,
    T=TCooIn_nominal)
    "Coolant source at nominal conditions"
    annotation (Placement(transformation(extent={{-82,30},{-62,50}})));

  Buildings.Fluid.Sources.Boundary_pT cooSin(
    redeclare package Medium = MediumCoo,
    nPorts=1)
    "Coolant pressure reference"
    annotation (Placement(transformation(extent={{80,30},{60,50}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTAirIn(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal)
    "Air inlet temperature sensor"
    annotation (Placement(transformation(extent={{40,-50},{20,-30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTAirOut(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal)
    "Air outlet temperature sensor"
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTCooIn(
    redeclare package Medium = MediumCoo,
    m_flow_nominal=mCoo_flow_nominal)
    "Coolant inlet temperature sensor"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTCooOut(
    redeclare package Medium = MediumCoo,
    m_flow_nominal=mCoo_flow_nominal)
    "Coolant outlet temperature sensor"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

equation
  connect(senTAirOut.port_b, airSin.ports[1])
    annotation (Line(points={{-40,-40},{-60,-40}},
                                                 color={0,127,255}));
  connect(cooSou.ports[1], senTCooIn.port_a)
    annotation (Line(points={{-62,40},{-40,40}},
                                               color={0,127,255}));
  connect(senTCooOut.port_b, cooSin.ports[1])
    annotation (Line(points={{40,40},{60,40}},
                                             color={0,127,255}));
  annotation (
    Documentation(
      info="<html>
<p>
Partial example model for a rear door heat exchanger.
This model declares the medium packages, nominal parameters,
fluid boundary conditions, temperature sensors, and their connections.
Extending models must declare the heat exchanger instance <code>hex</code>,
provide the value of <code>mAir_flow_nominal</code>,
and add the four connections involving <code>hex</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 20, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialExample;
