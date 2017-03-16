within Buildings.Fluid.HeatExchangers.BaseClasses;
function effCalc
  "Effectiveness calculation given C*, Ntu, and Configuration"

  input Real CSta
    "The capacity ratio; ratio of heat flow capacitances CMin/CMax";
  input Real Ntu
    "The number of transfer units";
  input Buildings.Fluid.Types.HeatExchangerConfiguration cfg
    "The heat exchanger configuration";

  output Real eff
    "The calculated effectiveness";

protected
  constant Real CStaMin = 1e-4
    "Number below which we treat CSta as 0";
  constant Real CStaMax = 1 - CStaMin
    "Number above which we treat CSta as 1";

algorithm
  if CSta < CStaMin then
    eff := 1 - exp(-Ntu)
      "Mitchell and Braun 2012 Table 13.1 for C* = 0";
    return;
  end if;
  if cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow then
    if CSta > CStaMax then
      eff := Ntu / (1 + Ntu)
        "Mitchell and Braun 2012, Table 13.1, C* = 1";
    else
      eff := (1 - exp(-Ntu*(1 - CSta)))/(1 - CSta*exp(-Ntu*(1 - CSta)))
        "Mitchell and Braun 2012 Table 13.1, C* != 1";
    end if;
  elseif cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1MixedStream2Unmixed or
         cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed then
    eff := (1 - exp(-CSta*(1 - exp(-Ntu))))/CSta
      "Mitchell and Braun 2012 Table 13.1,
      Crossflow, one fluid mixed, single pass";
  elseif cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.ParallelFlow then
    eff := (1 - exp(-Ntu*(1 + CSta)))/(1 + CSta)
      "Cengel and Turner 2005, Table 23-4";
  elseif cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowUnmixed then
    eff := 1 - exp(((Ntu^0.22)/CSta)*(exp(-CSta*Ntu^0.78) - 1))
      "Mitchell and Braun 2012 Table 13.1,
      Crossflow, both fluids unmixed";
  end if;
end effCalc;
