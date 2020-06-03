within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model CollectorDistributor
  "Model of a collector/distributor with zero pressure drop between connections"
  extends Networks.BaseClasses.PartialDistribution2Pipe(
    mDis_flow_nominal=sum(mCon_flow_nominal),
    mDisCon_flow_nominal=fill(mDis_flow_nominal, nCon),
    mEnd_flow_nominal=mDis_flow_nominal,
    show_heaFlo=false,
    iConDpSen=-1,
    redeclare Connection2Pipe con[nCon],
    redeclare model Model_pipDis = Fluid.FixedResistances.LosslessPipe);
  annotation (
  defaultComponentName="colDis");
end CollectorDistributor;
