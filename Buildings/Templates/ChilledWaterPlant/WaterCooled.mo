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
      final nCooTow=cooTowSec.nCooTow,
      final nPumCon=pumCon.nPum,
      final have_dedConWatPum=pumCon.is_dedicated,
      final typValConWatChi=pumCon.typValConWatChi,
      busCon(final nCooTow=nCooTow),
      dat(
        cooTowSec(
          typ = cooTowSec.typ,
          nCooTow = cooTowSec.nCooTow,
          cooTow(typ = cooTowSec.cooTow.typ)),
        pumCon(
          typ = pumCon.typ,
          nPum = pumCon.nPum,
          valConWatChi(typ = typValConWatChi),
          pum(each typ = pumCon.pum.typ))));

  replaceable package MediumConWat = Buildings.Media.Water
    "Condenser water medium";

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerSection.Parallel
    cooTowSec constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerSection.Interfaces.PartialCoolingTowerSection(
      redeclare final package Medium = MediumConWat,
      final dat=dat.cooTowSec)
    "Cooling tower section"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-170,-28})),
      choices(
        choice(redeclare Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerSection.Parallel
          cooTowSec "Cooling towers in parallel")));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Headered
    pumCon constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Interfaces.PartialCondenserPump(
      redeclare final package Medium = MediumConWat,
      final dat=dat.pumCon)
    "Condenser water pumps"
    annotation (Placement(transformation(extent={{-58,0},{-38,20}})),
      choices(
        choice(redeclare Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Headered
          pumCon "Headered condenser water pumps"),
        choice(redeclare Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Dedicated
          pumCon "Dedicated condenser water pumps")));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.Economizer.None
    eco constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.Economizer.Interfaces.PartialEconomizer(
      redeclare final package MediumChiWat = MediumChiWat,
      final dat=dat.eco)
    "Waterside economizer"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-50})),
      choices(
        choice(redeclare Buildings.Templates.ChilledWaterPlant.Components.Economizer.None
          eco "No economizer"),
        choice(redeclare Buildings.Templates.ChilledWaterPlant.Components.Economizer.WatersideEconomizer
          eco "Waterside economizer")));

  Buildings.Templates.Components.Sensors.Temperature TConWatSup(
    redeclare final package Medium = MediumConWat,
    final have_sen=true,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Templates.Components.Sensors.Temperature TConWatRet(
    redeclare final package Medium = MediumConWat,
    final have_sen=true,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Fluid.FixedResistances.Junction mixConWat(
    redeclare package Medium = MediumConWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=dat.mCon_flow_nominal*{1,-1,1},
    final dp_nominal={0,0,0})
    "Condenser water return mixer"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-50,-70})));
  Buildings.Fluid.Sources.Boundary_pT bouConWat(
    redeclare final package Medium = MediumConWat,
    nPorts=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,30})));

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
  connect(eco.busCon, busCon);

  // Mechanical
  connect(TConWatRet.port_a, cooTowSec.port_a)
    annotation (Line(points={{-140,-70},{-170,-70},{-170,-38}},
      color={0,127,255}));
  connect(cooTowSec.port_b, TConWatSup.port_a)
    annotation (Line(points={{-170,-18},{-170,10},{-140,10}},
                                                     color={0,127,255}));
  connect(TConWatSup.port_b,pumCon. port_a)
    annotation (Line(points={{-120,10},{-58,10}},    color={0,127,255}));
  connect(pumCon.port_wse, eco.port_a1)
    annotation (Line(points={{-38,4},{-32,4},{-32,-34},{-6,-34},{-6,-40}},
      color={0,127,255}));
  connect(chiSec.port_b1, mixConWat.port_3)
    annotation (Line(points={{-6,-18},{-6,-30},{-50,-30},{-50,-60}},
      color={0,127,255}));
  connect(pumCon.ports_b, chiSec.ports_a1)
    annotation (Line(points={{-38,10},{-6,10},{-6,2}},
      color={0,127,255}));
  connect(bouConWat.ports[1], pumCon.port_a)
    annotation (Line(points={{-90,20},{-90,10},{-58,10}},
      color={0,127,255}));
  connect(mixConWat.port_2, TConWatRet.port_b)
    annotation (Line(points={{-60,-70},{-120,-70}},  color={0,127,255}));
  connect(mixConWat.port_1, eco.port_b1)
    annotation (Line(points={{-40,-70},{-6,-70},{-6,-60}},
      color={0,127,255}));
  connect(VSecRet_flow.port_a,eco. port_a2)
    annotation (Line(points={{80,-70},{6,-70},{6,-60}}, color={0,127,255}));
  connect(eco.port_b2, chiSec.port_a2)
    annotation (Line(points={{6,-40},{6,-18}},                 color={0,127,255}));
end WaterCooled;
