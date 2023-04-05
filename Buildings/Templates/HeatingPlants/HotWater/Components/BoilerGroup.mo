within Buildings.Templates.HeatingPlants.HotWater.Components;
model BoilerGroup "Boiler group"
  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";

  parameter Integer nBoi(final min=0)
    "Number of boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.ModelBoilerHotWater typMod
    "Type of boiler model"
    annotation (Evaluate=true);
  parameter Boolean is_con
    "Set to true for condensing boiler, false for non-condensing boiler"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPri
    "Type of primary HW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Buildings.Templates.Components.Types.Valve typValBoiIso=
    if typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Dedicated then
      Buildings.Templates.Components.Types.Valve.None
    else Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Type of boiler HW isolation valve";

  parameter Buildings.Templates.HeatingPlants.HotWater.Components.Data.BoilerGroup dat(
    final nBoi=nBoi,
    final typMod=typMod)
    "Parameter record for boiler group";
  final parameter Buildings.Templates.Components.Data.BoilerHotWater datBoi[nBoi](
    final typMod=fill(typMod, nBoi),
    each final fue=dat.fue,
    final mHeaWat_flow_nominal=mHeaWatBoi_flow_nominal,
    final cap_nominal=capBoi_nominal,
    final dpHeaWat_nominal=if typValBoiIso==Buildings.Templates.Components.Types.Valve.None then
      dat.dpHeaWatBoi_nominal else fill(0, nBoi),
    final THeaWatSup_nominal=dat.THeaWatBoiSup_nominal,
    final per=dat.per)
    "Parameter record of each boiler";
  final parameter Buildings.Templates.Components.Data.Valve datValBoiIso[nBoi](
    final typ=fill(typValBoiIso, nBoi),
    final m_flow_nominal=mHeaWatBoi_flow_nominal,
    dpValve_nominal=fill(Buildings.Templates.Data.Defaults.dpValIso, nBoi),
    dpFixed_nominal=if typValBoiIso<>Buildings.Templates.Components.Types.Valve.None then
      dat.dpHeaWatBoi_nominal else fill(0, nBoi))
    "Parallel boilers HW bypass valve parameters"
    annotation (Dialog(enable=false));

  final parameter Modelica.Units.SI.MassFlowRate mHeaWatBoi_flow_nominal[nBoi]=
    dat.mHeaWatBoi_flow_nominal
    "HW mass flow rate - Each boiler";
  final parameter Modelica.Units.SI.HeatFlowRate capBoi_nominal[nBoi]=
    dat.capBoi_nominal
    "Heating capacity - Each boiler";
  final parameter Modelica.Units.SI.PressureDifference dpHeaWatBoi_nominal[nBoi]=
    dat.dpHeaWatBoi_nominal
    "HW pressure drop - Each boiler";
  final parameter Modelica.Units.SI.Temperature THeaWatBoiSup_nominal[nBoi]=
    dat.THeaWatBoiSup_nominal
    "HW supply temperature - Each boiler";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPorts_b ports_bHeaWat[nBoi](
    redeclare each final package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "HW supply"
    annotation (Placement(transformation(extent={{190,80},{210,160}}),
        iconTransformation(
        extent={{-10,-40},{10,40}},
        rotation=0,
        origin={400,400})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aHeaWat[nBoi](
    redeclare each final package Medium = Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "HW return"
    annotation (Placement(transformation(extent={{190,-140},{210,-60}}),
        iconTransformation(
        extent={{-10,-40},{10,40}},
        rotation=0,
        origin={400,-400})));
  Buildings.Templates.HeatingPlants.HotWater.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{-20,180},{20,220}}),
    iconTransformation(extent={{-20,580},{20,620}})));

  Buildings.Templates.Components.Boilers.HotWaterPolynomial boiPol[nBoi](
    redeclare each final package Medium = Medium,
    each final is_con=is_con,
    final dat=datBoi,
    each final allowFlowReversal=allowFlowReversal,
    each final energyDynamics=energyDynamics)
    if typMod==Buildings.Templates.Components.Types.ModelBoilerHotWater.Polynomial
    "Boiler - Polynomial"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Templates.Components.Boilers.HotWaterPolynomial boiTab[nBoi](
    redeclare each final package Medium = Medium,
    each final is_con=is_con,
    final dat=datBoi,
    each final allowFlowReversal=allowFlowReversal,
    each final energyDynamics=energyDynamics)
    if typMod==Buildings.Templates.Components.Types.ModelBoilerHotWater.Table
    "Boiler - Table"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

  Buildings.Templates.Components.Valves.TwoWayTwoPosition valBoiIso[nBoi](
    redeclare each final package Medium=Medium,
    final dat=datValBoiIso,
    each final allowFlowReversal=allowFlowReversal)
    if typValBoiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Boiler isolation valve"
    annotation (Placement(transformation(extent={{150,110},{170,130}})));
  Buildings.Templates.Components.Routing.PassThroughFluid pas[nBoi](
    redeclare each final package Medium=Medium)
    if typValBoiIso==Buildings.Templates.Components.Types.Valve.None
    "No boiler isolation valve"
    annotation (Placement(transformation(extent={{150,90},{170,110}})));

protected
  Buildings.Templates.Components.Interfaces.Bus busBoiCon[nBoi] if is_con
    "Boiler control bus - Condensing boilers"
    annotation (Placement(
        transformation(extent={{-60,140},{-20,180}}),iconTransformation(extent={
            {-350,6},{-310,46}})));
  Buildings.Templates.Components.Interfaces.Bus busBoiNon[nBoi] if not is_con
    "Boiler control bus - Non-condensing boilers"
    annotation (Placement(
      transformation(extent={{-100,140},{-60,180}}),
      iconTransformation(extent={{-350,6},{-310,46}})));
  Buildings.Templates.Components.Interfaces.Bus busValBoiNonIso[nBoi]
    if not is_con "Boiler isolation valve control bus - Non-condensing boilers"
    annotation (Placement(transformation(extent={{80,140},{120,180}}),
        iconTransformation(extent={{-350,6},{-310,46}})));
protected
  Buildings.Templates.Components.Interfaces.Bus busValBoiConIso[nBoi] if is_con
    "Boiler isolation valve control bus - Condensing boilers" annotation (
      Placement(transformation(extent={{140,140},{180,180}}),
        iconTransformation(extent={{-350,6},{-310,46}})));
equation
  connect(ports_aHeaWat, boiPol.port_a) annotation (Line(points={{200,-100},{-20,
          -100},{-20,0},{-10,0}}, color={0,127,255}));
  connect(boiPol.port_b, valBoiIso.port_a) annotation (Line(points={{10,0},{20,0},
          {20,120},{150,120}}, color={0,127,255}));
  connect(valBoiIso.port_b, ports_bHeaWat)
    annotation (Line(points={{170,120},{200,120}}, color={0,127,255}));
  connect(pas.port_b, ports_bHeaWat) annotation (Line(points={{170,100},{180,
          100},{180,120},{200,120}}, color={0,127,255}));
  connect(boiPol.port_b, pas.port_a) annotation (Line(points={{10,0},{20,0},{20,
          100},{150,100}},                     color={0,127,255}));
  connect(busBoiCon, boiPol.bus) annotation (Line(
      points={{-40,160},{-40,-40},{0,-40},{0,10}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.boiCon, busBoiCon) annotation (Line(
      points={{0,200},{0,180},{-40,180},{-40,160}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.boiNon, busBoiNon) annotation (Line(
      points={{0,200},{0,180},{-80,180},{-80,160}},
      color={255,204,51},
      thickness=0.5));
  connect(busBoiNon, boiPol.bus) annotation (Line(
      points={{-80,160},{-80,10},{0,10}},
      color={255,204,51},
      thickness=0.5));
  connect(valBoiIso.bus, busValBoiConIso) annotation (Line(
      points={{160,130},{160,160}},
      color={255,204,51},
      thickness=0.5));
  connect(busValBoiNonIso, valBoiIso.bus) annotation (Line(
      points={{100,160},{100,130},{160,130}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.valBoiNonIso, busValBoiNonIso) annotation (Line(
      points={{0,200},{0,180},{100,180},{100,160}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.valBoiConIso, busValBoiConIso) annotation (Line(
      points={{0,200},{4,200},{4,184},{160,184},{160,160}},
      color={255,204,51},
      thickness=0.5));
  connect(ports_aHeaWat, boiTab.port_a) annotation (Line(points={{200,-100},{-20,
          -100},{-20,-50},{-10,-50}}, color={0,127,255}));
  connect(boiTab.port_b, pas.port_a) annotation (Line(points={{10,-50},{20,-50},
          {20,100},{150,100}},         color={0,127,255}));
  connect(boiTab.port_b, valBoiIso.port_a) annotation (Line(points={{10,-50},{
          20,-50},{20,120},{150,120}},
                                    color={0,127,255}));
  connect(busBoiCon, boiTab.bus) annotation (Line(
      points={{-40,160},{-40,10},{0,10},{0,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busBoiNon, boiTab.bus) annotation (Line(
      points={{-80,160},{-80,-40},{0,-40}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-400,-600},{400,600}}), graphics={
        Text(
          extent={{-149,-610},{151,-650}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(extent={{-200,-180},{200,200}})));
end BoilerGroup;
