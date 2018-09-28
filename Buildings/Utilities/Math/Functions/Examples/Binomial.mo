within Buildings.Utilities.Math.Functions.Examples;
model Binomial "Test case for evaluation of binomial coefficients"
  extends Modelica.Icons.Example;

  Real bin[10] "Binomial coefficient";
  Integer n "Size of set";

equation
  n = integer(if time >= 1 then floor(time) else 1);

  for k in 1:10 loop
    if n >= k then
      bin[k] = Buildings.Utilities.Math.Functions.binomial(n,k);
    else
      bin[k] = 0.0;
    end if;
  end for;

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/Binomial.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=15.9),
    Documentation(info="<html>
<p>
This example demonstrates the use of the function for the evaluation of the
binomial coefficient \"n choose k\".
</p>
</html>", revisions="<html>
<ul>
<li>
June 6, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end Binomial;
