within Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Examples;
model Active
  "Example model for an active rear door heat exchanger"
  extends Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Examples.BaseClasses.PartialExample;

  parameter Modelica.Units.SI.Power PIT_nominal = 10000
    "Nominal IT load power handled by rear door heat exchanger";

  Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Active hex(
    redeclare package MediumCoo = MediumCoo,
    redeclare package MediumAir = MediumAir,
    redeclare parameter Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses.RearDoorHex dat(
      mAir_flow_nominal=mAir_flow_nominal,
      mCoo_flow_nominal=mCoo_flow_nominal,
      Q_flow_nominal=-PIT_nominal,
      TAirIn_nominal=TAirIn_nominal,
      TCooIn_nominal=TCooIn_nominal))
    "Active rear door heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Sources.Boundary_pT airSou(
    redeclare package Medium = MediumAir,
    p=MediumAir.p_default + 200,
    nPorts=1,
    T=TAirIn_nominal)
    "Air source at nominal conditions"
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
equation
  connect(senTAirIn.port_b, hex.portAir_a)
    annotation (Line(points={{20,-40},{16,-40},{16,-6},{10,-6}},
                                                            color={0,127,255}));
  connect(hex.portAir_b, senTAirOut.port_a)
    annotation (Line(points={{-10,-6},{-16,-6},{-16,-40},{-20,-40}},
                                                         color={0,127,255}));
  connect(senTCooIn.port_b, hex.portCoo_a)
    annotation (Line(points={{-20,40},{-16,40},{-16,6},{-10,6}},
                                               color={0,127,255}));
  connect(hex.portCoo_b, senTCooOut.port_a)
    annotation (Line(points={{10,6},{14,6},{14,40},{20,40}},
                                             color={0,127,255}));
  connect(airSou.ports[1], senTAirIn.port_a)
    annotation (Line(points={{60,-40},{40,-40}}, color={0,127,255}));
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
at 18&deg;C supply temperature. The server exhaust air enters at 50&deg;C.
A PI-controlled fan drives the air through the heat exchanger and maintains
the air outlet temperature at a set point of 35&deg;C (= 50&deg;C - 15 K).
</p>
<p>
The simulation runs for 3600 s at steady-state conditions.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 20, 2026, by Michael Wetter:<br/>
Refactored to extend
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Examples.BaseClasses.PartialExample\">
Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Examples.BaseClasses.PartialExample</a>.
</li>
<li>
September 13, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Active;
