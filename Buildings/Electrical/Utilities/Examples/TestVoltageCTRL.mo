within Buildings.Electrical.Utilities.Examples;
model TestVoltageCTRL
  "This test check the correctness of the voltage control function"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Voltage V_nominal = 220
    "Nominal voltage of the node to be controlled";
  parameter Real vThresh(min=0.0, max=1.0) = 0.1
    "Threshold that activates voltage ctrl (ratio of nominal voltage)";
  parameter Modelica.SIunits.Time tDelay = 300
    "Time to wait before plugging the load back";
  parameter Modelica.SIunits.Voltage V_max = 220*(1+vThresh)
    "Maximum allowed voltage";
  parameter Modelica.SIunits.Voltage V_min = 220*(1-vThresh)
    "Minimum allowed voltage";
  Buildings.Electrical.Utilities.Functions.voltageControl
                                                Vctrl(V_nominal=V_nominal, vThresh=vThresh, tDelay=tDelay);
equation
  Vctrl.V = 230 + 220*(0.12)*sin(2*Modelica.Constants.pi*time/1000);
  annotation (Documentation(revisions="<html>
<ul>
<li>
Aug 28, 2014, by Marco Bonvini:<br/>
Added documentation.
</li>
</ul>
</html>"));
end TestVoltageCTRL;
