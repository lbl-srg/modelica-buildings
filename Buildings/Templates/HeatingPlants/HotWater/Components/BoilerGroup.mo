within Buildings.Templates.HeatingPlants.HotWater.Components;
model BoilerGroup "Boiler group"
  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium";

  parameter Integer nBoi(final min=0)
    "Number of boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.BoilerHotWaterModel typMod
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
    "Parameter record for boiler group"
    annotation (Placement(transformation(extent={{-180,160},{-160,180}})));
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
        origin={400,500})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aHeaWat[nBoi](
    redeclare each final package Medium = Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "HW return"
    annotation (Placement(transformation(extent={{190,-140},{210,-60}}),
        iconTransformation(
        extent={{-10,-40},{10,40}},
        rotation=0,
        origin={400,-500})));
  Buildings.Templates.HeatingPlants.HotWater.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{-20,180},{20,220}}),
    iconTransformation(extent={{-20,680},{20,720}})));

  Buildings.Templates.Components.Boilers.HotWaterPolynomial boiPol[nBoi](
    redeclare each final package Medium = Medium,
    each final is_con=is_con,
    final dat=datBoi,
    each final allowFlowReversal=allowFlowReversal,
    each final energyDynamics=energyDynamics)
    if typMod==Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial
    "Boiler - Polynomial"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Templates.Components.Boilers.HotWaterPolynomial boiTab[nBoi](
    redeclare each final package Medium = Medium,
    each final is_con=is_con,
    final dat=datBoi,
    each final allowFlowReversal=allowFlowReversal,
    each final energyDynamics=energyDynamics)
    if typMod==Buildings.Templates.Components.Types.BoilerHotWaterModel.Table
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
    extent={{-400,-700},{400,700}}), graphics={
    Line(
      points={{200,500},{400,500}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Line(
      visible=nBoi >= 2,
      points={{200,200},{400,200}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Line(
      visible=nBoi >= 3,
      points={{200,-100},{400,-100}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Line(
      visible=nBoi >= 4,
      points={{200,-400},{400,-400}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Text(
      extent={{-151,-712},{149,-752}},
      textColor={0,0,255},
      textString="%name"),
    Bitmap(
          visible=nBoi >= 1,
          extent={{-280,390},{-160,510}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg"),
    Bitmap(
      visible=typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered
        and nBoi>=1,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={300,500}),
    Bitmap(
          visible=typArrPumHeaWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
               and nBoi >= 1,
          extent={{260,560},{340,640}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
          visible=nBoi >= 2,
          extent={{-280,90},{-160,212}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg"),
    Bitmap(
      visible=typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered
        and nBoi>=2,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
          origin={300,200}),
    Bitmap(
          visible=typArrPumHeaWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
               and nBoi >= 2,
          extent={{260,260},{340,340}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
          visible=nBoi >= 3,
          extent={{-280,-212},{-160,-92}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg"),
    Bitmap(
      visible=typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered
        and nBoi>=3,
      extent={{260,-40},{340,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered
        and nBoi>=3,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={300,-100}),
    Bitmap(
          visible=nBoi >= 4,
          extent={{-280,-510},{-160,-390}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg"),
    Bitmap(
      visible=typArrPumHeaWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
        and nBoi >= 4,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={300,-400}),
    Bitmap(
      visible=typArrPumHeaWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered
        and nBoi>=4,
      extent={{260,-340},{340,-260}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Rectangle(
      extent={{200,540},{-160,360}},
      lineColor={0,0,0},
      lineThickness=1),
    Text(
      visible=is_con,
      extent={{-160,520},{200,480}},
      textColor={0,0,0},
      textString="CON"),
    Text(
      extent={{-160,420},{200,380}},
      textColor={0,0,0},
      textString="BOI-1"),
    Line(
      points={{200,400},{400,400}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Rectangle(
      extent={{200,240},{-160,60}},
      lineColor={0,0,0},
      lineThickness=1,
      visible=nBoi >= 2),
    Text(
      visible=nBoi >= 2 and is_con,
      extent={{-160,220},{200,180}},
      textColor={0,0,0},
      textString="CON"),
    Text(
      visible=nBoi >= 2,
      extent={{-160,120},{200,80}},
      textColor={0,0,0},
      textString="BOI-2"),
    Line(
      visible=nBoi >= 2,
      points={{200,100},{400,100}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Rectangle(
      extent={{200,-60},{-160,-240}},
      lineColor={0,0,0},
      lineThickness=1,
      visible=nBoi >= 3),
    Text(
      visible=nBoi >= 3 and is_con,
      extent={{-160,-80},{200,-120}},
      textColor={0,0,0},
      textString="CON"),
    Text(
      visible=nBoi >= 3,
      extent={{-160,-180},{200,-220}},
      textColor={0,0,0},
      textString="BOI-3"),
    Line(
      points={{200,-200},{400,-200}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=nBoi >= 3),
    Rectangle(
      visible=nBoi >= 4,
      extent={{200,-360},{-160,-540}},
      lineColor={0,0,0},
      lineThickness=1),
    Text(
      visible=nBoi >= 4 and is_con,
      extent={{-160,-380},{200,-420}},
      textColor={0,0,0},
      textString="CON"),
    Text(
      visible=nBoi >= 4,
      extent={{-160,-480},{200,-520}},
      textColor={0,0,0},
      textString="BOI-4"),
    Line(
      points={{200,-500},{400,-500}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=nBoi >= 4),
        Line(
          points={{300,562},{300,500}},
          color={0,0,0},
          visible=typArrPumHeaWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
               and nBoi >= 1),
        Line(
          points={{300,262},{300,200}},
          color={0,0,0},
          visible=typArrPumHeaWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
               and nBoi >= 2),
        Line(
          points={{300,-38},{300,-100}},
          color={0,0,0},
          visible=typArrPumHeaWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
               and nBoi >= 3),
        Line(
          points={{300,-338},{300,-400}},
          color={0,0,0},
          visible=typArrPumHeaWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
               and nBoi >= 4)}),
  Diagram(coordinateSystem(extent={{-200,-180},{200,200}})),
    Documentation(info="<html>
<p>
This model represents a group of hot water boilers.
</p>
<p>
Modeling features and limitations:
</p>
<ul>
<li>
All units are either condensing boilers or non-condensing boilers,
depending on the value of the Boolean parameter <code>is_con</code>.
In order to represent a hybrid plant with both condensing and non-condensing
boilers, two instances of this model must be used.
</li>
<li>
All units are modeled based on the same boiler model, specified with the parameter
<code>typMod</code> which is based on the enumeration
<a href=\"modelica://Buildings.Templates.Components.Types.BoilerHotWaterModel\">
Buildings.Templates.Components.Types.BoilerHotWaterModel</a>.
However, the boiler characteristics such as the design capacity
and HW flow rate may be different from one unit to another.
</li>
<li>
Two-way two-position boiler isolation valves are automatically
included in case of headered primary HW pumps, as specified with the parameter
<code>typArrPumHeaWatPri</code> .
</li>
</ul>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
Sub-bus <code>boiCon[:]</code> (resp. <code>boiNon[:]</code>) storing all signals
dedicated to each condensing boiler (resp. non-condensing boiler), with a
dimensionality of one
<ul>
<li>
Boiler Enable signal <code>boi(Con|Non)[:].y1</code> :
DO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Boiler HW supply temperature setpoint <code>boi(Con|Non)[:].THeaWatSupSet</code>:
AO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Boiler firing rate <code>boi(Con|Non)[:].y_actual</code>:
AI signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Boiler HW supply temperature <code>boi(Con|Non)[:].THeaWatSup</code>:
AI signal dedicated to each unit, with a dimensionality of one
</li>
</ul>
</li>
<li>
Sub-bus <code>valBoiConIso[:]</code> (resp. <code>valBoiNonIso[:]</code>)
storing all signals dedicated to each condensing boiler (resp. non-condensing boiler)
isolation valve (if any), with a dimensionality of one
<ul>
<li>
Valve opening command <code>valBoi(Con|Non)Iso[:].y1</code> :
DO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Valve open end switch status <code>valBoi(Con|Non)Iso[:].y1_actual</code> :
DI signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Valve closed end switch status <code>valBoi(Con|Non)Iso[:].y0_actual</code> :
DI signal dedicated to each unit, with a dimensionality of one
</li>
</ul>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 28, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoilerGroup;
