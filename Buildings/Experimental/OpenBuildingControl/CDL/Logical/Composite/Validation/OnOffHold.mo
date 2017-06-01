within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite.Validation;
model OnOffHold "Validation model for the OnOffHold block"

extends Modelica.Icons.Example;

  Sources.BooleanPulse                                                booPul(period=
        1600, startTime=0)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite.OnOffHold
    onOffHold annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(booPul.y, onOffHold.u)
    annotation (Line(points={{-19,0},{18.8,0}},
                                              color={255,0,255}));
  annotation (
  experiment(StopTime=7200.0, Tolerance=1e-06),
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Composite/Validation/OnOffHold.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite.OnOffHold\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.Composite.OnOffHold</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 24, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>

</html>"));
end OnOffHold;
