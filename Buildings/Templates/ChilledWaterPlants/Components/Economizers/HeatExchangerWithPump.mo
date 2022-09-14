within Buildings.Templates.ChilledWaterPlants.Components.Economizers;
model HeatExchangerWithPump "Heat exchanger with pump for CHW flow control"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Economizers.Interfaces.PartialEconomizerHX(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithPump);

  Buildings.Templates.Components.Sensors.Temperature TChiWatEcoEnt(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mChiWat_flow_nominal,
    final have_sen=true,
    final typ=
    Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "WSE entering CHW temperature"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Templates.Components.Pumps.Single pumChiWat(
    have_valChe=false,
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpSingleSpeedControl.Variable,
    final dat=datPumChiWat)
    "Heat exchanger CHW pump"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  /* Control point connection - start */
  connect(bus.pumChiWatEco, pumChiWat.bus);
  connect(bus.TChiWatEcoEnt, TChiWatEcoEnt.y);
  /* Control point connection - stop */
  connect(port_a, TChiWatEcoEnt.port_a)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(TChiWatEcoEnt.port_b, pumChiWat.port_a)
    annotation (Line(points={{-70,0},{-50,0}}, color={0,127,255}));
  connect(pumChiWat.port_b, hex.port_a2)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  annotation (Documentation(info="<html>
No check valve by default
</html>"));
end HeatExchangerWithPump;
