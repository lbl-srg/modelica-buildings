within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case600FF
  "Basic test with light-weight construction and free floating temperature"
  extends Modelica.Icons.Example;
  Buildings.ThermalZones.ISO13790.Zone5R1C.ZoneHVAC
                zonHVAC(
    airRat=0.414,
    AWin={0,0,12,0},
    UWin=3.1,
    AWal={21.6,16.2,9.6,16.2},
    ARoo=48,
    UWal=0.534,
    URoo=0.327,
    UFlo=0.0377,
    b=1,
    AFlo=48,
    VRoo=129.6,
    hInt=2.1,
    redeclare replaceable Buildings.ThermalZones.ISO13790.Validation.BESTEST.Data.Case600Mass buiMas,
    nOrientations=4,
    surTil={1.5707963267949,1.5707963267949,1.5707963267949,1.5707963267949},
    surAzi={3.1415926535898,-1.5707963267949,0,1.5707963267949},
    gFac=0.789,
    coeFac={1,-0.189,0.644,-0.596},
    redeclare package Medium = Buildings.Media.Air)
                "Thermal zone"
    annotation (Placement(transformation(extent={{-14,-14},{14,14}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CO_Denver.Intl.AP.725650_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Constant intGai(k=200) "Internal heat gains"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage TRooHou(delta=3600)
    "Continuous mean of room air temperature"
    annotation (Placement(transformation(extent={{60,-2},{80,18}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage TRooAnn(delta=86400*365)
    "Continuous mean of room air temperature"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.Blocks.Sources.Constant latGai(k=0)   "Internal heat gains"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

equation
  connect(weaDat.weaBus,zonHVAC. weaBus) annotation (Line(
      points={{-60,20},{10,20},{10,11}},
      color={255,204,51},
      thickness=0.5));

  connect(intGai.y,zonHVAC. intSenGai) annotation (Line(points={{-59,-10},{-30,
          -10},{-30,10},{-16,10}},   color={0,0,127}));
  connect(zonHVAC.TAir, TRooHou.u)
    annotation (Line(points={{15,8},{58,8}}, color={0,0,127}));
  connect(TRooAnn.u,zonHVAC. TAir) annotation (Line(points={{58,50},{26,50},{26,
          8},{15,8}},    color={0,0,127}));
  connect(latGai.y, zonHVAC.intLatGai) annotation (Line(points={{-59,-50},{-24,
          -50},{-24,4},{-16,4}}, color={0,0,127}));
 annotation(experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases6xx/Case600FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 600FF of the BESTEST validation suite.
Case 600FF is a light-weight building.
The room temperature is free floating.
</p>
</html>", revisions="<html><ul>
<li>
March 5, 2025, by Jianjun Hu:<br/>
Replaced the moving average calculation with CDL block.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1982\">IBPSA #1982</a>.
</li>
<li>
May 2, 2024, by Alessandro Maccarini:<br/>
Updated according to ASHRAE 140-2020.
</li>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case600FF;
