within Buildings.Obsolete.Fluid.Movers.Data.Pumps.Wilo;
record Stratos32slash1to12 "Pump data for a Wilo Stratos 32/1-12 pump"
  extends Generic(
    speed_rpm_nominal=3580,
    final powerOrEfficiencyIsHydraulic=false,
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
    power(V_flow={2.11830535572e-05, 0.000167865707434, 0.000700939248601,
                    0.0012450039968,  0.00177258193445,  0.00227268185452,
                   0.00272332134293,  0.00312450039968,  0.00345423661071},
               P={    103.427852653,     110.225580543,     135.414121033,
                      162.955749719,     191.043411366,     216.051565678,
                      230.204882307,     236.346847436,     239.552825212}),
    pressure(V_flow={2.11830535572e-05, 0.000167865707434, 0.000700939248601,
                       0.0012450039968,  0.00177258193445,  0.00227268185452,
                      0.00272332134293,  0.00312450039968,  0.00345423661071},
                 dp={    59279.4925671,     59115.2927989,     59000.1476354,
                          57351.238791,     54446.2693068,     50284.7374612,
                         44865.6398104,     38328.4550274,     32066.9663984}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
  <p>Data from:
  <a href=\"http://productfinder.wilo.com/en/COM/product/00000018000029770002003a/fc_product_datasheet\">
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
<li>April 22, 2014
    by Filip Jorissen:<br/>
       Initial version
</li>
</ul>
</html>"));
end Stratos32slash1to12;
