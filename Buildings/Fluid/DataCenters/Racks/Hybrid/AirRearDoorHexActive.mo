within Buildings.Fluid.DataCenters.Racks.Hybrid;
model AirRearDoorHexActive
  "Air-cooled rack model with an active rear door heat exchanger"
  extends Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.PartialAirRearDoorHex(
    redeclare parameter Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexActive.Generic dat,
    redeclare final Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Active reaDooHex(
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
Model of an air-cooled IT rack
with an active rear door heat exchanger.
</p>
<p>
This model extends
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.PartialAirRearDoorHex\">
Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.PartialAirRearDoorHex</a>
and adds an active rear door heat exchanger using
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Active\">
Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Active</a>.
</p>
<p>
Unlike
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.Hybrid.AirRearDoorHexPassive\">
Buildings.Fluid.DataCenters.Racks.Hybrid.AirRearDoorHexPassive</a>,
this model includes a dedicated fan that actively drives air flow through the
heat exchanger. The fan speed is modulated by a PI controller to maintain
zero back pressure. The fan power is reported through the output
<code>PReaDooHexFan</code>.
</p>
<p>
The fan is part of the rear door heat exchanger model and positioned downstream
of the heat exchanger.
The rear door heat exchanger cools the warm rack exhaust air using a coolant loop connected
through <code>portReaDooHex_a</code> (inlet) and <code>portReaDooHex_b</code> (outlet).
</p>
<p>
The medium for the rear door heat exchanger coolant is <code>MediumReaDooHex</code>.
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
September 29, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(graphics={
        Text(
          extent={{24,-46},{98,-80}},
          textColor={0,0,127},
          textString="PReaDooHexFan"),
        Ellipse(extent={{48,18},{68,-2}}, lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{48,-6},{68,-26}},lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{48,-30},{68,-50}}, lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(points={{68,-16},{52,-8},{52,-24},{68,-16}},
                                                        lineColor={0,0,0}),
        Polygon(points={{68,-40},{52,-32},{52,-48},{68,-40}}, lineColor={0,0,0}),
        Polygon(points={{68,8},{52,16},{52,0},{68,8}},    lineColor={0,0,0})}));
end AirRearDoorHexActive;
