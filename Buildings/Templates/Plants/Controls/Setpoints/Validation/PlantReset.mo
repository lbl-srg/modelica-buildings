within Buildings.Templates.Plants.Controls.Setpoints.Validation;
model PlantReset
  Buildings.Templates.Plants.Controls.Setpoints.PlantReset res(
    nSenDpRem=2,
    dpSet_max={5E4,8E4},
    TSup_nominal=323.15,
    TSupSetLim=298.15,
    resDp_max=0.75,
    resTSup_min=0.25) "Plant reset"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable ena(
    table=[
      0, 0;
      2, 1;
      19, 0],
    timeScale=1000,
    final period=20000)
    "Plant enable"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable timTabLin(
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final table=[
      0, 0;
      150, 0;
      300, 0;
      450, 0;
      600, 0;
      750, 0;
      900, 0;
      1050, 0;
      1200, 4;
      1350, 3;
      1500, 2;
      1650, 1;
      1800, 0],
    timeScale=10)
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse staPro(
    width=0.1,
    final period=8000,
    shift=2000)
    "Staging process in progress"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
equation
  connect(timTabLin.y[1], reaToInt.u)
    annotation (Line(points={{-58,40},{-42,40}},color={0,0,127}));
  connect(reaToInt.y,res.nReqRes)
    annotation (Line(points={{-18,40},{0,40},{0,6},{18,6}},color={255,127,0}));
  connect(staPro.y, res.u1StaPro)
    annotation (Line(points={{-58,-40},{0,-40},{0,-6},{18,-6}},color={255,0,255}));
  connect(ena.y[1], res.u1Ena)
    annotation (Line(points={{-58,0},{18,0}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=20000.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Setpoints/Validation/PlantReset.mos"
        "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.Setpoints.PlantReset\">
Buildings.Templates.Plants.Controls.Setpoints.PlantReset</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)));
end PlantReset;
