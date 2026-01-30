within Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries;
model WithDHW "ETS connected to building loads without DHW"
  extends Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries.WithoutDHW(
    filNam="modelica://Buildings/Resources/Data/DHC/Loads/Examples/JBA_All_futu_tendays.mos");

  Modelica.Blocks.Continuous.Integrator dHHotWat if bui.have_hotWat
    "Cumulative enthalpy difference of domestic hot water"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
equation
  connect(bui.dHHotWat_flow, dHHotWat.u) annotation (Line(points={{4,44},{4,-30},
          {38,-30}},                 color={0,0,127}));
annotation(
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Examples/Combined/ETSHeatRecoveryHeatPump_BuildingTimeSeries/WithDHW.mos" "Simulate and plot"),
    experiment(
      StartTime=7776000,
      StopTime=8640000,
      Tolerance=1e-06),
Documentation(info="<html>
<p>
Validation model for a single building load, modeled as time series,
connected to an ETS that has domestic hot water integration.
</p>
<p>
Note the following:
</p>
<ul>
<li>
The model does not contain a district loop. Rather, the service line is
connected to a constant pressure boundary, and the example model contains
an energy transfer station connected to a building load.
</li>
<li>
The information that a domestic hot water integration is present
is obtained from the load profile <code>filNam</code>
by reading its entry for the peak domestic hot water load.
As it is nonzero,
the parameter <code>bui.have_hotWat</code> is set to <code>true</code>.
</li>
</ul>
<p>
This model is identical to
<a href=\"modelica://Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries.WithoutDHW\">
Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries.WithoutDHW</a>,
except that it has domestic hot water.
</p>
</html>"));
end WithDHW;
