within Buildings.Controls.OBC.CDL.Continuous.Sources.Validation;
model StandardTime "Test model for the StandardTime block"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Continuous.Sources.ModelTime staTim
    "Standard time"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (experiment(StartTime=-1,Tolerance=1e-6, StopTime=1),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Sources/Validation/StandardTime.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model tests the implementation of the block that outputs the
model time.
</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2017, by Jianjun Hu:<br/>
First implementation in CDL.
</li>
</ul>
</html>"));
end StandardTime;
