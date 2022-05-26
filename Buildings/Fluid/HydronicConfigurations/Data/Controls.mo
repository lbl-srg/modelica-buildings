within Buildings.Fluid.HydronicConfigurations.Data;
record Controls "Record with control parameters"
  extends Modelica.Icons.Record;

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Controls"), Evaluate=true);
  parameter Real k(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=1
    "Gain of controller"
    annotation (Dialog(group="Controls"));
  parameter Real Ti(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(group="Controls",
    enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Ni(
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)=0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation (Dialog(tab="Advanced",group="Controls",
    enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real y_reset=0
    "Neutral value to which the controller output is reset when switching the operating mode"
    annotation (Dialog(
    group="Controls",
    enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  annotation (defaultComponentName="cfg");
end Controls;
