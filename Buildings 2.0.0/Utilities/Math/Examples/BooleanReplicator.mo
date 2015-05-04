within Buildings.Utilities.Math.Examples;
model BooleanReplicator "Test model for boolean replicator"

  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.BooleanTable booTab(table={100,200,400,500})
    "Boolean input signal"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Utilities.Math.BooleanReplicator booRep(nout=
       4) "Replicates boolean values" annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(booTab.y, booRep.u) annotation (Line(
      points={{-19,10},{-2,10}},
      color={255,0,255},
      smooth=Smooth.None));
annotation (experiment(StopTime=600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/BooleanReplicator.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.BooleanReplicator\">
Buildings.Utilities.Math.BooleanReplicator</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 31, 2012, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
July 27, 2012, by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end BooleanReplicator;
