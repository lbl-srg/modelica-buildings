within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase;
model LiquidCooledSinglePhase
  "Hybrid rack model combining liquid-cooled and air-cooled components"
  extends Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.BaseClasses.LiquidCooledSinglePhase;

equation
  connect(air.port_b, portAir_b)
    annotation (Line(points={{10,-40},{102,-40}}, color={0,127,255}));
annotation (
  Documentation(
    info="<html>
<p>
Model of a hybrid IT rack that combines liquid-cooled and air-cooled components.
This model integrates two separate cooling technologies in a single rack.
The liquid cooling component uses cold plates and is based on
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase.ColdPlateR_P\">
Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase.ColdPlateR_P</a>,
while the air cooling component with integrated fans is based on
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.AirCooled.Rack_u\">
Buildings.Fluid.DataCenterEquipment.Racks.AirCooled.Rack_u</a>.
</p>
<p>
The model has separate fluid ports for each cooling loop.
For liquid cooling, <code>portLiq_a</code> and <code>portLiq_b</code> serve as the inlet and outlet ports.
For air cooling, <code>portAir_a</code> and <code>portAir_b</code> serve as the inlet and outlet ports.
Each cooling system has its own input for the electrical power consumption by the IT equipment.
The input <code>PLiq</code> specifies the power consumption for the liquid-cooled IT equipment,
and the input <code>PAir</code> specifies the power consumption for the air-cooled IT equipment.
Note that <code>PAir</code> does not include the power to operate the fan, as this is an output of the model.
</p>
<p>
The model provides three power consumption outputs on the right side.
The output <code>PLiqTot</code> is the electric power consumed by liquid-cooled IT.
The output <code>PAirTot</code> is the total electric power consumed by air-cooled IT, including fan energy.
The output <code>PAirFan</code> is the electric power consumed by the fan for air-cooled IT.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 14, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LiquidCooledSinglePhase;
