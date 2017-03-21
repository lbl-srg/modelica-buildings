within Buildings.Fluid.HeatExchangers.BaseClasses;
function effCalc
  "Effectiveness calculation given C*, Ntu, and Configuration"

  input Real Z(min=0, max=1)
    "Ratio of capacity flow rate (CMin/CMax)";
  input Real NTU "The number of transfer units";
  input Buildings.Fluid.Types.HeatExchangerConfiguration cfg
    "The heat exchanger configuration";

  output Real eps(min=0, max=1) "Heat exchanger effectiveness";

protected
  constant Real CStaMin = 1e-4
    "Number below which we treat CSta as 0";
  constant Real CStaMax = 1 - CStaMin
    "Number above which we treat CSta as 1";

algorithm
  if Z < CStaMin then
    eps := 1 - exp(-NTU)
      "Mitchell and Braun 2012 Table 13.1 for C* = 0";
    return;
  end if;
  if cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow then
    if Z > CStaMax then
      eps :=NTU  / (1 +NTU)
        "Mitchell and Braun 2012, Table 13.1, C* = 1";
    else
      eps :=(1 - exp(-NTU*(1 - Z)))/(1 - Z*exp(-NTU*(1 - Z)))
        "Mitchell and Braun 2012 Table 13.1, C* != 1";
    end if;
  elseif cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1MixedStream2Unmixed or
         cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed then
    eps :=(1 - exp(-Z*(1 - exp(-NTU))))/Z
      "Mitchell and Braun 2012 Table 13.1,
      Crossflow, one fluid mixed, single pass";
  elseif cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.ParallelFlow then
    eps :=(1 - exp(-NTU*(1 + Z)))/(1 + Z)
      "Cengel and Turner 2005, Table 23-4";
  elseif cfg == Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowUnmixed then
    eps :=1 - exp(((NTU^0.22)/Z)*(exp(-Z*NTU^0.78) - 1))
      "Mitchell and Braun 2012 Table 13.1,
      Crossflow, both fluids unmixed";
  end if;
end effCalc;
