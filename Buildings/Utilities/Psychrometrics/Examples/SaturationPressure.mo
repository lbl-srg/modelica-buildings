within Buildings.Utilities.Psychrometrics.Examples;
model SaturationPressure "Model to test the wet bulb temperature computation"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Air "Medium model"
           annotation (choicesAllMatching = true);

  Buildings.Utilities.Psychrometrics.SaturationPressure pSat
    "Saturation pressure"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp T(
    height=373.15 - 190,
    duration=1,
    offset=190) "Temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(T.y, pSat.TSat) annotation (Line(
      points={{-39,0},{-11,0}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Examples/SaturationPressure.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This examples is a unit test for the saturation pressure computation.
</html>", revisions="<html>
<ul>
<li>
October 2, 2012 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SaturationPressure;
