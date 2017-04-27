within Buildings.Fluid.Movers.Data.Pumps.Wilo;
record Stratos40slash1to8 "Pump data for a Wilo Stratos 40/1-8 pump"
  extends Generic(
    speed_rpm_nominal=3830,
    use_powerCharacteristic=true,
    power(V_flow={4.03163741226e-06,0.00188290448506,0.00245068662086,
          0.00286231420438,0.00325508173616,0.00357919645424,0.00394696189973},
        P={99.4470603052,175.709481933,197.426392754,209.437047607,213.2290948,
          215.740841723,218.557203232}),
    pressure(V_flow={4.03163741226e-06,0.00188290448506,0.00245068662086,
          0.00286231420438,0.00325508173616,0.00357919645424,0.00394696189973},
        dp={50361.3292164,50002.6907452,46761.3220062,42267.4693149,
          36095.691563,30066.6880748,23476.280464}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
  <p>Data from:
  <a href=\"http://productfinder.wilo.com/en/COM/product/00000018000028050002003a/fc_product_datasheet\">
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
end Stratos40slash1to8;
