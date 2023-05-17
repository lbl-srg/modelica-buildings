within Buildings.ThermalZones.ISO13790.Validation.BESTEST;
model Case900FF "Test with heavy-weight construction and free floating temperature"
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Case600FF(
    zon5R1C(
      redeclare replaceable Buildings.ThermalZones.ISO13790.Validation.BESTEST.Data.Case900Mass buiMas),
    daiComBESTESTFF(table=[0,0,0,0,0,0,0,0; 259200,0,0,0,0,0,0,0; 262800,1.61,-0.17,
          -0.9,-1.31,-0.7,-3.46,-2.68; 266400,0.93,-0.79,-1.6,-1.97,-1.4,-3.99,-3.33;
          270000,0.49,-1.09,-2,-2.37,-1.8,-4.4,-3.72; 273600,0.07,-1.67,-2.5,-2.81,
          -2.3,-4.8,-4.1; 277200,-0.41,-2.04,-2.9,-3.25,-2.7,-5.22,-4.51; 280800,
          -0.87,-2.43,-3.4,-3.68,-3.2,-5.6,-4.93; 284400,-1.27,-2.97,-3.9,-4.1,-3.6,
          -5.98,-5.34; 288000,-1.64,-3.15,-4.3,-4.4,-4,-6.08,-5.64; 291600,-1.54,
          -2.39,-3.3,-3.45,-3.2,-4.72,-4.59; 295200,-0.4,-1.09,-1.6,-1.6,-1.7,-2.98,
          -2.64; 298800,1.59,1.6,1.2,1.66,0.9,0.25,0.75; 302400,4.4,3.62,3.5,4.4,
          3.1,2.54,3.26; 306000,6.72,5.62,5.5,6.56,5.1,4.38,4.99; 309600,8.66,7.32,
          7.2,8.39,6.8,5.85,6.51; 313200,10.02,8.27,8,9.04,7.6,6.61,7.11; 316800,
          10.4,8.15,7.9,8.58,7.4,6.33,6.68; 320400,9.41,6.53,6.2,6.44,5.8,4.2,4.24;
          324000,7.66,5.25,4.7,4.43,4.4,2.87,2.45; 327600,6.74,4.52,3.8,3.37,3.6,
          2.11,1.71; 331200,6,3.88,3.2,2.73,3,1.58,1.32; 334800,5.41,3.22,2.7,2.11,
          2.4,1.05,0.82; 338400,4.74,2.85,2.2,1.66,1.9,0.55,0.42; 342000,4.2,2.47,
          1.7,1.26,1.5,0.15,0.05; 345600,3.66,1.9,1.2,0.83,1,-0.24,-0.34; 345600,
          0,0,0,0,0,0,0; 3153600,0,0,0,0,0,0,0]),
    annComBESTESTFF(TavgMin=297.65));

 annotation(experiment(Tolerance=1e-6, StopTime=3.1536e+007),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Case900FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 900FF of the BESTEST validation suite.
Case 900FF is a heavy-weight building.
The room temperature is free floating.
</p>
</html>", revisions="<html><ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case900FF;
