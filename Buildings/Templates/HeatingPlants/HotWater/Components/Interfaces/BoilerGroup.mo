within Buildings.Templates.HeatingPlants.HotWater.Components.Interfaces;
model BoilerGroup "Boiler group"
  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";

  parameter Integer nBoi(final min=0)
    "Number of boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.ModelBoilerHotWater typMod
    "Type of boiler model"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean is_con
    "Set to true for condensing boiler, false for non-condensing boiler"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumHeaWatPri "Type of primary HW pump arrangement"
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
    iconTransformation(extent={{-20,780},{20,820}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator THeaWatSupSet(nout=nBoi)
    "Replicating common HW supply temperature setpoint"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,170})));
  Modelica.Blocks.Routing.BooleanPassThrough pasEna[nBoi]
    "Direct pass through for Enable signal"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,170})));

  replaceable Buildings.Templates.Components.Interfaces.BoilerHotWater boi[nBoi]
    constrainedby Buildings.Templates.Components.Interfaces.BoilerHotWater(
    redeclare each final package Medium=Medium,
    each final is_con=is_con,
    final dat=datBoi,
    each final allowFlowReversal=allowFlowReversal,
    each final energyDynamics=energyDynamics)
    "Boiler"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
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
  Buildings.Templates.Components.Interfaces.Bus busBoi[nBoi]
    "Boiler control bus"
    annotation (Placement(transformation(extent={{-20,120},
            {20,160}}), iconTransformation(extent={{-350,6},{-310,46}})));
equation
  connect(bus.THeaWatSupSet, THeaWatSupSet.u) annotation (Line(
      points={{0,200},{0,182}},
      color={255,204,51},
      thickness=0.5));
  connect(THeaWatSupSet.y, busBoi.THeaWatSupSet)
    annotation (Line(points={{0,158},{0,140}}, color={0,0,127}));
  connect(bus.y1Boi, pasEna.u) annotation (Line(
      points={{0,200},{0,190},{-40,190},{-40,182}},
      color={255,204,51},
      thickness=0.5));
  connect(pasEna.y, busBoi.y1)
    annotation (Line(points={{-40,159},{-40,140},{0,140}}, color={255,0,255}));
  connect(ports_aHeaWat, boi.port_a) annotation (Line(points={{200,-100},{-20,
          -100},{-20,0},{-10,0}}, color={0,127,255}));
  connect(boi.port_b, valBoiIso.port_a) annotation (Line(points={{10,0},{20,0},
          {20,120},{150,120}}, color={0,127,255}));
  connect(valBoiIso.port_b, ports_bHeaWat)
    annotation (Line(points={{170,120},{200,120}}, color={0,127,255}));
  connect(pas.port_b, ports_bHeaWat) annotation (Line(points={{170,100},{180,
          100},{180,120},{200,120}}, color={0,127,255}));
  connect(boi.port_b, pas.port_a) annotation (Line(points={{10,0},{20,0},{20,
          120},{140,120},{140,100},{150,100}}, color={0,127,255}));
  connect(busBoi, boi.bus) annotation (Line(
      points={{0,140},{0,10}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.valBoiIso, valBoiIso.bus) annotation (Line(
      points={{0,200},{0,190},{160,190},{160,130}},
      color={255,204,51},
      thickness=0.5));
  connect(busBoi, bus.boi) annotation (Line(
      points={{0,140},{40,140},{40,200},{0,200}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-400,-800},{400,800}}), graphics={
        Text(
          extent={{-149,-810},{151,-850}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(extent={{-200,-180},{200,200}})));
end BoilerGroup;
