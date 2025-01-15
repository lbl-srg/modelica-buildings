within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Validation;
model BypassValve "Validate the control of inline valve"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.BypassValve wseVal(
    final Ti=10)
    "Chilled water return line in-line valve control"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse ecoSta(
    final width=0.8,
    final period=3600) "Water side economizer enable/disable status"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse dpWSE(
    final amplitude=3000,
    final period=3600,
    final offset=4500)
    "Static pressure difference across chilled water side economizer"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Plant enable"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaPla(
    final width=0.2, final period=3600)
    "Enabled plant"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(ecoSta.y, wseVal.uWSE) annotation (Line(points={{-38,0},{18,0}},
          color={255,0,255}));
  connect(dpWSE.y, wseVal.dpChiWat) annotation (Line(points={{-38,-40},{-20,-40},
          {-20,-6},{18,-6}}, color={0,0,127}));
  connect(enaPla.y, not2.u)
    annotation (Line(points={{-58,50},{-42,50}}, color={255,0,255}));
  connect(not2.y, wseVal.uPla) annotation (Line(points={{-18,50},{0,50},{0,6},{18,
          6}}, color={255,0,255}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Economizers/Subsequences/Validation/BypassValve.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.BypassValve\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.BypassValve</a>.
</p>
<p>
The validation shows that when the plant is enabled in waterside mode
(<code>uPla=true</code> and <code>uWSE=true</code>):
</p>
<ul>
<li>
The condenser water isolation valve to the heat exchanger will be fully
open (<code>yConIsoVal=1</code>).
</li>
<li>
The economizer in-line chilled water return line valve will be enabled,
with the initial position as fully open (<code>yRetVal=1</code>).
</li>
<li>
The return line valve will be modulated to maintain the static pressure
difference (<code>dpChiWat</code>) across the chilled water side of the heat
exchanger at the design value (<code>dpDes</code>).
</li>
</ul>
<p>
If the econimizer is disabled (<code>uWSE=false</code>), the condenser water
isolation valve to the heat exchanger should be fully closed and the return
line valve should be disabled in fully open position.
</p>
</html>", revisions="<html>
<ul>
<li>
July 15, 2022, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false)));
end BypassValve;
