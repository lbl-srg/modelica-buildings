within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Examples;
model Passive
  "Example model for hybrid liquid-cooled and air-cooled rack with rear door heat exchanger"
  extends Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.Examples.LiquidCooledSinglePhase(
    redeclare replaceable Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexPassive.Generic dat(
      reaDooHex=datReaDooHex),
    redeclare replaceable Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Passive rac
    constrainedby Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.BaseClasses.PartialRack(
      redeclare package MediumReaDooHex = MediumReaDooHex));

  package MediumReaDooHex = Buildings.Media.Water
    "Water for rear door heat exchanger loop";
  parameter Modelica.Units.SI.Temperature TReaDooCooIn_nominal=273.15 + 25
    "Rear door heat exchanger coolant supply temperature";

  parameter Modelica.Units.SI.Temperature TReaDooCooOut_nominal=273.15 + 35
    "Rear door heat exchanger coolant return temperature";

  parameter Modelica.Units.SI.Temperature TAirReaDooIn_nominal=TAirDatHal + datAir.dTAir_nominal
    "Air inlet temperature (hot room air entering the rack)";

  final parameter Modelica.Units.SI.MassFlowRate mReaDoo_flow_nominal=
      PAir_nominal/((TReaDooCooOut_nominal - TReaDooCooIn_nominal)*Buildings.Utilities.Psychrometrics.Constants.cpWatLiq)
    "Nominal mass flow rate for rear door heat exchanger at design conditions";

  replaceable parameter
    Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexPassive.BaseClasses.RearDoorHex
    datReaDooHex constrainedby
    Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexPassive.BaseClasses.RearDoorHex
    (
    mAir_flow_nominal=datAir.m_flow_nominal,
    mCoo_flow_nominal=mReaDoo_flow_nominal,
    cpCoo_flow_nominal=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    Q_flow_nominal=-PAir_nominal,
    TCooIn_nominal=TReaDooCooIn_nominal,
    TAirIn_nominal=TAirReaDooIn_nominal + datAir.dTAir_nominal)
    "Rear door heat exchanger performance data"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));

  Buildings.Fluid.Sources.Boundary_pT souReaDoo(
    redeclare package Medium = MediumReaDooHex,
    T=TReaDooCooIn_nominal,
    p=MediumReaDooHex.p_default + datReaDooHex.dpCoo_nominal,
    nPorts=1) "Rear door heat exchanger coolant supply at elevated pressure"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Sources.Boundary_pT sinReaDoo(
    redeclare package Medium = MediumReaDooHex,
    p=MediumReaDooHex.p_default,
    nPorts=1) "Sink rear door heat exchanger coolant"
    annotation (Placement(transformation(extent={{182,-10},{162,10}})));

  Sensors.TemperatureTwoPort senTReaDooLvg(
    redeclare package Medium = MediumReaDooHex,
    allowFlowReversal=false,
    m_flow_nominal=mReaDoo_flow_nominal,
    tau=0) "Coolant outlet temperature from rear door heat exchanger"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(rac.portReaDooHex_a, souReaDoo.ports[1]) annotation (Line(points={{40,0},{
          -60,0}},                       color={0,127,255}));
  connect(rac.portReaDooHex_b, senTReaDooLvg.port_a)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(senTReaDooLvg.port_b, sinReaDoo.ports[1]) annotation (Line(points={{120,
          0},{142,0},{142,0},{162,0}}, color={0,127,255}));
  annotation (
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenterEquipment/Racks/Hybrid/LiquidCooledSinglePhaseRearDoorHex/Examples/Passive.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model of a hybrid IT rack with liquid-cooled, air-cooled, and rear door
heat exchanger components.
This model extends the structure of
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.Examples.LiquidCooledSinglePhase\">
Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.Examples.LiquidCooledSinglePhase</a>
by adding a rear door heat exchanger cooling loop.
</p>
<p>
The room inlet air temperature is set to <i>40</i> &deg;C (hot room).
The air-cooled rack raises the air temperature by <i>10</i> K, so the air
entering the rear door heat exchanger is at approximately <i>50</i> &deg;C.
</p>
<p>
Water at <i>25</i> &deg;C is supplied to the rear door heat exchanger.
A PI controller maintains the coolant outlet temperature at <i>35</i> &deg;C
by adjusting the position of a two-way valve on the supply side.
When the coolant outlet temperature falls below the setpoint, the controller
opens the valve further to increase the coolant flow rate until the setpoint
is reached.
</p>
<p>
The liquid cooling and pump control loops operate identically to the
base example, with a supply temperature of <i>42</i> &deg;C maintained
by a sensible cooler upstream of the variable-speed pump.
</p>
</html>", revisions="<html>
<ul>
<li>
September 13, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Passive;
