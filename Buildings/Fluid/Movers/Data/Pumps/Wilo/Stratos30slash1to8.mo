within Buildings.Fluid.Movers.Data.Pumps.Wilo;
record Stratos30slash1to8 "Pump data for a Wilo Stratos 30/1-8 pump"
  extends Generic(
    final powerOrEfficiencyIsHydraulic=false,
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
    power(V_flow={2.66111582909e-06, 0.000621486635037, 0.000887056469533,
                    0.0011525489114,  0.00140859349908,  0.00168018209891,
                   0.00191740837085,  0.00219831980599},
               P={    42.7878285797,     72.7712666315,     87.0576021552,
                      99.7562542248,     108.565085499,     117.461493336,
                      123.188074537,     128.511579716}),
    pressure(V_flow={2.66111582909e-06, 0.000621486635037, 0.000887056469533,
                       0.0011525489114,  0.00140859349908,  0.00168018209891,
                      0.00191740837085,  0.00219831980599},
                 dp={    50002.7035151,      49603.919395,     47783.2940685,
                         44505.1908368,     39882.6694921,     33688.9797121,
                         27835.1000463,     20631.4409942}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
  <p>Data from:
  <a href=\"http://productfinder.wilo.com/en/COM/product/00000018000029420002003a/fc_product_datasheet\">
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
March 29, 2023, by Hongxiang Fu:<br/>
Deleted angular speed parameters with the unit rpm.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">IBPSA, #1704</a>.
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
end Stratos30slash1to8;
