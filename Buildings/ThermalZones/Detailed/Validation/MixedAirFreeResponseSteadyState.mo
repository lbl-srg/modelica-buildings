within Buildings.ThermalZones.Detailed.Validation;
model MixedAirFreeResponseSteadyState
  "Validation model for the room model with steady state boundary conditions"
  extends Examples.MixedAirFreeResponse(
  weaDat(
      pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      ceiHeiSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      totSkyCovSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      opaSkyCovSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      TDewPoiSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      TBlaSkySou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      TBlaSky=293.15,
      relHumSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      winSpeSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      winDirSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      HInfHorSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
      HSou=Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(k=0) "Zero input signal"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
equation
  connect(zer.y, weaDat.HDifHor_in) annotation (Line(points={{-78,40},{-66,40},{
          -66,40.5},{-61,40.5}},   color={0,0,127}));
  connect(zer.y, weaDat.HGloHor_in) annotation (Line(points={{-78,40},{-70,40},{
          -70,37},{-61,37}},   color={0,0,127}));
  annotation (
    experiment(
      StopTime=31536000,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/MixedAirFreeResponseSteadyState.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(extent={{-120,-100},{200,200}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This model validates that the detailed room model
starts at and remains at exactly <i>20</i>&deg;C room air temperature
if there is no solar radiation, constant outdoor conditions and no internal gains.
</p>
</html>", revisions="<html>
<ul>
<li>
April 20, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MixedAirFreeResponseSteadyState;
