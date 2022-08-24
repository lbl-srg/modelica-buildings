within Buildings.Fluid.Movers.Data.Pumps.Wilo;
record TopS30slash5 "Pump data for a staged Wilo-Top-S 30/5 pump"
  extends Generic(
    speed_rpm_nominal=2650,
    final powerOrEfficiencyIsHydraulic=false,
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
    power(V_flow={4.24448217317e-06, 0.000275419732126, 0.000501792114695,
                  0.000688077721185, 0.000827202414639,  0.00101584606678,
                    0.0011714770798,  0.00132710809281,  0.00148981324278,
                   0.00166195057536},
               P={    83.0171256559,     101.117659669,     113.263045942,
                       122.28302674,     128.764680916,     135.257448954,
                      139.852003784,     143.350736549,     145.269964752,
                      146.115128625}),
    pressure(V_flow={4.24448217317e-06, 0.000275419732126, 0.000501792114695,
                     0.000688077721185, 0.000827202414639,  0.00101584606678,
                       0.0011714770798,  0.00132710809281,  0.00148981324278,
                      0.00166195057536},
                 dp={    52688.1456954,     49223.2450331,      45151.986755,
                         40994.1059603,     37269.3377483,     31205.7615894,
                         25661.9205298,     19598.3443709,     12755.1655629,
                         4699.27152318}),
    speeds_rpm = {0, 1890, 2190, 2650});
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
  <p>Data from:
  <a href=\"http://productfinder.wilo.com/en/COM/product/00000000000296670002003a/fc_product_datasheet\">
  http://productfinder.wilo.com/en/COM/product/00000000000296670002003a/fc_product_datasheet
  </a>
  </p>
  <p>See
  <a href=\"modelica://Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6\">
  Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6
  </a>
  for more information about how the data is derived.
  </p>
  </html>",
  revisions="<html>
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
February 17, 2016, by Michael Wetter:<br/>
Updated parameter names for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">#396</a>.
</li>
<li>
January 19, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end TopS30slash5;
