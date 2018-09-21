within Buildings.Utilities.Math.Functions.Examples;
model BesselY0 "Test case for Bessel function Y0"
  extends Modelica.Icons.Example;

  Real Y0 "Bessel function Y0";

equation
  Y0 = Buildings.Utilities.Math.Functions.besselY0(time);

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/BesselY0.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StartTime=0.1, StopTime=30.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for Bessel functions of the
second kind of order 0, <i>Y0</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 6, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end BesselY0;
