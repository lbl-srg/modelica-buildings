within Buildings.Templates.ChilledWaterPlants.Components.Economizers;
model HeatExchangerWithValve
  "Heat exchanger with bypass valve for CHW flow control"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Economizers.Interfaces.PartialEconomizerHX(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve, hex(
        from_dp2=true));

  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatByp(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal,
    final dat=datValChiWatByp,
    val(from_dp=true))
    "WSE CHW bypass valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpChiWatEco(
    redeclare final package Medium=MediumChiWat,
    final have_sen=true)
    "WSE CHW differential pressure"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
equation
  /* Control point connection - start */
  connect(bus.valChiWatEcoByp, valChiWatByp.bus);
  connect(bus.dpChiWatEco, dpChiWatEco.y);
  /* Control point connection - stop */

  connect(port_a, hex.port_a2)
    annotation (Line(points={{-100,0},{-20,0},{-20,68},{-10,68}},
                                                color={0,127,255}));
  connect(port_a, valChiWatByp.port_a) annotation (Line(points={{-100,0},{-10,0}},
                                color={0,127,255}));
  connect(valChiWatByp.port_b, port_b) annotation (Line(points={{10,0},{100,0}},
                           color={0,127,255}));
  connect(hex.port_a2, dpChiWatEco.port_a) annotation (Line(points={{-10,68},{-20,
          68},{-20,40},{-10,40}}, color={0,127,255}));
  connect(hex.port_b2, dpChiWatEco.port_b) annotation (Line(points={{10,68},{20,
          68},{20,40},{10,40}}, color={0,127,255}));
annotation (
 defaultComponentName="eco");
end HeatExchangerWithValve;
