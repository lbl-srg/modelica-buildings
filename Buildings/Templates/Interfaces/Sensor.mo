within Buildings.Templates.Interfaces;
partial model Sensor
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Types.Sensor typ "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    if typ <> Types.Sensor.None and typ <> Types.Sensor.DifferentialPressure
      then dat.getReal(varName=id + "." + locStr + " air mass flow rate")
      else 0
    "Mass flow rate"
    annotation (
     Dialog(group="Nominal condition", enable=typ <> Types.Sensor.None and typ
           <> Types.Sensor.DifferentialPressure));

  final parameter String locStr=
    if Modelica.Utilities.Strings.find(insNam, "Out")<>0 then "Supply"
    elseif Modelica.Utilities.Strings.find(insNam, "Sup")<>0 then "Supply"
    elseif Modelica.Utilities.Strings.find(insNam, "Mix")<>0 then "Supply"
    elseif Modelica.Utilities.Strings.find(insNam, "Hea")<>0 then "Supply"
    elseif Modelica.Utilities.Strings.find(insNam, "Coo")<>0 then "Supply"
    elseif Modelica.Utilities.Strings.find(insNam, "Ret")<>0 then "Return"
    elseif Modelica.Utilities.Strings.find(insNam, "Dis")<>0 then "Discharge"
    else "Undefined"
    "String used to identify the sensor location"
    annotation(Evaluate=true);
  final parameter String insNam = getInstanceName()
    "Instance name"
    annotation(Evaluate=true);
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Modelica.Fluid.Interfaces.FluidPort_b port_bRef(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if typ ==
    Types.Sensor.DifferentialPressure
    "Port at the reference pressure for differential pressure sensor"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
  Buildings.Templates.BaseClasses.Connectors.BusInterface busCon
    "Control bus"
    annotation (Placement(transformation(extent={{-20,80},{20, 120}}),
      iconTransformation(extent={{-10,90},{10,110}})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Sensor;
