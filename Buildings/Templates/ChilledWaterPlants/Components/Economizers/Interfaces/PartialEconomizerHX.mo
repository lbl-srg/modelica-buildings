within Buildings.Templates.ChilledWaterPlants.Components.Economizers.Interfaces;
model PartialEconomizerHX "Partial model of WSE with plate heat exchanger"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Economizers.Interfaces.PartialEconomizer(
     final typ=Buildings.Templates.ChilledWaterPlants.Types.EconomizerFlowControl.WatersideEconomizer);

  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare final package Medium1 = MediumConWat,
    redeclare final package Medium2 = MediumChiWat,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final use_Q_flow_nominal=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final dp1_nominal=dat.dpConWatHex_nominal,
    final dp2_nominal=dat.dpChiWatHex_nominal,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final Q_flow_nominal=dat.QHex_flow_nominal,
    final T_a1_nominal=dat.T_ConWatHexEnt_nominal,
    final T_a2_nominal=dat.T_ChiWatHexEnt_nominal)
    "Heat exchanger"
    annotation (Placement(
        transformation(extent={{10,10},{-10,-10}}, rotation=180)));

  // If bypass valve

  // If heat exchanger pump

  // Condenser water side

equation
  /* Control point connection - start */
  /* Control point connection - stop */

  connect(port_a1, hex.port_a1)
    annotation (Line(points={{-100,60},{-20,60},{-20,6},{-10,6}},
      color={0,127,255}));

  connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{20,6},{20,60},
          {100,60}}, color={0,127,255}));
  connect(hex.port_b2, port_b2) annotation (Line(points={{-10,-6},{-20,-6},{-20,
          -60},{-100,-60}}, color={0,127,255}));
end PartialEconomizerHX;
