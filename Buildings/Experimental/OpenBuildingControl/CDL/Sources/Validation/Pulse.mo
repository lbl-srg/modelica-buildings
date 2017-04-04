within Buildings.Experimental.OpenBuildingControl.CDL.Sources.Validation;
model Pulse "Validation model for the Pulse block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Pulse Pulse1(
    amplitude = 2.0,
    width = 50,
    offset = 0.2,
    period = 1)
    "Block that generates pulse signal of type Real"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Sources/Validation/Pulse.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Sources.Pulse\">
Buildings.Experimental.OpenBuildingControl.CDL.Sources.Pulse</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
April 3, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Pulse;
