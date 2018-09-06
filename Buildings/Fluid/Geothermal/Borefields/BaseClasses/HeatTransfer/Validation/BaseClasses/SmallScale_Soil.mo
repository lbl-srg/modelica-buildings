within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Validation.BaseClasses;
record SmallScale_Soil
  "Soil data record for the Cimmino and Bernier (2015) experiment"
  extends
    Buildings.Fluid.Geothermal.Borefields.Data.Soil.Template(
      kSoi=0.262,
      cSoi=745,
      dSoi=1750);
  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="soiDat",
Documentation(
info="<html>
<p>
This record contains the soil data of the Cimmino and Bernier (2015) experiment.
</p>
<h4>References</h4>
<p>
Cimmino, M. and Bernier, M. 2015. <i>Experimental determination of the
g-functions of a small-scale geothermal borehole</i>. Geothermics 56: 60-71.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
Revised implementation, added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code>.
</li>
<li>
June 28, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmallScale_Soil;
