within Buildings.Templates.ChilledWaterPlant;
model WaterCooled
  extends
    Buildings.Templates.ChilledWaterPlant.BaseClasses.PartialChilledWaterLoop(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration.WaterCooled,
    redeclare replaceable
      Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Parallel
      chiSec constrainedby
      Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Interfaces.PartialChillerSection(
        redeclare final package MediumConWat = MediumConWat),
    redeclare replaceable
      Buildings.Templates.ChilledWaterPlant.Components.Economizer.None eco
      constrainedby
      Buildings.Templates.ChilledWaterPlant.Components.Economizer.Interfaces.PartialEconomizer(
        redeclare final package MediumConWat = MediumConWat),
    final have_dedConWatPum=pumCon.is_dedicated,
    final nCooTow=cooTowSec.nCooTow,
    final nPumCon=pumCon.nPum,
    final typValConWatChi=pumCon.typValConWatChi,
    busCon(final nCooTow=nCooTow));

  replaceable package MediumConWat=Buildings.Media.Water "Condenser water medium";

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerSection.Parallel
    cooTowSec constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerSection.Interfaces.PartialCoolingTowerSection(
      redeclare final package Medium = MediumConWat, final dat=dat.cooTowSec)
    "Cooling tower section"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Headered
    pumCon constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Interfaces.PartialCondenserPump(
      redeclare final package Medium = MediumConWat, final dat=dat.pumCon)
    "Condenser water pumps"
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
  Fluid.Sources.Boundary_pT bouConWat(redeclare final package Medium =
        MediumConWat,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-110,30})));
protected
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal=
    dat.chiSec.chi[1].dp1_nominal + dat.cooTowSec.cooTow[1].dp_nominal
    "Nominal pressure drop for condenser loop";
equation
  // Sensors
  connect(TConWatSup.y, busCon.TConWatSup);
  connect(TConWatRet.y, busCon.TConWatRet);

  // Bus connection
  connect(cooTowSec.weaBus, weaBus);
  connect(cooTowSec.busCon, busCon);
  connect(pumCon.busCon, busCon);

  // Mechanical
  connect(TConWatRet.port_a, cooTowSec.port_a)
    annotation (Line(points={{-140,-70},{-192,-70},{-192,-10},{-180,-10}},
      color={0,127,255}));
  connect(cooTowSec.port_b, TConWatSup.port_a)
    annotation (Line(points={{-160,-10},{-140,-10}}, color={0,127,255}));
  connect(TConWatSup.port_b,pumCon. port_a)
    annotation (Line(points={{-120,-10},{-100,-10}}, color={0,127,255}));
  connect(pumCon.port_wse, eco.port_a1)
    annotation (Line(points={{-80,-16},{-70,-16},{-70,-50},{-46,-50},{-46,-62}},
      color={0,127,255}));
  connect(chiSec.port_b1, mixConWat.port_3)
    annotation (Line(points={{-46,0},{-46,-40},{-90,-40},{-90,-60}},
      color={0,127,255}));
  connect(pumCon.ports_b, chiSec.ports_a1)
    annotation (Line(points={{-80,-10},{-70,-10},{-70,30},{-46,30},{-46,20}},
      color={0,127,255}));
  connect(bouConWat.ports[1], pumCon.port_a)
    annotation (Line(points={{-110,20},{-110,-10},{-100,-10}},
      color={0,127,255}));
  connect(mixConWat.port_2, TConWatRet.port_b)
    annotation (Line(points={{-100,-70},{-120,-70}}, color={0,127,255}));
  connect(mixConWat.port_1, eco.port_b1)
    annotation (Line(points={{-80,-70},{-60,-70},{-60,-88},{-46,-88},{-46,-82}},
      color={0,127,255}));
end WaterCooled;
