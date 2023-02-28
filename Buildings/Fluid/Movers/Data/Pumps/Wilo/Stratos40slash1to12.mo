within Buildings.Fluid.Movers.Data.Pumps.Wilo;
record Stratos40slash1to12 "Pump data for a Wilo Stratos 40/1-12 pump"
  extends Generic(
    speed_rpm_nominal=3690,
    final powerOrEfficiencyIsHydraulic=false,
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
    power(V_flow={2.05415499533e-05,  0.0012380952381, 0.00197759103641,
                   0.00261998132586, 0.00315779645191, 0.00385247432306,
                   0.00436788048553, 0.00493557422969},
               P={    195.711338777,     254.50525152,    302.203269367,
                      339.387400348,    367.008331835,    392.162896856,
                      397.658764999,    404.489181997}),
    pressure(V_flow={2.05415499533e-05,  0.0012380952381, 0.00197759103641,
                      0.00261998132586, 0.00315779645191, 0.00385247432306,
                      0.00436788048553, 0.00493557422969},
              dp={       78528.2698296,     78278.944236,    77854.9591567,
                         74108.1678158,    68408.8742011,    57809.9050693,
                         48393.0944907,    37408.2956474}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
  <p>Data from:
  <a href=\"http://productfinder.wilo.com/en/COM/product/00000018000029380002003a/fc_product_datasheet\">
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
end Stratos40slash1to12;
