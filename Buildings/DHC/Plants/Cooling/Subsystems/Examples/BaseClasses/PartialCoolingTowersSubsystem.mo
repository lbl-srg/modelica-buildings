within Buildings.DHC.Plants.Cooling.Subsystems.Examples.BaseClasses;
partial model PartialCoolingTowersSubsystem
  "Partial class for test models of subsystems"

  package Medium_W = Buildings.Media.Water "Medium model for water";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.5
    "Design water flow rate" annotation (Dialog(group="Nominal condition"));

  replaceable
    Buildings.Fluid.Interfaces.PartialTwoPortInterface tow
    constrainedby Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare package Medium = Medium_W,
    m_flow_nominal=m_flow_nominal,
    show_T=true) "Cooling tower"
    annotation (Placement(transformation(extent={{22,-60},{42,-40}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium_W,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nominalValuesDefineDefaultPressureCurve=true,
    use_riseTime=false) "Pump for condenser water loop"
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi "Control switch for chilled water pump"
    annotation (Placement(transformation(extent={{80,-200},{100,-180}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSwi(
    k=273.15 + 22,
    y(unit="K",
      displayUnit="degC"))
    "Switch temperature for switching tower pump on"
    annotation (Placement(transformation(extent={{-80,-206},{-60,-186}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(k=0) "Zero flow rate"
    annotation (Placement(transformation(extent={{20,-230},{40,-210}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant m_flow(k=m_flow_nominal)
    "Water flow rate"
    annotation (Placement(transformation(extent={{20,-168},{40,-148}})));

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

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=-1,
    final uHigh=1)
    "Pump on-off control"
    annotation (Placement(transformation(extent={{20,-200},{40,-180}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sub "Inputs different"
    annotation (Placement(transformation(extent={{-20,-200},{0,-180}})));

equation
  connect(weaDat.weaBus, weaBus)
   annotation (Line(points={{-80,50},{-60,50}},color={255,204,51}));
  connect(zer.y, swi.u3)
   annotation (Line(points={{42,-220},{60,-220},{60,-198},{78,-198}},
     color={0,0,127}));
  connect(m_flow.y, swi.u1)
   annotation (Line(points={{42,-158},{60,-158},{60,-182},{78,-182}},
     color={0,0,127}));
  connect(vol.ports[1], pum.port_a)
   annotation (Line(points={{28.6667,-120},{-76,-120},{-76,-50},{-70,-50}},
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
  connect(swi.y, pum.m_flow_in)
   annotation (Line(points={{102,-190},{120,-190},{120,-240},{-100,-240},{-100,-32},
          {-60,-32},{-60,-38}},      color={0,0,127}));
  connect(exp.ports[1], vol.ports[3])
   annotation (Line(points={{80,-120},{31.3333,-120}},color={0,127,255}));
  connect(pum.port_b, TEnt.port_a)
    annotation (Line(points={{-50,-50},{-40,-50}}, color={0,127,255}));
  connect(TEnt.port_b, tow.port_a)
    annotation (Line(points={{-20,-50},{22,-50}},color={0,127,255}));
  connect(sub.y, hys.u)
    annotation (Line(points={{2,-190},{18,-190}}, color={0,0,127}));
  connect(TVol.T, sub.u1) annotation (Line(points={{-49,-150},{-40,-150},{-40,-184},
          {-22,-184}}, color={0,0,127}));
  connect(TSwi.y, sub.u2)
    annotation (Line(points={{-58,-196},{-22,-196}}, color={0,0,127}));
  connect(hys.y, swi.u2)
    annotation (Line(points={{42,-190},{78,-190}}, color={255,0,255}));
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
December 11, 2023, by Jianjun Hu:<br/>
Reimplemented pump on-off control to avoid using the obsolete <code>OnOffController</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3595\">#3595</a>.
</li>
<li>
November 16, 2022, by Michael Wetter:<br/>
Set <code>use_inputFilter=false</code>.
</li>
<li>
January 28, 2022, by Hongxiang Fu:<br/>
Added a temperature sensor for better measurement of the entering water
temperature. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2866\">
#2866</a>.
</li>
<li>
May 28, 2021, by Chengnan Shi:<br/>
Duplicate <a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTower\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTower</a><br/>
Changed replaceable cooling tower model to <code>PartialTwoPortInterface</code>
for reusability in
<a href=\"modelica://Buildings.DHC.Plants.Cooling.Subsystems.Examples\">
Buildings.DHC.Plants.Cooling.Subsystems.Examples</a>.
</li>
</ul>
</html>"));
end PartialCoolingTowersSubsystem;
