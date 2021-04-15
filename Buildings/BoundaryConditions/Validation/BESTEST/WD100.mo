within Buildings.BoundaryConditions.Validation.BESTEST;
model WD100
  "Test model for BESTEST weather data: base case"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Angle lat=0.6952170009469
    "Latitude angle";
  parameter Real rho=0
    "Ground reflectance";
  parameter Modelica.SIunits.Length alt=1650
    "Altitude";
  WeatherData.ReaderTMY3 weaDatHHorIR(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.File,
    ceiHeiSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    ceiHei=alt,
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/BoundaryConditions/Validation/BESTEST/725650.mos"),
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation)
    "Reads all weather data and Tsky using horizontal radiation"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,origin={0,-90})));
  WeatherData.Bus weaBusHHorIR
    "weather bus to read all weather data and Tsky using horizontal radiation"
    annotation (Placement(transformation(extent={{-14,-82},{16,-54}}),iconTransformation(extent={{-220,70},{-200,90}})));
  IsotropicAndPerezDiffuseRadiation azi000til00(
    til=Buildings.Types.Tilt.Ceiling,
    lat=lat,
    azi=Buildings.Types.Azimuth.S,
    rho=rho)
    "Azimuth = Horizontal, Tilt = 0 °"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  IsotropicAndPerezDiffuseRadiation azi000til90(
    til=Buildings.Types.Tilt.Wall,
    lat=lat,
    azi=Buildings.Types.Azimuth.S,
    rho=rho)
    "Azimuth = South, Tilt = 90 °"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  IsotropicAndPerezDiffuseRadiation azi270til90(
    til=Buildings.Types.Tilt.Wall,
    lat=lat,
    azi=Buildings.Types.Azimuth.E,
    rho=rho)
    "Azimuth = East, Tilt = 90 °"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  IsotropicAndPerezDiffuseRadiation azi180til90(
    til=Buildings.Types.Tilt.Wall,
    lat=lat,
    azi=Buildings.Types.Azimuth.N,
    rho=rho)
    "Azimuth = North, Tilt = 90 °"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  IsotropicAndPerezDiffuseRadiation azi090til90(
    til=Buildings.Types.Tilt.Wall,
    lat=lat,
    azi=Buildings.Types.Azimuth.W,
    rho=rho)
    "Azimuth =  West, Tilt = 90 °"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  IsotropicAndPerezDiffuseRadiation azi315til90(
    til=Buildings.Types.Tilt.Wall,
    lat=lat,
    azi=Buildings.Types.Azimuth.SE,
    rho=rho)
    "Azimuth = 45 ° SE, Tilt = 0 °"
    annotation (Placement(transformation(extent={{-60,70},{-80,90}})));
  IsotropicAndPerezDiffuseRadiation azi045til90(
    til=Buildings.Types.Tilt.Wall,
    lat=lat,
    azi=Buildings.Types.Azimuth.SW,
    rho=rho)
    "Azimuth = 45 SW, Tilt = 90 °"
    annotation (Placement(transformation(extent={{-60,40},{-80,60}})));
  IsotropicAndPerezDiffuseRadiation azi270til30(
    til=0.5235987755983,
    lat=lat,
    azi=Buildings.Types.Azimuth.E,
    rho=rho)
    "Azimuth = East, Tilt = 30 °"
    annotation (Placement(transformation(extent={{-60,10},{-80,30}})));
  IsotropicAndPerezDiffuseRadiation azi000til30(
    til=0.5235987755983,
    lat=lat,
    azi=Buildings.Types.Azimuth.S,
    rho=rho)
    "Azimuth = South, Tilt = 0 °"
    annotation (Placement(transformation(extent={{-60,-20},{-80,0}})));
  IsotropicAndPerezDiffuseRadiation azi090til30(
    til=0.5235987755983,
    lat=lat,
    azi=Buildings.Types.Azimuth.W,
    rho=rho)
    "Azimuth = West, Tilt = 0 °"
    annotation (Placement(transformation(extent={{-60,-50},{-80,-30}})));
  Utilities.Psychrometrics.X_pTphi x_pTphi
    annotation (Placement(transformation(extent={{-40,-80},{-60,-60}})));
  Utilities.Psychrometrics.ToDryAir toDryAir
    annotation (Placement(transformation(extent={{-72,-80},{-92,-60}})));
  WeatherData.ReaderTMY3 weaDatTDryBulTDewPoinOpa(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.File,
    ceiHeiSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    ceiHei=alt,
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/BoundaryConditions/Validation/BESTEST/725650.mos"),
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover)
    "Reads all weather data and Tsky using dry bulb temperature, dew point temperature and sky cover"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,origin={70,-90})));
  WeatherData.Bus weaBusTDryBulTDewPoiOpa
    "Weather bus to read Tsky using dew point temperature and sky cover"
    annotation (Placement(transformation(extent={{52,-84},{84,-54}}),iconTransformation(extent={{-220,70},{-200,90}})));

equation
  connect(weaDatHHorIR.weaBus,weaBusHHorIR)
    annotation (Line(points={{4.44089e-16,-80},{4.44089e-16,-74},{0,-74},{0,-68},{1,-68}},color={255,204,51},thickness=0.5),Text(string="%second",index=1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(weaBusHHorIR.pAtm,x_pTphi.p_in)
    annotation (Line(points={{1,-68},{-18,-68},{-18,-64},{-38,-64}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-3,-6},{-3,-6}},horizontalAlignment=TextAlignment.Right));
  connect(weaBusHHorIR.TDryBul,x_pTphi.T)
    annotation (Line(points={{1,-68},{-18,-68},{-18,-70},{-38,-70}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(weaBusHHorIR.relHum,x_pTphi.phi)
    annotation (Line(points={{1,-68},{-18,-68},{-18,-76},{-38,-76}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(x_pTphi.X[1],toDryAir.XiTotalAir)
    annotation (Line(points={{-61,-70},{-71,-70}},color={0,0,127}));
  connect(weaDatTDryBulTDewPoinOpa.weaBus,weaBusTDryBulTDewPoiOpa)
    annotation (Line(points={{70,-80},{70,-69},{68,-69}},color={255,204,51},thickness=0.5),Text(string="%second",index=1,extent={{-3,6},{-3,6}},horizontalAlignment=TextAlignment.Right));
  connect(weaBusHHorIR,azi090til90.weaBus)
    annotation (Line(points={{1,-68},{0,-68},{0,-40},{60,-40}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(weaBusHHorIR,azi090til30.weaBus)
    annotation (Line(points={{1,-68},{0,-68},{0,-40},{-60,-40}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(weaBusHHorIR,azi000til30.weaBus)
    annotation (Line(points={{1,-68},{0,-68},{0,-10},{-60,-10}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(weaBusHHorIR,azi180til90.weaBus)
    annotation (Line(points={{1,-68},{0,-68},{0,-10},{60,-10}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(weaBusHHorIR,azi270til30.weaBus)
    annotation (Line(points={{1,-68},{0,-68},{0,20},{-60,20}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(weaBusHHorIR,azi270til90.weaBus)
    annotation (Line(points={{1,-68},{0,-68},{0,20},{60,20}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(weaBusHHorIR,azi045til90.weaBus)
    annotation (Line(points={{1,-68},{0,-68},{0,50},{-60,50}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(weaBusHHorIR,azi000til90.weaBus)
    annotation (Line(points={{1,-68},{0,-68},{0,50},{60,50}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(weaBusHHorIR,azi315til90.weaBus)
    annotation (Line(points={{1,-68},{0,-68},{0,80},{-60,80}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(weaBusHHorIR,azi000til00.weaBus)
    annotation (Line(points={{1,-68},{0,-68},{0,80},{60,80}},color={255,204,51},thickness=0.5),Text(string="%first",index=-1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  annotation (
    experiment(
      StopTime=3.1536e+07,
      Interval=900,
      Tolerance=1e-6),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/Validation/BESTEST/WD100.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<h4>WD100: Base Case</h4>
<p>Weather data file : 725650.epw</p>
<p><i>Table 1: Site Data for Weather file 725650.epw</i></p>
<table summary=\"Site Data for Weather file 725650.epw\" cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Latitude</p></td>
<td><p>39.833&deg; north</p></td>
</tr>
<tr>
<td><p>Longitude</p></td>
<td><p>104.65&deg; west</p></td>
</tr>
<tr>
<td><p>Altitude</p></td>
<td><p>1650 m</p></td>
</tr>
<tr>
<td><p>Time Zone</p></td>
<td><p>7</p></td>
</tr>
</table>
<p>This model is a template for all the other test cases.
It allows to extrapolate all the weather data from the Reader TMY3 for a specific location, incliation and azimuth.
The model
<a href=\"modelica://Buildings.BoundaryConditions.Validation.IsotropicAndPerezDiffuseRadiation\">Buildings.BoundaryConditions.Validation.IsotropicAndPerezDiffuseRadiation</a>
outputs radiation data using the available Isotropic and Perez methodlogies.
The sky temperature is calculated using both the Horizontal radiation model,
from data reader weaBusHorRad and the dew point temperature plus sky cover model from the datareader weaBusSkyCovDewTem.</p>
</html>",
      revisions="<html>
<ul>
<li>
March 11, 2020, by Ettore Zanetti:<br/>
First implementation.
</li>
<li>
April 14, 2020, by Ettore Zanetti:<br/>
Rework after comments from pull request
<a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1339\">#1339</a>.
</li>
</ul>
</html>"));
end WD100;
