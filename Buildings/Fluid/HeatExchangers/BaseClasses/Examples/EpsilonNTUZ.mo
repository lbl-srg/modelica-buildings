within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model EpsilonNTUZ "Test model for the functions epsilon_ntuZ and ntu_epsilonZ"
  extends Modelica.Icons.Example; 
  import f = Buildings.Fluid.Types.HeatExchangerFlowRegime;
  Real epsilon[5] "Heat exchanger effectiveness";
  Real eps[5] "Heat exchanger effectiveness";
  Real Z[5] "Ratio of capacity flow rates";
  Real ntu[5] "Number of transfer units";
  Real diff[5] "Difference in results";

equation
  for conf in {f.ParallelFlow,
               f.CounterFlow,
               f.CrossFlowUnmixed,
               f.CrossFlowCMinMixedCMaxUnmixed,
               f.CrossFlowCMinUnmixedCMaxMixed} loop
     Z[conf]       = abs(cos(time));
     epsilon[conf] = 0.01 + 0.98*abs(sin(time)) * 1/(1+Z[conf]);
     ntu[conf]     = ntu_epsilonZ(epsilon[conf], Z[conf], conf);
     eps[conf]     = epsilon_ntuZ(ntu[conf],     Z[conf], conf);
     diff[conf]    = epsilon[conf] - eps[conf];
     assert(abs(diff[conf]) < 1E-10, "Check model implementation for bugs.");
  end for;
  annotation(
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/EpsilonNTUZ.mos" "Simulate and plot"), Documentation(info="<html>
Model to test the implementation of the epsilon-NTU functions and their inverse functions.
</html>"));
end EpsilonNTUZ;
