within Buildings.Fluid.DataCenters.Racks.Hybrid;
model AirRearDoorHexPassive
  "Air-cooled rack model with a passive rear door heat exchanger"
  extends Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.PartialAirRearDoorHex(
    redeclare final Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Passive reaDooHex);

  annotation (
  defaultComponentName="rac",
  Documentation(
    info="<html>
<p>
Model of an air-cooled IT rack
with a passive rear door heat exchanger.
</p>
<p>
This model extends
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.PartialAirRearDoorHex\">
Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.PartialAirRearDoorHex</a>
and adds a rear door heat exchanger using
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Passive\">
Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Passive</a>.
</p>
<p>
The rear door heat exchanger is connected between the air outlet of the
air-cooled rack component <code>air.port_b</code> and the top-level air outlet
port <code>portAir_b</code>.
It cools the warm rack exhaust air using a liquid coolant loop connected
through <code>portReaDooHex_a</code> (inlet) and <code>portReaDooHex_b</code> (outlet).
</p>
<p>
The medium for the rear door heat exchanger coolant is <code>MediumReaDooHex</code>.
</p>
<p>
The model has separate fluid ports for each cooling loop.
For the rear door heat exchanger coolant, <code>portReaDooHex_a</code> and <code>portReaDooHex_b</code>
serve as the inlet and outlet ports.
</p>
<p>
If the fan of the air-cooled IT is controlled based on the rack outlet temperature,
then the temperature between the rack and the rear door heat exchanger is used as
the measurement signal; otherwise, the IT load is used as an input for the fan controller
</p>
</html>",
    revisions="<html>
<ul>
<li>
September 29, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirRearDoorHexPassive;
