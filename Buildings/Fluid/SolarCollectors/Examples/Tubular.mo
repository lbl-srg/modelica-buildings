within Buildings.Fluid.SolarCollectors.Examples;
model Tubular "Example showing the use of Tubular"
  import Buildings;
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater
    "Medium in the system";
  Buildings.Fluid.SolarCollectors.Tubular           solCol(
    redeclare package Medium = Medium,
    nSeg=3,
    shaCoe=0,
    G_nominal=800,
    per=Buildings.Fluid.SolarCollectors.Data.Tubular.SRCC2012033A(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    lat=0.73097781993588,
    azi=0.3,
    til=0.5,
    TEnv_nominal=283.15,
    TIn_nominal=293.15,
    use_shaCoe_in=false) "Tubular solar collector model"
             annotation (Placement(transformation(extent={{-12,-20},{8,0}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data input file"
    annotation (Placement(transformation(extent={{-32,20},{-12,40}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) "Inlet for fluid flow" annotation (Placement(transformation(extent={{88,-20},{68,0}},
          rotation=0)));
  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{68,60},{88,80}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{28,-20},{48,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium =
        Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-52,-20},{-32,0}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    use_p_in=false,
    nPorts=1,
    p(displayUnit="Pa") = 101325 + solCol.dp_nominal) "Outlet for water flow"  annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-82,-10})));
equation
  connect(solCol.port_b,TOut. port_a) annotation (Line(
      points={{8,-10},{28,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b,sin. ports[1]) annotation (Line(
      points={{48,-10},{68,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.port_b,solCol. port_a) annotation (Line(
      points={{-32,-10},{-12,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1],TIn. port_a) annotation (Line(
      points={{-72,-10},{-52,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus,solCol. weaBus) annotation (Line(
      points={{-12,30},{0.6,30},{0.6,0}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (__Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/SolarCollectors/Examples/Tubular.mos"
        "Simulate and Plot"),
        Documentation(info="<html>
        <p>
        This model demonstrates the implementation of <a href=\"modelica://Buildings.Fluid.SolarCollectors.Tubular\">Buildings.Fluid.SolarCollectors.Tubular</a>. In it water is passed through a tubular solar collector while being heated by the sun in
        the San Francisco, CA, USA climate.<br>
        </p>
        </html>",
        revisions="<html>
        <ul>
        <li>
        Mar 27, 2013 by Peter Grant:<br>
        First implementation
        </li>
        </ul>
        </html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end Tubular;
