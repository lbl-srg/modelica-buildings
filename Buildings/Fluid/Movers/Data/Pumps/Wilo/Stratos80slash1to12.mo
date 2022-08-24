within Buildings.Fluid.Movers.Data.Pumps.Wilo;
record Stratos80slash1to12 "Pump data for a Wilo Stratos 80/1-12 pump"
  extends Generic(
    speed_rpm_nominal=2610,
    final powerOrEfficiencyIsHydraulic=false,
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
    power(V_flow={8.79043600562e-06, 0.00277777777778, 0.00556874120956,
                   0.00776635021097, 0.00978815049226,  0.0113484528833,
                    0.0127329465541,   0.013985583685,  0.0154360056259},
               P={    437.425146701,    588.954435301,    792.603370491,
                      931.705429399,    1048.15648043,    1115.77190985,
                      1154.92222088,    1171.51603429,    1166.47479929}),
    pressure(V_flow={8.79043600562e-06, 0.00277777777778, 0.00556874120956,
                      0.00776635021097, 0.00978815049226,  0.0113484528833,
                       0.0127329465541,   0.013985583685,  0.0154360056259},
                 dp={    78355.8975904,    78243.6144578,    78054.5060241,
                         75596.0963855,    70490.1686747,    63682.2650602,
                         55361.4939759,    45527.8554217,    30966.5060241}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
  <p>Data from:
  <a href=\"http://productfinder.wilo.com/en/COM/product/0000001700017d670001003a/fc_product_datasheet\">
  http://productfinder.wilo.com/en/COM/product/0000000e000379df0002003a/fc_product_datasheet
  </a>
  </p>
  <p>See
  <a href=\"modelica://Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6\">
  Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6
  </a>
  for more information about how the data is derived.
  </p>
  </html>", revisions="<html>
<ul>
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
<li>April 22, 2014
    by Filip Jorissen:<br/>
       Initial version
</li>
</ul>
</html>"));
end Stratos80slash1to12;
