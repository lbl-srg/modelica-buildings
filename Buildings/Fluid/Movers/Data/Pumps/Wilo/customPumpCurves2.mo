within Buildings.Fluid.Movers.Data.Pumps.Wilo;
record customPumpCurves2
  "Modified pump data for closed loop validation"
  extends Generic(
    use_powerCharacteristic=true,
    speed_rpm_nominal=1450,
    power(V_flow={0, 0.0003, 0.0006}, P={0, 200, 0}),
    pressure(V_flow={0, 0.0003, 0.0006}, dp={60000,25000,0}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>Data from: <a href=\"http://productfinder.wilo.com/com/en/c000000220003ab4800010023/_000000100002c2550002003a/product.html\">http://productfinder.wilo.com/com/en/c000000220003ab4800010023/_000000100002c2550002003a/product.html</a></p>
<p>See <a href=\"modelica://Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6\">Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 </a>for more information about how the data is derived. </p>
</html>",   revisions="<html>
<ul>
<li>
June 01, 2017, by Iago Cupeiro:
<br/>
Changed data link to English version
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
end customPumpCurves2;
