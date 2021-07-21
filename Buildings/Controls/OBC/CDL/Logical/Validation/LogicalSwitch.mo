within Buildings.Controls.OBC.CDL.Logical.Validation;
model LogicalSwitch
  "Validation model for the LogicalSwitch block"
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    width=0.7,
    period=1.5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,24},{-6,44}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    width=0.5,
    period=3)
    "Block that outputs cyclic on and off: switch between u1 and u3"
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    width=0.5,
    period=5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-46},{-6,-26}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logicalSwitch
    "Switch between two boolean inputs"
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));

equation
  connect(booPul2.y,logicalSwitch.u2)
    annotation (Line(points={{-4,0},{-4,0},{24,0}},color={255,0,255}));
  connect(booPul1.y,logicalSwitch.u1)
    annotation (Line(points={{-4,34},{10,34},{10,8},{24,8}},color={255,0,255}));
  connect(booPul3.y,logicalSwitch.u3)
    annotation (Line(points={{-4,-36},{10,-36},{10,-8},{24,-8}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=5.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/LogicalSwitch.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.LogicalSwitch\">
Buildings.Controls.OBC.CDL.Logical.LogicalSwitch</a>.
</p>
<p>
The input <code>u2</code> is the switch input: If <code>u2 = true</code>,
then output <code>y = u1</code>;
else output <code>y = u3</code>.
</p>

</html>",
      revisions="<html>
<ul>
<li>
April 2, 2017, by Jianjun Hu:<br/>
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
end LogicalSwitch;
