within Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler;
record BAC_Trillium_TDFS1238N_C60ET40B
  "BAC Trillium TDFS1238N-C60ET40B"
  extends Generic(
    PFan_Q_flow_nominal=-117680/2931000,
    Q_flow_nominal=-2931000,
    TAirIn_nominal=308.15,
    TCooIn_nominal=319.26,
    TCooOut_nominal=313.7);

  annotation (
    defaultComponentName="datDryCoo",
    defaultComponentPrefixes="parameter",
    Documentation(info="<html>
<p>
Performance data record for BAC TrilliumSeries Dry Cooler, model TDFS1238N-C60ET40B.
</p>
</html>", revisions="<html>
<ul>
<li>
April 27, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BAC_Trillium_TDFS1238N_C60ET40B;
