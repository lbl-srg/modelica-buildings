within Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Examples.BaseClasses;
partial model PartialExample
  "Partial example model for a rear door heat exchanger"
  extends Modelica.Icons.Example;

  package MediumCoo = Buildings.Media.Water
    "Coolant medium (water)";

  package MediumAir = Buildings.Media.Air
    "Air medium";

  parameter Modelica.Units.SI.TemperatureDifference dTAir_nominal = 15
    "Design air temperature drop across heat exchanger";

  parameter Modelica.Units.SI.Temperature TAirIn_nominal = 273.15 + 40
    "Nominal air inlet temperature (warm server exhaust)";

  parameter Modelica.Units.SI.Temperature TCooIn_nominal = 273.15 + 18
    "Nominal coolant inlet temperature";

  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal = 0.3
    "Nominal coolant mass flow rate";

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
    "Nominal air mass flow rate";

  Buildings.Fluid.Sources.MassFlowSource_T airSou(
    redeclare package Medium = MediumAir,
    nPorts=1,
    use_m_flow_in=false,
    m_flow=mAir_flow_nominal,
    T=TAirIn_nominal)
    "Air source at nominal conditions"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Fluid.Sources.Boundary_pT airSin(
    redeclare package Medium = MediumAir,
    nPorts=1)
    "Air pressure reference"
    annotation (Placement(transformation(extent={{60,-50},{40,-30}})));

  Buildings.Fluid.Sources.MassFlowSource_T cooSou(
    redeclare package Medium = MediumCoo,
    nPorts=1,
    use_m_flow_in=false,
    m_flow=mCoo_flow_nominal,
    T=TCooIn_nominal)
    "Coolant source at nominal conditions"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Fluid.Sources.Boundary_pT cooSin(
    redeclare package Medium = MediumCoo,
    nPorts=1)
    "Coolant pressure reference"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTAirIn(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal,
    tau=0)
    "Air inlet temperature sensor"
    annotation (Placement(transformation(extent={{-34,-50},{-14,-30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTAirOut(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mAir_flow_nominal,
    tau=0)
    "Air outlet temperature sensor"
    annotation (Placement(transformation(extent={{14,-50},{34,-30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTCooIn(
    redeclare package Medium = MediumCoo,
    m_flow_nominal=mCoo_flow_nominal,
    tau=0)
    "Coolant inlet temperature sensor"
    annotation (Placement(transformation(extent={{-34,-10},{-14,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTCooOut(
    redeclare package Medium = MediumCoo,
    m_flow_nominal=mCoo_flow_nominal,
    tau=0)
    "Coolant outlet temperature sensor"
    annotation (Placement(transformation(extent={{14,-10},{34,10}})));

equation
  connect(airSou.ports[1], senTAirIn.port_a)
    annotation (Line(points={{-40,-40},{-34,-40}}, color={0,127,255}));
  connect(senTAirOut.port_b, airSin.ports[1])
    annotation (Line(points={{34,-40},{40,-40}}, color={0,127,255}));
  connect(cooSou.ports[1], senTCooIn.port_a)
    annotation (Line(points={{-40,0},{-34,0}}, color={0,127,255}));
  connect(senTCooOut.port_b, cooSin.ports[1])
    annotation (Line(points={{34,0},{40,0}}, color={0,127,255}));
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
