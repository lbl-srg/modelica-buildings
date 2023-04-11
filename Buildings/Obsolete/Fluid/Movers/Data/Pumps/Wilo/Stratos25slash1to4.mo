within Buildings.Obsolete.Fluid.Movers.Data.Pumps.Wilo;
record Stratos25slash1to4 "Pump data for a Wilo Stratos 25/1-4 pump"
  extends Generic(
    speed_rpm_nominal=1800,
    final powerOrEfficiencyIsHydraulic=false,
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
    power(V_flow={5.55555555556e-07, 0.000402190923318,  0.00052269170579,
                  0.000643192488263, 0.000752738654147, 0.000866979655712,
                  0.000973395931142,  0.00108607198748,  0.00115962441315},
               P={    14.2085618951,     21.2596204596,     23.3573239437,
                      25.1349149442,      26.581943662,     27.9121571534,
                      28.8498841148,     29.4981726255,     29.7520982304}),
    pressure(V_flow={5.55555555556e-07, 0.000402190923318,  0.00052269170579,
                     0.000643192488263, 0.000752738654147, 0.000866979655712,
                     0.000973395931142,  0.00108607198748,  0.00115962441315},
                 dp={    17066.9518717,     16997.0053476,     16437.4331551,
                         15528.1283422,     14408.9839572,     13149.9465241,
                         11681.0695187,     9932.40641711,     8533.47593583}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
  <p>Data from:
  <a href=\"http://productfinder.wilo.com/en/COM/product/0000000e000379df0002003a/fc_product_datasheet\">
  http://productfinder.wilo.com/en/COM/product/0000000e000379df0002003a/fc_product_datasheet
  </a>
  </p>
  <p>See
  <a href=\"modelica://Buildings.Obsolete.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6\">
  Buildings.Obsolete.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6
  </a>
  for more information about how the data is derived.
  </p>
  </html>",
  revisions="<html>
<ul>
<li>
March 28, 2023, by Hongxiang Fu:<br/>
Copied this record to the Obsolete package.
Revised its original version to remove all rotational speed specifications.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">#1704</a>.
</li>
<li>
October 14, 2021, by Hongxiang Fu:<br/>
Rewrote the statements using <code>use_powerCharacteristic</code>
to support the implementation of
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Euler\">
<code>Buildings.Fluid.Movers.BaseClasses.Euler</code></a>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
<li>
February 17, 2016, by Michael Wetter:<br/>
Updated parameter names for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">#396</a>.
</li>
<li>
December 12, 2014, by Michael Wetter:<br/>
Added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code> annotations.
</li>
<li>April 17, 2014
    by Filip Jorissen:<br/>
       Initial version
</li>
</ul>
</html>"));
end Stratos25slash1to4;
