within Buildings.Fluid.CHPs.DistrictCHP.Examples;
model Combined "Example of the usage of the combined model"
  extends Modelica.Icons.Example;
  package MediumS = Buildings.Media.Steam
    "Steam medium - Medium model for port_b (outlet)";
  package MediumW =
      Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium - Medium model for port_a (inlet)";

  parameter Buildings.Fluid.CHPs.DistrictCHP.Data.SolarTurbines.NaturalGas.Centaur50_T6200S_NG per
    "Performance curve for the selected gas turbine"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));

  Buildings.Fluid.CHPs.DistrictCHP.Combined comCyc(
    botCycExp(steBoi(fixed_p_start=false)),
    per=per)
    "Combined cycle CHP plant"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.CombiTimeTable loa(table=[0,1.0; 14400,1.0; 28800,1.0;
        43200,1.0; 57600,0.8; 72000,0.5; 86400,0.5]) "Load profile"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.CombiTimeTable ambTem(table=[0.0,25; 14400,25; 28800,
        25; 43200,23; 57600,22; 72000,23; 86400,25]) "Ambient temperature"
    annotation (Placement(transformation(extent={{-80,-6},{-60,14}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumW,
    use_p_in=false,
    p=30000,
    T=504.475,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Fluid.Sources.FixedBoundary bou(
    redeclare package Medium = MediumS,
    p=1000000,
    T=523.15,
    nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
  Modelica.Blocks.Continuous.Integrator mFuel(y(unit="kg/s"))
    "Mass flow of fuel consumption "
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Continuous.Integrator STG_Ele(y(unit="W"))
    "Steam turbine electrical energy generated"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Modelica.Blocks.Continuous.Integrator GTG_Ele(y(unit="W"))
    "Gas turbine electrical energy generated"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(comCyc.port_b, bou.ports[1]) annotation (Line(points={{10,0},{40,0},{
          40,-50},{60,-50}}, color={0,127,255}));
  connect(loa.y[1], comCyc.y) annotation (Line(points={{-59,70},{-40,70},{-40,8},
          {-12,8}}, color={0,0,127}));
  connect(ambTem.y[1], comCyc.TAmb)
    annotation (Line(points={{-59,4},{-12,4}}, color={0,0,127}));
  connect(comCyc.PEle, GTG_Ele.u) annotation (Line(points={{12,9},{40,9},{40,70},
          {58,70}},     color={0,0,127}));
  connect(comCyc.PEle_ST, STG_Ele.u) annotation (Line(points={{12,3},{52,3},{52,
          -10},{58,-10}}, color={0,0,127}));
  connect(comCyc.mFue_flow, mFuel.u)
    annotation (Line(points={{12,6},{52,6},{52,30},{58,30}}, color={0,0,127}));
  connect(comCyc.port_a, sou.ports[1]) annotation (Line(points={{-10,0},{-40,0},
          {-40,-50},{-60,-50}}, color={0,127,255}));
  annotation (
    Icon(
      coordinateSystem(preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=86400,Tolerance=1E-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/DistrictCHP/Examples/Combined.mos"
  "Simulate and plot"),
Documentation(info="<html>
<p>
This example model demonstrates the combined cycle CHP model
<a href=\"Modelica://Buildings.Fluid.CHPs.DistrictCHP.Combined\">
Buildings.Fluid.CHPs.DistrictCHP.Combined</a>
can produce electricity from both gas turbine and steam turbine based on the gas
turbine part load and the ambient temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
October 1, 2024, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end Combined;
