within Districts.Utilities.Math.Functions.Examples;
model PowerLinearized
  "Test problem for function that linearizes y=x^n below some threshold"
  extends Modelica.Icons.Example;
  Real T4(start=300^4) "Temperature raised to 4-th power";
  Real T "Temperature";
  Real TExact "Temperature";
equation
  T = (1+500*time);
  T = Districts.Utilities.Math.Functions.powerLinearized(x=T4, x0=243.15^4, n=0.25);
  TExact = abs(T4)^(1/4);

  annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/PowerLinearized.mos"
        "Simulate and plot"));
end PowerLinearized;
