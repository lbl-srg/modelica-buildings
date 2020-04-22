within Buildings.Fluid.Boilers.BaseClasses.Examples;
model Combustion
  "Test model for the empirical-based combustion process"
  extends Modelica.Icons.Example;

  package MediumFluGas =
      Modelica.Media.IdealGases.MixtureGases.FlueGasLambdaOnePlus (
        reference_X={0.718,0.009,0.182,0.091})
      "Flue gas from methane combustion with excess air (N2,O2,H2O,CO2)";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Power QFue_flow_nominal = 1
    "Nominal heat transfer rate of fuel into working fluid";

  Buildings.Fluid.Boilers.BaseClasses.Combustion com(
    redeclare package Medium = MediumFluGas,
    m_flow_nominal=m_flow_nominal,
    show_T=true)      "Combustion process"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Sources.Boundary_pT fluGasSin(redeclare package Medium = MediumFluGas,
    p=1000000,                                                           nPorts=1)
    "Flue gas sink"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Sources.MassFlowSource_T airSou(redeclare package Medium = MediumFluGas,
    m_flow=m_flow_nominal,
    T=293.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.TimeTable y(table=[0,0; 1800,1; 1800,0; 2400,0; 2400,1;
        3600,1])
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation
  connect(com.port_b, fluGasSin.ports[1])
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(y.y, com.y)
    annotation (Line(points={{-19,50},{-10,50},{-10,8},{-1,8}},
                                                             color={0,0,127}));
  connect(airSou.ports[1], com.port_a)
    annotation (Line(points={{-40,0},{0,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
experiment(Tolerance=1e-6, StopTime=3600.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/BaseClasses/Examples/Combustion.mos"
        "Simulate and plot"));
end Combustion;
