within Buildings.Utilities.Math.Functions.Examples;
model BesselJ1 "Test case for Bessel function J1"
  extends Modelica.Icons.Example;

  Real J1 "Bessel function J1";

equation
  J1 = Buildings.Utilities.Math.Functions.besselJ1(time);

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/BesselJ1.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=30.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for Bessel functions of the
first kind of order 1, <i>J1</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 6, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end BesselJ1;
