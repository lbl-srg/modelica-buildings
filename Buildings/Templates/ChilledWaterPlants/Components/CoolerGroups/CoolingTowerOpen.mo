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
    final tau=tau,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.None)
    "Cooler group inlet manifold"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outCoo(
    redeclare final package Medium=MediumConWat,
    final nPorts=nCoo,
    final m_flow_nominal=mConWat_flow_nominal,
    final show_T=show_T,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.None)
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
    Documentation(info="<html>
<h4>Control points</h4>
<p>
See the documentation of
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialCoolerGroup\">
Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialCoolerGroup</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{60,-100},{220,-160}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={239,239,239},
          fillPattern=FillPattern.Solid,
          visible=nCoo >= 4),
    Text(
          extent={{60,-100},{220,-160}},
          textColor={0,0,0},
          visible=nCoo >= 4,
          textString="CT-4"),
        Rectangle(
          extent={{-780,-100},{-620,-160}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={239,239,239},
          fillPattern=FillPattern.Solid,
          visible=nCoo >= 1),
    Rectangle(
          extent={{-620,160},{-780,-160}},
          lineColor={0,0,0},
          lineThickness=1,
          visible=nCoo >= 1),
    Text( extent={{-780,-98},{-620,-158}},
          textColor={0,0,0},
          textString="CT-1",
          visible=nCoo >= 1),
    Bitmap(
          extent={{-740,160},{-660,240}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg",
          visible=nCoo >= 1),
        Bitmap(
          extent={{-60,-60},{60,60}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Fans/Propeller.svg",
          origin={-700,122},
          rotation=-90,
          visible=nCoo >= 1),
        Line(
          points={{-820,-240},{-820,80},{-780,80}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nCoo >= 1),
        Line(
          points={{-700,-160},{-700,-300},{0,-300},{0,-302}},
          color={0,0,0},
          thickness=5,
          visible=nCoo >= 1),
        Rectangle(
          extent={{-500,-100},{-340,-160}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={239,239,239},
          fillPattern=FillPattern.Solid,
          visible=nCoo >= 2),
    Rectangle(
          extent={{-340,160},{-500,-160}},
          lineColor={0,0,0},
          lineThickness=1,
          visible=nCoo >= 2),
    Text( extent={{-500,-98},{-340,-158}},
          textColor={0,0,0},
          visible=nCoo >= 2,
          textString="CT-2"),
    Bitmap(
          extent={{-460,160},{-380,240}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg",
          visible=nCoo >= 2),
        Bitmap(
          extent={{-60,-60},{60,60}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Fans/Propeller.svg",
          origin={-420,122},
          rotation=-90,
          visible=nCoo >= 2),
        Line(
          points={{-822,-240},{-540,-240},{-540,80},{-500,80}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nCoo >= 2),
        Line(
          points={{-420,-160},{-420,-300}},
          color={0,0,0},
          thickness=5,
          visible=nCoo >= 2),
        Rectangle(
          extent={{-220,-100},{-60,-160}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={239,239,239},
          fillPattern=FillPattern.Solid,
          visible=nCoo >= 3),
    Rectangle(
          extent={{-60,160},{-220,-160}},
          lineColor={0,0,0},
          lineThickness=1,
          visible=nCoo >= 3),
    Text( extent={{-220,-98},{-60,-158}},
          textColor={0,0,0},
          visible=nCoo >= 3,
          textString="CT-3"),
    Bitmap(
          extent={{-180,160},{-100,240}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg",
          visible=nCoo >= 3),
        Bitmap(
          extent={{-60,-60},{60,60}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Fans/Propeller.svg",
          origin={-140,122},
          rotation=-90,
          visible=nCoo >= 3),
        Line(
          points={{-542,-240},{-260,-240},{-260,80},{-220,80}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nCoo >= 3),
        Line(
          points={{-140,-160},{-140,-300}},
          color={0,0,0},
          thickness=5,
          visible=nCoo >= 3),
    Rectangle(
          extent={{220,160},{60,-160}},
          lineColor={0,0,0},
          lineThickness=1,
          visible=nCoo >= 4),
    Bitmap(
          extent={{100,160},{180,240}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg",

          visible=nCoo >= 4),
        Bitmap(
          extent={{-60,-60},{60,60}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Fans/Propeller.svg",

          origin={140,122},
          rotation=-90,
          visible=nCoo >= 4),
        Line(
          points={{-262,-240},{20,-240},{20,80},{60,80}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nCoo >= 4),
        Line(
          points={{140,-160},{140,-300},{0,-300}},
          color={0,0,0},
          thickness=5,
          visible=nCoo >= 4),
    Bitmap(
          extent={{380,160},{460,240}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg",

          visible=nCoo >= 5),
        Bitmap(
          extent={{-60,-60},{60,60}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Fans/Propeller.svg",

          origin={420,122},
          rotation=-90,
          visible=nCoo >= 5),
        Line(
          points={{18,-240},{300,-240},{300,80},{340,80}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nCoo >= 5),
        Line(
          points={{420,-160},{420,-300},{140,-300}},
          color={0,0,0},
          thickness=5,
          visible=nCoo >= 5),
        Rectangle(
          extent={{340,-100},{500,-160}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={239,239,239},
          fillPattern=FillPattern.Solid,
          visible=nCoo >= 5),
    Rectangle(
          extent={{500,160},{340,-160}},
          lineColor={0,0,0},
          lineThickness=1,
          visible=nCoo >= 5),
    Text(
          extent={{340,-100},{500,-160}},
          textColor={0,0,0},
          visible=nCoo >= 5,
          textString="CT-5"),
    Bitmap(
          extent={{660,160},{740,240}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg",

          visible=nCoo >= 6),
        Bitmap(
          extent={{-60,-60},{60,60}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Fans/Propeller.svg",

          origin={700,122},
          rotation=-90,
          visible=nCoo >= 6),
        Line(
          points={{298,-240},{580,-240},{580,80},{620,80}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nCoo >= 6),
        Line(
          points={{700,-160},{700,-300},{420,-300}},
          color={0,0,0},
          thickness=5,
          visible=nCoo >= 6),
        Rectangle(
          extent={{620,-100},{780,-160}},
          lineColor={28,108,200},
          pattern=LinePattern.None,
          fillColor={239,239,239},
          fillPattern=FillPattern.Solid,
          visible=nCoo >= 6),
    Rectangle(
          extent={{780,160},{620,-160}},
          lineColor={0,0,0},
          lineThickness=1,
          visible=nCoo >= 6),
    Text(
          extent={{620,-100},{780,-160}},
          textColor={0,0,0},
          visible=nCoo >= 6,
          textString="CT-6")}));
end CoolingTowerOpen;
