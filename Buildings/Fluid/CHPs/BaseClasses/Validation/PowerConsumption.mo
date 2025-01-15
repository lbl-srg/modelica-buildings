within Buildings.Fluid.CHPs.BaseClasses.Validation;
model PowerConsumption "Validate model PowerConsumption"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.Data.ValidationData1 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable mWat_flow(
    table=[0,0; 300,0.4; 2700,0; 3000,0],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Water mass flow rate"
    annotation (Placement(transformation(extent={{-80,-8},{-60,12}})));
  Buildings.Fluid.CHPs.BaseClasses.Controller con(final per=per)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanTable runSig(
    final startValue=false,
    final table={300,2700})
    "Plant run signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.BooleanTable avaSig(
    final startValue=true,
    final table={3500})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Fluid.CHPs.BaseClasses.PowerConsumption powCon(
    final PStaBy=per.PStaBy,
    final PCooDow=per.PCooDow)
    "Internal controller for water mass flow rate"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

equation
  connect(avaSig.y, con.avaSig) annotation (Line(points={{-59,80},{-40,80},{-40,
          7},{-12,7}},        color={255,0,255}));
  connect(runSig.y, con.runSig) annotation (Line(points={{-59,40},{-50,40},{-50,
          4},{-12,4}},  color={255,0,255}));
  connect(con.opeMod,powCon. opeMod) annotation (Line(points={{11,0},{39,0}},
          color={0,127,0}));
  connect(mWat_flow.y[1], con.mWat_flow) annotation (Line(points={{-58,2},{-36,
          2},{-36,1},{-12,1}},
          color={0,0,127}));

annotation (
  experiment(StopTime=3000, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/PowerConsumption.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.PowerConsumption\">
Buildings.Fluid.CHPs.BaseClasses.PowerConsumption</a>
for calculating the power consumption during the stand-by and cool-down modes of
operation.
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
end PowerConsumption;
