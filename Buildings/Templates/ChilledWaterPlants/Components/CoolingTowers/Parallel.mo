within Buildings.Templates.ChilledWaterPlants.Components.CoolingTowers;
model Parallel "Cooling tower in parallel"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.CoolingTowers.Interfaces.PartialCoolingTowerSection(
      final typ=Buildings.Templates.ChilledWaterPlants.Types.CoolingTowerSection.CoolingTowerParallel);

  inner replaceable Buildings.Templates.Components.CoolingTowers.Merkel cooTow[
    nCooTow] constrainedby
    Buildings.Templates.Components.CoolingTowers.Interfaces.PartialCoolingTower(
    redeclare each final package Medium = Medium,
    each final show_T=show_T,
    each final allowFlowReversal=allowFlowReversal,
    final dat=dat.cooTow) "Cooling tower type" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}})), choices(choice(redeclare
          Buildings.Templates.Components.CoolingTowers.Merkel cooTow[nCooTow]
          "Merkel method")));

  inner replaceable Buildings.Templates.Components.Valves.TwoWayTwoPosition
    valCooTowInlIso[nCooTow] constrainedby
    Buildings.Templates.Components.Valves.Interfaces.PartialValve(
      redeclare each final package Medium = Medium,
      each final allowFlowReversal=allowFlowReversal,
      final dat = dat.valCooTowInlIso)
      "Cooling tower inlet isolation valves"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})),
      choices(
        choice(redeclare Buildings.Templates.Components.Valves.None
          valCooTowInlIso[nCooTow] "None"),
        choice(redeclare Buildings.Templates.Components.Valves.TwoWayTwoPosition
          valCooTowInlIso[nCooTow] "Two-positions")));
  inner replaceable Buildings.Templates.Components.Valves.None
    valCooTowOutIso[nCooTow] constrainedby
    Buildings.Templates.Components.Valves.Interfaces.PartialValve(
      redeclare each final package Medium = Medium,
      each final allowFlowReversal=allowFlowReversal,
      final dat = dat.valCooTowOutIso)
      "Cooling tower outlet isolation valves"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})),
      choices(
        choice(redeclare Buildings.Templates.Components.Valves.None
          valCooTowOutIso[nCooTow] "None"),
        choice(redeclare Buildings.Templates.Components.Valves.TwoWayTwoPosition
          valCooTowOutIso[nCooTow] "Two-positions")));

  Buildings.Fluid.Delays.DelayFirstOrder volInl(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=m_flow_nominal,
    tau=1,
    nPorts=nCooTow+1)
    "Fluid volume at inlet"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-80,-30})));
  Buildings.Fluid.Delays.DelayFirstOrder volOut(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=m_flow_nominal,
    tau=1,
    nPorts=nCooTow+1)
    "Fluid volume at outet"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,-30})));

initial equation
  assert(not valCooTowInlIso[1].is_none or not valCooTowOutIso[1].is_none,
    "Cooling tower must have either an inlet or outlet isolation valve, or both");

equation
  connect(volInl.ports[1], port_a)
    annotation (Line(points={{-80,-20},{-80,0},{-100,0}}, color={0,127,255}));
  connect(volInl.ports[2:nCooTow+1], valCooTowInlIso.port_a)
    annotation (Line(points={{-80,-20},{-80,0},{-60,0}}, color={0,127,255}));
  connect(volOut.ports[1], port_b)
    annotation (Line(points={{80,-20},{80,0},{100,0}}, color={0,127,255}));
  connect(volOut.ports[2:nCooTow+1], valCooTowOutIso.port_b)
    annotation (Line(points={{80,-20},{80,0},{60,0}}, color={0,127,255}));
  connect(cooTow.port_b, valCooTowOutIso.port_a)
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(valCooTowInlIso.port_b, cooTow.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(busCon.valCooTowInlIso, valCooTowInlIso.bus) annotation (Line(
      points={{0.1,100.1},{0.1,60},{-50,60},{-50,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busCon.valCooTowOutIso, valCooTowOutIso.bus) annotation (Line(
      points={{0.1,100.1},{0.1,60},{50,60},{50,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  for i in 1:nCooTow loop
    connect(busCon.cooTow[i], cooTow[i].bus) annotation (Line(
        points={{0.1,100.1},{0.1,56},{0,56},{0,10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(weaBus, cooTow[i].weaBus) annotation (Line(
        points={{50,100},{50,80},{5,80},{5,10}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
  end for;
end Parallel;
