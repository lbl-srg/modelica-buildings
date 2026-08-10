within Buildings.Templates.Plants.Chillers.Components.Validation;
model ChillerGroupAirCooled
  "Validation model for water-cooled chiller group"
  extends Modelica.Icons.Example;

  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";

  replaceable package MediumAir = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  parameter Integer nChi = 3 "Number of chillers";
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi] =
    capChi_nominal / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq /
    (TChiWatRet_nominal - TChiWatSup_nominal)
    "CHW mass flow rate - Each chiller"
    annotation(Evaluate=true,
      Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWatPri_flow_nominal = sum(
    mChiWatChi_flow_nominal)
    "Primary CHW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConAirChi_flow_nominal[nChi] =
    capChi_nominal * Buildings.Templates.Data.Defaults.ratMFloAirByCapChi
    "Air mass flow rate at condenser - Each air-cooled chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal[nChi] =
    fill(Buildings.Templates.Data.Defaults.dpChiWatChi, nChi)
    "CHW pressure drop - Each chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi](each min=0) =
    fill(1e6, nChi)
    "Cooling capacity - Each chiller (>0)"
    annotation(Dialog(group="Nominal condition"));
  parameter Real COPChi_nominal[nChi](each min=0) = fill(
    Buildings.Templates.Data.Defaults.COPChiAirCoo, nChi)
    "Cooling COP - Each chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal =
    Buildings.Templates.Data.Defaults.TChiWatSup
    "CHW supply temperature";
  parameter Modelica.Units.SI.Temperature TChiWatRet_nominal =
    Buildings.Templates.Data.Defaults.TChiWatRet
    "CHW return temperature";
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
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWatPri(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nChi,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    dp_nominal=1.5 * dpChiWatChi_nominal)
    "Parameter record for primary CHW pumps";
  parameter Buildings.Templates.Plants.Chillers.Components.Data.ChillerGroup datChi(
    final nChi=nChi,
    typ=Buildings.Templates.Components.Types.Chiller.AirCooled,
    final typArrChi=Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel,
    final mChiWatChi_flow_nominal=mChiWatChi_flow_nominal,
    final dpChiWatChi_nominal=dpChiWatChi_nominal,
    final capChi_nominal=capChi_nominal,
    final TChiWatSupChi_nominal=fill(TChiWatSup_nominal, nChi),
    TOut_nominal=Buildings.Templates.Data.Defaults.TOutChi,
    perChi(
      each fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/Chillers/ModularReversible/Validation/York_YCAL0033EE_101kW_3_1COP_AirCooled.txt"),
      each PLRSup={0.1, 0.45, 0.8, 1., 1.15},
      each devIde="York_YCAL0033EE_101kW_3_1COP_AirCooled",
      each use_TEvaOutForTab=true,
      each use_TConOutForTab=false))
    "Parameter record for chiller group"
    annotation(Placement(transformation(extent={{-240,180},{-220,200}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps outlet manifold"
    annotation(Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWatPri,
    final nPum=nChi,
    final have_var=false,
    final energyDynamics=energyDynamics)
    "Primary CHW pumps"
    annotation(Placement(transformation(extent={{-40,90},{-20,110}})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriSup(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW supply temperature"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={30,100})));
  Fluid.Sensors.MassFlowRate mChiWatPri_flow(
    redeclare final package Medium=MediumChiWat)
    "Primary CHW flow"
    annotation(Placement(transformation(extent={{50,90},{70,110}})));
  Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium=MediumChiWat,
    nPorts=1)
    "CHW pressure boundary condition"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=-90,
      origin={40,-100})));
  Plants.Chillers.Components.ChillerGroups.Compression chi(
    redeclare final package MediumChiWat=MediumChiWat,
    redeclare package MediumCon=MediumAir,
    typArrChi=Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel,
    typDisChiWat=Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only,
    final dat=datChi,
    final nChi=nChi,
    final energyDynamics=energyDynamics,
    typ=Buildings.Templates.Components.Types.Chiller.AirCooled,
    typCtlHea=Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.HeadPressureControl.NotRequired,
    typArrPumChiWatPri=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    typArrPumConWat=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
    have_pumConWatVar=false,
    typEco=Buildings.Templates.Plants.Chillers.Types.Economizer.None)
    "Chiller group"
    annotation(Placement(transformation(extent={{-140,-84},{-60,116}})));
  Buildings.Templates.Components.Routing.MultipleToSingle inlChiWatChi(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CHW inlet manifold"
    annotation(Placement(transformation(extent={{-52,-90},{-32,-70}})));
  Buildings.Templates.Components.Routing.MultipleToMultiple inlPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    nPorts_a=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Primary CHW pumps inlet manifold"
    annotation(Placement(transformation(extent={{-60,90},{-40,110}})));
  Fluid.Sources.Boundary_pT bouConAir(
    redeclare final package Medium=MediumAir,
    final nPorts=nChi)
    if chi.typ == Buildings.Templates.Components.Types.Chiller.AirCooled
    "Condenser cooling fluid pressure boundary condition"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-190,20})));
  Fluid.Sources.MassFlowSource_T souConAir[nChi](
    redeclare each final package Medium=MediumAir,
    final m_flow=mConAirChi_flow_nominal,
    each final nPorts=1)
    if chi.typ == Buildings.Templates.Components.Types.Chiller.AirCooled
    "Condenser air flow source"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-190,-20})));
  Fluid.Sensors.TemperatureTwoPort TChiWatPriRet(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal))
    "Primary CHW return temperature"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=0,
      origin={0,-80})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert pump return signal to real"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={240,80})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum comSigLoa(
    k=fill(1 / nChi, nChi),
    nin=nChi)
    "Compute load modulating signal"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={240,50})));
  Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=sum(mChiWatChi_flow_nominal),
    final energyDynamics=energyDynamics,
    final Q_flow_nominal=sum(capChi_nominal),
    dp_nominal=0)
    "Cooling load"
    annotation(Placement(transformation(extent={{88,-90},{68,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet[nChi](
    y(each final unit="K", each displayUnit="degC"),
    each k=Buildings.Templates.Data.Defaults.TChiWatSup)
    "CHW supply temperature set point"
    annotation(Placement(transformation(extent={{-40,350},{-20,370}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yValChiWatChiIso[nChi](
    each k=1)
    if chi.typValChiWatChiIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Chiller CHW isolation valve opening signal"
    annotation(Placement(transformation(extent={{-50,310},{-70,330}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Chi[nChi](
    each table=[0, 0; 1, 0; 1, 1; 2, 1],
    each timeScale=1000,
    each period=2000)
    "Chiller Start/Stop signal"
    annotation(Placement(transformation(extent={{-100,370},{-80,390}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiIso[nChi](
    each table=[0, 0; 1, 0; 1, 1; 2, 1],
    each timeScale=1000,
    each period=2000)
    if chi.typValChiWatChiIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Chiller CHW isolation valve opening signal"
    annotation(Placement(transformation(extent={{-80,330},{-100,350}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValChiWatChiBypSer[nChi](
    each table=[0, 0; 1, 0; 1, 1; 2, 1],
    each timeScale=1000,
    each period=2000)
    "Chiller CHW bypass valve opening signal - Series chillers"
    annotation(Placement(transformation(extent={{-80,290},{-100,310}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1PumChiWatPri[nChi](
    each table=[0, 0; 1, 0; 1, 1; 2, 1],
    each timeScale=1000,
    each period=2000)
    "Primary CHW pump Start/Stop signal"
    annotation(Placement(transformation(extent={{-110,230},{-90,250}})));
  protected
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiIso[nChi]
    "Chiller CHW isolation valve control bus"
    annotation(Placement(transformation(extent={{-200,320},{-160,360}}),
      iconTransformation(extent={{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiBypSer[nChi]
    "Chiller CHW bypass valve control bus - Series chillers"
    annotation(Placement(transformation(extent={{-200,280},{-160,320}}),
      iconTransformation(extent={{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus busChi[nChi]
    "Chiller control bus"
    annotation(Placement(transformation(extent={{180,120},{220,160}}),
      iconTransformation(extent={{-422,198},{-382,238}})));
  Buildings.Templates.Plants.Chillers.Interfaces.Bus busPla
    "Plant control bus"
    annotation(Placement(transformation(extent={{-100,120},{-60,160}}),
      iconTransformation(extent={{-432,12},{-412,32}})));
  protected
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pumps control bus"
    annotation(Placement(transformation(extent={{20,200},{60,240}}),
      iconTransformation(extent={{-316,184},{-276,224}})));
equation
  connect(chi.ports_bCon, bouConAir.ports)
    annotation(Line(points={{-140,112},{-140,20},{-180,20}},
      color={0,127,255}));
  connect(souConAir.ports[1], chi.ports_aCon)
    annotation(Line(points={{-180,-20},{-140,-20},{-140,-80}},
      color={0,127,255}));
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation(Line(points={{-20,100},{-20,100}},
      color={0,127,255}));
  connect(outPumChiWatPri.port_b, TChiWatPriSup.port_a)
    annotation(Line(points={{0,100},{20,100}},
      color={0,127,255}));
  connect(TChiWatPriSup.port_b, mChiWatPri_flow.port_a)
    annotation(Line(points={{40,100},{50,100}},
      color={0,127,255}));
  connect(inlChiWatChi.ports_a, chi.ports_aChiWat)
    annotation(Line(points={{-52,-80},{-60,-80}},
      color={0,127,255}));
  connect(chi.ports_bChiWat, inlPumChiWatPri.ports_a)
    annotation(Line(points={{-60,112},{-60,100}},
      color={0,127,255}));
  connect(inlPumChiWatPri.ports_b, pumChiWatPri.ports_a)
    annotation(Line(points={{-40,100},{-40,100}},
      color={0,127,255}));
  connect(chi.bus, busPla)
    annotation(Line(points={{-100,116.2},{-100,128},{-80,128},{-80,140}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.pumChiWatPri, pumChiWatPri.bus)
    annotation(Line(points={{-80,140},{-29,140},{-29,110},{-30,110}},
      color={255,204,51},
      thickness=0.5),
      Text(string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
  connect(TChiWatPriRet.port_b, inlChiWatChi.port_b)
    annotation(Line(points={{-10,-80},{-32,-80}},
      color={0,127,255}));
  connect(loa.port_a, mChiWatPri_flow.port_b)
    annotation(Line(points={{88,-80},{100,-80},{100,100},{70,100}},
      color={0,127,255}));
  connect(booToRea.y, comSigLoa.u)
    annotation(Line(points={{240,68},{240,62}},
      color={0,0,127}));
  connect(comSigLoa.y, loa.u)
    annotation(Line(points={{240,38},{240,-74},{90,-74}},
      color={0,0,127}));
  connect(busChi.y1_actual, booToRea.u)
    annotation(Line(points={{200,140},{240,140},{240,92}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla.chi, busChi)
    annotation(Line(points={{-80,140},{200,140}},
      color={255,204,51},
      thickness=0.5));
  connect(loa.port_b, TChiWatPriRet.port_a)
    annotation(Line(points={{68,-80},{10,-80}},
      color={0,127,255}));
  connect(bouChiWat.ports[1], loa.port_b)
    annotation(Line(points={{40,-90},{40,-80},{68,-80}},
      color={0,127,255}));
  connect(y1ValChiWatChiBypSer.y[1], busValChiWatChiBypSer.y1)
    annotation(Line(points={{-102,300},{-180,300}},
      color={255,0,255}));
  connect(y1ValChiWatChiIso.y[1], busValChiWatChiIso.y1)
    annotation(Line(points={{-102,340},{-180,340}},
      color={255,0,255}));
  connect(yValChiWatChiIso.y, busValChiWatChiIso.y)
    annotation(Line(points={{-72,320},{-166,320},{-166,340},{-180,340}},
      color={0,0,127}));
  connect(TChiWatSupSet.y, busChi.TChiWatSet)
    annotation(Line(points={{-18,360},{200,360},{200,140}},
      color={0,0,127}));
  connect(y1Chi.y[1], busChi.y1)
    annotation(Line(points={{-78,380},{200,380},{200,140}},
      color={255,0,255}));
  connect(busValChiWatChiBypSer, busPla.valChiWatChiByp)
    annotation(Line(points={{-180,300},{-180,140},{-80,140}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatChiIso, busPla.valChiWatChiIso)
    annotation(Line(
      points={{-180,340},{-184,340},{-184,136},{-80,136},{-80,140}},
      color={255,204,51},
      thickness=0.5));
  connect(y1PumChiWatPri.y[1], busPumChiWatPri.y1)
    annotation(Line(points={{-88,240},{40,240},{40,220}},
      color={255,0,255}));
  connect(busPumChiWatPri, busPla.pumChiWatPri)
    annotation(Line(points={{40,220},{40,140},{-80,140}},
      color={255,204,51},
      thickness=0.5));
annotation(Diagram(coordinateSystem(extent={{-260,-140},{260,220}})),
  experiment(StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Chillers/Components/Validation/ChillerGroupAirCooled.mos"
      "Simulate and plot"),
  Documentation(
    info="<html>
<p>
  This model validates the chiller group model
  <a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.ChillerGroups.Compression\">
    Buildings.Templates.Plants.Chillers.Components.ChillerGroups.Compression</a>
  for air-cooled chillers.
</p>
<p>
  The validation uses open-loop controls and tests a single system
  configuration. The controls are automatically configured (by means of
  parameters bindings with the chiller group component parameters) to provide
  the necessary signals for any system configuration. To test a different
  system configuration, one needs only to modify the chiller group component.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    April 17, 2025, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end ChillerGroupAirCooled;
