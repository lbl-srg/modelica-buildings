within Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups;
model AirToWater
  "Air-to-water heat pump group"
  extends Buildings.Templates.Plants.HeatPumps.Components.Interfaces.PartialHeatPumpGroup(
    redeclare final package MediumSou=MediumAir,
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWater);
  Buildings.Templates.Components.HeatPumps.AirToWater hp[nHp](
    each final show_T=show_T,
    redeclare each final package MediumHeaWat = MediumHeaWat,
    redeclare each final package MediumAir = MediumAir,
    each final is_rev=is_rev,
    final dat=datHp,
    each final allowFlowReversal=allowFlowReversal,
    each final energyDynamics=energyDynamics,
    each final have_dpChiHeaWat=have_dpChiHeaWatHp,
    each final have_dpSou=have_dpSou)
    "Heat pump unit"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
equation
  for i in 1:nHp loop
    connect(busWea, hp[i].busWea)
      annotation (Line(points={{20,200},{20,40},{6,40},{6,10}},
                                                        color={255,204,51},thickness=0.5));
  end for;
  connect(busHp, hp.bus)
    annotation (Line(points={{0,160},{0,10}},color={255,204,51},thickness=0.5));
  connect(ports_aSou, hp.port_aSou)
    annotation (Line(points={{-120,-200},{-120,-10},{-10,-10}},color={0,127,255}));
  connect(ports_bSou, hp.port_bSou)
    annotation (Line(points={{120,-200},{120,-10},{10,-10}},color={0,127,255}));
  connect(ports_aHeaWatShc, hp[nHp + 1:nHp + nShc].port_a)
    annotation (Line(points={{120,200},{120,0},{10,0}}, color={0,127,255}));
  connect(ports_aChiWatShc, hp[nHp + 1:nHp + nShc].port_aChiWat) annotation (
      Line(points={{60,200},{60,20},{-20,20},{-20,10},{-10,10}}, color={0,127,
          255}));
  connect(hp[nHp + 1:nHp + nShc].port_bChiWat, ports_bChiWatShc) annotation (
      Line(points={{10,10},{20,10},{20,30},{-60,30},{-60,200}}, color={0,127,
          255}));
  connect(ports_aChiHeaWatHp, hp[1:nHp].port_a)
    annotation (Line(points={{180,200},{180,0},{10,0}}, color={0,127,255}));
  connect(hp[1:nHp].port_b, ports_bChiHeaWatHp)
    annotation (Line(points={{-10,0},{-180,0},{-180,200}}, color={0,127,255}));
  connect(hp[nHp + 1:nHp + nShc].port_b, ports_bHeaWatShc)
    annotation (Line(points={{-10,0},{-120,0},{-120,202}}, color={0,127,255}));
  annotation (
    defaultComponentName="hp", Documentation(info="<html>
<p>
This model represents a group of heat pumps.
</p>
</html>", revisions="<html>
<ul>
<li>
August 21, 2025, by Antoine Gautier:<br/>
Refactored with load-dependent 2D table data heat pump model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4152\">#4152</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirToWater;
