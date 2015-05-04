within Buildings.Controls.SetPoints.Examples;
model Table "Test model for table that determines set points"
  extends Modelica.Icons.Example;
  Buildings.Controls.SetPoints.Table tabConExt(table=[20,0; 22,0.5; 25,0.5; 26,1])
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Ramp TRoo(
    duration=1,
    offset=15,
    height=15)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.SetPoints.Table tabLinExt(constantExtrapolation=false, table=[
        20,0; 22,0.5; 25,0.5; 26,1])
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(TRoo.y, tabLinExt.u) annotation (Line(
      points={{-59,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo.y, tabConExt.u) annotation (Line(
      points={{-59,10},{-50,10},{-50,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/SetPoints/Examples/Table.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that demonstrates the use of the block
<a href=\"modelica://Buildings.Controls.SetPoints.Table\">
Buildings.Controls.SetPoints.Table</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 21, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end Table;
