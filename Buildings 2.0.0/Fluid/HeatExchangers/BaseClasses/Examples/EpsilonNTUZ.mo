within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model EpsilonNTUZ "Test model for the functions epsilon_ntuZ and ntu_epsilonZ"
  extends Modelica.Icons.Example;
  import f = Buildings.Fluid.Types.HeatExchangerFlowRegime;
  Real Z[5] "Ratio of capacity flow rates";
  Real epsilon[5] "Heat exchanger effectiveness";
  Real eps[5] "Heat exchanger effectiveness";
  Real ntu[5] "Number of transfer units";
  Real diff[5] "Difference in results";

equation
  for conf in {f.ParallelFlow,
               f.CounterFlow,
               f.CrossFlowUnmixed,
               f.CrossFlowCMinMixedCMaxUnmixed,
               f.CrossFlowCMinUnmixedCMaxMixed} loop
     Z[Integer(conf)]       = abs(cos(time));
     epsilon[Integer(conf)] = 0.01 + 0.98*abs(sin(time)) * 1/(1+Z[Integer(conf)]);
     ntu[Integer(conf)]     = ntu_epsilonZ(epsilon[Integer(conf)], Z[Integer(conf)], Integer(conf));
     eps[Integer(conf)]     = epsilon_ntuZ(ntu[Integer(conf)],     Z[Integer(conf)], Integer(conf));
     diff[Integer(conf)]    = epsilon[Integer(conf)] - eps[Integer(conf)];
  end for;
  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/EpsilonNTUZ.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Model to test the implementation of the epsilon-NTU functions and their inverse functions.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 19, 2014, by Michael Wetter:<br/>
Added conversion from <code>conf</code> to <code>Integer(conf)</code>
as array elements cannot be accessed by an enumeration. This
allows the model to run in OpenModelica.
</li>
</ul>
</html>"));
end EpsilonNTUZ;
