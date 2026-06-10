within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model SortRuntimeG36 "Validation model for equipment runtime sorting logic"
  Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime sorRunTim(
      runTim_start={1000,950,900}*3600,
                                   nin=3)
    "Sort runtime"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant u1AvaEqu[3](k=fill(true,
        3)) "Equipment available signal"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(table=[0,0,0,1; 51,0,
        1,1; 102,0,1,0; 202,0,0,0],
    timeScale=3600,
    period=250*3600)                            "Equipment enable signal"
    annotation (Placement(transformation(extent={{-90,-4},{-70,16}})));
equation
  connect(u1AvaEqu.y, sorRunTim.u1Ava) annotation (Line(points={{-68,-40},{-20,
          -40},{-20,-6},{-12,-6}}, color={255,0,255}));
  connect(y1.y[1:3], sorRunTim.u1Run[1:3]) annotation (Line(points={{-68,6},{
          -12,6},{-12,6.66667}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/SortRuntimeG36.mos"
        "Simulate and plot"),
    experiment(
      StopTime=792000.0,
      Tolerance=1e-06),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,100}}, grid={2,2})),
    Documentation(
      info="<html>
<p>
This model reproduces the example provided in section 5.1.15.3
of ASHRAE, 2024.
In this example, three pumps are lead/lag alternated.
Simulating the model shows that the staging order <code>sorRunTim.yIdx</code>
matches the one from the guideline.
</p>
<h4>References</h4>
<ul>
<li id=\"ASHRAE2021\">
ASHRAE, 2024. Guideline 36-2024, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
June 10, 2026, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end SortRuntimeG36;
