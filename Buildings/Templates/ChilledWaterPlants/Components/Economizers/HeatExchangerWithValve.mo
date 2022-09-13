within Buildings.Templates.ChilledWaterPlants.Components.Economizers;
model HeatExchangerWithValve
  "Heat exchanger with bypass valve for CHW flow control"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Economizers.Interfaces.PartialEconomizerHX(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve);

  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatByp(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal,
    final dat=datValChiWatByp)
    "WSE CHW bypass valve"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  /* Control point connection - start */
  connect(bus.valChiWatEcoByp, valChiWatByp.bus);
  /* Control point connection - stop */

  connect(port_a, hex.port_a2)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(port_a, valChiWatByp.port_a) annotation (Line(points={{-100,0},{-20,0},
          {-20,-40},{-10,-40}}, color={0,127,255}));
  connect(valChiWatByp.port_b, port_b) annotation (Line(points={{10,-40},{20,-40},
          {20,0},{100,0}}, color={0,127,255}));
end HeatExchangerWithValve;
