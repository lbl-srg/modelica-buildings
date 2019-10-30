within Buildings.Fluid.CHPs.BaseClasses.Validation;
model EnergyConversion "Validate model EnergyConversion"

  parameter Buildings.Fluid.CHPs.Data.ValidationData2 per
    "CHP performance data"
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));

  Buildings.Fluid.CHPs.BaseClasses.EnergyConversion eneCon(final per=per)
    annotation (Placement(transformation(extent={{60,-32},{80,-12}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable mWat_flow(
    table=[0,0; 300,0.4; 2700,0; 3000,0],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Fluid.CHPs.BaseClasses.Controller con(final per=per) "Operation mode"
    annotation (Placement(transformation(extent={{0,74},{20,94}})));
  Modelica.Blocks.Sources.BooleanTable runSig(startValue=false, table={300,2700})
    "Plant run signal"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.BooleanTable avaSig(startValue=true, table={3500})
    "Plant availability signal"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TEng(
    final height=90,
    final duration=600,
    final offset=273.15 + 15,
    final startTime=360) "Engine temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TWatIn(
    final k=273.15 + 15)
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.TimeTable PEle(
    table=[0,0; 299,0; 300,2500; 2699,2500;2700,0; 3000,0])
    "Electric power demand"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

protected
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,-81},{-60,-61}})));

equation
  connect(con.opeMod, eneCon.opeMod) annotation (Line(points={{21,84},{40,84},{40,
          -13},{59,-13}}, color={0,127,0}));
  connect(avaSig.y, con.avaSig) annotation (Line(points={{-59,90},{-30,90},
          {-30,76},{-2,76}}, color={255,0,255}));
  connect(runSig.y, con.runSig) annotation (Line(points={{-59,50},{-54,50},{-54,
          92},{-2,92}}, color={255,0,255}));
  connect(TEng.y, con.TEng) annotation (Line(points={{-58,-30},{-40,-30},{-40,
          82},{-2,82}},
                    color={0,0,127}));
  connect(TEng.y, eneCon.TEng) annotation (Line(points={{-58,-30},{0,-30},{0,
          -31},{58,-31}},
                     color={0,0,127}));
  connect(TWatIn.y, eneCon.TWatIn) annotation (Line(points={{2,10},{20,10},{20,-22},
          {58,-22}}, color={0,0,127}));
  connect(PEle.y, eneCon.PEle) annotation (Line(points={{1,50},{30,50},{30,-17},
          {58,-17}}, color={0,0,127}));
  connect(mWat_flow.y[1], eneCon.mWat_flow) annotation (Line(points={{-58,10},{-48,
          10},{-48,-27},{58,-27}},     color={0,0,127}));
  connect(mWat_flow.y[1], con.mWat_flow) annotation (Line(points={{-58,10},{-48,
          10},{-48,86},{-2,86}}, color={0,0,127}));

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
