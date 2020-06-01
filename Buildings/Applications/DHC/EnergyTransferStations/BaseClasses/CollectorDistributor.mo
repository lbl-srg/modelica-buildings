within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model CollectorDistributor
  "Model of a collector/distributor with zero pressure drop between connections"
  extends Networks.BaseClasses.PartialDistribution2Pipe(
    mDis_flow_nominal={sum(mCon_flow_nominal[i:nCon]) for i in 1:nCon},
    show_heaFlo=false,
    mEnd_flow_nominal=sum(mDis_flow_nominal),
    iConDpSen=-1,
    redeclare Connection2Pipe con[nCon],
    redeclare model Model_pipDis = Fluid.FixedResistances.LosslessPipe);
  annotation (
  defaultComponentName="colDis");
end CollectorDistributor;
