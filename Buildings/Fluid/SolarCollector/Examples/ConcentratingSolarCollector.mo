within Buildings.Fluid.SolarCollector.Examples;
model ConcentratingSolarCollector
  "Example showing the use of ConcentratingSolarCollector"
  import Buildings;
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater;
  Buildings.Fluid.SolarCollector.Concentrating      solCol(
    redeclare package Medium = Medium,
    nSeg=3,
    Cp=4189,
    shaCoe=0,
    I_nominal=800,
    per=Buildings.Fluid.SolarCollector.Data.Concentrating.SRCC2011127A(),
    lat=0.73097781993588,
    azi=0.3,
    til=0.5,
    TMean_nominal=293.15,
    TEnv_nominal=283.15)
             annotation (Placement(transformation(extent={{-14,-20},{6,0}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-34,20},{-14,40}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) annotation (Placement(transformation(extent={{86,-20},{66,0}},
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
    p(displayUnit="Pa") = 101325 + 2*solCol.dp_nominal) annotation (Placement(
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
  connect(weaDat.weaBus,solCol. weaBus) annotation (Line(
      points={{-14,30},{-1.4,30},{-1.4,0}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Commands(file=
          "Resources/Scripts/Dymola/Fluid/SolarCollector/Examples/ConcentratingSolarCollector.mos"
        "Simulate and Plot"),
        Documentation(info="<html>
        <p>
        This model provides an example of how the Concentrating solar collector model is used. In it water is passed through the solar collector while being heated by the sun in
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
        </html>"));
end ConcentratingSolarCollector;
