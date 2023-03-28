within Buildings.ThermalZones.ISO13790.Examples;
model FreeFloatingHVAC "Illustrates the use of the 5R1C HVAC thermal zone in free-floating conditions"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")) "weather data"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Zone5R1C.ZoneHVAC zonHVAC(
    airRat=0.5,
    AWin={0,0,3,0},
    UWin=1.8,
    AWal={12,12,9,12},
    ARoo=16,
    UWal=1.3,
    URoo=1.3,
    UFlo=1,
    AFlo=16,
    VRoo=16*3,
    nOrientations=4,
    surTil={1.5707963267949,1.5707963267949,1.5707963267949,1.5707963267949},
    surAzi={3.1415926535898,-1.5707963267949,0,1.5707963267949},
    gFac=0.5,
    redeclare package Medium = Buildings.Media.Air,
    redeclare Buildings.ThermalZones.ISO13790.Data.Light buiMas) "Thermal zone"
    annotation (Placement(transformation(extent={{26,-12},{54,16}})));
  Modelica.Blocks.Sources.Constant intGains(k=10) "Internal heat gains"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Sources.Constant latGains(k=0) "Latent gains"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(zonHVAC.weaBus, weaDat.weaBus) annotation (Line(
      points={{50,13},{50,20},{-60,20}},
      color={255,204,51},
      thickness=0.5));
  connect(latGains.y, zonHVAC.intLatGai) annotation (Line(points={{-59,-50},{
          -32,-50},{-32,6},{24,6}},   color={0,0,127}));
  connect(intGains.y, zonHVAC.intSenGai) annotation (Line(points={{-59,-20},{
          -40,-20},{-40,12},{24,12}},   color={0,0,127}));
  annotation (experiment(
    StartTime=8640000,
    StopTime=9504000,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Examples/FreeFloatingHVAC.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model illustrates the use of <a href=\"modelica://Buildings.ThermalZones.ISO13790.Zone5R1C.ZoneHVAC\">
Buildings.ThermalZones.ISO13790.Zone5R1C.ZoneHVAC</a> in a free-floating case (i.e. no heating or cooling).
</p>
</html>",
revisions="<html>
<ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end FreeFloatingHVAC;
