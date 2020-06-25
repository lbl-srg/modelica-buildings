within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model CollectorDistributor
  "Model of a collector/distributor with zero pressure drop between connections"
  extends Networks.BaseClasses.PartialDistribution2Pipe(
    mDis_flow_nominal=sum(mCon_flow_nominal),
    final mDisCon_flow_nominal=fill(mDis_flow_nominal, nCon),
    final mEnd_flow_nominal=mDis_flow_nominal,
    final allowFlowReversal=true,
    show_heaFlo=false,
    final iConDpSen=-1,
    redeclare Connection2Pipe con[nCon],
    redeclare model Model_pipDis = Fluid.FixedResistances.LosslessPipe);
  annotation (
  defaultComponentName="colDis", Documentation(info="<html>
<p>
mDis_flow_nominal is not final as it can be set to a higher value than
sum(mCon_flow_nominal) in case of U-tube with primary recirculation.
</p>
</html>"),
Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>"));
end CollectorDistributor;
