within Buildings.Controls.OBC.CDL.Continuous.Validation;
model Less "Validation model for the Less block"
  Buildings.Controls.OBC.CDL.Continuous.Less les
    "Less block, without hysteresis"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Less lesHys(h=0.2)
    "Less block, with hysteresis"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Sources.TimeTable ram(table=[0,0; 1,0; 2,1; 3,1; 4,0; 5,0])
    "Ramp signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Sources.Constant con(k=0.5) "Constant signal"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(con.y, lesHys.u2) annotation (Line(points={{-38,-10},{-26,-10},{-26,-28},
          {-12,-28}}, color={0,0,127}));
  connect(con.y, les.u2) annotation (Line(points={{-38,-10},{-26,-10},{-26,22},{
          -12,22}}, color={0,0,127}));
  connect(ram.y[1], les.u1)
    annotation (Line(points={{-38,30},{-12,30}}, color={0,0,127}));
  connect(ram.y[1], lesHys.u1) annotation (Line(points={{-38,30},{-20,30},{-20,-20},
          {-12,-20}}, color={0,0,127}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/Less.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Less\">
Buildings.Controls.OBC.CDL.Continuous.Less</a>.
The instance <code>les</code> has no hysteresis, and the
instance <code>lesHys</code> has a hysteresis.
</p>
</html>", revisions="<html>
<ul>
<li>
August 5, 2020, by Michael Wetter:<br/>
Updated model to add a test case with hysteresis.
</li>
<li>
April 1, 2017, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end Less;
