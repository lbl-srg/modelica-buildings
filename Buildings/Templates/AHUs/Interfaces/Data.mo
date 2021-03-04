within Buildings.Templates.AHUs.Interfaces;
package Data
  extends Modelica.Icons.MaterialPropertiesPackage;

  record Fan
    extends Modelica.Icons.Record;
    parameter Types.Branch bra
      "Branch where the equipment is installed"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    outer parameter String id=""
      "System identifier";
    outer parameter ExternData.JSONFile dat
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Fan;

  record Sensor
    extends Modelica.Icons.Record;
    parameter Types.Branch bra
      "Branch where the equipment is installed"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    outer parameter String id=""
      "System identifier";
    outer parameter ExternData.JSONFile dat
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Sensor;
end Data;
