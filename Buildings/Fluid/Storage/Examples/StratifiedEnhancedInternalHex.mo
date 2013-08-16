within Buildings.Fluid.Storage.Examples;
model StratifiedEnhancedInternalHex
  "Example showing the use of StratifiedEnhancedInternalHex"
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
        origin={-70,4})));
  Buildings.Fluid.Sources.Boundary_pT boundary3(          redeclare package
      Medium = Medium, nPorts=1)                            annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-68,-26})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem( m_flow_nominal=0.1,
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=senTem.T)
    annotation (Placement(transformation(extent={{-94,42},{-74,62}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary1(
    use_T_in=true,
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=0)
    annotation (Placement(transformation(extent={{-58,38},{-38,58}})));
  Buildings.Fluid.Storage.StratifiedEnhancedInternalHex tan(
    redeclare package Medium = Medium,
    m_flow_nominal=0.001,
    VTan=0.151416,
    dIns=0.0762,
    redeclare package MediumHex = Medium,
    CHex=40,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=0.278*4200*20,
    mHex_flow_nominal=0.278,
    energyDynamicsHex=Modelica.Fluid.Types.Dynamics.SteadyState,
    hexTopHeight=0.995,
    hexBotHeight=0.1,
    hexSegMult=1,
    hTan=1.746,
    TTan_nominal=293.15,
    THex_nominal=323.15)
    annotation (Placement(transformation(extent={{-22,-6},{12,26}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(senTem.port_b, boundary.ports[1]) annotation (Line(
      points={{50,10},{70,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(realExpression.y, boundary1.T_in) annotation (Line(
      points={{-73,52},{-60,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary1.ports[1], tan.port_a) annotation (Line(
      points={{-38,48},{-30,48},{-30,10},{-22,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.port_b, senTem.port_a) annotation (Line(
      points={{12,10},{30,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundary2.ports[1], tan.port_a1) annotation (Line(
      points={{-60,4},{-32,4},{-32,3.92},{-22,3.92}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.port_b1, boundary3.ports[1]) annotation (Line(
      points={{-22,-2.8},{-22,-26},{-58,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Examples/StratifiedEnhancedInternalHex.mos"
        "Simulate and Plot"),
        Documentation(info="<html>
        <p>
        This model provides an example of how the <a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhancedInternalHex\">
        Buildings.Fluid.Storage.StratifiedEnhancedInternalHex</a> model can be used. In it a constant
        water draw is taken from the tank while a constant flow of hot water is passed through the heat
        exchanger to heat the water in the tank.<br/>
        </p>
        </html>",
        revisions = "<html>
        <ul>
        <li>
        Mar 27, 2013 by Peter Grant:<br/>
        First implementation
        </li>
        </ul>
        </html>"));
end StratifiedEnhancedInternalHex;
