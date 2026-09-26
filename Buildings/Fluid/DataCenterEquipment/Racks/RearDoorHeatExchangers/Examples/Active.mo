within Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Examples;
model Active
  "Example model for an active rear door heat exchanger"
  extends Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Examples.BaseClasses.PartialExample;

  parameter Modelica.Units.SI.Power PIT_nominal = 10000
    "Nominal IT load power handled by rear door heat exchanger";

  parameter Buildings.Fluid.DataCenterEquipment.Racks.Hybrid.Data.LiquidCooledSinglePhaseRearDoorHexActive.BaseClasses.RearDoorHex dat(
      mAir_flow_nominal=mAir_flow_nominal,
      mCoo_flow_nominal=mCoo_flow_nominal,
      Q_flow_nominal=-PIT_nominal,
      TAirIn_nominal=TAirIn_nominal,
      TCooIn_nominal=TCooIn_nominal,
      cpAir_nominal=cpAir_default,
      cpCoo_nominal=cpCoo_default)
    "Performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.DataCenterEquipment.Racks.RearDoorHeatExchangers.Active hex(
    redeclare package MediumCoo = MediumCoo,
    redeclare package MediumAir = MediumAir,
    dat = dat)
    "Active rear door heat exchanger"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  Sources.Boundary_pT airSou(
    redeclare package Medium = MediumAir,
    p=MediumAir.p_default + dat.dpAir_nominal,
    nPorts=1,
    T=TAirIn_nominal)
    "Air source at nominal conditions"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={82,-40})));

  FixedResistances.PressureDrop res(
    redeclare package Medium = MediumAir,
    m_flow_nominal=dat.mAir_flow_nominal,
    dp_nominal=dat.dpAir_nominal) "Resistance of upstream rack"
    annotation (Placement(transformation(extent={{64,-50},{44,-30}})));
equation
  connect(senTAirIn.port_b, hex.portAir_a)
    annotation (Line(points={{10,-40},{-4,-40},{-4,-6},{-10,-6}},
                                                            color={0,127,255}));
  connect(hex.portAir_b, senTAirOut.port_a)
    annotation (Line(points={{-30,-6},{-34,-6},{-34,-40},{-40,-40}},
                                                         color={0,127,255}));
  connect(senTCooIn.port_b, hex.portCoo_a)
    annotation (Line(points={{-40,40},{-36,40},{-36,6},{-30,6}},
                                               color={0,127,255}));
  connect(hex.portCoo_b, senTCooOut.port_a)
    annotation (Line(points={{-10,6},{-4,6},{-4,40},{10,40}},
                                             color={0,127,255}));
  connect(airSou.ports[1], res.port_a)
    annotation (Line(points={{72,-40},{64,-40}}, color={0,127,255}));
  connect(res.port_b, senTAirIn.port_a)
    annotation (Line(points={{44,-40},{30,-40}}, color={0,127,255}));
  annotation (
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/DataCenterEquipment/Racks/RearDoorHeatExchangers/Examples/Active.mos"
      "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Example model for an active rear door heat exchanger.
</p>
<p>
The model uses a constant water mass flow rate.
The air mass flow rate is determined by the fan control.
Because the IT load and the water mass flow rate are constant,
the air mass flow rate is also constant after the initial transient.
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
end Active;
