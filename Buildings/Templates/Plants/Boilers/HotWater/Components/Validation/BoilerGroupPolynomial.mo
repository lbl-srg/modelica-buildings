within Buildings.Templates.Plants.Boilers.HotWater.Components.Validation;
model BoilerGroupPolynomial
  "Validation model for boiler group"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";

  parameter Integer nBoi(min=0) = 3 "Number of boilers";
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal = sum(
    datBoi.mHeaWatBoi_flow_nominal)
    "HW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Buildings.Templates.Plants.Boilers.HotWater.Components.Data.BoilerGroup datBoi(
    final typMod=boi.typMod,
    final nBoi=nBoi,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    mHeaWatBoi_flow_nominal=datBoi.capBoi_nominal /
      (Buildings.Templates.Data.Defaults.THeaWatSupHig -
        Buildings.Templates.Data.Defaults.THeaWatRetHig) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    capBoi_nominal=fill(1000E3, nBoi),
    dpHeaWatBoi_nominal=fill(
      Buildings.Templates.Data.Defaults.dpHeaWatBoi, nBoi),
    THeaWatSupBoi_nominal=fill(
      Buildings.Templates.Data.Defaults.THeaWatSupHig, nBoi))
    "Design and operating parameters"
    annotation(Placement(transformation(extent={{100,100},{120,120}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumHeaWatPri(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nBoi,
    final m_flow_nominal=fill(
      mHeaWat_flow_nominal / datPumHeaWatPri.nPum, datPumHeaWatPri.nPum),
    dp_nominal=datBoi.dpHeaWatBoi_nominal .+
      Buildings.Templates.Data.Defaults.dpValChe .+
      Buildings.Templates.Data.Defaults.dpValIso)
    "Parameter record for primary HW pumps"
    annotation(Placement(transformation(extent={{100,60},{120,80}})));
  parameter Modelica.Units.SI.Time tau = 10
    "Time constant at nominal flow"
    annotation(Dialog(tab="Dynamics",
      group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  Buildings.Templates.Plants.Boilers.HotWater.Components.BoilerGroup boi(
    redeclare final package Medium=Medium,
    final nBoi=nBoi,
    typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial,
    final is_con=true,
    typArrPumHeaWatPri=Buildings.Templates.Components.Types.PumpArrangement.Headered,
    final dat=datBoi,
    final energyDynamics=energyDynamics)
    "Boiler group"
    annotation(Placement(transformation(extent={{-120,-100},{-40,20}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatPri(
    have_var=false,
    have_valChe=true,
    final nPum=nBoi,
    final dat=datPumHeaWatPri,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary HW pumps"
    annotation(Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumHeaWatPri(
    redeclare final package Medium=Medium,
    final nPorts_a=nBoi,
    final have_comLeg=boi.typArrPumHeaWatPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Headered,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics)
    "Primary HW pumps inlet manifold"
    annotation(Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatPri(
    redeclare final package Medium=Medium,
    final nPorts=nBoi,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics)
    "Primary HW pumps outlet manifold"
    annotation(Placement(transformation(extent={{30,-10},{50,10}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHeaWat_flow_nominal)
    "HW supply temperature"
    annotation(Placement(transformation(extent={{60,-10},{80,10}})));
  Fluid.Sensors.MassFlowRate mHeaWat_flow(redeclare final package Medium=Medium)
    "HW mass flow rate"
    annotation(Placement(transformation(extent={{90,-10},{110,10}})));
  Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium=Medium,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal,
    T=Buildings.Templates.Data.Defaults.THeaWatRetHig,
    nPorts=2)
    "Boundary conditions for HW distribution system"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=-90,
      origin={60,-100})));
  Fluid.Sensors.TemperatureTwoPort THeaWatRet(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mHeaWat_flow_nominal)
    "HW return temperature"
    annotation(Placement(transformation(extent={{30,-90},{10,-70}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlBoi(
    redeclare final package Medium=Medium,
    final nPorts=nBoi,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics)
    "Boiler group inlet manifold"
    annotation(Placement(transformation(extent={{-10,-90},{-30,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1BoiCon[nBoi](
    each table=[0, 0; 1, 1; 2, 0],
    each timeScale=1000,
    each period=2000)
    "Boiler Enable signal - Condensing boilers"
    annotation(Placement(transformation(extent={{-150,90},{-130,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatConSupSet[nBoi](
    y(each final unit="K", each displayUnit="degC"),
    each final k=Buildings.Templates.Data.Defaults.THeaWatSupHig)
    "HW supply temperature setpoint - Condensing boilers"
    annotation(Placement(transformation(extent={{-150,130},{-130,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValBoiConIso[nBoi](
    table=y1BoiCon.table,
    timeScale=y1BoiCon.timeScale,
    period=y1BoiCon.period)
    "Boiler isolation valve opening signal - Condensing boilers"
    annotation(Placement(transformation(extent={{-150,50},{-130,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumHeaWatPriCon[nBoi](
    table=y1BoiCon.table,
    timeScale=y1BoiCon.timeScale,
    period=y1BoiCon.period)
    "Primary HW pump Enable signal - Condensing boilers"
    annotation(Placement(transformation(extent={{-10,90},{-30,110}})));
  protected
  Buildings.Templates.Plants.Boilers.HotWater.Interfaces.Bus busPla
    "Plant control bus"
    annotation(Placement(transformation(extent={{-100,20},{-60,60}}),
      iconTransformation(extent={{-310,60},{-270,100}})));
  Buildings.Templates.Components.Interfaces.Bus busBoiCon[nBoi]
    "Boiler control bus - Condensing boilers"
    annotation(Placement(transformation(extent={{-120,100},{-80,140}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValBoiConIso[nBoi]
    "Boiler isolation valve control bus - Condensing boilers"
    annotation(Placement(transformation(extent={{-120,40},{-80,80}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPriCon
    "Primary HW pump control bus - Condensing boilers"
    annotation(Placement(transformation(extent={{-80,80},{-40,120}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
equation
  connect(inlPumHeaWatPri.ports_b, pumHeaWatPri.ports_a)
    annotation(Line(points={{-10,0},{0,0}},
      color={0,127,255}));
  connect(boi.ports_bHeaWat, inlPumHeaWatPri.ports_a)
    annotation(Line(points={{-40,2.85714},{-36,2.85714},{-36,0},{-30,0}},
      color={0,127,255}));
  connect(outPumHeaWatPri.port_b, THeaWatSup.port_a)
    annotation(Line(points={{50,0},{60,0}},
      color={0,127,255}));
  connect(THeaWatSup.port_b, mHeaWat_flow.port_a)
    annotation(Line(points={{80,0},{90,0}},
      color={0,127,255}));
  connect(inlBoi.ports_b, boi.ports_aHeaWat)
    annotation(Line(points={{-30,-80},{-36,-80},{-36,-82.8571},{-40,-82.8571}},
      color={0,127,255}));
  connect(THeaWatRet.port_b, inlBoi.port_a)
    annotation(Line(points={{10,-80},{-10,-80}},
      color={0,127,255}));
  connect(pumHeaWatPri.ports_b, outPumHeaWatPri.ports_a)
    annotation(Line(points={{20,0},{30,0}},
      color={0,127,255}));
  connect(mHeaWat_flow.port_b, bouHeaWat.ports[1])
    annotation(Line(points={{110,0},{120,0},{120,-80},{59,-80},{59,-90}},
      color={0,127,255}));
  connect(bouHeaWat.ports[2], THeaWatRet.port_a)
    annotation(Line(points={{61,-90},{61,-80},{30,-80}},
      color={0,127,255}));
  connect(busPla, boi.bus)
    annotation(Line(points={{-80,40},{-80,20}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.pumHeaWatPriCon, pumHeaWatPri.bus)
    annotation(Line(points={{-80,40},{10,40},{10,10}},
      color={255,204,51},
      thickness=0.5));
  connect(y1PumHeaWatPriCon.y[1], busPumHeaWatPriCon.y1)
    annotation(Line(points={{-32,100},{-60,100}},
      color={255,0,255}));
  connect(y1BoiCon.y[1], busBoiCon.y1)
    annotation(Line(points={{-128,100},{-100,100},{-100,120}},
      color={255,0,255}));
  connect(y1ValBoiConIso.y[1], busValBoiConIso.y1)
    annotation(Line(points={{-128,60},{-100,60}},
      color={255,0,255}));
  connect(THeaWatConSupSet.y, busBoiCon.THeaWatSupSet)
    annotation(Line(points={{-128,140},{-100,140},{-100,120}},
      color={0,0,127}));
  connect(busBoiCon, busPla.boiCon)
    annotation(Line(points={{-100,120},{-80,120},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(busValBoiConIso, busPla.valBoiConIso)
    annotation(Line(points={{-100,60},{-80,60},{-80,40}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHeaWatPriCon, busPla.pumHeaWatPriCon)
    annotation(Line(points={{-60,100},{-80,100},{-80,40}},
      color={255,204,51},
      thickness=0.5));
annotation(Diagram(coordinateSystem(extent={{-160,-140},{140,160}},
  grid={2,2})),
  experiment(StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Boilers/HotWater/Components/Validation/BoilerGroupPolynomial.mos"
      "Simulate and plot"),
  Documentation(
    info="<html>
<p>
  This model validates the boiler group model
  <a href=\"modelica://Buildings.Templates.Plants.Boilers.HotWater.Components.BoilerGroup\">
    Buildings.Templates.Plants.Boilers.HotWater.Components.BoilerGroup</a>
  in the case where a polynomial is used to represent the boiler efficiency.
  The HW supply temperature setpoint, the HW return temperature and the
  primary HW pump speed are fixed at their design value when the boilers are
  enabled.
</p>
</html>"));
end BoilerGroupPolynomial;
