within Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Examples;
model Active
  "Example model for an active rear door heat exchanger"
  extends Modelica.Icons.Example;

  package MediumCoo = Buildings.Media.Water
    "Coolant medium (water)";

  package MediumAir = Buildings.Media.Air
    "Air medium";

  parameter Modelica.Units.SI.Power PIT_nominal = 10000
    "Nominal IT load power handled by rear door heat exchanger";

  parameter Modelica.Units.SI.TemperatureDifference dTAir_nominal = 15
    "Design air temperature drop across heat exchanger";

  parameter Modelica.Units.SI.Temperature TAirIn_nominal = 273.15 + 40
    "Nominal air inlet temperature (warm server exhaust)";

  parameter Modelica.Units.SI.Temperature TCooIn_nominal = 273.15 + 18
    "Nominal coolant inlet temperature";

  parameter Modelica.Units.SI.MassFlowRate mCoo_flow_nominal = 0.3
    "Nominal coolant mass flow rate";

  Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Active hx(
    redeclare package MediumCoo = MediumCoo,
    redeclare package MediumAir = MediumAir,
    redeclare parameter Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses.RearDoorHex dat(
      PIT_nominal=PIT_nominal,
      dTAir_nominal=dTAir_nominal,
      Q_flow_nominal=-PIT_nominal,
      mCoo_flow_nominal=mCoo_flow_nominal,
      TAirIn_nominal=TAirIn_nominal,
      TCooIn_nominal=TCooIn_nominal))
    "Active rear door heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Constant TSetSrc(
    k=TAirIn_nominal - dTAir_nominal)
    "Air outlet temperature set point"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Fluid.Sources.MassFlowSource_T airSou(
    redeclare package Medium = MediumAir,
    nPorts=1,
    use_m_flow_in=false,
    m_flow=hx.dat.mAir_flow_nominal,
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
    m_flow_nominal=hx.dat.mAir_flow_nominal,
    tau=0)
    "Air inlet temperature sensor"
    annotation (Placement(transformation(extent={{-34,-50},{-14,-30}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTAirOut(
    redeclare package Medium = MediumAir,
    m_flow_nominal=hx.dat.mAir_flow_nominal,
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
  connect(TSetSrc.y, hx.TSet)
    annotation (Line(points={{-39,40},{-20,40},{-20,4},{-10,4}}, color={0,0,127}));
  connect(airSou.ports[1], senTAirIn.port_a)
    annotation (Line(points={{-40,-40},{-34,-40}}, color={0,127,255}));
  connect(senTAirIn.port_b, hx.portAir_a)
    annotation (Line(points={{-14,-40},{-10,-40},{-10,-4}}, color={0,127,255}));
  connect(hx.portAir_b, senTAirOut.port_a)
    annotation (Line(points={{10,-4},{10,-40},{14,-40}}, color={0,127,255}));
  connect(senTAirOut.port_b, airSin.ports[1])
    annotation (Line(points={{34,-40},{40,-40}}, color={0,127,255}));
  connect(cooSou.ports[1], senTCooIn.port_a)
    annotation (Line(points={{-40,0},{-34,0}}, color={0,127,255}));
  connect(senTCooIn.port_b, hx.portCoo_a)
    annotation (Line(points={{-14,0},{-10,0}}, color={0,127,255}));
  connect(hx.portCoo_b, senTCooOut.port_a)
    annotation (Line(points={{10,0},{14,0}}, color={0,127,255}));
  connect(senTCooOut.port_b, cooSin.ports[1])
    annotation (Line(points={{34,0},{40,0}}, color={0,127,255}));

annotation (
  experiment(
    StopTime=3600,
    Tolerance=1e-06),
  __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenterEquipment/Racks/RearDoorHeatExchangers/Examples/Active.mos"
    "Simulate and plot"),
  Documentation(
    info="<html>
<p>
Example model for an active rear door heat exchanger.
</p>
<p>
The model simulates a 10 kW rear door heat exchanger using water as coolant
at 18°C supply temperature. The server exhaust air enters at 50°C.
A PI-controlled fan drives the air through the heat exchanger and maintains
the air outlet temperature at a set point of 35°C (= 50°C - 15 K).
</p>
<p>
The simulation runs for 3600 s at steady-state conditions.
</p>
</html>",
    revisions="<html>
<ul>
<li>
September 18, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Active;
