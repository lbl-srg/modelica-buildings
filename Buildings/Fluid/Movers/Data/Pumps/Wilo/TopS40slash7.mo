within Buildings.Fluid.Movers.Data.Pumps.Wilo;
record TopS40slash7 "Pump data for a staged Wilo-Top-S 40/7 pump"
  extends Generic(
    speed_rpm_nominal=2800,
    use_powerCharacteristic = true,
    power(V_flow={9.97406742472e-07,0.000621384400559,0.00113006183922,
                  0.00162078595651,0.00206961899062,0.00244663873928,
                  0.0029074406543,0.00330241372432,0.00375723119888,
                  0.00418212647117,0.00466686614802},
          P={254.806788065,282.40881459,303.06122449,330.952380952,
             347.819548872,360.093167702,372.657450077,380.261136713,
             386.328725038,390.607012036,391.047619048}),
    pressure(V_flow={9.97406742472e-07,0.000621384400559,0.00113006183922,0.00162078595651,
                     0.00206961899062,0.00244663873928,0.0029074406543,0.00330241372432,
                     0.00375723119888,0.00418212647117,0.00466686614802},
             dp={70951.3953488,69946.0659263,67225.7989228,63706.4291679,
                 59843.4165588,54951.3185253,48807.3201536,42775.1388251,
                 34577.6798464,26835.4759718,17270.2037493}),
    speeds_rpm = {0, 2200, 2450, 2650});
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
  <p>Data from:
  <a href=\"http://productfinder.wilo.com/en/COM/product/000000120001ad1f0001003a/fc_product_datasheet\">
  http://productfinder.wilo.com/en/COM/product/000000120001ad1f0001003a/fc_product_datasheet
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
February 17, 2016, by Michael Wetter:<br/>
Updated parameter names for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/396\">#396</a>.
</li>
<li>
February 17, 2016, by Michael Wetter:<br/>
Updated parameter names for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/396\">#396</a>.
</li>
<li>
January 19, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end TopS40slash7;
