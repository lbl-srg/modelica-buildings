within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.Interface;
partial model PartialSingleBoreHole "Single borehole heat exchanger"
  extends PartialBoreHoleElement;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
                              annotation (choicesAllMatching=true);
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(show_T=true,
      redeclare package Medium = Medium);
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(final
      computeFlowResistance=false, final linearizeFlowResistance=false);
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;

  Modelica.SIunits.Temperature TWallAve "Average borehole temperature";

end PartialSingleBoreHole;
