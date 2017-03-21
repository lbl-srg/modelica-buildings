within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model TestEffCalc
  "Test using the effCalc function to calculate effectiveness"
  extends Modelica.Icons.Example;
  parameter Real Z[:]=0:0.25:1 "Ratio of capacity flow rates, Z = CMin/CMax";

  // VARIABLES
  Real NTU(min=0) = time "Number of transfer units";
  Real effPar[size(Z, 1)] "Effectiveness of a parallel flow heat exchanger";
  Real effCou[size(Z, 1)] "Effectiveness of a counter flow heat exchanger";
  Real effCro[size(Z, 1)]
    "Effectiveness of a cross-flow heat exchanger; both streams mixed";
  Real effCro1Mix2Unm[size(Z, 1)]
    "Effectiveness of a cross-flow heat exchanger; stream 1 mixed, 2 unmixed";
  Real effCro1Unm2Mix[size(Z, 1)]
    "Effectiveness of a cross-flow heat exchanger; stream 1 unmixed, 2 mixed";

protected
  constant Buildings.Fluid.Types.HeatExchangerConfiguration par=
    Buildings.Fluid.Types.HeatExchangerConfiguration.ParallelFlow;
  constant Buildings.Fluid.Types.HeatExchangerConfiguration cou=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow;
  constant Buildings.Fluid.Types.HeatExchangerConfiguration cro=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowUnmixed;
  constant Buildings.Fluid.Types.HeatExchangerConfiguration cro1Mix2Unm=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1MixedStream2Unmixed;
  constant Buildings.Fluid.Types.HeatExchangerConfiguration cro1Unm2Mix=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1UnmixedStream2Mixed;

equation
  for i in 1:size(Z, 1) loop
    effPar[i] =Buildings.Fluid.HeatExchangers.BaseClasses.effCalc(
      Z=Z[i],
      NTU=NTU,
      cfg=par);
    effCou[i] =Buildings.Fluid.HeatExchangers.BaseClasses.effCalc(
      Z=Z[i],
      NTU=NTU,
      cfg=cou);
    effCro[i] =Buildings.Fluid.HeatExchangers.BaseClasses.effCalc(
      Z=Z[i],
      NTU=NTU,
      cfg=cro);
    effCro1Mix2Unm[i] =Buildings.Fluid.HeatExchangers.BaseClasses.effCalc(
      Z=Z[i],
      NTU=NTU,
      cfg=cro1Mix2Unm);
    effCro1Unm2Mix[i] =Buildings.Fluid.HeatExchangers.BaseClasses.effCalc(
      Z=Z[i],
      NTU=NTU,
      cfg=cro1Unm2Mix);
  end for;
  annotation (
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/TestEffCalc.mos"
      "Simulate and Plot"),
    experiment(StopTime=5),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TestEffCalc;
