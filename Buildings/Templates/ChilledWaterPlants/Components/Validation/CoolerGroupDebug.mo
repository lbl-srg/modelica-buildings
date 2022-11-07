within Buildings.Templates.ChilledWaterPlants.Components.Validation;
model CoolerGroupDebug "Validation model for cooler group"
  extends Modelica.Icons.Example;

  replaceable package MediumConWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";

  parameter Integer nCoo=2
    "Number of cooler units";

  parameter Modelica.Units.SI.MassFlowRate mConWatCoo_flow_nominal[nCoo]=
    capCoo_nominal/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/
    (TConWatRet_nominal-TConWatSup_nominal)
    "CW mass flow rate - Each cooler unit"
    annotation (Evaluate=true, Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal=
    sum(mConWatCoo_flow_nominal)
    "Total CW mass flow rate (all units)";
  parameter Modelica.Units.SI.PressureDifference dpConWatFriCoo_nominal[nCoo]=
    fill(Buildings.Templates.Data.Defaults.dpConWatFriTow, nCoo)
    "CW flow-friction losses through tower and piping only (without static head or valve)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatStaCoo_nominal[nCoo]=
    fill(Buildings.Templates.Data.Defaults.dpConWatStaTow, nCoo)
    "CW static pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mAirCoo_flow_nominal[nCoo]=
    mConWatCoo_flow_nominal / Buildings.Templates.Data.Defaults.ratFloWatByAirTow
    "Air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capCoo_nominal[nCoo]=fill(1e6, nCoo)
    "Cooling capacity - Each unit (>0)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.Temperature TAirEnt_nominal=
    Buildings.Templates.Data.Defaults.TAirDryCooEnt
    "Entering air drybulb temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TWetBulEnt_nominal=
    Buildings.Templates.Data.Defaults.TWetBulTowEnt
    "Entering air wetbulb temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConWatSup_nominal=
    Buildings.Templates.Data.Defaults.TConWatSup
    "CW supply temperature";
  parameter Modelica.Units.SI.Temperature TConWatRet_nominal=
    Buildings.Templates.Data.Defaults.TConWatRet
    "CW return temperature";

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Buildings.Templates.Components.Data.PumpMultiple datPumConWat(
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    final nPum=nCoo,
    final m_flow_nominal=mConWatCoo_flow_nominal,
    dp_nominal=fill(1.5*max(dpConWatFriCoo_nominal .+ dpConWatStaCoo_nominal), nCoo))
    "Parameter record for CW pumps";
  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.CoolerGroup datCoo(
    final nCoo=nCoo,
    final typCoo=Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen,
    final mConWatCoo_flow_nominal=mConWatCoo_flow_nominal,
    final dpConWatFriCoo_nominal=dpConWatFriCoo_nominal,
    final dpConWatStaCoo_nominal=dpConWatStaCoo_nominal,
    final mAirCoo_flow_nominal=mAirCoo_flow_nominal,
    final TWetBulEnt_nominal=TWetBulEnt_nominal,
    final TConWatSup_nominal=TConWatSup_nominal,
    final TConWatRet_nominal=TConWatRet_nominal,
    PFanCoo_nominal=Buildings.Templates.Data.Defaults.PFanByFloConWatTow * mConWatCoo_flow_nominal)
    "Parameter record for cooler group";

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1[nCoo](
    each table=[0,0; 1.2,0; 1.2,1; 2,1],
    each timeScale=1000,
    each period=2000) "CW pump and cooler Start/Stop signal"
    annotation (Placement(transformation(extent={{-250,210},{-230,230}})));
  Fluid.HeatExchangers.HeaterCooler_u loaCon(
    redeclare final package Medium = MediumConWat,
    final m_flow_nominal=mConWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capCoo_nominal),
    dp_nominal=0) "Load from condenser"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={20,40})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValIso[nCoo](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    "CW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-250,170},{-230,190}})));

  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus busPla
    "Plant control bus"
    annotation (Placement(transformation(extent={{180,100},{220,140}}),
                 iconTransformation(extent={{-432,12},{-412,32}})));
  Buildings.Templates.Components.Pumps.Multiple pumConWat(
    redeclare final package Medium = MediumConWat,
    final dat=datPumConWat,
    final nPum=nCoo,
    final have_var=false)
    "CW pumps"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumConWat(
    redeclare final package Medium = MediumConWat,
    final nPorts=nCoo,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "CW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Templates.Components.Routing.SingleToMultiple outConWatChi(
    redeclare final package Medium = MediumConWat,
    final nPorts=nCoo,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CW outlet manifold"
    annotation (Placement(transformation(extent={{0,-10},{-20,10}})));
  Fluid.Sources.Boundary_pT bouCon(
    redeclare final package Medium =MediumConWat,
    nPorts=1)
    "CW pressure boundary condition" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-80,-30})));
  Buildings.Templates.Components.Interfaces.Bus busPumConWat
    "CW pumps control bus"
    annotation (Placement(transformation(extent={{180,60},{220,100}}),
                         iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nCoo]
    "Convert start signal to real"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,80})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum comSigLoa(
    final k=fill(1/nCoo, nCoo),
    final nin=nCoo)
    "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,50})));
  CoolerGroups.CoolingTowerOpen coo(
    show_T=true,
    redeclare final package MediumConWat = MediumConWat,
    final dat=datCoo,
    final nCoo=nCoo) "Cooler group" annotation (Placement(transformation(
        extent={{40,-40},{-40,40}},
        rotation=0,
        origin={-140,80})));
  Buildings.Templates.Components.Interfaces.Bus valCooOutIso[nCoo]
    "Cooler outlet isolation valve control bus" annotation (Placement(
        transformation(extent={{120,120},{160,160}}), iconTransformation(extent=
           {{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus valCooInlIso[nCoo]
    "Cooler inlet isolation valve control bus"
    annotation (Placement(
        transformation(extent={{80,120},{120,160}}), iconTransformation(extent={
            {-422,198},{-382,238}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoo(k=1)
    "Fan speed signal"
    annotation (Placement(transformation(extent={{-250,250},{-230,270}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-250,130},{-230,150}})));
equation
  connect(pumConWat.ports_a, inlPumConWat.ports_b)
    annotation (Line(points={{-50,0},{-50,0}},       color={0,127,255}));
  connect(y1.y[1], busPumConWat.y1) annotation (Line(points={{-228,220},{160,
          220},{160,80},{200,80}}, color={255,0,255}));
  connect(booToRea.y,comSigLoa. u)
    annotation (Line(points={{240,68},{240,62}},     color={0,0,127}));
  connect(comSigLoa.y, loaCon.u)
    annotation (Line(points={{240,38},{240,20},{26,20},{26,28}},
                                                             color={0,0,127}));
  connect(coo.port_b, inlPumConWat.port_a) annotation (Line(points={{-150,80},{-200,
          80},{-200,0},{-70,0}},           color={0,127,255}));
  connect(bouCon.ports[1], inlPumConWat.port_a) annotation (Line(points={{-80,-20},
          {-80,0},{-70,0}},     color={0,127,255}));
  connect(pumConWat.ports_b, outConWatChi.ports_b)
    annotation (Line(points={{-30,0},{-20,0}},     color={0,127,255}));
  connect(outConWatChi.port_a, loaCon.port_a)
    annotation (Line(points={{0,0},{20,0},{20,30}},      color={0,127,255}));
  connect(loaCon.port_b, coo.port_a) annotation (Line(points={{20,50},{20,80},{-130,
          80}},        color={0,127,255}));
  connect(busPumConWat, pumConWat.bus) annotation (Line(
      points={{200,80},{200,10},{-40,10}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla, coo.bus) annotation (Line(
      points={{200,120},{-140,120}},
      color={255,204,51},
      thickness=0.5));
  connect(valCooInlIso, busPla.valCooInlIso) annotation (Line(
      points={{100,140},{100,120},{200,120}},
      color={255,204,51},
      thickness=0.5));
  connect(valCooOutIso, busPla.valCooOutIso) annotation (Line(
      points={{140,140},{140,120},{200,120}},
      color={255,204,51},
      thickness=0.5));
  connect(y1ValIso.y[1], valCooInlIso.y1) annotation (Line(points={{-228,180},{100,
          180},{100,140}},      color={255,0,255}));
  connect(y1ValIso.y[1], valCooOutIso.y1) annotation (Line(points={{-228,180},{140,
          180},{140,140}}, color={255,0,255}));
  connect(weaDat.weaBus, coo.busWea) annotation (Line(
      points={{-230,140},{-118,140},{-118,120}},
      color={255,204,51},
      thickness=0.5));
  connect(yCoo.y, busPla.yCoo) annotation (Line(points={{-228,260},{200,260},{
          200,120}}, color={0,0,127}));
  connect(y1.y[1], busPla.y1Coo) annotation (Line(points={{-228,220},{180,220},
          {180,124},{200,124},{200,120}}, color={255,0,255}));
  connect(y1.y[1], booToRea.u) annotation (Line(points={{-228,220},{240,220},{
          240,92}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-260,-300},{260,300}})),
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Templates/ChilledWaterPlants/Components/Validation/CoolerGroup.mos"
    "Simulate and plot"));
end CoolerGroupDebug;
