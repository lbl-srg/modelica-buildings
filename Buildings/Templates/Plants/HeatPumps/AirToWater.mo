within Buildings.Templates.Plants.HeatPumps;
model AirToWater
  "Air-to-water heat pump plant"
  extends Buildings.Templates.Plants.HeatPumps.Interfaces.PartialHeatPumpPlant(
    redeclare final package MediumSou=MediumAir,
    cfg(
      final typMod=hp.typMod));
  Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups.AirToWater hp(
    redeclare final package MediumHeaWat=MediumHeaWat,
    redeclare final package MediumAir=MediumAir,
    final nHp=nHp,
    final is_rev=is_rev,
    final have_preDroChiHeaWat=false,
    final have_preDroSou=false,
    final dat=dat.hp,
    final allowFlowReversal=allowFlowReversal,
    final allowFlowReversalSou=false)
    "Heat pump group"
    annotation (Placement(transformation(extent={{-160,-200},{40,-120}})));
  Components.ValvesIsolation valIso
    annotation (Placement(transformation(extent={{-160,-28},{40,52}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri
    "Headered primary CHW pumps"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatPri
    "Primary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
  Components.PumpsPrimaryDedicated pumPri
    annotation (Placement(transformation(extent={{-160,-114},{40,-34}})));
equation
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{100,40},{120,40}},color={0,127,255}));
  connect(inlPumChiWatPri.ports_b, pumChiWatPri.ports_a)
    annotation (Line(points={{80,40},{80,40}},  color={0,127,255}));
  connect(valIso.port_bChiWat, inlPumChiWatPri.port_a)
    annotation (Line(points={{40,40},{60,40}},color={0,127,255}));
  connect(outPumChiWatPri.port_b, port_bChiWat)
    annotation (Line(points={{140,40},{300,40}},color={0,127,255}));
  connect(port_aChiWat, valIso.port_aChiWat)
    annotation (Line(points={{300,0},{60,0},{60,24},{40,24}},color={0,127,255}));
  connect(valIso.ports_bChiHeaWatHp, pumPri.ports_aChiHeaWat)
    annotation (Line(points={{-10,-28},{-10,-34}},
                                                color={0,127,255}));
  connect(pumPri.ports_bChiHeaWatHp, hp.ports_aChiHeaWat)
    annotation (Line(points={{-10,-114},{-10,-120}},
                                                  color={0,127,255}));
  connect(hp.ports_bChiHeaWat, pumPri.ports_aChiHeaWatHp)
    annotation (Line(points={{-110,-120},{-110,-114}},
                                                    color={0,127,255}));
  connect(pumPri.ports_bChiHeaWat, valIso.ports_aChiHeaWatHp)
    annotation (Line(points={{-110,-34},{-110,-28}},
                                                  color={0,127,255}));
  connect(pumPri.ports_bHeaWat, valIso.ports_aHeaWatHp)
    annotation (Line(points={{-126,-34},{-126,-28}}, color={0,127,255}));
  connect(pumPri.ports_bChiWat, valIso.ports_aChiWatHp)
    annotation (Line(points={{-94,-34},{-94,-28.2}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
Heat pump CHW and HW pressure drops are computed within the component <code>valIso</code>
for best computational efficiency.
</p>
</html>"));
end AirToWater;
