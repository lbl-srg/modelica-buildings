within Buildings.Fluid.Actuators.Dampers.Examples;
model VAVBoxExpLin
  extends Modelica.Icons.Example;

  import Medium = Buildings.Media.Air "Medium model for air";

  parameter Modelica.SIunits.MassFlowRate m_flo_nom = 1;
  parameter Modelica.SIunits.PressureDifference dp_nom = 10;

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=4,
    use_p_in=false,
    p=Medium.p_default + dp_nom)
    annotation (Placement(transformation(extent={{-98,24},{-78,44}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
                             nPorts=4, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{102,24},{82,44}})));
  Buildings.Fluid.Actuators.Dampers.VAVBoxExpLin damLin(
    redeclare package Medium = Medium,
    linearized=true,
    use_inputFilter=false,
    from_dp=false,
    v_nominal=1,
    m_flow_nominal=m_flo_nom,
    dp_nominalIncludesDamper=true,
    dp_nominal=dp_nom)
    annotation (Placement(transformation(extent={{-10,56},{10,76}})));
  Buildings.Fluid.Actuators.Dampers.VAVBoxExpLin damNoLin(
    redeclare package Medium = Medium,
    use_inputFilter=false,
    from_dp=false,
    v_nominal=1,
    m_flow_nominal=m_flo_nom,
    linearized=false,
    dp_nominalIncludesDamper=true,
    dp_nominal=dp_nom)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
    Modelica.Blocks.Sources.Ramp uDam(
    startTime=0,
    height=1,
    duration=1,
    offset=0)
    annotation (Placement(transformation(extent={{-140,82},{-120,102}})));
  Buildings.Fluid.Actuators.Dampers.VAVBoxExpLin damLinInvFlo(
    redeclare package Medium = Medium,
    linearized=true,
    use_inputFilter=false,
    from_dp=false,
    v_nominal=1,
    m_flow_nominal=m_flo_nom,
    dp_nominalIncludesDamper=true,
    dp_nominal=dp_nom)
    annotation (Placement(transformation(extent={{10,118},{-10,138}})));
  Buildings.Fluid.Actuators.Dampers.VAVBoxExponential damExp(
    m_flow_nominal=m_flo_nom,
    dp_nominal=dp_nom,
    redeclare package Medium = Medium,
    use_inputFilter=false)
    annotation (Placement(transformation(extent={{-10,-76},{10,-56}})));
equation
  connect(sou.ports[1], damLin.port_a) annotation (Line(points={{-78,37},{-46,
          37},{-46,66},{-10,66}}, color={0,127,255}));
  connect(damLin.port_b, sin.ports[1]) annotation (Line(points={{10,66},{46,66},
          {46,37},{82,37}}, color={0,127,255}));
  connect(damNoLin.port_b, sin.ports[2]) annotation (Line(points={{10,-2},{46,
          -2},{46,35},{82,35}}, color={0,127,255}));
  connect(sou.ports[2], damNoLin.port_a) annotation (Line(points={{-78,35},{-44,
          35},{-44,-2},{-10,-2}}, color={0,127,255}));
  connect(uDam.y, damLin.y) annotation (Line(points={{-119,92},{-60,92},{-60,78},
          {0,78}}, color={0,0,127}));
  connect(uDam.y, damNoLin.y) annotation (Line(points={{-119,92},{-59.5,92},{
          -59.5,10},{0,10}}, color={0,0,127}));
  connect(sou.ports[3], damLinInvFlo.port_b) annotation (Line(points={{-78,33},
          {-44,33},{-44,128},{-10,128}}, color={0,127,255}));
  connect(damLinInvFlo.port_a, sin.ports[3]) annotation (Line(points={{10,128},
          {46,128},{46,33},{82,33}}, color={0,127,255}));
  connect(uDam.y, damLinInvFlo.y) annotation (Line(points={{-119,92},{-60,92},{
          -60,140},{0,140}}, color={0,0,127}));
  connect(sou.ports[4], damExp.port_a) annotation (Line(points={{-78,31},{-44,
          31},{-44,-66},{-10,-66}}, color={0,127,255}));
  connect(damExp.port_b, sin.ports[4]) annotation (Line(points={{10,-66},{46,
          -66},{46,31},{82,31}}, color={0,127,255}));
  connect(uDam.y, damExp.y) annotation (Line(points={{-119,92},{-58,92},{-58,
          -54},{0,-54}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,
            -100},{120,140}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{120,
            140}})),
    experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Actuators/Dampers/Examples/VAVBoxExpLin.mos"
        "Simulate and plot"));
end VAVBoxExpLin;
