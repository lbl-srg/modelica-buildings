within Buildings.Fluid.SolarCollectors.Examples;
model FlatPlateWithTank
  "Example showing use of the flat plate solar collector in a complete solar thermal system"
  import Buildings;
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater
    "Fluid in the storage tank";
  replaceable package Medium_2 =
      Buildings.Media.ConstantPropertyLiquidWater
    "Fluid flowing through the collector";

  Buildings.Fluid.SolarCollectors.FlatPlate solCol(
    nSeg=3,
    shaCoe=0,
    redeclare package Medium = Medium_2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    rho=0.2,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=5,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    lat=0.73097781993588,
    azi=0.3,
    til=0.78539816339745,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.YourHomeTechHP2014())
    "Flat plate solar collector model"
             annotation (Placement(transformation(extent={{-2,46},{18,66}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos",
      computeWetBulbTemperature=false) "Weather data file reader"
    annotation (Placement(transformation(extent={{-30,80},{-10,100}})));
  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{70,68},{90,88}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal,
    redeclare package Medium = Medium_2) "Temperature sensor"
    annotation (Placement(transformation(extent={{30,46},{50,66}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn(m_flow_nominal=solCol.m_flow_nominal,
      redeclare package Medium = Medium_2) "Temperature sensor"
    annotation (Placement(transformation(extent={{-34,46},{-14,66}})));
  Buildings.Fluid.Storage.StratifiedEnhancedInternalHX
                             tan(
    nSeg=4,
    redeclare package Medium = Medium,
    hTan=1,
    m_flow_nominal=0.1,
    VTan=1.5,
    dIns=0.07,
    redeclare package Medium_2 = Medium_2,
    C=200,
    m_flow_nominal_HX=0.1,
    m_flow_nominal_tank=0.1,
    UA_nominal=300,
    ASurHX=0.199,
    dHXExt=0.01905,
    HXTopHeight=0.9,
    HXBotHeight=0.65,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Storage tank model"
                 annotation (Placement(transformation(
        extent={{-15,-15},{15,15}},
        rotation=180,
        origin={27,-33})));
  Buildings.Fluid.SolarCollectors.Controls.SolarPumpController
                                                     pumCon(per=
        Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.YourHomeTechHP2014())
    "Pump controller"                                                                                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-88,50})));
  Modelica.Blocks.Sources.Constant TRoo(k=273.15 + 20) "Room temperature"
    annotation (Placement(transformation(extent={{-72,-92},{-52,-72}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature rooT
    "Convert TRoo from Real to K"
    annotation (Placement(transformation(extent={{-40,-92},{-20,-72}})));
  Modelica.Blocks.Math.Gain gain(k=0.04) "Flow rate of the system in kg/s"
                                 annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={-88,10})));
  Buildings.Fluid.Sources.Boundary_pT bou(nPorts=1, redeclare package Medium =
        Medium) "Outlet for hot water draw"
                                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,6})));
  Buildings.Fluid.Sources.MassFlowSource_T bou1(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=0.01,
    T=288.15) "Inlet and flow rate for hot water draw"
                                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={44,6})));
  Buildings.Fluid.Movers.FlowMachine_m_flow pum(redeclare package Medium =
        Medium_2, m_flow_nominal=0.1)
    "Pump forcing circulation through the system"                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-6})));
  Buildings.Fluid.Storage.ExpansionVessel exp(redeclare package Medium =
        Medium_2, VTot=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Expansion tank in the system"
                            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-48})));
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
  connect(TIn.T, pumCon.TIn) annotation (Line(
      points={{-24,67},{-24,78},{-92,78},{-92,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, pumCon.weaBus) annotation (Line(
      points={{-10,90},{-2,90},{-2,72},{-82,72},{-82,60.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(TRoo.y, rooT.T)                  annotation (Line(
      points={{-51,-82},{-42,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rooT.port, tan.heaPorTop)                  annotation (Line(
      points={{-20,-82},{24,-82},{24,-44.1}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rooT.port, tan.heaPorSid)                  annotation (Line(
      points={{-20,-82},{18.6,-82},{18.6,-33}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumCon.y, gain.u) annotation (Line(
      points={{-88,38.2},{-88,19.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.ports[1], tan.port_b) annotation (Line(
      points={{-1.33227e-15,-4},{-1.33227e-15,-16},{0,-16},{0,-33},{12,-33}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou1.ports[1], tan.port_a) annotation (Line(
      points={{44,-4},{46,-4},{46,-33},{42,-33}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(gain.y, pum.m_flow_in) annotation (Line(
      points={{-88,1.2},{-88,-6.2},{-62,-6.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_b, TIn.port_a) annotation (Line(
      points={{-50,4},{-50,56},{-34,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_a, exp.port_a) annotation (Line(
      points={{-50,-16},{-50,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(exp.port_a, tan.port_b1) annotation (Line(
      points={{-50,-48},{13.5,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, tan.port_a1) annotation (Line(
      points={{50,56},{62,56},{62,-48},{40.5,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
                      __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/SolarCollectors/Examples/FlatPlateWithTank.mos"
        "Simulate and Plot"),
        Documentation(info="<html>
        <p>
        This example shows how several different models can be combined to create an entire solar water heating system. The <a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhancedInternalHX\">
        Buildings.Fluid.Storage.StratifiedEnhancedInternalHX</a> (tan) model is used to represent the tank filled with hot water. A loop, powered by a pump
        <a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_m_flow\">(Buildings.Fluid.Movers.FlowMachine_m_flow</a>, pum) passes the water through an expansion tank
        <a href=\"modelica://Buildings.Fluid.Storage.ExpansionVessel\"> (Buildings.Fluid.Storage.ExpansionVessel</a>, exp), a temperature sensor
        <a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\"> (Buildings.Fluid.Sensors.TemperatureTwoPort</a>, TIn), the solar collector
        <a href=\"modelica://Buildings.Fluid.SolarCollectors.FlatPlate\"> (Buildings.Fluid.SolarCollectors.FlatPlate,</a> solCol) and a second temperature sensor 
        <a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\"> (Buildings.Fluid.Sensors.TemperatureTwoPort</a>, TOut) before re-entering the tank.
        </p>
        <p>
        The solar collector is connected to the weather model <a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\"> 
        (Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>, weaDat) which passes information for the San Francisco, CA, USA climate. This information is used to identify 
        both the heat gain in the water from the sun and the heat loss to the ambient conditions.
        </p>
        <p>
        The flow rate through the pump is controlled by a solar pump controller model <a href=\"modelica://Buildings.Fluid.SolarCollectors.Controls.SolarPumpController\"> 
        (Buildings.Fluid.SolarCollectors.Controls.SolarPumpController</a>, pumCon) and a gain model. The controller outputs a binary on (1) / off (0) signal. The
        on/off signal is passed through the gain model, multiplying by 0.04, to represent a flow rate of 0.04 kg/s when the pump is active.
        </p>
        <p>
        The heat ports for the tank are connected to an ambient temperature of 20 degrees C representing the temperature of the room the tank is stored in.
        </p>
        <p>
        bou1 <a href=\"modelica://Buildings.Fluid.Sources.MassFlowSource_T\">(Buildings.Fluid.Sources.MassFlowSource_T)</a> provides a constant mass flow rate for a hot water
        draw while bou <a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">(Buildings.Fluid.Sources.Boundary_pT)</a> provides an outlet boundary condition for the outlet
        of the draw.<br>
        </p>
        </html>",
        revisions="<html>
        <ul>
        <li>
        Mar 27, 2013 by Peter Grant:<br>
        First implementation
        </li>
        </ul>
        </html>"));
end FlatPlateWithTank;
