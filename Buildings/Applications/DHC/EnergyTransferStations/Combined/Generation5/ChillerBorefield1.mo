within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5;
model ChillerBorefield1
  "ETS model for 5GDHC systems with heat recovery chiller and optional borefield"
  extends ChillerBorefield(
    redeclare Controls.Supervisory1 conSup(
      final controllerType=controllerType,
      final kHot=kHot,
      final kCol=kCol,
      final Ti=Ti,
      final dTDea=dTDea,
      final THeaWatSupSetMin=THeaWatSupSetMin,
      final TChiWatSupSetMax=TChiWatSupSetMax,
      final dTHys=dTHys),
    chi(
      have_res=true,
      final TChiWatSupSetMin=TChiWatSupSetMin));

  parameter Modelica.SIunits.TemperatureDifference dTHys = 1.0
    "Temperature hysteresis for supervisory control"
    annotation (Dialog(group="Supervisory controller"));

equation
  connect(conSup.THeaWatSupSet, chi.THeaWatSupSet) annotation (Line(points={{
          -238,19},{-24,19},{-24,-6},{-12,-6}}, color={0,0,127}));
annotation (
        defaultComponentName="ets",
Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>

<p>
<img alt=\"Sequence chart\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/Combined/Generation5/ChillerBorefield.png\"/>
</p>
</html>"));
end ChillerBorefield1;
