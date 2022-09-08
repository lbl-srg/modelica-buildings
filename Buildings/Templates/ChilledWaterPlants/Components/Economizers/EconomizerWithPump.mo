within Buildings.Templates.ChilledWaterPlants.Components.Economizers;
model EconomizerWithPump "WSE with heat exchanger pump"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Economizers.Interfaces.PartialEconomizerHX(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithPump);

  Buildings.Templates.Components.Sensors.Temperature TChiWatEcoEnt(
    redeclare final package Medium=MediumChiWat,
    final have_sen=true,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "WSE entering CHW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        origin={80,-60})));
equation
  /* Control point connection - start */
  connect(TChiWatEcoEnt.y, bus.TChiWatEcoEnt);
  connect(pumChiWatEco.bus, bus.pumChiWatEco);
  /* Control point connection - stop */

  connect(port_a2, TChiWatEcoEnt.port_a)
    annotation (Line(points={{100,-60},{90,-60}}, color={0,127,255}));
  connect(TChiWatEcoEnt.port_b, hex.port_a2) annotation (Line(points={{70,-60},{
          20,-60},{20,-6},{10,-6}}, color={0,127,255}));
end EconomizerWithPump;
