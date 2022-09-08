within Buildings.Templates.ChilledWaterPlants.Components.Economizers;
model EconomizerWithoutPump
  "WSE without heat exchanger pump (bypass valve modeled outside)"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Economizers.Interfaces.PartialEconomizerHX(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithValve);

  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatEcoByp(
      redeclare final package Medium = MediumChiWat) "WSE CHW bypass valve"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={0,-60})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpChiWatEco(
    redeclare final package Medium=MediumChiWat,
    final have_sen=true,
    final text_flip=true)
    "CHW differential pressure"
    annotation (Placement(transformation(extent={{10,-30},{-10,-10}})));
equation
  /* Control point connection - start */
  connect(dpChiWatEco.y, bus.dpChiWatEco);
  connect(valChiWatEcoByp.bus, bus.valChiWatEcoByp);
  /* Control point connection - stop */

  connect(port_a2, valChiWatEcoByp.port_a)
    annotation (Line(points={{100,-60},{10,-60}}, color={0,127,255}));
  connect(valChiWatEcoByp.port_b, port_b2) annotation (Line(points={{-10,-60},{-54,
          -60},{-54,-60},{-100,-60}}, color={0,127,255}));
  connect(port_a2, hex.port_a2) annotation (Line(points={{100,-60},{20,-60},{20,
          -6},{10,-6}}, color={0,127,255}));
  connect(hex.port_a2, dpChiWatEco.port_a)
    annotation (Line(points={{10,-6},{10,-20}}, color={0,127,255}));
  connect(hex.port_b2, dpChiWatEco.port_b)
    annotation (Line(points={{-10,-6},{-10,-20}}, color={0,127,255}));
end EconomizerWithoutPump;
