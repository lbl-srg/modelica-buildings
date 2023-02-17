within Buildings.Fluid.Movers.Data.Pumps.Wilo;
record TopS40slash10 "Pump data for a staged Wilo-Top-S 40/10 pump"
  extends Generic(
    speed_rpm_nominal=2900,
    final powerOrEfficiencyIsHydraulic=false,
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
    power(V_flow={2.29252636405e-05, 0.00110041265475, 0.00221610881858,
                   0.00334708849152, 0.00417239798258,  0.0048448723827,
                   0.00537979520098, 0.00605991135565, 0.00625859697387},
               P={    432.950095719,    492.916811695,     565.94308364,
                      630.111524164,    658.215613383,      671.6839839,
                      676.925957128,    671.543363813,    668.661679135}),
    pressure(V_flow={2.29252636405e-05, 0.00110041265475, 0.00221610881858,
                      0.00334708849152, 0.00417239798258,  0.0048448723827,
                      0.00537979520098, 0.00605991135565, 0.00625859697387},
                 dp={    98785.5232361,    97106.6860151,    91320.1257409,
                         79370.6856694,    66042.1923274,    53051.3974809,
                         40227.5679296,    25353.7625039,    20566.1680722}),
    speeds_rpm = {0, 2600, 2800});
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
  <p>Data from:
  <a href=\"http://productfinder.wilo.com/en/COM/product/000000120001ad890001003a/fc_product_datasheet\">
  http://productfinder.wilo.com/en/COM/product/000000120001ad890001003a/fc_product_datasheet
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
end TopS40slash10;
