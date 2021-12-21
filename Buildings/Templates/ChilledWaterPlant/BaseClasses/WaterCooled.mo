within Buildings.Templates.ChilledWaterPlant.BaseClasses;
model WaterCooled
  extends
    Buildings.Templates.ChilledWaterPlant.BaseClasses.PartialChilledWaterLoop(
    final is_airCoo=false,
    redeclare replaceable Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel chiGro
      constrainedby
      Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.ChillerGroup(
        redeclare final package MediumCW = MediumCW,
        final m1_flow_nominal=mCon_flow_nominal),
    redeclare replaceable Buildings.Templates.ChilledWaterPlant.Components.Controls.OpenLoop con
      constrainedby
      Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces.PartialController(
        final nPumCon=nPumCon,
        final nCooTow=nCooTow),
    redeclare replaceable Components.ReturnSection.NoEconomizer WSE
      constrainedby
      Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.ChilledWaterReturnSection(
        redeclare final package MediumCW = MediumCW,
        final m1_flow_nominal=mCon_flow_nominal));

  replaceable package MediumCW=Buildings.Media.Water "Condenser water medium";

  final parameter Integer nPumCon = pumCon.nPum "Number of condenser pumps";
  final parameter Integer nCooTow = cooTow.nCooTow "Number of cooling towers";

  final parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=
    dat.getReal(varName=id + ".CondenserWater.m_flow_nominal.value")
    "Condenser mass flow rate";

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.CoolingTowerParallel
    cooTow constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces.CoolingTowerGroup(
      redeclare final package Medium = MediumCW,
      final m_flow_nominal=mCon_flow_nominal)
    "Cooling tower group"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Headered
    pumCon(final has_WSE=not WSE.is_none) constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.CondenserWaterPumpGroup(
      redeclare final package Medium = MediumCW,
      final mTot_flow_nominal=mCon_flow_nominal,
      final dp_nominal=dpCon_nominal,
      final nChi=nChi)
    "Condenser water pump group"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Templates.Components.Sensors.Temperature TCWSup(
    redeclare final package Medium = MediumCW,
    final have_sen,
    final m_flow_nominal=mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Templates.Components.Sensors.Temperature TCWRet(
    redeclare final package Medium = MediumCW,
    final have_sen,
    final m_flow_nominal=mCon_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Fluid.FixedResistances.Junction mixCW(
    redeclare package Medium = MediumCW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=mCon_flow_nominal*{1,-1,1},
    final dp_nominal={0,0,0})
    "Condenser water return mixer"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-90,-70})));

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusCondenserWater cwCon(nPum=
        nPumCon, nCooTow=nCooTow)
    if not is_airCoo
    "Condenser loop control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={-200,60})));

  Fluid.Sources.Boundary_pT bouCW(redeclare final package Medium = MediumCW,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-110,30})));
protected
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal=
    chiGro.dp1_nominal + cooTow.dp_nominal
    "Nominal pressure drop for condenser loop";
equation
  connect(TCWRet.port_a, cooTow.port_a)
    annotation (Line(points={{-140,-70},{-192,-70},{-192,-10},{-180,-10}},
      color={0,127,255}));
  connect(cooTow.port_b, TCWSup.port_a)
    annotation (Line(points={{-160,-10},{-140,-10}}, color={0,127,255}));
  connect(TCWSup.port_b,pumCon. port_a)
    annotation (Line(points={{-120,-10},{-100,-10}}, color={0,127,255}));
  connect(pumCon.port_wse, WSE.port_a1)
    annotation (Line(points={{-80,-16},{-70,-16},{-70,-50},{-46,-50},{-46,-62}},
      color={0,127,255}));
  connect(chiGro.port_b1, mixCW.port_3)
    annotation (Line(points={{-46,0},{-46,-40},{-90,-40},{-90,-60}},
      color={0,127,255}));
  connect(pumCon.ports_b, chiGro.ports_a1)
    annotation (Line(points={{-80,-10},{-70,-10},{-70,30},{-46,30},{-46,20}},
      color={0,127,255}));

  connect(weaBus, cooTow.weaBus);

  connect(TCWSup.y, cwCon.TCWSup);
  connect(TCWRet.y, cwCon.TCWRet);
  connect(cooTow.busCon, cwCon.cooTow);
  connect(pumCon.busCon, cwCon.pum);
  connect(con.busCW, cwCon) annotation (Line(
      points={{60,60},{-200,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(bouCW.ports[1], pumCon.port_a) annotation (Line(points={{-110,20},{
          -110,-10},{-100,-10}},              color={0,127,255}));
  connect(mixCW.port_2, TCWRet.port_b)
    annotation (Line(points={{-100,-70},{-120,-70}}, color={0,127,255}));
  connect(mixCW.port_1, WSE.port_b1) annotation (Line(points={{-80,-70},{-60,
          -70},{-60,-88},{-46,-88},{-46,-82}}, color={0,127,255}));
end WaterCooled;
