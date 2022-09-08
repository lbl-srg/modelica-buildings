within Buildings.Templates.ChilledWaterPlants;
model WaterCooled "Water-cooled plants"
  extends
    Buildings.Templates.ChilledWaterPlants.Interfaces.PartialChilledWaterLoop(
    bus(final nCooTow=nCooTow),
    final typ=Buildings.Templates.ChilledWaterPlants.Types.Configuration.WaterCooled,

    redeclare replaceable
      Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Parallel
      chiSec constrainedby
      Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Interfaces.PartialChillerSection(
        redeclare final package MediumConWat = MediumConWat),
    final nCooTow=cooTowSec.nCooTow,
    final nPumCon=pumCon.nPum,
    final have_dedConWatPum=pumCon.is_dedicated,
    final have_eco=eco.have_eco,
    dat(
      cooTowSec(
        typ=cooTowSec.typ,
        nCooTow=cooTowSec.nCooTow,
        cooTow(typ=cooTowSec.cooTow.typ),
        valCooTowInlIso(typ=cooTowSec.valCooTowInlIso.typ),
        valCooTowOutIso(typ=cooTowSec.valCooTowOutIso.typ)),
      pumCon(
        typ=pumCon.typ,
        nPum=pumCon.nPum,
        valConWatChiIso(typ=pumCon.typValConWatChiIso),
        pum(each typ=pumCon.pum.typ)),
      eco(typ=eco.typ, have_valChiWatEcoByp=eco.have_valChiWatEcoByp)));

  replaceable package MediumConWat = Buildings.Media.Water
    "Condenser water medium";

  inner replaceable
    Buildings.Templates.ChilledWaterPlants.Components.CoolingTowerSection.Parallel
    cooTowSec constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.CoolingTowerSection.Interfaces.PartialCoolingTowerSection(
     redeclare final package Medium = MediumConWat, final dat=dat.cooTowSec)
    "Cooling tower section" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-220,0})),   choices(choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.CoolingTowerSection.Parallel
          cooTowSec "Cooling towers in parallel")));
  inner replaceable
    Buildings.Templates.ChilledWaterPlants.Components.PumpsCondenserWater.Headered
    pumCon constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.PumpsCondenserWater.Interfaces.PartialCondenserPump(
      redeclare final package Medium = MediumConWat, final dat=dat.pumCon)
    "Condenser water pumps" annotation (Placement(transformation(extent={{-120,
            -110},{-100,-90}})),
                         choices(choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.PumpsCondenserWater.Headered
          pumCon "Headered condenser water pumps"), choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.PumpsCondenserWater.Dedicated
          pumCon "Dedicated condenser water pumps")));
  inner replaceable
    Buildings.Templates.ChilledWaterPlants.Components.Economizers.None eco
    constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.Economizers.Interfaces.PartialEconomizer(
    redeclare final package MediumChiWat = MediumChiWat,
    redeclare final package MediumConWat = MediumConWat,
    final dat=dat.eco) "Waterside economizer" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-70,-162})), choices(choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.Economizers.None
          eco "No economizer"), choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.Economizers.WatersideEconomizer
          eco "Waterside economizer")));

  Buildings.Templates.Components.Sensors.Temperature TConWatSup(
    redeclare final package Medium = MediumConWat,
    final have_sen=true,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Common condenser water supply temperature from towers"
    annotation (Placement(transformation(extent={{-190,-10},{-170,10}})));
  Buildings.Templates.Components.Sensors.Temperature TConWatRet(
    redeclare final package Medium = MediumConWat,
    final have_sen=true,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Common condenser water return temperature to towers"
    annotation (Placement(transformation(extent={{-190,-190},{-170,-170}})));
  Buildings.Fluid.FixedResistances.Junction mixConWat(
    redeclare package Medium = MediumConWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=dat.mCon_flow_nominal*{1,-1,1},
    final dp_nominal={0,0,0})
    "Condenser water return mixer"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-140,-180})));
  Buildings.Fluid.Sources.Boundary_pT bouConWat(
    redeclare final package Medium = MediumConWat,
    nPorts=2)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-140,10})));

protected
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal=
    dat.chiSec.chi[1].dp1_nominal + dat.cooTowSec.cooTow[1].dp_nominal
    "Nominal pressure drop for condenser loop";

equation
  // Sensors
  connect(TConWatSup.y, bus.TConWatSup);
  connect(TConWatRet.y, bus.TConWatRet);

  // Bus connection
  connect(cooTowSec.weaBus,busWea);
  connect(cooTowSec.busCon, bus);
  connect(pumCon.bus, bus);
  connect(eco.bus, bus);

  // Mechanical
  connect(TConWatRet.port_a, cooTowSec.port_a)
    annotation (Line(points={{-190,-180},{-230,-180},{-230,0}},
      color={0,127,255}));
  connect(cooTowSec.port_b, TConWatSup.port_a)
    annotation (Line(points={{-210,0},{-190,0}},     color={0,127,255}));
  connect(TConWatSup.port_b,pumCon. port_a)
    annotation (Line(points={{-170,0},{-160,0},{-160,-100},{-120,-100}},
                                                     color={0,127,255}));
  connect(pumCon.port_wse, eco.port_a1)
    annotation (Line(points={{-100,-106},{-100,-152},{-76,-152}},
      color={0,127,255}));
  connect(chiSec.port_b1, mixConWat.port_3)
    annotation (Line(points={{-78,-130},{-78,-140},{-140,-140},{-140,-170}},
      color={0,127,255}));
  connect(pumCon.ports_b, chiSec.ports_a1)
    annotation (Line(points={{-100,-100},{-78,-100},{-78,-110}},
      color={0,127,255}));
  connect(bouConWat.ports[1], pumCon.port_a)
    annotation (Line(points={{-141,-3.55271e-15},{-141,-100},{-120,-100}},
      color={0,127,255}));
  connect(mixConWat.port_2, TConWatRet.port_b)
    annotation (Line(points={{-150,-180},{-170,-180}},
                                                     color={0,127,255}));
  connect(mixConWat.port_1, eco.port_b1)
    annotation (Line(points={{-130,-180},{-40,-180},{-40,-172},{-76,-172}},
      color={0,127,255}));
  connect(eco.port_b2, chiSec.port_a2)
    annotation (Line(points={{-64,-152},{-20,-152},{-20,-130},{-66,-130}},
                                                               color={0,127,255}));
  connect(TConWatSup.port_b, bouConWat.ports[2]) annotation (Line(points={{-170,0},
          {-145,0},{-145,-3.55271e-15},{-139,-3.55271e-15}},    color={0,127,
          255}));
end WaterCooled;
