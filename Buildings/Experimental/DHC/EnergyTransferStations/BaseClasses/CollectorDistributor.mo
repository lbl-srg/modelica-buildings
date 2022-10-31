within Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses;
model CollectorDistributor
  "Model of a collector/distributor with zero pressure drop between connections"
  extends Buildings.Experimental.DHC.Networks.BaseClasses.PartialDistribution2Pipe(
    mDis_flow_nominal=sum(
      mCon_flow_nominal),
    final mDisCon_flow_nominal=fill(
      mDis_flow_nominal,
      nCon),
    final mEnd_flow_nominal=mDis_flow_nominal,
    final allowFlowReversal=true,
    final iConDpSen=-1,
    redeclare Connection2PipeLossless con[nCon],
    redeclare model Model_pipDis=Fluid.FixedResistances.LosslessPipe);
  annotation (
    defaultComponentName="colDis",
    Documentation(
      info="<html>
<p>
This model represents a collector/distributor which connects
<code>nCon</code> hydronic circuits in parallel.
The pressure drop between each connection is assumed negligible
compared to the pressure drop in each circuit, and is set to zero
in the model.
By default,
</p>
<ul>
<li>
there is no bypass flow (which can be added later by connecting
the ports <code>port_bDisSup</code> and <code>port_aDisRet</code>),
</li>
<li>
the nominal distribution mass flow rate
<code>mDis_flow_nominal</code> is equal to the sum
of the nominal mass flow rate in each circuit.
However, this parameter assigment is not final and it can be set
for instance to a higher value to represent a primary overflow
in a supply through loop.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end CollectorDistributor;
