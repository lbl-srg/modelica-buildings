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
    final nPorts=nChi,
    final m_flow_nominal=mCon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Templates.Components.Pumps.Multiple pumConWat(
    redeclare final package Medium=MediumCon,
    final nPum=nChi,
    final typCtrSpe=typCtrSpePumConWat,
    final dat=dat.pumConWat,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple outPumConWat(
    redeclare final package Medium=MediumCon,
    final nPorts_a=nChi,
    final nPorts_b=if typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
      then nChi+1 else nChi,
    final m_flow_nominal=mCon_flow_nominal,
    final have_comLeg=typArrPumConWat==Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  replaceable
    Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTowerOpen
    coo constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialCoolerGroup(
    redeclare final package MediumConWat = MediumCon,
    final nCoo=nCoo,
    final dat=dat.coo,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal) "Cooler group"
    annotation (Placement(transformation(extent={{-180,-40},{-260,40}})));
  Fluid.Sources.Boundary_pT bouConWat(
    redeclare final package Medium = MediumCon,
    p=200000,
    nPorts=1) "CW pressure boundary condition" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-120,-150})));
equation
  /* Control point connection - start */
  connect(bus, coo.bus);
  connect(bus.pumConWat, pumConWat.bus);
  /* Control point connection - stop */
  connect(coo.port_b, inlPumConWat.port_a) annotation (Line(points={{-230,0},{
          -280,0},{-280,-100},{-120,-100}},   color={0,127,255}));
  connect(pumConWat.ports_b, outPumConWat.ports_a)
    annotation (Line(points={{-80,-100},{-80,-100}},  color={0,127,255}));
  connect(outConChi.port_b, coo.port_a)
    annotation (Line(points={{-80,0},{-210,0}}, color={0,127,255}));
  connect(outPumConWat.ports_b, chi.ports_aCon)
    annotation (Line(points={{-60,-100},{-60,-100}}, color={0,127,255}));
  connect(inlPumConWat.ports_b, pumConWat.ports_a)
    annotation (Line(points={{-100,-100},{-100,-100}}, color={0,127,255}));
  connect(busWea, coo.busWea) annotation (Line(
      points={{-1.11022e-15,280},{0,280},{0,40},{-198,40}},
      color={255,204,51},
      thickness=0.5));
  connect(inlPumConWat.port_a, bouConWat.ports[1])
    annotation (Line(points={{-120,-100},{-120,-140}}, color={0,127,255}));
end WaterCooled;
