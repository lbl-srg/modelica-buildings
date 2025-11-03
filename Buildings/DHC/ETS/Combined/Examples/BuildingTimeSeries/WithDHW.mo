within Buildings.DHC.ETS.Combined.Examples.BuildingTimeSeries;
model WithDHW "ETS connected to building loads without DHW"
  extends Buildings.DHC.ETS.Combined.Examples.BuildingTimeSeries.WithoutDHW(
    filNam="modelica://Buildings/Resources/Data/DHC/Loads/Examples/JBA_All_futu_tendays.mos");

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
Note that the information that a domestic hot water integration is present
is obtained from the load profile <code>filNam</code>.
</p>
</html>"));
end WithDHW;
