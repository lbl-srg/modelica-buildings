within Buildings.Fluid.Air.Example.BaseClasses;
partial model PartialAirHandlerControl
  "Partial model for testing air hanlders with temperature and humidity control"
  package Medium1 = Buildings.Media.Water "Medium model for water";
  package Medium2 = Buildings.Media.Air
    "Medium model for air";
  parameter Buildings.Fluid.Air.Example.Data.Data_I dat
  "Performance data for the air handler";
  Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium2,
    nPorts=1,
    use_p_in=false,
    p(displayUnit="Pa"),
    T=303.15) annotation (Placement(transformation(extent={{-112,0},{-92,20}})));
  Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium2,
    T=dat.nomVal.T_a2_nominal,
    X={0.02,1 - 0.02},
    use_T_in=true,
    use_X_in=true,
    p(displayUnit="Pa"))
    annotation (Placement(transformation(
          extent={{138,0},{118,20}})));
  Sources.Boundary_pT sin_1(
    redeclare package Medium = Medium1,
    nPorts=1,
    use_p_in=false,
    p=300000,
    T=293.15) annotation (Placement(transformation(extent={{138,40},{118,60}})));
  Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium1,
    use_T_in=true,
    p=300000 + 12000)
    annotation (Placement(transformation(extent={{-42,40},{-22,60}})));
  FixedResistances.PressureDrop res_2(
    from_dp=true,
    redeclare package Medium = Medium2,
    dp_nominal=100,
    m_flow_nominal=dat.nomVal.m2_flow_nominal)
    annotation (Placement(transformation(extent={{-60,0},{-80,20}})));
  FixedResistances.PressureDrop res_1(
    from_dp=true,
    redeclare package Medium = Medium1,
    dp_nominal=3000,
    m_flow_nominal=dat.nomVal.m1_flow_nominal)
    annotation (Placement(transformation(extent={{88,40},{108,60}})));
  Sensors.TemperatureTwoPort temSen(redeclare package Medium = Medium2,
  m_flow_nominal=dat.nomVal.m2_flow_nominal)
    annotation (Placement(transformation(extent={{10,0},{-10,20}})));
  Modelica.Blocks.Sources.TimeTable TSet(table=[0,288.15; 600,288.15; 600,288.15;
        1200,288.15; 1800,288.15; 2400,288.15; 2400,288.15])
    "Setpoint temperature" annotation (Placement(transformation(extent={{-42,80},
            {-22,100}})));
  Modelica.Blocks.Sources.Constant const(k=0.8)
    annotation (Placement(transformation(extent={{98,-80},{118,-60}})));
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi(use_p_in=false)
    annotation (Placement(transformation(extent={{148,-52},{168,-32}})));
  Modelica.Blocks.Sources.Constant const1(k=dat.nomVal.T_a2_nominal)
    annotation (Placement(transformation(extent={{98,-48},{118,-28}})));
  Modelica.Blocks.Sources.Step TWat(
    offset=dat.nomVal.T_a1_nominal,
    height=3,
    startTime=1500)
   "Water temperature, raised to high value at t=3000 s"
    annotation (Placement(transformation(extent={{-82,44},{-62,64}})));
  Sensors.MassFractionTwoPort masFra(redeclare package Medium = Medium2,
      m_flow_nominal=dat.nomVal.m2_flow_nominal) "Sensor for mass fraction"
    annotation (Placement(transformation(extent={{-26,0},{-46,20}})));
equation
  connect(sin_1.ports[1],res_1. port_b) annotation (Line(
      points={{118,50},{108,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1],res_2. port_b) annotation (Line(
      points={{-92,10},{-80,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(x_pTphi.X,sou_2. X_in) annotation (Line(
      points={{169,-42},{176,-42},{176,-44},{184,-44},{184,6},{140,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y,x_pTphi. phi) annotation (Line(
      points={{119,-70},{134,-70},{134,-48},{146,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y,x_pTphi. T) annotation (Line(
      points={{119,-38},{132,-38},{132,-42},{146,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const1.y,sou_2. T_in) annotation (Line(
      points={{119,-38},{132,-38},{132,-10},{158,-10},{158,14},{140,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TWat.y,sou_1. T_in) annotation (Line(
      points={{-61,54},{-44,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen.port_b, masFra.port_a)
    annotation (Line(points={{-10,10},{-26,10}}, color={0,127,255}));
  connect(masFra.port_b, res_2.port_a)
    annotation (Line(points={{-46,10},{-60,10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},
            {220,120}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{220,120}})));
end PartialAirHandlerControl;
