within Buildings.Templates.ChilledWaterPlants.Components.Validation;
model CoolerGroupCoolingTowerOpen
  "Validation model for cooler group with open-circuit cooling towers"
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
    "Parameter record for CW pumps"
    annotation (Placement(transformation(extent={{180,260},{200,280}})));
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
    "Parameter record for cooler group"
    annotation (Placement(transformation(extent={{220,260},{240,280}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1[nCoo](
    each table=[0,0; 1.2,0; 1.2,1; 2,1],
    each timeScale=1000,
    each period=2000) "CW pump and cooler Start/Stop signal"
    annotation (Placement(transformation(extent={{-250,190},{-230,210}})));
  Fluid.HeatExchangers.HeaterCooler_u loaCon(
    redeclare final package Medium = MediumConWat,
    final m_flow_nominal=mConWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capCoo_nominal),
    dp_nominal=0) "Load from condenser"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={20,20})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1ValIso[nCoo](
    each table=[0,0; 1,0; 1,1; 2,1],
    each timeScale=1000,
    each period=2000)
    "CW isolation valve opening signal"
    annotation (Placement(transformation(extent={{-250,150},{-230,170}})));

  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus busPla
    "Plant control bus"
    annotation (Placement(transformation(extent={{180,80},{220,120}}),
                 iconTransformation(extent={{-432,12},{-412,32}})));
  Buildings.Templates.Components.Pumps.Multiple pumConWat(
    redeclare final package Medium = MediumConWat,
    final dat=datPumConWat,
    final nPum=nCoo,
    final have_var=false)
    "CW pumps"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumConWat(
    redeclare final package Medium = MediumConWat,
    final nPorts=nCoo,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "CW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Buildings.Templates.Components.Routing.SingleToMultiple outConWatChi(
    redeclare final package Medium = MediumConWat,
    final nPorts=nCoo,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CW outlet manifold"
    annotation (Placement(transformation(extent={{0,-30},{-20,-10}})));
  Fluid.Sources.Boundary_pT bouCon(
    redeclare final package Medium =MediumConWat,
    nPorts=1)
    "CW pressure boundary condition" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-80,-50})));
  Buildings.Templates.Components.Interfaces.Bus busPumConWat
    "CW pumps control bus"
    annotation (Placement(transformation(extent={{180,40},{220,80}}),
                         iconTransformation(extent={{-316,184},{-276,224}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nCoo]
    "Convert start signal to real"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,60})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum comSigLoa(
    final k=fill(1/nCoo, nCoo),
    final nin=nCoo)
    "Compute load modulating signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={240,30})));
  CoolerGroups.CoolingTowerOpen coo(
    show_T=true,
    redeclare final package MediumConWat = MediumConWat,
    final dat=datCoo,
    final nCoo=nCoo) "Cooler group" annotation (Placement(transformation(
        extent={{40,-40},{-40,40}},
        rotation=0,
        origin={-140,60})));
  Buildings.Templates.Components.Interfaces.Bus valCooOutIso[nCoo]
    "Cooler outlet isolation valve control bus" annotation (Placement(
        transformation(extent={{120,100},{160,140}}), iconTransformation(extent=
           {{-422,198},{-382,238}})));
  Buildings.Templates.Components.Interfaces.Bus valCooInlIso[nCoo]
    "Cooler inlet isolation valve control bus"
    annotation (Placement(
        transformation(extent={{80,100},{120,140}}), iconTransformation(extent={
            {-422,198},{-382,238}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoo(k=1)
    "Fan speed signal"
    annotation (Placement(transformation(extent={{-250,230},{-230,250}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-250,110},{-230,130}})));
  Fluid.HeatExchangers.HeaterCooler_u loaCon1(
    redeclare final package Medium = MediumConWat,
    final m_flow_nominal=mConWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=sum(capCoo_nominal),
    dp_nominal=0) "Load from condenser"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={20,-160})));
  Buildings.Templates.Components.Pumps.Multiple pumConWat1(
    redeclare final package Medium = MediumConWat,
    final dat=datPumConWat,
    final nPum=nCoo,
    final have_var=false)
    "CW pumps"
    annotation (Placement(transformation(extent={{-50,-210},{-30,-190}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumConWat1(
    redeclare final package Medium = MediumConWat,
    final nPorts=nCoo,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "CW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-70,-210},{-50,-190}})));
  Buildings.Templates.Components.Routing.SingleToMultiple outConWatChi1(
    redeclare final package Medium = MediumConWat,
    final nPorts=nCoo,
    final m_flow_nominal=mConWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    "Chiller group CW outlet manifold"
    annotation (Placement(transformation(extent={{0,-210},{-20,-190}})));
  Fluid.Sources.Boundary_pT bouCon1(redeclare final package Medium =
        MediumConWat, nPorts=1)
    "CW pressure boundary condition" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-80,-230})));
  CoolerGroups.CoolingTowerOpen coo1(
    show_T=true,
    redeclare final package MediumConWat = MediumConWat,
    final dat=datCoo,
    final nCoo=nCoo,
    redeclare replaceable Buildings.Templates.Components.Valves.None
      valCooInlIso "No Valve",
    redeclare replaceable Buildings.Templates.Components.Valves.None
      valCooOutIso "No Valve") "Cooler group" annotation (Placement(
        transformation(
        extent={{40,-40},{-40,40}},
        rotation=0,
        origin={-140,-120})));
  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus busPla1
    "Plant control bus"
    annotation (Placement(transformation(extent={{180,-100},{220,-60}}),
                 iconTransformation(extent={{-432,12},{-412,32}})));
  Buildings.Templates.Components.Interfaces.Bus busPumConWat1
    "CW pumps control bus"
    annotation (Placement(transformation(extent={{180,-140},{220,-100}}),
                         iconTransformation(extent={{-316,184},{-276,224}})));

equation
  connect(pumConWat.ports_a, inlPumConWat.ports_b)
    annotation (Line(points={{-50,-20},{-50,-20}},   color={0,127,255}));
  connect(y1.y[1], busPumConWat.y1) annotation (Line(points={{-228,200},{160,200},
          {160,60},{200,60}},      color={255,0,255}));
  connect(booToRea.y,comSigLoa. u)
    annotation (Line(points={{240,48},{240,42}},     color={0,0,127}));
  connect(comSigLoa.y, loaCon.u)
    annotation (Line(points={{240,18},{240,0},{26,0},{26,8}},color={0,0,127}));
  connect(coo.port_b, inlPumConWat.port_a) annotation (Line(points={{-150,60},{-200,
          60},{-200,-20},{-70,-20}},       color={0,127,255}));
  connect(bouCon.ports[1], inlPumConWat.port_a) annotation (Line(points={{-80,-40},
          {-80,-20},{-70,-20}}, color={0,127,255}));
  connect(pumConWat.ports_b, outConWatChi.ports_b)
    annotation (Line(points={{-30,-20},{-20,-20}}, color={0,127,255}));
  connect(outConWatChi.port_a, loaCon.port_a)
    annotation (Line(points={{0,-20},{20,-20},{20,10}},  color={0,127,255}));
  connect(loaCon.port_b, coo.port_a) annotation (Line(points={{20,30},{20,60},{-130,
          60}},        color={0,127,255}));
  connect(busPumConWat, pumConWat.bus) annotation (Line(
      points={{200,60},{200,-10},{-40,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla, coo.bus) annotation (Line(
      points={{200,100},{-140,100}},
      color={255,204,51},
      thickness=0.5));
  connect(valCooInlIso, busPla.valCooInlIso) annotation (Line(
      points={{100,120},{100,100},{200,100}},
      color={255,204,51},
      thickness=0.5));
  connect(valCooOutIso, busPla.valCooOutIso) annotation (Line(
      points={{140,120},{140,100},{200,100}},
      color={255,204,51},
      thickness=0.5));
  connect(y1ValIso.y[1], valCooInlIso.y1) annotation (Line(points={{-228,160},{100,
          160},{100,120}},      color={255,0,255}));
  connect(y1ValIso.y[1], valCooOutIso.y1) annotation (Line(points={{-228,160},{140,
          160},{140,120}}, color={255,0,255}));
  connect(weaDat.weaBus, coo.busWea) annotation (Line(
      points={{-230,120},{-118,120},{-118,100}},
      color={255,204,51},
      thickness=0.5));
  connect(pumConWat1.ports_a, inlPumConWat1.ports_b)
    annotation (Line(points={{-50,-200},{-50,-200}},
                                                   color={0,127,255}));
  connect(y1.y[1], busPumConWat1.y1) annotation (Line(points={{-228,200},{160,200},
          {160,-120},{200,-120}},      color={255,0,255}));
  connect(coo1.port_b, inlPumConWat1.port_a) annotation (Line(points={{-150,-120},
          {-200,-120},{-200,-200},{-70,-200}},
                                          color={0,127,255}));
  connect(bouCon1.ports[1], inlPumConWat1.port_a) annotation (Line(points={{-80,
          -220},{-80,-200},{-70,-200}},
                                      color={0,127,255}));
  connect(pumConWat1.ports_b, outConWatChi1.ports_b)
    annotation (Line(points={{-30,-200},{-20,-200}},
                                                   color={0,127,255}));
  connect(outConWatChi1.port_a, loaCon1.port_a)
    annotation (Line(points={{0,-200},{20,-200},{20,-170}},
                                                         color={0,127,255}));
  connect(loaCon1.port_b, coo1.port_a)
    annotation (Line(points={{20,-150},{20,-120},{-130,-120}},
                                                        color={0,127,255}));
  connect(busPumConWat1, pumConWat1.bus) annotation (Line(
      points={{200,-120},{200,-190},{-40,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(busPla1, coo1.bus) annotation (Line(
      points={{200,-80},{-140,-80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, coo1.busWea) annotation (Line(
      points={{-230,120},{-220,120},{-220,-60},{-118,-60},{-118,-80}},
      color={255,204,51},
      thickness=0.5));
  connect(yCoo.y, busPla.yCoo) annotation (Line(points={{-228,240},{200,240},{200,
          100}},     color={0,0,127}));
  connect(y1.y[1], busPla.y1Coo) annotation (Line(points={{-228,200},{180,200},{
          180,104},{200,104},{200,100}},  color={255,0,255}));
  connect(y1.y[1], busPla1.y1Coo) annotation (Line(points={{-228,200},{180,200},
          {180,-76},{200,-76},{200,-80}}, color={255,0,255}));
  connect(yCoo.y, busPla1.yCoo) annotation (Line(points={{-228,240},{220,240},{220,
          -80},{200,-80}},     color={0,0,127}));
  connect(y1.y[1], booToRea.u) annotation (Line(points={{-228,200},{240,200},{240,
          72}},     color={255,0,255}));
  connect(comSigLoa.y, loaCon1.u) annotation (Line(points={{240,18},{240,-180},{
          26,-180},{26,-172}},  color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-260,-300},{260,300}})),
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Templates/ChilledWaterPlants/Components/Validation/CoolerGroup.mos"
    "Simulate and plot"),
    Documentation(info="<html>
This model validates the cooler group model
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTowerOpen\">
Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTowerOpen</a>.
</html>"));
end CoolerGroupCoolingTowerOpen;
