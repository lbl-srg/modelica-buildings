within Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers;
model Active
  "Active rear door heat exchanger with integrated temperature controlled fan"
  extends Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.BaseClasses.PartialRearDoorHeatExchanger(
    redeclare replaceable parameter Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses.RearDoorHex dat);

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance for fan"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Conservation equations"));

  parameter Real k=1 "Gain of PI controller"
    annotation(
      Dialog(group="Fan controller"));
  parameter Modelica.Units.SI.Time Ti=10
    "Integrator time constant of PI controller"
    annotation(
      Dialog(group="Fan controller"));

  Modelica.Blocks.Interfaces.RealOutput PFan(
    final quantity="Power",
    final unit="W")
    "Power consumed by rear door heat exchanger fan"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses.Fan fan(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversalAir,
    final m_flow_nominal=dat.mAir_flow_nominal,
    final PFan_nominal=dat.PFan_nominal,
    final eta_nominal=dat.eta_nominal,
    final energyDynamics=energyDynamics) "Rear door heat exchanger fan"
    annotation (Placement(transformation(extent={{20,-70},{0,-50}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTAirOut(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=dat.mAir_flow_nominal,
    final tau=0,
    final allowFlowReversal=allowFlowReversalAir)
    "Air temperature leaving rear door heat exchanger"
    annotation (Placement(transformation(extent={{-40,-70},{-60,-50}})));

  FanControllers.BackPressure con(k=k, Ti=Ti) "Controller for fan"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Sensors.Pressure senPreIn(redeclare package Medium = MediumAir)
    "Inlet pressure"
    annotation (Placement(transformation(extent={{90,-50},{70,-30}})));
  Sensors.Pressure senPreOut(redeclare package Medium = MediumAir)
    "Outlet pressure"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
equation
  connect(fan.port_b, reaDooHex.port_a2) annotation (Line(points={{0,-60},{-10,-60},
          {-10,-14},{16,-14},{16,-6},{10,-6}}, color={0,127,255}));
  connect(senTAirOut.port_b, portAir_b)
    annotation (Line(points={{-60,-60},{-100,-60}},
                                                  color={0,127,255}));
  connect(fan.P, PFan) annotation (Line(points={{-1,-54},{-4,-54},{-4,-34},{60,-34},
          {60,0},{110,0}}, color={0,0,127}));

  connect(senTAirReaDooHexIn.port_b, fan.port_a)
    annotation (Line(points={{60,-60},{20,-60}}, color={0,127,255}));
  connect(reaDooHex.port_b2, senTAirOut.port_a) annotation (Line(points={{-10,-6},
          {-20,-6},{-20,-60},{-40,-60}}, color={0,127,255}));
  connect(senPreOut.port, portAir_b) annotation (Line(points={{-80,-50},{-80,-60},
          {-100,-60}}, color={0,127,255}));
  connect(con.pSet, senPreOut.p) annotation (Line(points={{-62,-20},{-66,-20},{-66,
          -40},{-69,-40}}, color={0,0,127}));
  connect(con.pMea, senPreIn.p)
    annotation (Line(points={{-50,-32},{-50,-40},{69,-40}}, color={0,0,127}));
  connect(senPreIn.port, senTAirReaDooHexIn.port_a)
    annotation (Line(points={{80,-50},{80,-60}}, color={0,127,255}));
  connect(con.y, fan.y) annotation (Line(points={{-38,-20},{28,-20},{28,-54},{22,
          -54}}, color={0,0,127}));
annotation (
  defaultComponentName="reaDooHex",
  Documentation(
    info="<html>
<p>
Model of an active rear door heat exchanger (RDHx) for IT racks.
</p>
<p>
In this configuration, an integrated fan drives the warm server exhaust air through
the heat exchanger mounted at the rear door of the rack.
The fan speed is modulated by a PI controller to maintain the air outlet temperature
at the set point <code>TSet</code>.
The fan power is reported through the output <code>PFan</code>.
</p>
<p>
The liquid coolant enters through <code>portCoo_a</code> and exits through
<code>portCoo_b</code>. The air enters through <code>portAir_a</code> (warm server
exhaust), passes through the fan and then through the heat exchanger, and exits through
<code>portAir_b</code> (cooled air leaving the rack).
</p>
<p>
The performance data are provided through the record <code>dat</code> of type
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses.RearDoorHex\">
Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses.RearDoorHex</a>,
which specifies the nominal IT load <code>PIT_nominal</code>, the target air temperature
rise <code>dTAir_nominal</code>, and the fan nominal power <code>PFan_nominal</code>.
</p>
</html>",
    revisions="<html>
<ul>
<li>
September 18, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-86,18},{-56,-18}},
          textColor={0,0,127},
          textString="TSet"),
        Text(
          extent={{64,18},{94,-18}},
          textColor={0,0,127},
          textString="PFan"),
        Ellipse(extent={{34,48},{54,28}}, lineColor={0,0,0}),
        Polygon(points={{54,38},{38,46},{38,30},{54,38}}, lineColor={0,0,0}),
        Polygon(points={{54,4},{38,12},{38,-4},{54,4}}, lineColor={0,0,0}),
        Ellipse(extent={{34,14},{54,-6}}, lineColor={0,0,0}),
        Polygon(points={{54,-32},{38,-24},{38,-40},{54,-32}}, lineColor={0,0,0}),
        Ellipse(extent={{34,-22},{54,-42}}, lineColor={0,0,0})}));
end Active;
