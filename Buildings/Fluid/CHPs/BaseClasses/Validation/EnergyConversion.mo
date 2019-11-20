within Buildings.Fluid.CHPs.BaseClasses.Validation;
model EnergyConversion "Validate model EnergyConversion"

  parameter Buildings.Fluid.CHPs.Data.ValidationData2 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.CHPs.BaseClasses.EnergyConversion eneCon(final per=per)
    "Energy conversion volume"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable mWat_flow(
    table=[0,0; 300,0.4; 2700,0; 3000,0],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Cooling water flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.CHPs.BaseClasses.Controller con(final per=per) "Operation mode"
    annotation (Placement(transformation(extent={{0,64},{20,84}})));
  Modelica.Blocks.Sources.BooleanTable runSig(startValue=false, table={300,2700})
    "Plant run signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.BooleanTable avaSig(startValue=true, table={3500})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TEng(
    final height=90,
    final duration=600,
    final offset=273.15 + 15,
    final startTime=360) "Engine temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TWatIn(
    final k=273.15 + 15) "Cooling water inlet temperature"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.TimeTable PEle(
    table=[0,0; 299,0; 300,2500; 2699,2500;2700,0; 3000,0])
    "Electric power demand"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

protected
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

equation
  connect(con.opeMod, eneCon.opeMod) annotation (Line(points={{21,74},{40,74},{40,
          -21},{59,-21}}, color={0,127,0}));
  connect(avaSig.y, con.avaSig) annotation (Line(points={{-59,80},{-30,80},{-30,
          66},{-2,66}}, color={255,0,255}));
  connect(runSig.y, con.runSig) annotation (Line(points={{-59,40},{-54,40},{-54,
          82},{-2,82}}, color={255,0,255}));
  connect(TEng.y, con.TEng) annotation (Line(points={{-58,-30},{-40,-30},{-40,72},
          {-2,72}}, color={0,0,127}));
  connect(TEng.y, eneCon.TEng) annotation (Line(points={{-58,-30},{0,-30},{0,-39},
          {58,-39}}, color={0,0,127}));
  connect(TWatIn.y, eneCon.TWatIn) annotation (Line(points={{2,0},{20,0},{20,-30},
          {58,-30}}, color={0,0,127}));
  connect(PEle.y, eneCon.PEle) annotation (Line(points={{1,40},{30,40},{30,-25},
          {58,-25}}, color={0,0,127}));
  connect(mWat_flow.y[1], eneCon.mWat_flow) annotation (Line(points={{-58,0},{-48,
          0},{-48,-35},{58,-35}}, color={0,0,127}));
  connect(mWat_flow.y[1], con.mWat_flow) annotation (Line(points={{-58,0},{-48,0},
          {-48,76},{-2,76}}, color={0,0,127}));

annotation (
  experiment(StopTime=3000, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/BaseClasses/Validation/EnergyConversion.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.EnergyConversion\">
Buildings.Fluid.CHPs.BaseClasses.EnergyConversion</a>
for defining the energy conversion control volume.
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
</html>"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end EnergyConversion;
