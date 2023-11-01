within Buildings.HeatTransfer.Windows.Validation;
model WindowSteadyState
  "Validation model for window with steady-state boundary condition"
  extends Buildings.HeatTransfer.Windows.Examples.Window(
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
  Controls.OBC.CDL.Reals.Sources.Constant HSol(
    k=0) "Solar irradiation"
    annotation (Placement(transformation(extent={{-92,-30},{-72,-10}})));
equation
  connect(weaDat.HGloHor_in, HSol.y) annotation (Line(points={{-21,-23},{-46,-23},
          {-46,-20},{-70,-20}}, color={0,0,127}));
  connect(weaDat.HDifHor_in, HSol.y) annotation (Line(points={{-21,-19.5},{-45.5,
          -19.5},{-45.5,-20},{-70,-20}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model validates that the window model has no heat transfer if
the boundary conditions are constant at <i>20</i>&deg;C.
</p>
</html>", revisions="<html>
<ul>
<li>
April 20, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-06, StopTime=31536000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/Validation/WindowSteadyState.mos"
        "Simulate and plot"));
end WindowSteadyState;
