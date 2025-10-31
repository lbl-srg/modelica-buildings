within Buildings.DHC.ETS.Combined.Examples;
model ConnectedETSWithDHW "ETS connected to building loads without DHW"
  extends Buildings.DHC.ETS.Combined.Examples.ConnectedETSNoDHW
                                                          (filNam=
        "modelica://Buildings/Resources/Data/DHC/Loads/Examples/JBA_All_futu_tendays.mos");

equation

annotation(
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/ETS/Combined/Examples/ConnectedETSWithDHW.mos" "Simulate and plot"),
    experiment(
      StartTime=7776000,
      StopTime=8640000,
      Tolerance=1e-06),
Documentation(info="<html>
<p>
Validation model for a single building with DHW integration in the ETS.
The model itself does not impose that DHW integration is present.
This information is determined from the load profile.
</p>
</html>"));
end ConnectedETSWithDHW;
