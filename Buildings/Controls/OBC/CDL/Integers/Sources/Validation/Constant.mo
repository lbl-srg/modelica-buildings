within Buildings.Controls.OBC.CDL.Integers.Sources.Validation;
model Constant "Validate the Constant block"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant con(k=5) "Block output integer constant value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Sources/Validation/Constant.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.Sources.Constant\">
Buildings.Controls.OBC.CDL.Integers.Sources.Constant</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
July 17, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Constant;
