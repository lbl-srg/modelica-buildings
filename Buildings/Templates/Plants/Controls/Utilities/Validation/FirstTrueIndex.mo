within Buildings.Templates.Plants.Controls.Utilities.Validation;
model FirstTrueIndex
  "Validation model"
  Utilities.FirstTrueIndex idxFirTru(
    nin=6)
    "Return first true index"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Utilities.FirstTrueIndex idxFirTruAllFal(nin=6)
    "Return first true index – All elements of input vector are false"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conAllFal[6](k=fill(false,
        6)) "Constant array"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[6](k={false,true,
        false,false,true,false}) "Constant array"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
equation
  connect(con.y, idxFirTru.u1)
    annotation (Line(points={{-38,60},{-12,60}}, color={255,0,255}));
  connect(conAllFal.y, idxFirTruAllFal.u1)
    annotation (Line(points={{-38,0},{-12,0}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Utilities/Validation/FirstTrueIndex.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.FirstTrueIndex\">
Buildings.Templates.Plants.Controls.Utilities.FirstTrueIndex</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
XXXX, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end FirstTrueIndex;
