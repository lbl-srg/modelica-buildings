within Buildings.Fluid.SolarCollectors.Examples;
model FlatPlateWithTank
  "Example showing use of the flat plate solar collector in a complete solar thermal system"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water
    "Fluid in the storage tank";
  replaceable package Medium_2 =
      Buildings.Media.Water "Fluid flowing through the collector";

  Buildings.Fluid.SolarCollectors.ASHRAE93  solCol(
    shaCoe=0,
    redeclare package Medium = Medium_2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    rho=0.2,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=5,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_SolahartKf(),
    nSeg=9,
    lat=0.73097781993588,
    azi=0.3,
    til=0.78539816339745) "Flat plate solar collector model"
    annotation (Placement(transformation(extent={{-2,46},{18,66}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"),
    computeWetBulbTemperature=false) "Weather data file reader"
    annotation (Placement(transformation(extent={{-30,80},{-10,100}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal,
    redeclare package Medium = Medium_2) "Temperature sensor"
    annotation (Placement(transformation(extent={{30,46},{50,66}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn(m_flow_nominal=solCol.m_flow_nominal,
    redeclare package Medium = Medium_2) "Temperature sensor"
    annotation (Placement(transformation(extent={{-34,46},{-14,66}})));
  Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
   tan(
    nSeg=4,
    redeclare package Medium = Medium,
    hTan=1.8,
    m_flow_nominal=0.1,
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
      extent={{-15,-15},{15,15}},
      origin={27,-33})));
  Buildings.Fluid.SolarCollectors.Controls.SolarPumpController
    pumCon(per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_ThermaLiteHS20())
    "Pump controller"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,50})));
  Buildings.HeatTransfer.Sources.FixedTemperature rooT(T=293.15)
    "Room temperature"
    annotation (Placement(transformation(extent={{-40,-92},{-20,-72}})));
  Modelica.Blocks.Math.Gain gain(k=0.04) "Flow rate of the system in kg/s"
    annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={-80,12})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
    Medium, nPorts=1) "Outlet for hot water draw"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-12,-30})));
  Buildings.Fluid.Sources.MassFlowSource_T bou1(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    nPorts=1,
    m_flow=0.001,
    T=288.15) "Inlet and flow rate for hot water draw"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      origin={70,-32})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium_2,
    m_flow_nominal=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump forcing circulation through the system" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-6})));
  Buildings.Fluid.Storage.ExpansionVessel exp(
    redeclare package Medium = Medium_2, V_start=0.1) "Expansion tank"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      origin={-66,-36})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TTan
    "Temperature in the tank water that surrounds the heat exchanger"
    annotation (Placement(transformation(extent={{0,0},{-20,20}})));
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
      points={{-10,90},{-2,90},{-2,65.6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, pumCon.weaBus) annotation (Line(
      points={{-10,90},{-2,90},{-2,72},{-74,72},{-74,60.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rooT.port, tan.heaPorTop)                  annotation (Line(
      points={{-20,-82},{48,-82},{48,-10},{30,-10},{30,-21.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rooT.port, tan.heaPorSid)                  annotation (Line(
      points={{-20,-82},{35.4,-82},{35.4,-33}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumCon.y, gain.u) annotation (Line(
      points={{-80,38.2},{-80,21.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, pum.m_flow_in) annotation (Line(
      points={{-80,3.2},{-80,-6.2},{-62,-6.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_b, TIn.port_a) annotation (Line(
      points={{-50,4},{-50,56},{-34,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_a, exp.port_a) annotation (Line(
      points={{-50,-16},{-50,-46},{-66,-46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(exp.port_a, tan.portHex_b) annotation (Line(
      points={{-66,-46},{-4,-46},{-4,-45},{12,-45}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, tan.portHex_a) annotation (Line(
      points={{50,56},{60,56},{60,-16},{8,-16},{8,-38.7},{12,-38.7}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[1], tan.port_a) annotation (Line(
      points={{-2,-30},{6,-30},{6,-33},{12,-33}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou1.ports[1], tan.port_b) annotation (Line(
      points={{60,-32},{52,-32},{52,-33},{42,-33}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.heaPorVol[3], TTan.port) annotation (Line(
      points={{27,-32.775},{18,-32.775},{18,10},{0,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TTan.T, pumCon.TIn) annotation (Line(
      points={{-20,10},{-44,10},{-44,68},{-84,68},{-84,62}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (                      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/Examples/FlatPlateWithTank.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-6, StopTime=86400.0),
        Documentation(info="<html>
          <p>
            This example shows how several different models can be combined to create
            an entire solar water heating system. The
            <a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhancedInternalHex\">
            Buildings.Fluid.Storage.StratifiedEnhancedInternalHex</a> (tan) model is
            used to represent the tank filled with hot water. A loop, powered by a pump
            (<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
            Buildings.Fluid.Movers.FlowControlled_m_flow</a>, pum), passes the water
            through an expansion tank
            (<a href=\"modelica://Buildings.Fluid.Storage.ExpansionVessel\">
            Buildings.Fluid.Storage.ExpansionVessel</a>, exp), a temperature sensor
            (<a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\">
            Buildings.Fluid.Sensors.TemperatureTwoPort</a>, TIn), the solar collector
            (<a href=\"modelica://Buildings.Fluid.SolarCollectors.ASHRAE93\">
            Buildings.Fluid.SolarCollectors.ASHRAE93,</a> solCol) and a second temperature
            sensor
            (<a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\">
            Buildings.Fluid.Sensors.TemperatureTwoPort</a>, TOut) before re-entering the
            tank.
          </p>
          <p>
            The solar collector is connected to the weather model
            (<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">
            Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>, weaDat) which passes
            information for the San Francisco, CA, USA climate. This information is used to
            identify both the heat gain in the water from the sun and the heat loss to the
            ambient conditions.
          </p>
          <p>
            The flow rate through the pump is controlled by a solar pump controller model
            (<a href=\"modelica://Buildings.Fluid.SolarCollectors.Controls.SolarPumpController\">
            Buildings.Fluid.SolarCollectors.Controls.SolarPumpController</a>, pumCon) and a
            gain model. The controller outputs a binary on (1) / off (0) signal. The on/off
            signal is passed through the gain model, multiplying by 0.04, to represent a
            flow rate of 0.04 kg/s when the pump is active.
          </p>
          <p>
            The heat ports for the tank are connected to an ambient temperature of 20
            degrees C representing the temperature of the room the tank is stored in.
          </p>
          <p>
            bou1 (<a href=\"modelica://Buildings.Fluid.Sources.MassFlowSource_T\">
            Buildings.Fluid.Sources.MassFlowSource_T)</a> provides a constant mass flow
            rate for a hot water draw while bou
            (<a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">
            Buildings.Fluid.Sources.Boundary_pT)</a> provides a boundary
            condition for the outlet of the draw.
          </p>
      </html>",
revisions="<html>
<ul>
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
</html>"));
end FlatPlateWithTank;
