within Buildings.Templates.ChilledWaterPlant;
model WaterCooled
  extends
    Buildings.Templates.ChilledWaterPlant.BaseClasses.PartialChilledWaterLoop(
    dat(final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration.WaterCooled),
    redeclare replaceable
      Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel
      chiGro(final have_CWDedPum=pumCon.is_dedicated) constrainedby
      Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.PartialChillerGroup(
       redeclare final package MediumCW = MediumCW,
       final m1_flow_nominal=dat.mCon_flow_nominal),
    redeclare replaceable
      Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.NoEconomizer
      retSec constrainedby
      Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.PartialReturnSection(
       redeclare final package MediumCW = MediumCW,
       final m1_flow_nominal=dat.mCon_flow_nominal),
    final nPumCon = dat.pumCon.nPum,
    final nCooTow = dat.cooTowGro.nCooTow,
    final have_CWDedPum = pumCon.is_dedicated,
    busCon(final nCooTow=nCooTow));

  replaceable package MediumCW=Buildings.Media.Water "Condenser water medium";

  // Note: Ideally, the number of cooling tower nCooTow would be assigned in
  // cooTowGro and propagated up to the system-wide nCooTow. But surprisingly,
  // this propagation is not working in Dymola, even if a similar propagation
  // is working for nChi.

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.CoolingTowerParallel
    cooTowGro constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces.PartialCoolingTowerGroup(
      redeclare final package Medium = MediumCW,
      final dat=dat.cooTowGro,
      final nCooTow=nCooTow,
      final m_flow_nominal=dat.mCon_flow_nominal)
    "Cooling tower group"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Headered
    pumCon(final have_WSE=not retSec.is_none) constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.PartialCondenserWaterPumpGroup(
    redeclare final package Medium = MediumCW,
    final dat=dat.pumCon,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final dp_nominal=dpCon_nominal) "Condenser water pump group"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Templates.Components.Sensors.Temperature TCWSup(
    redeclare final package Medium = MediumCW,
    final have_sen=true,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Templates.Components.Sensors.Temperature TCWRet(
    redeclare final package Medium = MediumCW,
    final have_sen=true,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Fluid.FixedResistances.Junction mixCW(
    redeclare package Medium = MediumCW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=dat.mCon_flow_nominal*{1,-1,1},
    final dp_nominal={0,0,0})
    "Condenser water return mixer"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-90,-70})));
  Fluid.Sources.Boundary_pT bouCW(redeclare final package Medium = MediumCW,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-110,30})));
protected
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal=
    dat.chiGro.chi[1].dp1_nominal + dat.cooTowGro.cooTow[1].dp_nominal
    "Nominal pressure drop for condenser loop";
equation
  // Sensors
  connect(TCWSup.y, busCon.TCWSup);
  connect(TCWRet.y, busCon.TCWRet);

  // Bus connection
  connect(cooTowGro.weaBus, weaBus);
  connect(cooTowGro.busCon, busCon);
  connect(pumCon.busCon, busCon);

  // Mechanical
  connect(TCWRet.port_a, cooTowGro.port_a)
    annotation (Line(points={{-140,-70},{-192,-70},{-192,-10},{-180,-10}},
      color={0,127,255}));
  connect(cooTowGro.port_b, TCWSup.port_a)
    annotation (Line(points={{-160,-10},{-140,-10}}, color={0,127,255}));
  connect(TCWSup.port_b,pumCon. port_a)
    annotation (Line(points={{-120,-10},{-100,-10}}, color={0,127,255}));
  connect(pumCon.port_wse, retSec.port_a1)
    annotation (Line(points={{-80,-16},{-70,-16},{-70,-50},{-46,-50},{-46,-62}},
      color={0,127,255}));
  connect(chiGro.port_b1, mixCW.port_3)
    annotation (Line(points={{-46,0},{-46,-40},{-90,-40},{-90,-60}},
      color={0,127,255}));
  connect(pumCon.ports_b, chiGro.ports_a1)
    annotation (Line(points={{-80,-10},{-70,-10},{-70,30},{-46,30},{-46,20}},
      color={0,127,255}));
  connect(bouCW.ports[1], pumCon.port_a)
    annotation (Line(points={{-110,20},{-110,-10},{-100,-10}},
      color={0,127,255}));
  connect(mixCW.port_2, TCWRet.port_b)
    annotation (Line(points={{-100,-70},{-120,-70}}, color={0,127,255}));
  connect(mixCW.port_1, retSec.port_b1)
    annotation (Line(points={{-80,-70},{-60,-70},{-60,-88},{-46,-88},{-46,-82}},
      color={0,127,255}));
end WaterCooled;
