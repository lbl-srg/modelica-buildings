within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Validation;
model Pulse "Validation model for the Pulse block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Pulse pulse(
    amplitude = 2.0,
    width = 0.5,
    offset = 0.2,
    period = 1)
    "Block that generates pulse signal of type Real"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Sources/Validation/Pulse.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Pulse\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Pulse</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
July 17, 2017, by Jianjun Hu:<br/>
First implemented in CDL.Continuous.Sources package.
</li>
</ul>
</html>"));
end Pulse;
