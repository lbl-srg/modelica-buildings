within Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.Validation;
model RemoveFromStagingOrder
  Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.RemoveFromStagingOrder remStaOrd(
    nUni=4) "Remove from staging order"
    annotation(Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxSor[4](k={3, 1, 2, 4})
    "Units sorted by increasing runtime"
    annotation(Placement(transformation(extent={{-70,30},{-50,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1(
    table=[
      0, 0, 1, 1, 0;
      1, 1, 1, 0, 0;
      2, 0, 0, 0, 0;
      3, 1, 1, 1, 1;
      4, 1, 1, 1, 0;
      5, 0, 0, 0, 1],
    timeScale=1,
    period=6)
    "Enable signal"
    annotation(Placement(transformation(extent={{-70,-30},{-50,-10}})));
equation
  connect(idxSor.y, remStaOrd.uIdxSor)
    annotation(Line(points={{-48,40},{-20,40},{-20,6},{-2,6}},
      color={255,127,0}));
  connect(u1.y, remStaOrd.u1)
    annotation(Line(points={{-48,-20},{-20,-20},{-20,-6},{-2,-6}},
      color={255,0,255}));
  annotation(
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/BaseClasses/Validation/RemoveFromStagingOrder.mos"
      "Simulate and plot"),
    experiment(
      StopTime=6.0,
      Tolerance=1e-06),
    Icon(coordinateSystem(preserveAspectRatio=false),
  graphics={Ellipse(lineColor={75,138,73},
    fillColor={255,255,255},
    fillPattern=FillPattern.Solid,
    extent={{-100,-100},{100,100}}),
  Polygon(lineColor={0,0,255},
    fillColor={75,138,73},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
    points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.RemoveFromStagingOrder\">
Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.RemoveFromStagingOrder</a>.
</p>
</html>"));
end RemoveFromStagingOrder;
