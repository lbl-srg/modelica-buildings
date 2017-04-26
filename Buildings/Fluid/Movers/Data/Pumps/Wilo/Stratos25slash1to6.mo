within Buildings.Fluid.Movers.Data.Pumps.Wilo;
record Stratos25slash1to6 "Pump data for a Wilo Stratos 25/1-6 pump"
  extends Generic(
    speed_rpm_nominal=2540,
    use_powerCharacteristic=true,
    power(V_flow={8.4618254914e-06,0.000274485730449,0.000555832400486,
          0.000837082776634,0.00110292011218,0.00138657181719,0.00166761756882,
          0.00187198329301}, P={27.7850423935,35.9020280633,46.212011386,
          55.5493899809,62.3704820257,68.7045763872,73.3263927089,75.1773568358}),
    pressure(V_flow={8.4618254914e-06,0.000274485730449,0.000555832400486,
          0.000837082776634,0.00110292011218,0.00138657181719,0.00166761756882,
          0.00187198329301}, dp={34808.1176471,34738.9411765,34508.1176471,
          32430.7058824,29083.7647059,24005.6470588,18004.2352941,13041.5294118}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>Data from
<a href=\"http://productfinder.wilo.com/en/COM/product/00000018000028040002003a/fc_product_datasheet\">
http://productfinder.wilo.com/en/COM/product/00000018000028040002003a/fc_product_datasheet</a>
</p>
<p>
The nominal rpm is arbitrarily chosen as the rpm of the pump curve
in the data sheet that has the highest rpm,
without being limited by the maximum power limitation
(see dotted curve on figure below).
Pump curves (H(m_flow) and P(m_flow)) from the data sheets
are digitized using
<a href=\"http://arohatgi.info/WebPlotDigitizer/app/\">web plot digitizer</a>.
</p>
<h4>Limitations:</h4>
<ul>
<li>The pump curve cap at high rpm that can be seen is not enforced
by the model.
</li>
<li>
The pump curve may be altered slightly to guarantee that <i>dp/dm&lt;0</i>
</li>
</ul>
<p>
The figure below illustrates a digitized pump curve.
</p>
<p align=\"center\">
<img alt=\"Pump curve\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/Data/stratoscurve.png\"/></p>
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
<li>April 17, 2014
    by Filip Jorissen:<br/>
       Initial version
</li>
</ul>
</html>"));
end Stratos25slash1to6;
