within Buildings.Fluid.HeatExchangers;
model WetCoilEffectivesnessNTU
  "Heat exchanger with effectiveness - NTU relation and simple model for moisture condensation, assuming completely wet coil"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectivenessNTU(
    final sensibleOnly1=true,
    final X_w1_nominal=0,
    sensibleOnly2=not Medium2.nXi>0,
    UA = 1/(1/hA.hA_1 + 1/hA.hA_2));

  parameter Real r_nominal(
    min=0,
    max=1) = 2/3
    "Ratio between air-side and water-side convective heat transfer (hA-value) at nominal condition";

  Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil hA(
    final r_nominal=r_nominal,
    final UA_nominal=UA_nominal,
    final m_flow_nominal_w=m1_flow_nominal,
    final m_flow_nominal_a=m2_flow_nominal,
    waterSideTemperatureDependent=false,
    airSideTemperatureDependent=false)
    "Model for convective heat transfer coefficient";

  Modelica.SIunits.HeatFlowRate QSen2_flow = Q2_flow - QLat2_flow
    "Sensible heat input into air stream (negative if air is cooled)";

  Modelica.SIunits.HeatFlowRate QLat2_flow=
    Buildings.Utilities.Psychrometrics.Constants.h_fg * mWat2_flow
    "Latent heat input into air (negative if air is dehumidified)";

equation
  // Convective heat transfer coefficient
  hA.m1_flow = m1_flow;
  hA.m2_flow = m2_flow;
  hA.T_1 = T_in1;
  hA.T_2 = T_in2;
  annotation (Documentation(revisions="<html>
<ul>
<li>
April 7, 2019, by Filip Jorissen:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1109\">#1109</a>.
</li>
</ul>
</html>", info="<html>
<p>
fixme: Documentation must be added.
</p>
</html>"), Icon(graphics={
        Polygon(
          points={{-56,-50},{-58,-56},{-60,-64},{-58,-72},{-54,-74},{-44,-74},{-38,
              -68},{-40,-60},{-44,-48},{-50,-36},{-56,-50}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-26,-32},{-28,-38},{-30,-46},{-28,-54},{-24,-56},{-14,-56},{-8,
              -50},{-10,-42},{-14,-30},{-20,-18},{-26,-32}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,-48},{6,-54},{4,-62},{6,-70},{10,-72},{20,-72},{26,-66},{24,
              -58},{20,-46},{14,-34},{8,-48}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{44,-22},{42,-28},{40,-36},{42,-44},{46,-46},{56,-46},{62,-40},
              {60,-32},{56,-20},{50,-8},{44,-22}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end WetCoilEffectivesnessNTU;
