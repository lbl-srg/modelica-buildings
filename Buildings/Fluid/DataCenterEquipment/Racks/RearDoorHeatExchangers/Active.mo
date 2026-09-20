within Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers;
model Active
  "Active rear door heat exchanger with integrated temperature controlled fan"
  extends Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.BaseClasses.PartialRearDoorHeatExchanger(
    redeclare parameter Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses.RearDoorHex dat);

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance for fan"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Conservation equations"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Set point for air temperature leaving rear door heat exchanger"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,70},{-100,110}})));

  Modelica.Blocks.Interfaces.RealOutput PFan(
    final quantity="Power",
    final unit="W")
    "Power consumed by rear door heat exchanger fan"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
      iconTransformation(extent={{100,80},{120,100}})));

  Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses.ControlledFan fan(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=dat.mAir_flow_nominal,
    final PFan_nominal=dat.PFan_nominal,
    final eta_nominal=dat.eta_nominal,
    energyDynamics=energyDynamics)
    "Rear door heat exchanger fan"
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTAirOut(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=dat.mAir_flow_nominal,
    final tau=0,
    allowFlowReversal=false)
    "Air temperature leaving rear door heat exchanger"
    annotation (Placement(transformation(extent={{-40,-70},{-60,-50}})));

equation
  connect(fan.port_b, reaDooHex.port_a2)
    annotation (Line(points={{30,-60},{16,-60},{16,-6},{10,-6}},       color={0,127,255}));
  connect(reaDooHex.port_b2, senTAirOut.port_a)
    annotation (Line(points={{-10,-6},{-20,-6},{-20,-60},{-40,-60}},
                                                                   color={0,127,255}));
  connect(senTAirOut.port_b, portAir_b)
    annotation (Line(points={{-60,-60},{-100,-60}},
                                                  color={0,127,255}));
  connect(senTAirOut.T, fan.TMea)
    annotation (Line(points={{-50,-49},{-50,-40},{56,-40},{56,-56},{52,-56}},  color={0,0,127}));
  connect(TSet, fan.TSet)
    annotation (Line(points={{-120,80},{-30,80},{-30,-20},{58,-20},{58,-52},{52,
          -52}},                                                      color={0,0,127}));
  connect(fan.P, PFan)
    annotation (Line(points={{29,-54},{26,-54},{26,40},{110,40}},  color={0,0,127}));

  connect(senTAirReaDooHexIn.port_b, fan.port_a)
    annotation (Line(points={{60,-60},{50,-60}}, color={0,127,255}));
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
          extent={{-90,108},{-60,72}},
          textColor={0,0,127},
          textString="TSet"),
        Text(
          extent={{60,108},{90,72}},
          textColor={0,0,127},
          textString="PFan")}));
end Active;
