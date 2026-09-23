within Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers;
model Passive
  "Passive rear door heat exchanger — air driven by fans in server"
  extends Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.BaseClasses.PartialRearDoorHeatExchanger;

equation
  connect(reaDooHex.port_b2, portAir_b)
    annotation (Line(points={{-10,-6},{-20,-6},{-20,-60},{-100,-60}},
                                                                    color={0,127,255}));

  connect(senTAirReaDooHexIn.port_b, reaDooHex.port_a2) annotation (Line(points={{40,-60},
          {20,-60},{20,-6},{10,-6}},          color={0,127,255}));
annotation (
  defaultComponentName="reaDooHex",
  Documentation(
    info="<html>
<p>
Model of a passive rear door heat exchanger (RDHx) for IT racks.
</p>
<p>
In this configuration, the server fans inside the rack drive the warm exhaust air
through the heat exchanger mounted at the rear door.
No dedicated fan is added; the air-side pressure drop is overcome by the server fans.
</p>
<p>
The liquid coolant enters through <code>portCoo_a</code> and exits through
<code>portCoo_b</code>. The air enters through <code>portAir_a</code> (warm server
exhaust) and exits through <code>portAir_b</code> (cooled air leaving the rack).
</p>
<p>
The performance data are provided through the record <code>dat</code> of type
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexPassive.BaseClasses.RearDoorHex\">
Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexPassive.BaseClasses.RearDoorHex</a>.
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
end Passive;
