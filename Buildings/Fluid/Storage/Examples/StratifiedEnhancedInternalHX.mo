within Buildings.Fluid.Storage.Examples;
model StratifiedEnhancedInternalHX
  "Example showing the use of StratifiedEnhancedInternalHX"
  import Buildings;
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.ConstantPropertyLiquidWater
    "Buildings library model for water";

  Buildings.Fluid.Sources.Boundary_pT boundary(      nPorts=1, redeclare
      package Medium = Medium)                                 annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,10})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary2(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=0.278,
    T=353.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,42})));
  Buildings.Fluid.Sources.Boundary_pT boundary3(          redeclare package
      Medium = Medium, nPorts=1)                            annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,42})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem( m_flow_nominal=0.1,
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=senTem.T)
    annotation (Placement(transformation(extent={{-94,4},{-74,24}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary1(
    use_T_in=true,
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=0)
    annotation (Placement(transformation(extent={{-58,0},{-38,20}})));
  Buildings.Fluid.Storage.StratifiedEnhancedInternalHX tan(
    redeclare package Medium = Medium,
    m_flow_nominal=0.001,
    VTan=0.151416,
    hTan=1,
    dIns=0.0762,
    redeclare package Medium_2 = Medium,
    HXTopHeight=0.75,
    HXBotHeight=0.25,
    C=40,
    m_flow_nominal_tank=0.001,
    HXSegMult=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-22,-6},{12,26}})));
equation
  connect(senTem.port_b, boundary.ports[1]) annotation (Line(
      points={{50,10},{70,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(realExpression.y, boundary1.T_in) annotation (Line(
      points={{-73,14},{-60,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary1.ports[1], tan.port_a) annotation (Line(
      points={{-38,10},{-22,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.port_b, senTem.port_a) annotation (Line(
      points={{12,10},{30,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundary2.ports[1], tan.port_a1) annotation (Line(
      points={{-60,42},{-32,42},{-32,26},{-20.3,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.port_b1, boundary3.ports[1]) annotation (Line(
      points={{10.3,26},{28,26},{28,42},{50,42}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Examples/StratifiedEnhancedInternalHX.mos"
        "Simulate and Plot"),
        Documentation(info="<html>
        <p>
        This model provides an example of how the <a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhancedInternalHX\">
        Buildings.Fluid.Storage.StratifiedEnhancedInternalHX</a> model can be used. In it a constant
        water draw is taken from the tank while a constant flow of hot water is passed through the heat
        exchanger to heat the water in the tank.<br>
        </p>
        </html>",
        revisions = "<html>
        <ul>
        <li>
        Mar 27, 2013 by Peter Grant:<br>
        First implementation
        </li>
        </ul>
        </html>"));
end StratifiedEnhancedInternalHX;
