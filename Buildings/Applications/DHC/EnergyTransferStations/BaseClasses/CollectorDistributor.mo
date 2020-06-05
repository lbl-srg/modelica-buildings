within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model CollectorDistributor
  "Model of a collector/distributor with zero pressure drop between connections"
  extends Networks.BaseClasses.PartialDistribution2Pipe(
    final mDis_flow_nominal=sum(mCon_flow_nominal),
    final mDisCon_flow_nominal=fill(mDis_flow_nominal, nCon),
    final mEnd_flow_nominal=mDis_flow_nominal,
    final allowFlowReversal=true,
    show_heaFlo=false,
    final iConDpSen=-1,
    redeclare Connection2Pipe con[nCon],
    redeclare model Model_pipDis = Fluid.FixedResistances.LosslessPipe);
  annotation (
  defaultComponentName="colDis");
end CollectorDistributor;
