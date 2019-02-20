within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Validation.BaseClasses;
record SmallScale_Configuration
  "Configuration data record for the Cimmino and Bernier (2015) experiment"
  extends
    Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Template(
      borCon = Types.BoreholeConfiguration.SingleUTube,
      nBor=1,
      cooBor={{0,0}},
      mBor_flow_nominal=0.0303/60,
      dp_nominal=5e4,
      hBor=0.4*375,
      rBor=0.00629*375,
      dBor=0.019*375,
      rTub=0.125*0.0254/2*375,
      kTub=401.0,
      eTub=0.06*0.0254*375,
      xC=0.0050/2*375);

annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="conDat",
Documentation(
info="<html>
<p>
This record contains the configuration data of the Cimmino and
Bernier (2015) experiment. Since the model is not adapted to the simulation of
small scale boreholes, the borehole dimensions are multiplied by a factor 375
to obtain a scaled-up 150.0 m long borehole.
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
end SmallScale_Configuration;
