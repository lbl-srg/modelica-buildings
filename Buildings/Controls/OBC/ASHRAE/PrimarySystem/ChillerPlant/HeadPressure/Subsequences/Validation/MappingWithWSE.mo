within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.Validation;
model MappingWithWSE
  "Validate sequence of specifying equipment setpoint based on head pressure control loop output"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithWSE
    witWSE "Specify setpoints for plant when waterside economizer is enabled"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithWSE
    noWSE "Specify setpoints for plant when waterside economizer is disabled"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant enaPreCon(
    final k=true) "Constant true"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant enaWSE(
    final k=true) "Constant true"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant desPumSpe(
    final k=0.75) "Design condenser water pump speed at current stage"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp conLoo(
    final duration=5) "Control loop output"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation
  connect(conLoo.y, witWSE.uHeaPreCon)
    annotation (Line(points={{-38,80},{-24,80},{-24,68},{-2,68}}, color={0,0,127}));
  connect(desPumSpe.y, witWSE.desConWatPumSpe)
    annotation (Line(points={{-38,40},{-20,40},{-20,64},{-2,64}}, color={0,0,127}));
  connect(enaWSE.y, witWSE.uWSE)
    annotation (Line(points={{-38,0},{-16,0},{-16,56},{-2,56}}, color={255,0,255}));
  connect(enaPreCon.y, witWSE.uHeaPreEna)
    annotation (Line(points={{-38,-40},{-12,-40},{-12,52},{-2,52}}, color={255,0,255}));
  connect(conLoo.y, noWSE.uHeaPreCon)
    annotation (Line(points={{-38,80},{-24,80},{-24,-72},{-2,-72}}, color={0,0,127}));
  connect(desPumSpe.y, noWSE.desConWatPumSpe)
    annotation (Line(points={{-38,40},{-20,40},{-20,-76},{-2,-76}}, color={0,0,127}));
  connect(enaWSE.y, not1.u)
    annotation (Line(points={{-38,0},{-2,0}}, color={255,0,255}));
  connect(not1.y, noWSE.uWSE)
    annotation (Line(points={{22,0},{40,0},{40,-60},{-16,-60},{-16,-84},{-2,-84}},
                 color={255,0,255}));
  connect(enaPreCon.y, noWSE.uHeaPreEna)
    annotation (Line(points={{-38,-40},{-12,-40},{-12,-88},{-2,-88}}, color={255,0,255}));

annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/HeadPressure/Subsequences/Validation/MappingWithWSE.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithWSE\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithWSE</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end MappingWithWSE;
