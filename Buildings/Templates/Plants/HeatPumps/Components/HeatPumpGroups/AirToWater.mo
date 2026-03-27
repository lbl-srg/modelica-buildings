within Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups;
model AirToWater
  "Air-to-water heat pump group"
  extends Buildings.Templates.Plants.HeatPumps.Components.Interfaces.PartialHeatPumpGroup(
    redeclare final package MediumSou=MediumAir,
    final typHp=Buildings.Templates.Components.Types.HeatPump.AirToWater);
  Buildings.Templates.Components.HeatPumps.AirToWater hp[nHp](
    each final show_T=show_T,
    redeclare each final package MediumHeaWat=MediumHeaWat,
    redeclare each final package MediumChiWat=MediumChiWat,
    redeclare each final package MediumAir=MediumAir,
    each final typMod=if is_rev
      then Buildings.Templates.Components.Types.HeatPumpCapability.Reversible
      else Buildings.Templates.Components.Types.HeatPumpCapability.HeatingOnly,
    final dat=datHp,
    each final allowFlowReversal=allowFlowReversal,
    each final energyDynamics=energyDynamics,
    each final have_dpChiHeaWat=have_dpChiHeaWat,
    each final have_dpSou=have_dpSou)
    if have_hp
    "Heat pumps"
    annotation(Placement(transformation(extent={{10,-50},{-10,-30}})));
  Buildings.Templates.Components.HeatPumps.AirToWater shc[nShc](
    each final show_T=show_T,
    redeclare each final package MediumHeaWat=MediumHeaWat,
    redeclare each final package MediumChiWat=MediumChiWat,
    redeclare each final package MediumAir=MediumAir,
    each final typMod=Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent,
    final dat=datShc,
    each final allowFlowReversal=allowFlowReversal,
    each final energyDynamics=energyDynamics,
    each final have_dpChiHeaWat=have_dpChiHeaWat,
    each final have_dpSou=have_dpSou)
    if have_shc
    "SHC units"
    annotation(Placement(transformation(extent={{-30,-10},{-50,10}})));
equation
  for i in 1:nHp loop
    connect(busWea, hp[i].busWea)
      annotation(Line(points={{20,200},{20,-30},{6,-30}},
        color={255,204,51},
        thickness=0.5));
    connect(ports_aSou[i], hp[i].port_aSou)
      annotation(Line(points={{-160,-200},{-160,-50},{-10,-50}},
        color={0,127,255}));
    connect(ports_bSou[i], hp[i].port_bSou)
      annotation(Line(points={{160,-200},{160,-50},{10,-50}},
        color={0,127,255}));
  end for;
  for i in 1:nShc loop
    connect(busWea, shc[i].busWea)
      annotation(Line(points={{20,200},{20,10},{-34,10}},
        color={255,204,51},
        thickness=0.5));
    connect(ports_aSou[nHp + i], shc[i].port_aSou)
      annotation(Line(points={{-160,-200},{-160,-10},{-50,-10}},
        color={0,127,255}));
    connect(ports_bSou[nHp + i], shc[i].port_bSou)
      annotation(Line(points={{160,-200},{160,-10},{-30,-10}},
        color={0,127,255}));
  end for;
  connect(ports_aHeaWatShc, shc.port_a)
    annotation(Line(points={{120,200},{120,0},{-30,0}},
      color={0,127,255}));
  connect(ports_bChiWatShc, shc.port_bChiWat)
    annotation(Line(points={{-60,200},{-60,30},{-30,30},{-30,10}},
      color={0,127,255}));
  connect(ports_aChiWatShc, shc.port_aChiWat)
    annotation(Line(points={{60,200},{60,20},{-60,20},{-60,10},{-50,10}},
      color={0,127,255}));
  connect(busShc, shc.bus)
    annotation(Line(points={{-40,160},{-40,10}},
      color={255,204,51},
      thickness=0.5));
  connect(busHp, hp.bus)
    annotation(Line(points={{0,160},{0,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(ports_aChiHeaWatHp, hp.port_a)
    annotation(Line(points={{180,200},{180,-40},{10,-40}},
      color={0,127,255}));
  connect(hp.port_b, ports_bChiHeaWatHp)
    annotation(Line(points={{-10,-40},{-180,-40},{-180,200}},
      color={0,127,255}));
  connect(shc.port_b, ports_bHeaWatShc)
    annotation(Line(points={{-50,0},{-120,0},{-120,200}},
      color={0,127,255}));
annotation(defaultComponentName="hp",
  Documentation(
    info="<html>
<p>This model represents a group of heat pumps.</p>
</html>",
    revisions="<html>
<ul>
  <li>
    August 21, 2025, by Antoine Gautier:<br />
    Refactored with load-dependent 2D table data heat pump model.<br />
    This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4152\">#4152</a>.
  </li>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end AirToWater;
