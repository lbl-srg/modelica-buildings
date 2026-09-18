within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Examples;
model Active
  "Example model for hybrid liquid-cooled and air-cooled rack with active rear door heat exchanger"
  extends Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.Examples.LiquidCooledSinglePhase(
    redeclare replaceable Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.Generic dat(
      reaDooHex=datReaDooHex),
    redeclare replaceable Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Active rac
    constrainedby Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.BaseClasses.PartialRack(
      redeclare package MediumReaDooHex = MediumReaDooHex));

  package MediumReaDooHex = Buildings.Media.Water
    "Water for rear door heat exchanger loop";
  parameter Modelica.Units.SI.Temperature TReaDoo_a = 273.15+25
    "Rear door heat exchanger coolant supply temperature";

  parameter Modelica.Units.SI.Temperature TReaDoo_b_set = 273.15+35
    "Rear door heat exchanger coolant outlet temperature setpoint";

  parameter Modelica.Units.SI.Temperature TAirIn = 273.15+40
    "Air inlet temperature (hot room air entering the rack)";

  final parameter Modelica.Units.SI.MassFlowRate mReaDoo_flow_nominal=
    PAir/((TReaDoo_b_set - TReaDoo_a)*Buildings.Utilities.Psychrometrics.Constants.cpWatLiq)
    "Nominal mass flow rate for rear door heat exchanger at design conditions";

  replaceable parameter Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses.RearDoorHex datReaDooHex
    constrainedby Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses.RearDoorHex(
    mAir_flow_nominal=datAir.m_flow_nominal,
    mCoo_flow_nominal=mReaDoo_flow_nominal,
    cpCoo_flow_nominal=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    Q_flow_nominal=-PAir,
    TCooIn_nominal=TReaDoo_a,
    TAirIn_nominal=TAirIn + datAir.dTAir_nominal) "Rear door heat exchanger performance data"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));

  Buildings.Fluid.Sources.Boundary_pT souReaDoo(
    redeclare package Medium = MediumReaDooHex,
    T=TReaDoo_a,
    p=Buildings.Media.Water.p_default + datReaDooHex.dpCoo_nominal,
    nPorts=1)
    "Rear door heat exchanger coolant supply at elevated pressure"
    annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));

  Sources.Boundary_pT sinReaDoo(
    redeclare package Medium = MediumReaDooHex,
    p=Buildings.Media.Water.p_default,
    nPorts=1)                          "Sink rear door heat exchanger coolant"
    annotation (Placement(transformation(extent={{182,-10},{162,10}})));

  Sensors.TemperatureTwoPort senTReaDooLvg(
    redeclare package Medium = MediumReaDooHex,
    allowFlowReversal=false,
    m_flow_nominal=mReaDoo_flow_nominal,
    tau=0) "Coolant outlet temperature from rear door heat exchanger"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));


equation
  connect(sinReaDoo.ports[1], senTReaDooLvg.port_b)
    annotation (Line(points={{162,0},{120,0}}, color={0,127,255}));
  connect(senTReaDooLvg.port_a, rac.portReaDooHex_b)
    annotation (Line(points={{100,0},{60,0}}, color={0,127,255}));
  connect(souReaDoo.ports[1], rac.portReaDooHex_a) annotation (Line(points={{-60,
          -2},{-12,-2},{-12,0},{40,0}}, color={0,127,255}));
  annotation (
    experiment(
      StopTime=7200,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenterEquipment/Racks/Hybrid/LiquidCooledSinglePhaseRearDoorHex/Examples/Active.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model of a hybrid IT rack with liquid-cooled, air-cooled, and active rear door
heat exchanger components.
</p>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Examples.Passive\">
Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Examples.Passive</a>
except that the rear door heat exchanger has a built-in fan.
</p>
</html>", revisions="<html>
<ul>
<li>
September 17, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Active;
