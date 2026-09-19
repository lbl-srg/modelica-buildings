within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex;
model Passive
  "Hybrid rack model combining liquid-cooled and air-cooled components with a rear door heat exchanger"
  extends Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.BaseClasses.PartialRack(
    redeclare parameter Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexPassive.Generic dat,
    redeclare final RearDoorHeatExchangers.Passive reaDooHex(
      dat=dat.reaDooHex));

  annotation (
  defaultComponentName="rac",
  Documentation(
    info="<html>
<p>
Model of a hybrid IT rack that combines liquid-cooled and air-cooled components
with a rear door heat exchanger.
</p>
<p>
This model extends
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.BaseClasses.LiquidCooledSinglePhase\">
Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.BaseClasses.LiquidCooledSinglePhase</a>
and adds a rear door heat exchanger using
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Passive\">
Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Passive</a>.
</p>
<p>
The rear door heat exchanger is connected between the air outlet of the
air-cooled rack component <code>air.port_b</code> and the top-level air outlet
port <code>portAir_b</code>.
It cools the warm rack exhaust air using a liquid coolant loop connected
through <code>portReaDooHex_a</code> (inlet) and <code>portReaDooHex_b</code> (outlet).
</p>
<p>
The medium for the rear door heat exchanger coolant is <code>MediumReaDooHex</code>,
which is separate from the liquid cooling medium <code>MediumLiq</code> used to cool the
cold plate components.
</p>
<p>
The model has separate fluid ports for each cooling loop.
For liquid cooling, <code>portLiq_a</code> and <code>portLiq_b</code> serve as the inlet and outlet ports.
For air cooling, <code>portAir_a</code> and <code>portAir_b</code> serve as the inlet and outlet ports.
For the rear door heat exchanger coolant, <code>portReaDooHex_a</code> and <code>portReaDooHex_b</code>
serve as the inlet and outlet ports.
</p>
</html>",
    revisions="<html>
<ul>
<li>
September 12, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Passive;