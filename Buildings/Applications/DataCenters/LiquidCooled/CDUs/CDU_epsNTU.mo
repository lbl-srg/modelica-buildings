within Buildings.Applications.DataCenters.LiquidCooled.CDUs;
model CDU_epsNTU "CDU using epsilon-NTU for heat transfer"
  extends Buildings.Applications.DataCenters.LiquidCooled.CDUs.BaseClasses.PartialCDU(
    redeclare Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
      final from_dp1=from_dpPla,
      final dp1_nominal=dpHexPla_nominal,
      final linearizeFlowResistance1=linearizeFlowResistancePla,
      final deltaM1=deltaMPla,
      final from_dp2=from_dpRac,
      final dp2_nominal=dpHexRac_nominal,
      final linearizeFlowResistance2=linearizeFlowResistanceRac,
      final deltaM2=deltaMRac,
      configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
      final use_Q_flow_nominal=true,
      final Q_flow_nominal=Q_flow_nominal,
      final T_a1_nominal=TPlaIn_nominal,
      final T_a2_nominal=TRacIn_nominal,
      final r_nominal=r_nominal,
      final n1=nPla,
      final n2=nRac)
    );

  annotation (
  defaultComponentName="cdu",
  Documentation(
    info="<html>
<p>
Model of a coolant distribution unit (CDU) with with a steady-state,
counter-flow heat exchanger that uses the epsilon-NTU correlations.
</p>
<p>
This model configures the heat exchanger that is used in
<a href=\"Buildings.Applications.DataCenters.LiquidCooled.CDUs.BaseClasses.PartialCDU\">
Buildings.Applications.DataCenters.LiquidCooled.CDUs.BaseClasses.PartialCDU</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 29, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CDU_epsNTU;
