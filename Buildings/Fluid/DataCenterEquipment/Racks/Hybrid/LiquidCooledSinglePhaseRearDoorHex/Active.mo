within Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex;
model Active
  "Hybrid rack model combining liquid-cooled and air-cooled components with an active rear door heat exchanger"
  extends Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.BaseClasses.PartialRack(
    redeclare parameter Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.Generic dat,
    redeclare final Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Active reaDooHex(
      final k=kReaDooHex,
      final Ti=TiReaDooHex));

  parameter Real kReaDooHex=1 "Gain of PI controller"
    annotation(
      Dialog(group="Rear door heat exchanger fan controller"));
  parameter Modelica.Units.SI.Time TiReaDooHex=10
    "Integrator time constant of PI controller"
    annotation(
      Dialog(group="Rear door heat exchanger fan controller"));

  Modelica.Blocks.Interfaces.RealOutput PReaDooHexFan(
    final quantity="Power",
    final unit="W")
    "Power consumed by rear door heat exchanger fan"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
      iconTransformation(extent={{100,-70},{120,-50}})));

equation

  connect(reaDooHex.PFan, PReaDooHexFan) annotation (Line(points={{41,-6},{80,-6},
          {80,20},{110,20}}, color={0,0,127}));
annotation (
  defaultComponentName="rac",
  Documentation(
    info="<html>
<p>
Model of a hybrid IT rack that combines liquid-cooled and air-cooled components
with an active rear door heat exchanger.
This model extends
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.BaseClasses.LiquidCooledSinglePhase\">
Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhase.BaseClasses.LiquidCooledSinglePhase</a>
and adds an active rear door heat exchanger using
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Active\">
Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Active</a>.
</p>
<p>
Unlike
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Passive\">
Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.LiquidCooledSinglePhaseRearDoorHex.Passive</a>,
this model includes a dedicated fan that actively drives air flow through the
heat exchanger. The fan speed is modulated by a PI controller to maintain the
air outlet temperature of the heat exchanger at the set point
<code>TSetReaDooHex</code>. The fan power is reported through the output
<code>PReaDooHexFan</code>.
</p>
<p>
The rear door heat exchanger is connected between the outlet of the fan and the
top-level air outlet port <code>portAir_b</code>.
It cools the warm rack exhaust air using a liquid coolant loop connected
through <code>portReaDooHex_a</code> (inlet) and <code>portReaDooHex_b</code> (outlet).
</p>
<p>
The medium for the rear door heat exchanger coolant is <code>MediumReaDooHex</code>,
which is separate from the liquid cooling medium <code>MediumLiq</code> used by the
cold plate components.
</p>
<p>
If the fan of the air-cooled IT is controlled based on the rack outlet temperature,
then the temperature between the rack and the rear door heat exchanger is used as
the measurement signal; otherwise, the IT load is used as an input for the fan controller.
The fan of the rear door heat exchanger is controlled to have zero back pressure.
Therefore, if the CPU fan speed increases, it will build up back pressure, and
the rear door heat exchanger then increases its speed as well.
</p>
</html>",
    revisions="<html>
<ul>
<li>
September 17, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(graphics={
        Text(
          extent={{-34,104},{-4,68}},
          textColor={0,0,127},
          textString="TSet"),
        Ellipse(
          extent={{80,16},{90,6}},
          lineColor={0,127,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{84,8},{86,-6}},
          lineColor={0,127,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{0,100},{0,74},{56,74},{56,26}}, color={0,0,127})}));
end Active;
