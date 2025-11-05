within Buildings.DHC.ETS.Combined.Examples.BuildingTimeSeries;
model WithDHW "ETS connected to building loads without DHW"
  extends Buildings.DHC.ETS.Combined.Examples.BuildingTimeSeries.WithoutDHW(
    filNam="modelica://Buildings/Resources/Data/DHC/Loads/Examples/JBA_All_futu_tendays.mos",
    ENet(nin=3));

  Modelica.Blocks.Continuous.Integrator dHHotWat if bui.have_hotWat
    "Cumulative enthalpy difference of domestic hot water"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
equation
  connect(bui.dHHotWat_flow, dHHotWat.u) annotation (Line(points={{44,-22},{44,-28},
          {24,-28},{24,20},{38,20}}, color={0,0,127}));
  connect(dHHotWat.y, ENet.u[3]) annotation (Line(points={{61,20},{70,20},{70,50},
          {78,50}}, color={0,0,127}));
annotation(
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/ETS/Combined/Examples/BuildingTimeSeries/WithDHW.mos" "Simulate and plot"),
    experiment(
      StartTime=7776000,
      StopTime=8640000,
      Tolerance=1e-06),
Documentation(info="<html>
<p>
Validation model for a single building with DHW integration in the ETS.
fixme: Note that the information that a domestic hot water integration is present
is obtained from the load profile <code>filNam</code>.
</p>
</html>"));
end WithDHW;
