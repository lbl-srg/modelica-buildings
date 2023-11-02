within Buildings.ThermalZones.ISO13790.Validation.BESTEST;
model Case600FF "Basic test with light-weight construction and free floating temperature"
  extends Modelica.Icons.Example;
  Zone5R1C.Zone zon5R1C(
    airRat=0.5,
    AWin={0,0,12,0},
    UWin=2.984,
    AWal={21.6,16.2,9.6,16.2},
    ARoo=48,
    UWal=0.56,
    URoo=0.33,
    UFlo=1,
    b=0,
    AFlo=48,
    VRoo=129.6,
    hInt=2.74,
    redeclare replaceable Buildings.ThermalZones.ISO13790.Validation.BESTEST.Data.Case600Mass buiMas,
    nOrientations=4,
    surTil={1.5707963267949,1.5707963267949,1.5707963267949,1.5707963267949},
    surAzi={3.1415926535898,-1.5707963267949,0,1.5707963267949},
    gFac=0.789) "Thermal zone"
    annotation (Placement(transformation(extent={{-14,-14},{14,14}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/DRYCOLD.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Constant intGai(k=200) "Internal heat gains"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Math.ContinuousMean conMea
    "Continuous mean of room air temperature"
    annotation (Placement(transformation(extent={{60,-2},{80,18}})));
  Modelica.Blocks.Sources.CombiTimeTable daiComBESTESTFF(table=[0,0,0,0,0,0,0,0;
        259200,0,0,0,0,0,0,0; 262800,-8.88,-12.04,-12.3,-12.21,-12.1,-12.02,-13.04;
        266400,-10.48,-13.52,-14.1,-13.8,-13.7,-13.5,-14.59; 270000,-11.76,-14.4,
        -15.4,-14.9,-14.7,-14.7,-15.65; 273600,-12.75,-15.26,-16.3,-15.79,-15.6,
        -15.65,-16.46; 277200,-13.69,-16,-17.1,-16.55,-16.4,-16.47,-17.16;
        280800,-14.49,-16.4,-17.9,-17.2,-17,-17.14,-17.79; 284400,-15.15,-17.01,
        -18.5,-17.74,-17.6,-17.7,-18.32; 288000,-15.63,-17.05,-18.8,-17.85,-17.8,
        -17.59,-18.47; 291600,-14.63,-13.74,-14.7,-14.88,-14.6,-13.46,-15.47;
        295200,-10.03,-7.99,-7.8,-9.07,-8.9,-7.1,-9.56; 298800,-2.2,2.6,3.2,
        1.01,1,3.66,0.49; 302400,8.84,12.22,13.4,11.21,10.7,13.49,10.39; 306000,
        18.96,20.86,22.3,20.03,19.2,21.77,18.75; 309600,27.19,27.53,29.5,27.27,
        26.1,28.26,25.48; 313200,33.22,31.33,33.8,31.34,29.8,32.09,29.21;
        316800,35.51,31.06,33.5,31.47,29.7,32.16,28.97; 320400,31.46,24.28,27,
        25.96,23.9,25.71,22.58; 324000,23.99,17.46,19.7,18.96,17.6,18.84,15.59;
        327600,18.08,12.05,13.7,13.04,12.2,13.1,10.2; 331200,13.02,7.57,8.7,
        8.31,7.8,8.41,6.02; 334800,8.87,3.6,4.4,4.27,4,4.39,2.39; 338400,5.12,
        0.52,1,0.99,0.9,0.97,-0.59; 342000,2.03,-1.94,-1.9,-1.66,-1.7,-1.78,-3.04;
        345600,-1.03,-4.07,-4.4,-3.92,-3.9,-4.03,-5.14; 345600,0,0,0,0,0,0,0;
        3153600,0,0,0,0,0,0,0]) "Daily comparison BESTEST FF"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.ThermalZones.ISO13790.Validation.BESTEST.Data.Case600FFResults annComBESTESTFF "Annual comparison BESTEST FF"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
equation
  connect(weaDat.weaBus, zon5R1C.weaBus) annotation (Line(
      points={{-60,20},{10,20},{10,11}},
      color={255,204,51},
      thickness=0.5));

  connect(intGai.y, zon5R1C.intSenGai) annotation (Line(points={{-59,-10},{-30,
          -10},{-30,10},{-16,10}},   color={0,0,127}));
  connect(zon5R1C.TAir, conMea.u)
    annotation (Line(points={{15,8},{58,8}}, color={0,0,127}));
 annotation(experiment(
      StopTime=31536000,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Case600FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 600FF of the BESTEST validation suite.
Case 600FF is a light-weight building.
The room temperature is free floating.
</p>
</html>", revisions="<html><ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case600FF;
