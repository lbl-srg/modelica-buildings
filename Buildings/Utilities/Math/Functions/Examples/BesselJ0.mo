within Buildings.Utilities.Math.Functions.Examples;
model BesselJ0 "Test case for Bessel function J0"
  extends Modelica.Icons.Example;

  Real J0 "Bessel function J0";

equation

  J0 = Buildings.Utilities.Math.Functions.besselJ0(time);

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/BesselJ0.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=30.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for Bessel functions of the
first kind of order 0, <i>J0</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 6, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end BesselJ0;
