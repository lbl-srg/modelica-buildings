within Buildings.Fluid.Storage.Examples;
model StratifiedEnhancedInternalHX
  "Example showing the use of StratifiedEnhancedInternalHX"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Fluid.Storage.StratifiedEnhancedInternalHX tan(
    m_flow_nominal=0.1,
    VTan=0.15,
    hTan=1,
    dIns=0.01,
    C=200,
    VolHX=0.1,
    UA_nominal=15,
    m_flow_nominal_HX=0.1,
    m_flow_nominal_tank=0.1,
    ASurHX=0.199,
    dHXExt=0.01905,
    TopHXSeg=4,
    BotHXSeg=3,
    HXSegMult=4,
    redeclare package Medium = Buildings.Media.WaterIF97_pT,
    redeclare package Medium_2 = Buildings.Media.WaterIF97_pT,
    HXTopHeight=0.9,
    HXBotHeight=0.6)
    annotation (Placement(transformation(extent={{-18,-6},{16,26}})));
  Buildings.Fluid.Sources.Boundary_pT boundary(      nPorts=1, redeclare
      package Medium = Buildings.Media.WaterIF97_pT)           annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,10})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary2(
    nPorts=1,
    m_flow=0.1,
    redeclare package Medium = Buildings.Media.WaterIF97_pT,
    T=323.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,42})));
  Buildings.Fluid.Sources.Boundary_pT boundary3(nPorts=1, redeclare package
      Medium = Buildings.Media.WaterIF97_pT)                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,42})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem( m_flow_nominal=0.1,
      redeclare package Medium = Buildings.Media.WaterIF97_pT)
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=senTem.T)
    annotation (Placement(transformation(extent={{-94,4},{-74,24}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary1(
    nPorts=1,
    use_T_in=true,
    m_flow=0.1,
    redeclare package Medium = Buildings.Media.WaterIF97_pT)
    annotation (Placement(transformation(extent={{-58,0},{-38,20}})));
equation
  connect(boundary2.ports[1], tan.port_a1) annotation (Line(
      points={{-60,42},{-28,42},{-28,26},{-16.3,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundary3.ports[1], tan.port_b1) annotation (Line(
      points={{50,42},{28,42},{28,26},{14.3,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.port_b, senTem.port_a) annotation (Line(
      points={{16,10},{30,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.port_b, boundary.ports[1]) annotation (Line(
      points={{50,10},{70,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundary1.ports[1], tan.port_a) annotation (Line(
      points={{-38,10},{-18,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(realExpression.y, boundary1.T_in) annotation (Line(
      points={{-73,14},{-60,14}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Examples/StratifiedEnhancedInternalHX.mos"
        "Simulate and Plot"));
end StratifiedEnhancedInternalHX;
