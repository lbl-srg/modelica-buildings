within Buildings.Fluid.CHPs.BaseClasses.Validation;
model WaterFlowControl "Validate model WaterFlowControl"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.CHPs.Data.ValidationData2 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Fluid.CHPs.BaseClasses.WaterFlowControl conWat(final per=per)
    "Internal controller for water mass flow rate"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
protected
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{60,59},{80,79}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable mWat_flow(
    table=[0,0; 300,0.4; 2700,0; 3000,0],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Water mass flow rate"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Fluid.CHPs.BaseClasses.Controller con(final per=per)
    "Operation mode controller"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Sources.BooleanTable runSig(
    final startValue=false,
    final table={300,2700})
    "Plant run signal"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.BooleanTable avaSig(
    final startValue=true,
    final table={3500})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TEng(
    y(final unit="K", displayUnit="degC"),
    final height=90,
    final duration=300,
    final offset=273.15 + 15,
    final startTime=360) "Engine temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TWatIn(
    y(final unit="K", displayUnit="degC"),
    final k=273.15 + 15)
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable PEle(
    final table=[0,0; 300,2500; 2700,0; 3000,0],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Electric power demand"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
equation
  connect(avaSig.y, con.avaSig) annotation (Line(points={{-59,70},{-48,70},{-48,
          77},{-2,77}},      color={255,0,255}));
  connect(runSig.y, con.runSig) annotation (Line(points={{-59,30},{-42,30},{-42,
          74},{-2,74}}, color={255,0,255}));
  connect(TEng.y, con.TEng) annotation (Line(points={{-58,-50},{-30,-50},{-30,
          68},{-2,68}}, color={0,0,127}));
  connect(con.opeMod, conWat.opeMod) annotation (Line(points={{21,70},{40,70},{40,
          7},{59,7}}, color={0,127,0}));
  connect(TWatIn.y, conWat.TWatIn) annotation (Line(points={{2,-30},{20,-30},
          {20,-7},{58,-7}}, color={0,0,127}));
  connect(mWat_flow.y[1], con.mWat_flow) annotation (Line(points={{-58,-10},{
          -36,-10},{-36,71},{-2,71}},
                                 color={0,0,127}));
  connect(PEle.y[1], conWat.PEle) annotation (Line(points={{2,30},{20,30},{20,0},
          {58,0}}, color={0,0,127}));
  connect(PEle.y[1], con.PEle) annotation (Line(points={{2,30},{20,30},{20,54},
          {-10,54},{-10,62},{-2,62}}, color={0,0,127}));
  connect(PEle.y[1], con.PEleNet) annotation (Line(points={{2,30},{20,30},{20,
          54},{-10,54},{-10,65},{-2,65}}, color={0,0,127}));
annotation (
    experiment(StopTime=3000, Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/WaterFlowControl.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.WaterFlowControl\">
Buildings.Fluid.CHPs.BaseClasses.WaterFlowControl</a>
for calculating the optimum cooling water flow rate based on internal contol.
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
end WaterFlowControl;
