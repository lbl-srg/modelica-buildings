within Buildings.Applications.DataCenters.DataHalls.CDUs.LiquidToLiquid;
model CDU_epsNTU "CDU using epsilon-NTU for heat transfer"
  extends
    Buildings.Applications.DataCenters.DataHalls.CDUs.BaseClasses.PartialCDU(
      redeclare Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
      final from_dp1=from_dpPla,
      final dp1_nominal=dat.dpHexPla_nominal,
      final linearizeFlowResistance1=linearizeFlowResistancePla,
      final n1=dat.nPla,
      final deltaM1=dat.deltaMPla,
      final from_dp2=from_dpRac,
      final dp2_nominal=dat.dpHexRac_nominal,
      final linearizeFlowResistance2=linearizeFlowResistanceRac,
      final n2=dat.nRac,
      final deltaM2=dat.deltaMRac,
      configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
      final use_Q_flow_nominal=true,
      final Q_flow_nominal=dat.Q_flow_nominal,
      final T_a1_nominal=dat.TPlaIn_nominal,
      final T_a2_nominal=dat.TRacIn_nominal,
      final r_nominal=dat.r_nominal,
      final nCon1=dat.nConPla,
      final nCon2=dat.nConRac));

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
<a href=\"modelica://Buildings.Applications.DataCenters.DataHalls.CDUs.BaseClasses.PartialCDU\">
Buildings.Applications.DataCenters.DataHalls.CDUs.BaseClasses.PartialCDU</a>
with a counter-flow heat exchanger that uses the &epsilon;-NTU relations, using an instance of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU</a>, and hence
the heat transfer is calculated with convection coefficients
that are a function of the mass flow rate.
</p>
<p>
See
<a href=\"modelica://Buildings.Applications.DataCenters.DataHalls.CDUs.BaseClasses.PartialCDU\">
Buildings.Applications.DataCenters.DataHalls.CDUs.BaseClasses.PartialCDU</a>
for a description of the CDU model.
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
