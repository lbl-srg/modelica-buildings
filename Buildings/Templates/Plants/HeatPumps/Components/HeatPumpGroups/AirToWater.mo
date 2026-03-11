within Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups;
model AirToWater
  "Air-to-water heat pump group"
  extends Buildings.Templates.Plants.HeatPumps.Components.Interfaces.PartialHeatPumpGroup(
    redeclare final package MediumSou=MediumAir,
    final typHp=Buildings.Templates.Components.Types.HeatPump.AirToWater);
  Buildings.Templates.Components.HeatPumps.AirToWater hp[nHp + nShc](
    each final show_T=show_T,
    redeclare each final package MediumHeaWat=MediumHeaWat,
    redeclare each final package MediumAir=MediumAir,
    final typMod=typModUni,
    final dat=datUni,
    each final allowFlowReversal=allowFlowReversal,
    each final energyDynamics=energyDynamics,
    each final have_dpChiHeaWat=have_dpChiHeaWatHp,
    each final have_dpSou=have_dpSou)
    "Heat pump unit"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}})));
equation
  for i in 1:nHp + nShc loop
    connect(busWea, hp[i].busWea)
      annotation(Line(points={{20,200},{20,20},{6,20},{6,10}},
        color={255,204,51},
        thickness=0.5));
  end for;
  // Array slice expansion with potential heterogeneous conditionality
  // is not supported in connect statements: a for loop is required.
  for i in nHp + 1:nHp + nShc loop
    connect(hp[i].port_b, ports_bHeaWatShc[i - nHp])
      annotation(Line(points={{-10,0},{-10,20},{-120,20},{-120,200}},
        color={255,204,51},
        thickness=0.5));
    connect(hp[i].port_bChiWat, ports_bChiWatShc[i - nHp])
      annotation(Line(points={{10,10},{10,20},{-60,20},{-60,200}},
        color={255,204,51},
        thickness=0.5));
    connect(ports_aChiWatShc[i - nHp], hp[i].port_aChiWat)
      annotation(Line(points={{60,200},{60,40},{-10,40},{-10,10}},
        color={0,127,255}));
    connect(ports_aHeaWatShc[i - nHp], hp[i].port_a)
      annotation(Line(points={{120,200},{122,200},{122,0},{10,0}},
        color={0,127,255}));
    connect(busShc[i - nHp], hp[i].bus)
      annotation(Line(points={{-40,160},{-38,160},{-38,26},{0,26},{0,12}},
        color={255,204,51},
        thickness=0.5));
  end for;
  // Surprisingly, the array syntax is supported on the range [1:nHp].
  // We still use a for loop for extra caution and maximum cross-tool support.
  for i in 1:nHp loop
    connect(hp[i].port_b, ports_bChiHeaWatHp[i])
      annotation(Line(points={{-10,0},{-180,0},{-180,200}},
        color={0,127,255}));
    connect(ports_aChiHeaWatHp[i], hp[i].port_a)
      annotation(Line(points={{180,200},{180,0},{10,0}},
        color={0,127,255}));
    connect(busHp[i], hp[i].bus)
      annotation(Line(points={{0,160},{0,10}},
        color={255,204,51},
        thickness=0.5));
  end for;
  connect(ports_aSou, hp.port_aSou)
    annotation(Line(points={{-160,-200},{-160,-10},{-10,-10}},
      color={0,127,255}));
  connect(ports_bSou, hp.port_bSou)
    annotation(Line(points={{160,-200},{160,-10},{10,-10}},
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
