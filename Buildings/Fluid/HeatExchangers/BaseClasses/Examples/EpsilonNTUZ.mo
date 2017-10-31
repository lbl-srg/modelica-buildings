within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model EpsilonNTUZ "Test model for the functions epsilon_ntuZ and ntu_epsilonZ"
  extends Modelica.Icons.Example;
  import f = Buildings.Fluid.Types.HeatExchangerFlowRegime;
  Real Z[6] "Ratio of capacity flow rates";
  Real epsilon[6] "Heat exchanger effectiveness";
  Real eps[6] "Heat exchanger effectiveness";
  Real ntu[6] "Number of transfer units";
  Real diff[6] "Difference in results";

equation
  for conf in {Integer(f.ParallelFlow),
               Integer(f.CounterFlow),
               Integer(f.CrossFlowUnmixed),
               Integer(f.CrossFlowCMinMixedCMaxUnmixed),
               Integer(f.CrossFlowCMinUnmixedCMaxMixed),
               Integer(f.ConstantTemperaturePhaseChange)} loop
    Z[conf]       = abs(cos(time));
    epsilon[conf] = 0.01 + 0.98*abs(sin(time)) * 1/(1+Z[conf]);
    ntu[conf]     = ntu_epsilonZ(epsilon[conf], Z[conf], conf);
    eps[conf]     = epsilon_ntuZ(ntu[conf],     Z[conf], conf);
    diff[conf]    = epsilon[conf] - eps[conf];
  end for;
  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
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
September 28, 2016, by Massimo Cimmino:<br/>
Modified the test model for the addition of <code>ConstantTemperaturePhaseChange</code> flow regime.
</li>
<li>
April 25, 2016, by Michael Wetter:<br/>
Added work-around for JModelica in processing the enumeration.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/510\">Buildings, issue 510</a>.
</li>
<li>
October 19, 2014, by Michael Wetter:<br/>
Added conversion from <code>conf</code> to <code>Integer(conf)</code>
as array elements cannot be accessed by an enumeration. This
allows the model to run in OpenModelica.
</li>
</ul>
</html>"));
end EpsilonNTUZ;
