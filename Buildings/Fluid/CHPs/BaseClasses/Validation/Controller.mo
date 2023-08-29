within Buildings.Fluid.CHPs.BaseClasses.Validation;
model Controller "Validate model Controller"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.Data.ValidationData3 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Modelica.Blocks.Sources.BooleanTable runSig(
    startValue=false,
    table={900,960,1200,2200})
    "Plant run signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.CHPs.BaseClasses.Controller con(final per=per)
    "Operation mode controller"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.BooleanTable avaSig(
    final startValue=false,
    table={300,600,900}) "Plant availability signal"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable mWat_flow(
    table=[0,0; 900,0.4; 1320,0; 1500,0.4;
           1900,0; 1960,0.4; 2200,0; 3000,0],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

protected
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

equation
  connect(avaSig.y, con.avaSig) annotation (Line(points={{-19,70},{10,70},{10,17},
          {18,17}}, color={255,0,255}));
  connect(runSig.y, con.runSig) annotation (Line(points={{-19,30},{-10,30},{-10,
          14},{18,14}}, color={255,0,255}));
  connect(mWat_flow.y[1], con.mWat_flow) annotation (Line(points={{-18,-30},{-10,
          -30},{-10,11},{18,11}},     color={0,0,127}));

annotation (
  experiment(StopTime=3000, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/Controller.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.Controller\">
Buildings.Fluid.CHPs.BaseClasses.Controller</a>
for switching between six operating modes.
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2019, by Jianjun Hu:<br/>
Refactored implementation.
</li>
<li>
July 01 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
