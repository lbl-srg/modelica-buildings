within Buildings.Fluid.Boilers.BaseClasses.Examples;
model Combustion "Test model for combustion process"
  extends Modelica.Icons.Example;

  package MediumAir = Modelica.Media.IdealGases.MixtureGases.CombustionAir
    "Air medium (N2,O2) for combustion process";
  package MediumFluGas =
      Modelica.Media.IdealGases.MixtureGases.FlueGasLambdaOnePlus (
        reference_X={0.718,0.009,0.182,0.091})
      "Flue gas from methane combustion with excess air (N2,O2,H2O,CO2)";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Power QFue_flow_nominal = 1
    "Nominal heat transfer rate of fuel into working fluid";


  Buildings.Fluid.Boilers.BaseClasses.Combustion com(
    redeclare package Medium_a = MediumAir,
    redeclare package Medium_b = MediumFluGas,
    m_flow_nominal=m_flow_nominal,
    fue=Data.Fuels.NaturalGasLowerHeatingValue()) "Combustion process"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Sources.Boundary_pT fluGasSin(redeclare package Medium = MediumFluGas, nPorts=1)
    "Flue gas sink"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant QFue_flow(k=QFue_flow_nominal)
    "Heat transfer rate of fuel"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Sources.Boundary_pT airSou(redeclare package Medium = MediumAir, nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{-78,-10},{-58,10}})));
equation
  connect(QFue_flow.y, com.QFue_flow) annotation (Line(points={{-59,50},{-10,50},
          {-10,10},{-2,10}}, color={0,0,127}));
  connect(com.port_b, fluGasSin.ports[1])
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(airSou.ports[1], com.port_a)
    annotation (Line(points={{-58,0},{0,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Combustion;
