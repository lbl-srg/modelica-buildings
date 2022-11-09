within Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups;
model CoolingTowerOpen "Open-circuit cooling towers in parallel"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialCoolerGroup(
    final typValCooOutIso=valCooOutIso[1].typ,
    final typValCooInlIso=valCooInlIso[1].typ,
    final typCoo=Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen);

  Buildings.Templates.Components.Coolers.CoolingTower coo[nCoo](
    redeclare each final package MediumConWat=MediumConWat,
    each final typ=typCoo,
    final dat=datCoo,
    each final show_T=show_T,
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_small=m_flow_small,
    each final energyDynamics=energyDynamics,
    each final tau=tau)
    "Cooling tower"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  replaceable Buildings.Templates.Components.Valves.TwoWayTwoPosition valCooInlIso[nCoo]
    constrainedby Buildings.Templates.Components.Interfaces.PartialValve(
      redeclare each final package Medium=MediumConWat,
      final dat=datValCooInlIso,
      each final show_T=show_T,
      each final allowFlowReversal=allowFlowReversal,
      each final m_flow_small=m_flow_small)
    "Inlet isolation valve"
    annotation (
      choices(
      choice(redeclare each replaceable Buildings.Templates.Components.Valves.TwoWayTwoPosition valCooInlIso
        "Two-way two-position valve"),
      choice(redeclare each replaceable Buildings.Templates.Components.Valves.None valCooInlIso
        "No Valve")),
    Placement(transformation(extent={{-50,-10},{-30,10}})));
  replaceable Buildings.Templates.Components.Valves.TwoWayTwoPosition valCooOutIso[nCoo]
    constrainedby Buildings.Templates.Components.Interfaces.PartialValve(
      redeclare each final package Medium = MediumConWat,
      final dat=datValCooOutIso,
      each final show_T=show_T,
      each final allowFlowReversal=allowFlowReversal,
      each final m_flow_small=m_flow_small)
    "Outlet isolation valve"
    annotation (
      choices(
      choice(redeclare each replaceable Buildings.Templates.Components.Valves.TwoWayTwoPosition valCooOutIso
        "Two-way two-position valve"),
      choice(redeclare each replaceable Buildings.Templates.Components.Valves.None valCooOutIso
        "No Valve")),
    Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlCoo(
    redeclare final package Medium=MediumConWat,
    final nPorts=nCoo,
    final m_flow_nominal=mConWat_flow_nominal,
    final show_T=show_T,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Cooler group inlet manifold"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outCoo(
    redeclare final package Medium=MediumConWat,
    final nPorts=nCoo,
    final m_flow_nominal=mConWat_flow_nominal,
    final show_T=show_T,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Cooling tower group outlet manifold"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
equation
  /* Control point connection - start */
  connect(busCoo, coo.bus);
  /*
  HACK: The following clauses should be removed at translation if typVal*==*.None`
  but Dymola fails to do so.
  Hence, explicit `if then` statements are used.
  */
  if typValCooInlIso<>Buildings.Templates.Components.Types.Valve.None then
    connect(bus.valCooInlIso, valCooInlIso.bus);
  end if;
  if typValCooOutIso<>Buildings.Templates.Components.Types.Valve.None then
    connect(bus.valCooOutIso, valCooOutIso.bus);
  end if;
  for i in 1:nCoo loop
     connect(busWea, coo[i].busWea);
  end for;
  /* Control point connection - stop */
  connect(valCooInlIso.port_b, coo.port_a)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(port_b, outCoo.port_b)
    annotation (Line(points={{100,0},{90,0}}, color={0,127,255}));
  connect(port_a, inlCoo.port_a)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(inlCoo.ports_b, valCooInlIso.port_a)
    annotation (Line(points={{-70,0},{-50,0}}, color={0,127,255}));
  connect(coo.port_b, valCooOutIso.port_a)
    annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
  connect(valCooOutIso.port_b, outCoo.ports_a)
    annotation (Line(points={{50,0},{70,0}}, color={0,127,255}));
    annotation (
    defaultComponentName="coo",
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-400,-400},{400,400}})),
    Documentation(info="<html>
<h4>Control points</h4>
<p>
See the documentation of
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialCoolerGroup\">
Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialCoolerGroup</a>.
</p>
</html>"));
end CoolingTowerOpen;
