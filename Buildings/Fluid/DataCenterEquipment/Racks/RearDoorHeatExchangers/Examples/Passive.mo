within Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Examples;
model Passive
  "Example model for a passive rear door heat exchanger"
  extends Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Examples.BaseClasses.PartialExample(
    mAir_flow_nominal=-Q_flow_nominal/(dTAir_nominal*Buildings.Utilities.Psychrometrics.Constants.cpAir));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal = -10000
    "Nominal cooling duty (negative = heat removed from air)";

  Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Passive hex(
    redeclare package MediumCoo = MediumCoo,
    redeclare package MediumAir = MediumAir,
    dat(
      mAir_flow_nominal=mAir_flow_nominal,
      mCoo_flow_nominal=mCoo_flow_nominal,
      Q_flow_nominal=Q_flow_nominal,
      TAirIn_nominal=TAirIn_nominal,
      TCooIn_nominal=TCooIn_nominal))
    "Passive rear door heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(senTAirIn.port_b, hex.portAir_a)
    annotation (Line(points={{-14,-40},{-10,-40},{-10,-4}}, color={0,127,255}));
  connect(hex.portAir_b, senTAirOut.port_a)
    annotation (Line(points={{10,-4},{10,-40},{14,-40}}, color={0,127,255}));
  connect(senTCooIn.port_b, hex.portCoo_a)
    annotation (Line(points={{-14,0},{-10,0}}, color={0,127,255}));
  connect(hex.portCoo_b, senTCooOut.port_a)
    annotation (Line(points={{10,0},{14,0}}, color={0,127,255}));
  annotation (
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenterEquipment/Racks/RearDoorHeatExchangers/Examples/Passive.mos"
      "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Example model for a passive rear door heat exchanger.
</p>
<p>
The model simulates a 10 kW rear door heat exchanger using water as coolant
at 18&deg;C supply temperature. The server exhaust air enters at 50&deg;C at the nominal
mass flow rate and is cooled by approximately 15 K.
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
end Passive;
