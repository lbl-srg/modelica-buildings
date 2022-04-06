within Buildings.Templates.ChilledWaterPlant;
model WaterCooled
  extends
    Buildings.Templates.ChilledWaterPlant.BaseClasses.PartialChilledWaterLoop(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration.WaterCooled,
    redeclare replaceable
      Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel
      chiGro constrainedby
      Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.PartialChillerGroup(
       redeclare final package MediumConWat = MediumConWat),
    redeclare replaceable
      Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.NoEconomizer
      retSec constrainedby
      Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.PartialReturnSection(
       redeclare final package MediumConWat = MediumConWat),
    final have_dedConWatPum = pumCon.is_dedicated,
    final nCooTow = cooTowGro.nCooTow,
    final nPumCon = pumCon.nPum,
    busCon(final nCooTow=nCooTow));

  replaceable package MediumConWat=Buildings.Media.Water "Condenser water medium";

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.CoolingTowerParallel
    cooTowGro constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces.PartialCoolingTowerGroup(
      redeclare final package Medium = MediumConWat,
      final dat=dat.cooTowGro)
    "Cooling tower group"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Headered
    pumCon(final have_eco=not retSec.is_none) constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.PartialCondenserWaterPumpGroup(
    redeclare final package Medium = MediumConWat,
    final dat=dat.pumCon) "Condenser water pump group"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Templates.Components.Sensors.Temperature TConWatSup(
    redeclare final package Medium = MediumConWat,
    final have_sen=true,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Templates.Components.Sensors.Temperature TConWatRet(
    redeclare final package Medium = MediumConWat,
    final have_sen=true,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Fluid.FixedResistances.Junction mixConWat(
    redeclare package Medium = MediumConWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=dat.mCon_flow_nominal*{1,-1,1},
    final dp_nominal={0,0,0})
    "Condenser water return mixer"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-90,-70})));
  Fluid.Sources.Boundary_pT bouConWat(redeclare final package Medium = MediumConWat,
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
  connect(TConWatSup.y, busCon.TConWatSup);
  connect(TConWatRet.y, busCon.TConWatRet);

  // Bus connection
  connect(cooTowGro.weaBus, weaBus);
  connect(cooTowGro.busCon, busCon);
  connect(pumCon.busCon, busCon);

  // Mechanical
  connect(TConWatRet.port_a, cooTowGro.port_a)
    annotation (Line(points={{-140,-70},{-192,-70},{-192,-10},{-180,-10}},
      color={0,127,255}));
  connect(cooTowGro.port_b, TConWatSup.port_a)
    annotation (Line(points={{-160,-10},{-140,-10}}, color={0,127,255}));
  connect(TConWatSup.port_b,pumCon. port_a)
    annotation (Line(points={{-120,-10},{-100,-10}}, color={0,127,255}));
  connect(pumCon.port_wse, retSec.port_a1)
    annotation (Line(points={{-80,-16},{-70,-16},{-70,-50},{-46,-50},{-46,-62}},
      color={0,127,255}));
  connect(chiGro.port_b1, mixConWat.port_3)
    annotation (Line(points={{-46,0},{-46,-40},{-90,-40},{-90,-60}},
      color={0,127,255}));
  connect(pumCon.ports_b, chiGro.ports_a1)
    annotation (Line(points={{-80,-10},{-70,-10},{-70,30},{-46,30},{-46,20}},
      color={0,127,255}));
  connect(bouConWat.ports[1], pumCon.port_a)
    annotation (Line(points={{-110,20},{-110,-10},{-100,-10}},
      color={0,127,255}));
  connect(mixConWat.port_2, TConWatRet.port_b)
    annotation (Line(points={{-100,-70},{-120,-70}}, color={0,127,255}));
  connect(mixConWat.port_1, retSec.port_b1)
    annotation (Line(points={{-80,-70},{-60,-70},{-60,-88},{-46,-88},{-46,-82}},
      color={0,127,255}));
end WaterCooled;
