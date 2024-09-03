within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses;
partial model PartialStaticTwoPortCoolingTower
  "Base class for test models of cooling towers"

  package Medium_W = Buildings.Media.Water "Medium model for water";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.5
    "Design water flow rate" annotation (Dialog(group="Nominal condition"));

  replaceable
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower tow
     constrainedby
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower(
    redeclare package Medium = Medium_W,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true) "Cooling tower"
    annotation (Placement(transformation(extent={{22,-60},{42,-40}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium_W,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nominalValuesDefineDefaultPressureCurve=true)
    "Pump for condenser water loop"
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));

  Modelica.Blocks.Logical.OnOffController onOffCon(
    bandwidth=2,
    reference(
      unit="K",
      displayUnit="degC"),
    u(unit="K",
      displayUnit="degC"))
    "On/off controller"
    annotation (Placement(transformation(extent={{-20,-200},{0,-180}})));

  Modelica.Blocks.Logical.Switch swi "Control switch for chilled water pump"
    annotation (Placement(transformation(extent={{20,-200},{40,-180}})));

  Modelica.Blocks.Sources.Constant TSwi(k=273.15 + 22)
    "Switch temperature for switching tower pump on"
    annotation (Placement(transformation(extent={{-80,-206},{-60,-186}})));

  Modelica.Blocks.Sources.Constant zer(k=0) "Zero flow rate"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));

  Modelica.Blocks.Sources.Constant m_flow(k=m_flow_nominal)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-20,-168},{0,-148}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(nPorts=3,
    redeclare package Medium = Medium_W,
    m_flow_nominal=m_flow_nominal,
    V=0.5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));

  Buildings.Fluid.Sources.Boundary_pT exp(
    redeclare package Medium = Medium_W,
    nPorts=1) "Expansion vessel"
    annotation (Placement(transformation(extent={{100,-130},{80,-110}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixHeaFlo(
    Q_flow=0.5*m_flow_nominal*4200*5) "Fixed heat flow rate"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TVol
    "Water temperature"
    annotation (Placement(transformation(extent={{-70,-160},{-50,-140}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TEnt(
    redeclare package Medium = Medium_W,
    m_flow_nominal=m_flow_nominal)
    "Water entering temperature"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
equation
  connect(weaDat.weaBus, weaBus)
   annotation (Line(points={{-80,50},{-60,50}},color={255,204,51}));
  connect(onOffCon.y, swi.u2)
   annotation (Line(points={{1,-190},{18,-190}},color={255,0,255}));
  connect(zer.y, swi.u3)
   annotation (Line(points={{1,-220},{8,-220},{8,-198},{18,-198}},
     color={0,0,127}));
  connect(m_flow.y, swi.u1)
   annotation (Line(points={{1,-158},{8,-158},{8,-182},{18,-182}},
     color={0,0,127}));
  connect(vol.ports[1], pum.port_a)
   annotation (Line(points={{28.6667,-120},{-70,-120},{-70,-50}},
      color={0,127,255}));
  connect(fixHeaFlo.port, vol.heatPort)
   annotation (Line(points={{-20,-90},{10,-90},{10,-110},{20,-110}},
     color={191,0,0}));
  connect(vol.heatPort, TVol.port)
   annotation (Line(points={{20,-110},{-80,-110},{-80,-150},{-70,-150}},
      color={191,0,0}));
  connect(tow.port_b, vol.ports[2])
   annotation (Line(points={{42,-50},{60,-50},{60,-120},{30,-120}},
      color={0,127,255}));
  connect(onOffCon.u, TSwi.y)
   annotation (Line(points={{-22,-196},{-59,-196}},color={0,0,127}));
  connect(TVol.T, onOffCon.reference)
   annotation (Line(points={{-49,-150},{-40,-150},{-40,-184},{-22,-184}},
      color={0,0,127}));
  connect(swi.y, pum.m_flow_in)
   annotation (Line(points={{41,-190},{46,-190},{46,-240},{-100,-240},{-100,-30},
          {-60,-30},{-60,-38}},color={0,0,127}));
  connect(exp.ports[1], vol.ports[3])
   annotation (Line(points={{80,-120},{31.3333,-120}},color={0,127,255}));

  connect(pum.port_b, TEnt.port_a)
    annotation (Line(points={{-50,-50},{-40,-50}}, color={0,127,255}));
  connect(TEnt.port_b, tow.port_a)
    annotation (Line(points={{-20,-50},{22,-50}},color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,
            -260},{140,100}})),  Documentation(info="<html>
<p>
Partial model to test cooling tower models that are connected to a weather data reader
and a simple fluid loop to which a constant amount of heat is added.
The pump in the cooling tower loop is switched on and off depending
on the temperature of the control volume to which the heat is added.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 28, 2022, by Hongxiang Fu:<br/>
Added a temperature sensor for better measurement of the entering water
temperature. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2866\">
#2866</a>.
</li>
<li>
January 16, 2020, by Michael Wetter:<br/>
Changed energy balance to dynamic balance and set fan to use the input filter,
which is the default for most applications.
</li>
<li>
July 12, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialStaticTwoPortCoolingTower;
