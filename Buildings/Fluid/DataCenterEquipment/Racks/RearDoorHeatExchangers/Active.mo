within Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers;
model Active
  "Active rear door heat exchanger with integrated temperature controlled fan"
  extends Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.BaseClasses.PartialRearDoorHeatExchanger(
    redeclare replaceable parameter Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses.RearDoorHex dat
    constrainedby Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses.RearDoorHex);

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
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final allowFlowReversal=allowFlowReversalAir,
    final m_flow_nominal=dat.mAir_flow_nominal,
    final PFan_nominal=dat.PFan_nominal,
    final eta_nominal=dat.eta_nominal,
    final energyDynamics=energyDynamics,
    addPowerToMedium=true) "Rear door heat exchanger fan"
    annotation (Placement(transformation(extent={{0,-70},{-20,-50}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTAirOut(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=dat.mAir_flow_nominal,
    final tau=0,
    final allowFlowReversal=allowFlowReversalAir)
    "Air temperature leaving rear door heat exchanger"
    annotation (Placement(transformation(extent={{-40,-70},{-60,-50}})));

  Buildings.Fluid.DataCenterEquipment.Racks.FanControllers.BackPressure con(
    final k=k,
    final Ti=Ti) "Controller for fan"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Sensors.Pressure senPreIn(redeclare package Medium = MediumAir)
    "Inlet pressure"
    annotation (Placement(transformation(extent={{90,-46},{70,-26}})));
  Sensors.Pressure senPreOut(redeclare package Medium = MediumAir)
    "Outlet pressure"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Sensors.TemperatureTwoPort senTAirReaDooHexOut(
    redeclare package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversalAir,
    m_flow_nominal=dat.mAir_flow_nominal)
    "Air temperature exiting rear door heat exchanger"  annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-50,40})));
equation
  connect(senTAirOut.port_b, portAir_b)
    annotation (Line(points={{-60,-60},{-100,-60}},
                                                  color={0,127,255}));
  connect(fan.P, PFan) annotation (Line(points={{-21,-51},{-30,-51},{-30,-40},{60,
          -40},{60,0},{110,0}},
                           color={0,0,127}));

  connect(senPreOut.port, portAir_b) annotation (Line(points={{-80,-30},{-80,
          -60},{-100,-60}},
                       color={0,127,255}));
  connect(con.pSet, senPreOut.p) annotation (Line(points={{-42,-20},{-69,-20}},
                           color={0,0,127}));
  connect(con.pMea, senPreIn.p)
    annotation (Line(points={{-30,-32},{-30,-36},{69,-36}}, color={0,0,127}));
  connect(senPreIn.port, senTAirReaDooHexIn.port_a)
    annotation (Line(points={{80,-46},{80,-60},{60,-60}},
                                                 color={0,127,255}));
  connect(con.y, fan.y) annotation (Line(points={{-18,-20},{-10,-20},{-10,-48}},
                 color={0,0,127}));
  connect(senTAirReaDooHexIn.port_b, reaDooHex.port_a2) annotation (Line(points={{40,-60},
          {30,-60},{30,48},{10,48}},          color={0,127,255}));
  connect(fan.port_b, senTAirOut.port_a)
    annotation (Line(points={{-20,-60},{-40,-60}}, color={0,127,255}));
  connect(reaDooHex.port_b2, senTAirReaDooHexOut.port_a) annotation (Line(
        points={{-10,48},{-20,48},{-20,40},{-40,40}}, color={0,127,255}));
  connect(senTAirReaDooHexOut.port_b, fan.port_a) annotation (Line(points={{-60,
          40},{-72,40},{-72,20},{10,20},{10,-60},{0,-60}}, color={0,127,255}));
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
The fan speed is modulated by a PI controller to maintain zero back pressure.
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
Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses.RearDoorHex</a>.
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
