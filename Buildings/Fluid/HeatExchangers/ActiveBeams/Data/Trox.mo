within Buildings.Fluid.HeatExchangers.ActiveBeams.Data;
package Trox "Performance data for Trox"
  record DID632A_nozzleH_length6ft_cooling =
    Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Generic (
      primaryAir(
        r_V = {0,0.714286, 1,1.2857},
        f =   {0,0.823403, 1,1.1256}),
      dT(
        f = {0,0.5,1},
        r_dT=
            {0,0.5,1}),
      water(
        r_V = {0,0.33333,0.5,0.666667,0.833333,1,1.333333},
        f =   {0,0.71,0.85,0.92,0.97,1,1.04}),
      mAir_flow_nominal=0.0792,
      mWat_flow_nominal =   0.094,
      dpWat_nominal = 10000,
      dpAir_nominal = 100,
      dT_nominal =          -10,
      Q_flow_nominal =   -1092)
  "Performance data for Trox DID 632A for cooling mode"
       annotation (
    Documentation(revisions="<html>
<ul>
<li>
June 13, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 20, 2016, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Performance data for Trox active beam for cooling mode.
</p>
</html>"));


  record DID632A_nozzleH_length6ft_heating =
      Buildings.Fluid.HeatExchangers.ActiveBeams.Data.Generic (
      dT(
        f = {0,0.5,1},
        r_dT=
            {0,0.5,1}),
      primaryAir(
        r_V = {0,0.714286, 1, 1.2857},
        f =   {0,0.8554, 1, 1.0778}),
      water(
        r_V = {0,0.33333,0.5,0.666667,0.833333,1,1.333333},
        f =   {0,0.71,0.85,0.92,0.97,1,1.04}),
      mAir_flow_nominal=0.0792,
      mWat_flow_nominal =   0.094,
      dpWat_nominal = 10000,
      dpAir_nominal = 100,
      dT_nominal =          27.8,
      Q_flow_nominal =   2832)
  "Performance data for Trox DID 632A for heating mode"
      annotation (
    Documentation(revisions="<html>
<ul>
<li>
June 13, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 20, 2016, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Performance data for Trox active beam for heating mode.
</p>
</html>"));


annotation (Documentation(revisions="", info="<html>
<p>
Package with performance data for active beams from Trox.
</p>
</html>"));
end Trox;
