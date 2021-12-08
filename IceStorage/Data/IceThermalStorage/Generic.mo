within IceStorage.Data.IceThermalStorage;
record Generic

  parameter Integer nCha = 6 "Number of coefficients for charging characteristic curve";
  parameter Integer nDisCha = 6 "Number of coefficients for discharging characteristic curve";

  parameter Real chaCoeff[nCha] "Coefficients for charging curve";
  parameter Real disChaCoeff[nDisCha] "Coeffcients for discharging curve";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Generic;
