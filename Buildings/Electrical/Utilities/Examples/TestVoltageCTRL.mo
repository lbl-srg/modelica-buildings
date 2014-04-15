within Buildings.Electrical.Utilities.Examples;
model TestVoltageCTRL
  "This test check the correctness of the voltage controller model"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Voltage V_nominal = 220
    "Nominal voltage of the node to be controlled";
  parameter Real Vthresh(min=0.0, max=1.0) = 0.1
    "Threshold that activates voltage ctrl (ratio of nominal voltage)";
  parameter Modelica.SIunits.Time Tdelay = 300
    "Time to wait before plugging the load back";
  parameter Modelica.SIunits.Voltage V_max = 220*(1+Vthresh)
    "Maximum allowed voltage";
  parameter Modelica.SIunits.Voltage V_min = 220*(1-Vthresh)
    "Minimum allowed voltage";
  Buildings.Electrical.Utilities.Functions.VoltageControl
                                                Vctrl(V_nominal=V_nominal, Vthresh=Vthresh, Tdelay=Tdelay);
equation
  Vctrl.V = 230 + 220*(0.12)*sin(2*Modelica.Constants.pi*time/1000);
end TestVoltageCTRL;
