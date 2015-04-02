within Buildings.Fluid.Movers.Examples;
model MoverStages "Example model of mover using stages"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
     2 "Nominal mass flow rate";

  FlowControlled_m_flow floMac(
    redeclare package Medium = Medium,
    dynamicBalance=false,
    inputType=Buildings.Fluid.Types.InputType.Stage,
    m_flow_nominal=m_flow_nominal,
    stageInputs={0,m_flow_nominal},
    filteredSpeed=false) "Model of a flow machine"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=1) "Pressure source"
              annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    nPorts=1) "Pressure sink"
              annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.IntegerStep integerStep(height=1, startTime=0.5,
    offset=1) "Integer step input, 1 is off, 2 is on"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation
  connect(sou.ports[1], floMac.port_a) annotation (Line(
      points={{-60,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(floMac.port_b, sou1.ports[1]) annotation (Line(
      points={{10,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(integerStep.y, floMac.stage) annotation (Line(
      points={{-19,50},{0,50},{0,12}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/MoverStages.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates the use of the <code>Integer</code> 
stage connector for a mover model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 2, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-06),
    __Dymola_experimentSetupOutput(events=false));
end MoverStages;
