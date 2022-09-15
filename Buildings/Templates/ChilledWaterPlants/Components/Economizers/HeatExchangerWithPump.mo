within Buildings.Templates.ChilledWaterPlants.Components.Economizers;
model HeatExchangerWithPump "Heat exchanger with pump for CHW flow control"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialEconomizerHX(
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Economizer.HeatExchangerWithPump, hex(
        from_dp2=true));

  Buildings.Templates.Components.Sensors.Temperature TChiWatEcoEnt(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mChiWat_flow_nominal,
    final have_sen=true,
    final typ=
    Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "WSE entering CHW temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,20})));
  Buildings.Templates.Components.Pumps.Single pumChiWat(
    have_valChe=false,
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal,
    final typCtrSpe=Buildings.Templates.Components.Types.PumpSingleSpeedControl.Variable,
    final dat=datPumChiWat)
    "Heat exchanger CHW pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,50})));
  Fluid.FixedResistances.PressureDrop resChiWatByp(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=mChiWat_flow_nominal,
    from_dp=true,
    final dp_nominal=100) "Bypass flow resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  /* Control point connection - start */
  connect(bus.pumChiWatEco, pumChiWat.bus);
  connect(bus.TChiWatEcoEnt, TChiWatEcoEnt.y);
  /* Control point connection - stop */
  connect(TChiWatEcoEnt.port_b, pumChiWat.port_a)
    annotation (Line(points={{-20,30},{-20,40}},
                                               color={0,127,255}));
  connect(pumChiWat.port_b, hex.port_a2)
    annotation (Line(points={{-20,60},{-20,68},{-10,68}},
                                               color={0,127,255}));
  connect(port_a, TChiWatEcoEnt.port_a)
    annotation (Line(points={{-100,0},{-20,0},{-20,10}}, color={0,127,255}));
  connect(port_a, resChiWatByp.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(resChiWatByp.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
annotation (
 defaultComponentName="eco",
Documentation(info="<html>
No check valve by default
</html>"));
end HeatExchangerWithPump;
