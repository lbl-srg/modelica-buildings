within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Capacities_u
  "Validate stage capacities sequence for chiller stage inputs"

  parameter Integer nSta = 2
  "Highest chiller stage";

  parameter Modelica.SIunits.Power staNomCap[nSta] = {5e5, 5e5}
    "Nominal capacity at all chiller stages, starting with stage 0";

  parameter Modelica.SIunits.Power minStaUnlCap[nSta] = {0.2*staNomCap[1], 0.2*staNomCap[2]}
    "Nominal part load ratio for at all chiller stages, starting with stage 0";

  parameter Real small = 0.001
  "Small number to avoid division with zero";

  parameter Real large = staNomCap[end]*nSta*10
  "Large number for numerical consistency";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap0(
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap1(
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap2(
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staCap[nSta + 2](
    final k={small,5e5,1e6,large})
    "Array of chiller stage cumulative capacities starting with stage 0 and ending with a large value to prevent staging up from the maximum stage"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload[nSta + 2](
    final k={0,1e5,2e5,large})
    "Array of chiller stage cumulative minimum capacities starting with stage 0 and ending with a large value to prevent staging up from the maximum stage"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(final k=0)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(final k=1)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage2(final k=2)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nSta](
    final k=fill(true, nSta))
    "Stage availability array"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  CDL.Logical.Sources.Constant con1 [nSta](final k=fill(true, nSta))
    "Stage availability array"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(stage0.y, staCap0.u)
    annotation (Line(points={{-59,90},{-50,90},{-50,93},{-41,93}}, color={255,127,0}));
  connect(stage1.y, staCap1.u)
    annotation (Line(points={{-59,0},{-50,0},{-50,3},{-41,3}}, color={255,127,0}));
  connect(stage2.y, staCap2.u)
    annotation (Line(points={{-59,-90},{-50,-90},{-50,-87},{-41,-87}}, color={255,127,0}));
annotation (
 experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Capacities_uSta.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,160}})));
end Capacities_u;
