within Buildings.Utilities.Math.Examples;
model BooleanReplicator "Test model for BooleanReplicator"

  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.BooleanTable booleanTable(table={100,200,400,500})
    "Boolean input signal"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Utilities.Math.BooleanReplicator booleanReplicator(nout=
       4) "Replicates boolean values" annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(booleanTable.y, booleanReplicator.u) annotation (Line(
      points={{-19,10},{-2,10}},
      color={255,0,255},
      smooth=Smooth.None));
annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                    graphics),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/BooleanReplicator.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the implementation of BooleanReplicator.
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2012, by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));
end BooleanReplicator;
