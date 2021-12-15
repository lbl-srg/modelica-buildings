within IceStorage.Data.IceThermalStorage;
record Generic

  parameter Integer nCha = 6 "Number of coefficients for charging characteristic curve";
  parameter Integer nDisCha = 6 "Number of coefficients for discharging characteristic curve";

  parameter Real coeCha[nCha] "Coefficients for charging curve";
  parameter Real coeDisCha[nDisCha] "Coeffcients for discharging curve";
  parameter Real dtCha "Time step of curve fitting data";
  parameter Real dtDisCha "Time step of curve fitting data";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Generic;
