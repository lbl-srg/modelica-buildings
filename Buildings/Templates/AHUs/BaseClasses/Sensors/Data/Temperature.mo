within Buildings.Templates.AHUs.BaseClasses.Sensors.Data;
record Temperature
  extends Buildings.Templates.AHUs.Interfaces.Data.Sensor;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    if braStr=="Supply" then
    dat.getReal(varName=id + ".Supply air mass flow rate")
    elseif braStr=="Return" then
    dat.getReal(varName=id + ".Return air mass flow rate")
    else 0
    "Mass flow rate"
    annotation (
      Dialog(group="Nominal condition"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Temperature;
