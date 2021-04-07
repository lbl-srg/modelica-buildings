within Buildings.BoundaryConditions.Validation.BESTEST;
model WD300
  "Test model for BESTEST weather data: Southern hemisphere case"
  extends WD100(
    lat=-0.58281779711847,
    rho=0,
    alt=474,
    weaDatHHorIR(
      filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/BoundaryConditions/Validation/BESTEST/855740.mos")),
    weaDatTDryBulTDewPoinOpa(
      filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/BoundaryConditions/Validation/BESTEST/855740.mos")));
  annotation (
    experiment(
      StopTime=3.1536e+07,
      Interval=900,
      Tolerance=1e-6),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/Validation/BESTEST/WD300.mos" "Simulate and plot"),
    Documentation(
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
</html>",
      info="<html>
<h4>WD300: Southern Hemisphere Case</h4>
<p>Weather data file : 855740.epw</p>
<p><i>Table 1: Site Data for Weather file 855740.epw</i></p>
<table summary=\"Site Data for Weather file 855740.epw\" cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Latitude</p></td>
<td><p>33.393&deg; south</p></td>
</tr>
<tr>
<td><p>Longitude</p></td>
<td><p>70.786&deg; west</p></td>
</tr>
<tr>
<td><p>Altitude</p></td>
<td><p>474 m</p></td>
</tr>
<tr>
<td><p>Time Zone</p></td>
<td><p>4</p></td>
</tr>
</table>
</html>"));
end WD300;
