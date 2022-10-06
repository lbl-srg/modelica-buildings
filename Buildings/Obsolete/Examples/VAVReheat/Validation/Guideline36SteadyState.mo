within Buildings.Obsolete.Examples.VAVReheat.Validation;
model Guideline36SteadyState
  "Validation of detailed model that is at steady state with constant weather data"
  extends Buildings.Obsolete.Examples.VAVReheat.Guideline36(
    flo(
      gai(K=0*[0.4; 0.4; 0.2]),
      use_windPressure=false,
      sampleModel=false),
    hvac(
      occSch(occupancy=3600*24*365*{1,2}, period=2*3600*24*365)),
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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant solRad(k=0) "Solar radiation"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-70,-20})));
equation
  connect(weaDat.HDifHor_in, solRad.y) annotation (Line(points={{-91,0.5},{-96,
          0.5},{-96,-20},{-82,-20}},     color={0,0,127}));
  connect(weaDat.HGloHor_in, solRad.y) annotation (Line(points={{-91,-3},{-96,
          -3},{-96,-20},{-82,-20}},    color={0,0,127}));
  annotation (
    experiment(
      StopTime=604800,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Examples/VAVReheat/Validation/Guideline36SteadyState.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This model validates that the detailed model of multiple rooms and an HVAC system
starts at and remains at exactly <i>20</i>&deg;C room air temperature
if there is no solar radiation, constant outdoor conditions, no internal gains and
no HVAC operation.
</p>
</html>", revisions="<html>
<ul>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed assignment of parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class and introduced floor areas in base class
to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Guideline36SteadyState;
