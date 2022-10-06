within Buildings.Templates.ChilledWaterPlants;
model WaterCooled "Water-cooled chiller plant"
  extends
    Buildings.Templates.ChilledWaterPlants.Interfaces.PartialChilledWaterLoop(
    redeclare replaceable package MediumCon=Buildings.Media.Water,
    final typChi=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    final typCoo=coo.typCoo,
    final typValCooInlIso=coo.typValCooInlIso,
    final typValCooOutIso=coo.typValCooOutIso);

  // CW loop
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumConWat(
    redeclare final package Medium=MediumCon,
    final nPorts=nPumConWat,
    final m_flow_nominal=mCon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Templates.Components.Pumps.Multiple pumConWat(
    redeclare final package Medium=MediumCon,
    final nPum=nPumConWat,
    final typCtrSpe=typCtrSpePumConWat,
    final dat=dat.pumConWat,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps"
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}})));
  replaceable
    Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTowerOpen
    coo constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialCoolerGroup(
    redeclare final package MediumConWat = MediumCon,
    final nCoo=nCoo,
    final dat=dat.coo,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "Cooler group"
    annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-180,-40},{-260,40}})));
  Fluid.Sources.Boundary_pT bouConWat(
    redeclare final package Medium = MediumCon,
    p=200000,
    nPorts=1)
    "CW pressure boundary condition"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-160,-150})));
equation
  /* Control point connection - start */
  connect(bus, coo.bus);
  connect(bus.pumConWat, pumConWat.bus);
  /* Control point connection - stop */
  connect(coo.port_b, inlPumConWat.port_a) annotation (Line(points={{-230,0},{
          -280,0},{-280,-100},{-160,-100}},   color={0,127,255}));
  connect(outConChi.port_b, coo.port_a)
    annotation (Line(points={{-100,0},{-210,0}},color={0,127,255}));
  connect(inlPumConWat.ports_b, pumConWat.ports_a)
    annotation (Line(points={{-140,-100},{-130,-100}}, color={0,127,255}));
  connect(busWea, coo.busWea) annotation (Line(
      points={{-1.11022e-15,280},{0,280},{0,40},{-198,40}},
      color={255,204,51},
      thickness=0.5));
  connect(inlPumConWat.port_a, bouConWat.ports[1])
    annotation (Line(points={{-160,-100},{-160,-140}}, color={0,127,255}));
  connect(pumConWat.ports_b, inlConChi.ports_a)
    annotation (Line(points={{-110,-100},{-100,-100}}, color={0,127,255}));
end WaterCooled;
