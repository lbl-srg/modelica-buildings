within Buildings.Fluid.Movers.Data.Pumps.Wilo;
record CronolineIL80slash220dash4slash4
  "Pump data for a Wilo Cronoline-IL 80/220-4/4 pump"
  extends Generic(
    use_powerCharacteristic=true,
    speed_rpm_nominal=1450,
    power(V_flow={0.00303454715219,0.00578898225957,0.00863678804855,0.0113912231559,0.0146125116713,0.0181605975724,0.0214285714286,0.0248366013072,0.0274042950514,0.0282446311858}, P={1905.29339941,2202.03582759,2548.86483304,2812.07908132,3146.06691483,3435.07911022,3592.75276695,3710.09774539,3774.78991597,3793.34692457}),
    pressure(V_flow={0.00303454715219,0.00578898225957,0.00863678804855,0.0113912231559,0.0146125116713,0.0181605975724,0.0214285714286,0.0248366013072,0.0274042950514,0.0282446311858}, dp={168215.17064,166653.242326,164291.843595,161128.282627,154367.77774,142807.085577,128439.498542,108468.216086,92889.3102384,86895.3009775}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>Data from: <a href=\"http://productfinder.wilo.com/nl/BE/product/000000100002c2550002003a/fc_product_datasheet\">http://productfinder.wilo.com/nl/BE/product/000000100002c2550002003a/fc_product_datasheet</a></p>
<p>See <a href=\"modelica://Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6\">Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 </a>for more information about how the data is derived. </p>
</html>",   revisions="<html>
<ul>
<li>
February 17, 2016, by Michael Wetter:<br/>
Updated parameter names for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/396\">#396</a>.
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
end CronolineIL80slash220dash4slash4;
