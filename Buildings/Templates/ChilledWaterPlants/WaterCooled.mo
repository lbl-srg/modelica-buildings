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
    annotation (Placement(transformation(extent={{-160,-190},{-140,-170}})));
  Buildings.Templates.Components.Pumps.Multiple pumConWat(
    redeclare final package Medium=MediumCon,
    final nPum=nPumConWat,
    final have_var=have_varPumConWat,
    final have_varCom=have_varComPumConWat,
    final dat=dat.pumConWat,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "CW pumps"
    annotation (Placement(transformation(extent={{-130,-190},{-110,-170}})));
  replaceable
    Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTowerOpen
    coo constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialCoolerGroup(
    redeclare final package MediumConWat = MediumCon,
    final have_varCom=true,
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
        origin={-160,-230})));
  Buildings.Templates.Components.Sensors.Temperature TConWatSup(
    redeclare final package Medium = MediumCon,
    final have_sen=ctl.typCtlFanCoo
                      ==Buildings.Templates.ChilledWaterPlants.Types.CoolerFanSpeedControl.SupplyTemperature
      or ctl.typCtlFanCoo==Buildings.Templates.ChilledWaterPlants.Types.CoolerFanSpeedControl.ReturnTemperature
      and not ctl.is_clsCpl,
    final m_flow_nominal=mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "CW supply temperature (from coolers)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-140,0})));
  Buildings.Templates.Components.Sensors.Temperature TConWatRet(
    redeclare final package Medium = MediumCon,
    final have_sen=ctl.typCtlFanCoo
                      ==Buildings.Templates.ChilledWaterPlants.Types.CoolerFanSpeedControl.ReturnTemperature,
    final m_flow_nominal=mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "CW return temperature (to coolers)"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-200,-180})));
equation
  /* Control point connection - start */
  connect(bus, coo.bus);
  connect(bus.pumConWat, pumConWat.bus);
  connect(TConWatSup.y, bus.TConWatSup);
  connect(TConWatRet.y, bus.TConWatRet);
  /* Control point connection - stop */
  connect(inlPumConWat.ports_b, pumConWat.ports_a)
    annotation (Line(points={{-140,-180},{-130,-180}}, color={0,127,255}));
  connect(busWea, coo.busWea) annotation (Line(
      points={{-1.11022e-15,280},{0,280},{0,260},{-200,260},{-200,40},{-198,40}},
      color={255,204,51},
      thickness=0.5));
  connect(inlPumConWat.port_a, bouConWat.ports[1])
    annotation (Line(points={{-160,-180},{-160,-220}}, color={0,127,255}));
  connect(pumConWat.ports_b, inlConChi.ports_a)
    annotation (Line(points={{-110,-180},{-100,-180}}, color={0,127,255}));
  connect(outConChi.port_b, TConWatSup.port_b)
    annotation (Line(points={{-100,0},{-130,0}}, color={0,127,255}));
  connect(TConWatSup.port_a, coo.port_a)
    annotation (Line(points={{-150,0},{-210,0}}, color={0,127,255}));
  connect(coo.port_b, TConWatRet.port_b) annotation (Line(points={{-230,0},{
          -280,0},{-280,-180},{-210,-180}},
                                       color={0,127,255}));
  connect(TConWatRet.port_a, inlPumConWat.port_a)
    annotation (Line(points={{-190,-180},{-160,-180}}, color={0,127,255}));
end WaterCooled;
