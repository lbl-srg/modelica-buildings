within Buildings.Fluid.HeatExchangers.BaseClasses;
function effCalc
  "Effectiveness calculation given C*, Ntu, and Configuration"
  input Real CSta
    "The ratio of heat flow capacitances CMin/CMax";
  input Real Ntu
    "The number of transfer units";
  input Buildings.Fluid.Types.HeatExchangerConfiguration cfg
    "The heat exchanger configuration";
  output Real eff
    "The calculated effectiveness";
algorithm
  if cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow then
    eff :=(1 - exp(-Ntu*(1 - CSta)))/(1 - CSta*exp(-Ntu*(1 - CSta)))
      "Mitchell and Braun 2012 Table 13.1, C* != 1";
  elseif cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1MixedStream2Unmixed or
         cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed then
    eff :=(1 - exp(-CSta*(1 - exp(-Ntu))))/CSta
      "Mitchell and Braun 2012 Table 13.1,
      Crossflow, one fluid mixed, single pass";
  elseif cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.ParallelFlow then
    eff :=(1 - exp(-Ntu*(1 + CSta)))/(1 + CSta)
      "Cengel and Turner 2005, Table 23-4";
  elseif cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowUnmixed then
    eff :=1 - exp(((Ntu^0.22)/CSta)*(exp(-CSta*Ntu^0.78) - 1))
      "Mitchell and Braun 2012 Table 13.1,
      Crossflow, both fluids unmixed";
  end if;
end effCalc;
