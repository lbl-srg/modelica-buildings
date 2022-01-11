within Buildings.Utilities.IO.Files.Examples.BaseClasses;
model PartialCSV "Base model for CSV reader and writer example"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Cosine cos(f=0.345) "Cosine"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Step step(startTime=5) "Step function"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  annotation (Documentation(revisions="<html>
<ul>
<li>
May 14, 2018 by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/924\">#924</a>.
</li>
</ul>
</html>", info="<html>
<p>
Partial model that contains a step function and cosine signal.
</p>
</html>"));
end PartialCSV;
