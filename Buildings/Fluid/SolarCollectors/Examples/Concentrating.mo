within Buildings.Fluid.SolarCollectors.Examples;
model Concentrating "Example showing the use of Concentrating"
  import Buildings;
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater
    "Medium in the system";
  Buildings.Fluid.SolarCollectors.Concentrating     solCol(
    redeclare package Medium = Medium,
    nSeg=3,
    shaCoe=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_shaCoe_in=false,
    per=Buildings.Fluid.SolarCollectors.Data.Concentrating.VerificationModel(),
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    rho=0.2,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=5,
    lat=0.73097781993588,
    azi=0.3,
    til=0.5) "Concentrating solar collector model"
             annotation (Placement(transformation(extent={{-14,-20},{6,0}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data input file"
    annotation (Placement(transformation(extent={{-48,20},{-28,40}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) "Inlet for fluid flow"
                                    annotation (Placement(transformation(extent={{86,-20},{66,0}},
          rotation=0)));
  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{66,60},{86,80}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{26,-20},{46,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium =
        Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-54,-20},{-34,0}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    use_p_in=false,
    nPorts=1,
    p(displayUnit="Pa") = 101325 + solCol.dp_nominal) "Outlet for fluid flow"  annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-84,-10})));
equation
  connect(solCol.port_b,TOut. port_a) annotation (Line(
      points={{6,-10},{26,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b,sin. ports[1]) annotation (Line(
      points={{46,-10},{66,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.port_b,solCol. port_a) annotation (Line(
      points={{-34,-10},{-14,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1],TIn. port_a) annotation (Line(
      points={{-74,-10},{-54,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{-28,30},{-20,30},{-20,-0.4},{-14,-0.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
        Documentation(info="<html>
        <p>
        This model demonstrates the implementation of 
        <a href=\"modelica://Buildings.Fluid.SolarCollectors.Concentrating\">
        Buildings.Fluid.SolarCollectors.Concentrating</a>.
        In it water is passed through the solar collector while being heated by 
        the sun in the San Francisco, CA, USA climate.<br/>
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    Commands(file=
          "Resources/Scripts/Dymola/Fluid/SolarCollectors/Examples/Concentrating.mos"
        "Simulate and Plot"));
end Concentrating;
