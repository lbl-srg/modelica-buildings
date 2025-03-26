within Buildings.Fluid.SolarCollectors.Examples;
model FlatPlateWithTank
  "Example showing use of the flat plate solar collector in a complete solar thermal system"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water
    "Fluid in the storage tank";
  replaceable package Medium_2 = Buildings.Media.Water "Fluid flowing through the collector";

  parameter Modelica.Units.SI.Angle azi=0.3
    "Surface azimuth (0 for south-facing; -90 degree for east-facing; +90 degree for west facing";
  parameter Modelica.Units.SI.Angle til=0.78539816339745
    "Surface tilt (0 for horizontally mounted collector)";
  parameter Real rho=0.2 "Ground reflectance";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = solCol.m_flow_nominal
    "Nominal mass flow rate";

  Buildings.Fluid.SolarCollectors.ASHRAE93 solCol(
    redeclare package Medium = Medium_2,
    shaCoe=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=5,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_SolahartKf(),
    nSeg=9,
    final azi=azi,
    final til=til,
    final rho=rho) "Flat plate solar collector model"
    annotation (Placement(transformation(extent={{-2,46},{18,66}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"),
    computeWetBulbTemperature=false) "Weather data file reader"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    T_start(displayUnit="K"),
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium_2) "Temperature sensor"
    annotation (Placement(transformation(extent={{30,46},{50,66}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn(m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium_2) "Temperature sensor"
    annotation (Placement(transformation(extent={{-34,46},{-14,66}})));
  Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
   tan(
    nSeg=4,
    redeclare package Medium = Medium,
    hTan=1.8,
    m_flow_nominal=m_flow_nominal,
    VTan=1.5,
    dIns=0.07,
    redeclare package MediumHex = Medium_2,
    CHex=200,
    dExtHex=0.01905,
    hHex_a=0.9,
    hHex_b=0.65,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=3000,
    mHex_flow_nominal=3000/20/4200,
    T_start=293.15,
    TTan_nominal=293.15,
    THex_nominal=323.15,
    energyDynamicsHex=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Storage tank model"
    annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      origin={100,-20})));
  Buildings.Fluid.SolarCollectors.Controls.CollectorPump pumCon(
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_ThermaLiteHS20(),
    final azi=azi,
    final til=til,
    final rho=rho)
    "Pump controller"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,0})));
  Buildings.HeatTransfer.Sources.FixedTemperature rooT(T=293.15)
    "Room temperature"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
    Medium, nPorts=1) "Outlet for hot water draw"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=180,
      origin={150,20})));
  Buildings.Fluid.Sources.MassFlowSource_T bou1(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    nPorts=1,
    m_flow=0.001,
    T=288.15) "Inlet and flow rate for hot water draw"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      origin={150,-20})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium_2,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nominalValuesDefineDefaultPressureCurve=true)
    "Pump forcing circulation through the system" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,0})));
  Buildings.Fluid.Storage.ExpansionVessel exp(
    redeclare package Medium = Medium_2, V_start=0.1) "Expansion tank"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      origin={0,-20})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TTan
    "Temperature in the tank water that surrounds the heat exchanger"
    annotation (Placement(transformation(extent={{-80,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=
        m_flow_nominal)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
equation
  connect(solCol.port_b,TOut. port_a) annotation (Line(
      points={{18,56},{30,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.port_b,solCol. port_a) annotation (Line(
      points={{-14,56},{-2,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus,solCol. weaBus) annotation (Line(
      points={{-160,70},{-2,70},{-2,64}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, pumCon.weaBus) annotation (Line(
      points={{-160,70},{-152,70},{-152,5},{-140,5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rooT.port, tan.heaPorTop)                  annotation (Line(
      points={{40,-80},{48,-80},{48,0},{104,0},{104,-5.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rooT.port, tan.heaPorSid)                  annotation (Line(
      points={{40,-80},{111.2,-80},{111.2,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pum.port_b, TIn.port_a) annotation (Line(
      points={{-50,10},{-50,56},{-34,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_a, exp.port_a) annotation (Line(
      points={{-50,-10},{-50,-36},{0,-36},{0,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(exp.port_a, tan.portHex_b) annotation (Line(
      points={{0,-30},{0,-36},{80,-36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, tan.portHex_a) annotation (Line(
      points={{50,56},{68,56},{68,-27.6},{80,-27.6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[1], tan.port_a) annotation (Line(
      points={{140,20},{100,20},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou1.ports[1], tan.port_b) annotation (Line(
      points={{140,-20},{120,-20},{120,-40},{100,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.heaPorVol[3], TTan.port) annotation (Line(
      points={{100,-19.85},{98,-19.85},{98,-20},{96,-20},{96,30},{-80,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TTan.T, pumCon.TIn) annotation (Line(
      points={{-101,30},{-160,30},{-160,-4},{-142,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumCon.on, booToRea.u)
    annotation (Line(points={{-118,0},{-102,0}}, color={255,0,255}));
  connect(pum.m_flow_in, booToRea.y) annotation (Line(points={{-62,7.77156e-16},
          {-70,7.77156e-16},{-70,0},{-78,0}}, color={0,0,127}));
  annotation (
   __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/Examples/FlatPlateWithTank.mos"
        "Simulate and plot"),
   experiment(Tolerance=1e-6, StopTime=86400.0),
        Documentation(info="<html>
<p>
This example shows how several different models can be combined to create
an entire solar water heating system.
The
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhancedInternalHex\">
Buildings.Fluid.Storage.StratifiedEnhancedInternalHex</a> (tan) model is
used to represent the tank filled with hot water.
A loop, powered by a pump
(<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>, pum), 
passes the water through an expansion tank
(<a href=\"modelica://Buildings.Fluid.Storage.ExpansionVessel\">
Buildings.Fluid.Storage.ExpansionVessel</a>, exp),
a temperature sensor
(<a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\">
Buildings.Fluid.Sensors.TemperatureTwoPort</a>, TIn),
the solar collector
(<a href=\"modelica://Buildings.Fluid.SolarCollectors.ASHRAE93\">
Buildings.Fluid.SolarCollectors.ASHRAE93,</a> solCol),
and a second temperature sensor
(<a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\">
Buildings.Fluid.Sensors.TemperatureTwoPort</a>, TOut)
before re-entering the tank.
</p>
<p>
The solar collector is connected to the weather model
(<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">
Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>, weaDat) which passes
information for the San Francisco, CA, USA climate.
This information is used to identify both the heat gain in the water 
from the sun and the heat loss to the ambient conditions.
</p>
<p>
The flow rate through the pump is controlled by a solar pump controller model
(<a href=\"modelica://Buildings.Fluid.SolarCollectors.Controls.CollectorPump\">
Buildings.Fluid.SolarCollectors.Controls.CollectorPump</a>, pumCon)
and a gain model.
The controller outputs a binary on (1) / off (0) signal.
The on/off signal is passed through a boolean to real signal converter 
to set the pump mass flow rate.
</p>
<p>
The heat ports for the tank are connected to an ambient temperature of 
20 degrees C representing the temperature of the room the tank is stored in.
</p>
<p>
bou1 (<a href=\"modelica://Buildings.Fluid.Sources.MassFlowSource_T\">
Buildings.Fluid.Sources.MassFlowSource_T)</a> provides a constant mass flow
rate for a hot water draw while bou
(<a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">
Buildings.Fluid.Sources.Boundary_pT)</a> 
provides a boundary condition for the outlet of the draw.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 15, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
November 7, 2022, by Michael Wetter:<br/>
Revised example to provide values for new parameters and to integrate the revised solar pump controller.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3074\">issue 3074</a>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter assignment for <code>lat</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
April 18, 2014, by Michael Wetter:<br/>
Updated model to use the revised tank and increased the tank height.
</li>
<li>
March 25, 2014, by Michael Wetter:<br/>
Updated model with new expansion vessel.
</li>
<li>
March 27, 2013 by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-200,-100},{180,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end FlatPlateWithTank;
