within Buildings.Experimental.OpenBuildingControl.CDL.Integers.Validation;
model OnCounter "Validation model for the OnCounter block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Integers.OnCounter onCounter
    "Block that outputs increment if the input switches to true"
    annotation (Placement(transformation(extent={{16,-10},{36,10}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse booPul(
    width = 0.5,
    period = 0.1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse reset(
    width = 0.5,
    period = 1.0)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-50},{-6,-30}})));

equation
  connect(reset.y, onCounter.reset) annotation (Line(points={{-5,-40},{26,-40},{
          26,-14},{26,-14},{26,-12},{26,-12}},
                              color={255,0,255}));
  connect(booPul.y, onCounter.trigger)
    annotation (Line(points={{-5,0},{4,0},{14,0}}, color={255,0,255}));
  annotation (
  experiment(StopTime=2.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Integers/Validation/OnCounter.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Integers.OnCounter\">
Buildings.Experimental.OpenBuildingControl.CDL.Integers.OnCounter</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end OnCounter;
