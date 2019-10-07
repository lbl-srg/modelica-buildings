within Buildings.Utilities.Math.Functions.Examples;
model BesselY1 "Test case for Bessel function Y1"
  extends Modelica.Icons.Example;

  Real Y1 "Bessel function Y1";

equation
  Y1 = Buildings.Utilities.Math.Functions.besselY1(time);

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/BesselY1.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StartTime=0.1, StopTime=30.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for Bessel functions of the
second kind of order 1, <i>Y1</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 6, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end BesselY1;
