within Buildings.Examples.Tutorial.CDL.Controls.Validation;
model BoilerReturn
  "Validation model for the return temperature controller of the boiler"
    extends Modelica.Icons.Example;

  Buildings.Examples.Tutorial.CDL.Controls.BoilerReturn conBoiRet
    "Controller for boiler return water temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TRet(
    height=50,
    duration=3600,
    offset=293.15) "Return water temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(TRet.y, conBoiRet.TRet)
    annotation (Line(points={{-38,0},{-12,0}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
Validation model for the boiler return water temperature controller.
The input to the controller is a ramp signal of increasing measured return water temperature.
The validation shows that as the temperature crosses the set point, the valve opens.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/CDL/Controls/Validation/BoilerReturn.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06));
end BoilerReturn;
