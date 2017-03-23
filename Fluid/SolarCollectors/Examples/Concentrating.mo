within Buildings.Fluid.SolarCollectors.Examples;
model Concentrating "Example showing the use of Concentrating"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater
    "Medium in the system";
  Buildings.Fluid.SolarCollectors.EN12975           solCol(
    redeclare package Medium = Medium,
    shaCoe=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_shaCoe_in=false,
    per=Buildings.Fluid.SolarCollectors.Data.Concentrating.C_VerificationModel(),
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    rho=0.2,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=5,
    nSeg=9,
    lat=0.73097781993588,
    azi=0.3,
    til=0.5) "Concentrating solar collector model"
    annotation (Placement(transformation(extent={{4,-20},{24,0}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data input file"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) "Inlet for fluid flow"
    annotation (Placement(transformation(extent={{92,-20},{72,0}},rotation=0)));
  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{60,60},{80,80}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{38,-20},{58,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium =
    Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-32,-20},{-12,0}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    use_p_in=true,
    p(displayUnit="Pa")) "Inlet for water flow"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-54,-10})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=3/86400,
    offset=101325,
    amplitude=-2*solCol.dp_nominal)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
equation
  connect(solCol.port_b,TOut. port_a) annotation (Line(
      points={{24,-10},{38,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b,sin. ports[1]) annotation (Line(
      points={{58,-10},{72,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.port_b,solCol. port_a) annotation (Line(
      points={{-12,-10},{4,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{-20,30},{-6,30},{-6,-0.4},{4,-0.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sine.y, sou.p_in) annotation (Line(
      points={{-79,-10},{-72,-10},{-72,-18},{-66,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], TIn.port_a) annotation (Line(
      points={{-44,-10},{-32,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
      <p>
        This model demonstrates the implementation of 
        <a href=\"modelica://Buildings.Fluid.SolarCollectors.EN12975\">
        Buildings.Fluid.SolarCollectors.EN12975</a>.
        In it water is passed through the solar thermal collector while 
        being heated by the sun in the San Francisco, CA, USA climate.
      </p>
    </html>",
    revisions="<html>
      <ul>
        <li>
          Mar 27, 2013 by Peter Grant:<br/>
          First implementation
        </li>
      </ul>
    </html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/Examples/Concentrating.mos"
        "Simulate and Plot"));
end Concentrating;
