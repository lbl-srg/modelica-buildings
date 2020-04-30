within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model CollectorDistributor
  "Model of a collector/distributor with zero pressure drop between connections"
  extends Networks.BaseClasses.PartialDistribution2Pipe(
    final mDis_flow_nominal={sum(mCon_flow_nominal[i:nCon]) for i in 1:nCon},
    each have_heaFloOut=true,
    final mEnd_flow_nominal=0,
    final iConDpSen=-1,
    redeclare Connection2Pipe con[nCon],
    redeclare model Model_pipDis = Fluid.FixedResistances.LosslessPipe);
  annotation (
  defaultComponentName="colDis");
end CollectorDistributor;
