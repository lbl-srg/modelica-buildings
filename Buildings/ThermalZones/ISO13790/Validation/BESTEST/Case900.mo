within Buildings.ThermalZones.ISO13790.Validation.BESTEST;
model Case900
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Case600(
    zon5R1C(hInt=2.74,
      redeclare replaceable Buildings.ThermalZones.ISO13790.Validation.BESTEST.Data.Case900Mass buiMas),
    annComBESTEST(
      EHeaMax=7347600000,
      EHeaMin=4212000000,
      ECooMax=-11394000000,
      ECooMin=-7686000000,
      PHeaMax=3797,
      PHeaMin=2850,
      PCooMax=-3871,
      PCooMin=-2888),
    daiComBESTEST(table=[0,0,0,0,0,0,0,0; 259200,0,0,0,0,0,0,0; 262800,2440,3100,
          3100,3390,3210,3080,3400; 266400,2610,3200,3240,3540,3350,3200,3550; 270000,
          2620,3200,3280,3560,3380,3280,3570; 273600,2670,3310,3380,3610,3450,3330,
          3630; 277200,2740,3370,3450,3670,3510,3420,3690; 280800,2800,3400,3500,
          3720,3560,3470,3750; 284400,2830,3450,3560,3760,3610,3520,3800; 288000,
          2840,3380,3520,3750,3610,3460,3790; 291600,2640,2900,2970,3170,3080,2830,
          3170; 295200,2120,2350,2200,2320,2350,2060,2450; 298800,1500,1400,1030,
          950,1120,790,1290; 302400,680,380,230,100,300,40,620; 306000,70,0,0,0,
          0,0,140; 309600,0,0,0,0,0,0,0; 313200,0,0,0,0,0,0,0; 316800,0,0,0,0,0,
          0,90; 320400,30,120,0,280,140,130,1200; 324000,410,770,740,1220,910,760,
          1600; 327600,800,1310,1140,1610,1280,1200,1810; 331200,1070,1610,1430,
          1820,1540,1460,1940; 334800,1270,1930,1700,2040,1810,1700,2120; 338400,
          1500,2140,1890,2170,2000,1930,2230; 342000,1660,2220,2030,2290,2150,2090,
          2340; 345600,1750,2310,2190,2420,2310,2230,2460; 345600,0,0,0,0,0,0,0;
          3153600,0,0,0,0,0,0,0]));

 annotation(experiment(
      StopTime=31536000,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Case900.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the basic test case 900 of the BESTEST validation suite.
Case 900 is a heavy-weight building with room temperature control set to <i>20</i>&deg;C
for heating and <i>27</i>&deg;C for cooling. The room has no shade and a window that faces south.
</p>
</html>", revisions="<html><ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case900;
