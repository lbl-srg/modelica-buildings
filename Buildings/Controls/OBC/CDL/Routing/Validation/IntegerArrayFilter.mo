within Buildings.Controls.OBC.CDL.Routing.Validation;
model IntegerArrayFilter
  "Validation model for the IntegerArrayFilter block"
  Buildings.Controls.OBC.CDL.Routing.IntegerArrayFilter
    intFil(nin=3, nout=2, msk={true,false,true})
    "Block that filter the input array"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Integers.Sources.Constant IntInp[3](k={1,2,3}) "Integer inputs"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(IntInp.y, intFil.u)
    annotation (Line(points={{-18,0},{18,0}}, color={255,127,0}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/IntegerArrayFilter.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.IntegerArrayFilter\">
Buildings.Controls.OBC.CDL.Routing.IntegerArrayFilter</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 25, 2021, by Baptiste Ravache:<br/>
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
end IntegerArrayFilter;
