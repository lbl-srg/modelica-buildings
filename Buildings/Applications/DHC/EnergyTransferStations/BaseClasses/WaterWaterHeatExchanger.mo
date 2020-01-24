within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model WaterWaterHeatExchanger "Heat exchanger model"
  //  parameter Real eps_nominal "Nominal heat transfer effectiveness";
  //    extends Buildings.Fluid.HeatExchangers.ConstantEffectiveness(
  //    eps = eps_nominal,
  //    show_T=true);
  extends Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU(
    use_Q_flow_nominal = false,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    show_T=true);
    annotation (Placement(transformation(extent={{-10,-84},{10,-64}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WaterWaterHeatExchanger;
