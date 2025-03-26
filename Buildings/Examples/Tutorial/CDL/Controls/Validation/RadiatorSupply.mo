within Buildings.Examples.Tutorial.CDL.Controls.Validation;
model RadiatorSupply
  "Validation model for the valve of the radiator supply"
    extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TRoo(
    height=-4,
    duration=3600,
    offset=297.15) "Room air temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Examples.Tutorial.CDL.Controls.RadiatorSupply
    conRadSup "Controller for radiator supply water temperature"
              annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TSup(
    amplitude=20,
    freqHz=1/720,
    offset=303.15) "Measured supply water temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(TRoo.y, conRadSup.TRoo) annotation (Line(points={{-38,30},{-20,30},{-20,
          6},{8,6}}, color={0,0,127}));
  connect(conRadSup.TSup, TSup.y) annotation (Line(points={{8,-6},{-16,-6},{-16,
          -30},{-38,-30}}, color={0,0,127}));
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
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/CDL/Controls/Validation/RadiatorSupply.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06));
end RadiatorSupply;
