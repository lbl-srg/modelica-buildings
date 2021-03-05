within Buildings.Templates.AHUs.Interfaces;
package Data
  extends Modelica.Icons.MaterialPropertiesPackage;

  record Coil
    extends Modelica.Icons.Record;

    parameter Types.CoilFunction fun
      "Equipment function: MAY NOT BE NEEDED, can be inferred from instance name"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    final inner parameter String funStr=
      if lasCha=="iCoo" then "Cooling"
      elseif lasCha=="Hea3" then "Reheat"
      else "Preheat"
      "String used to fetch coil parameters";
    final parameter String insNam = getInstanceName()
      "Instance name";
    final parameter Integer lenInsNam=
      Modelica.Utilities.Strings.length(insNam)
      "Length of instance name";
    final parameter String lasCha=
      Modelica.Utilities.Strings.substring(insNam, lenInsNam-3, lenInsNam)
      "Last characters of instance name";
    outer parameter String id=""
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file"
      annotation (Placement(transformation(extent={{70,70},{90,90}})));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Coil;

  record Fan
    extends Modelica.Icons.Record;
    parameter Types.Branch bra
      "Branch where the equipment is installed"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    outer parameter String id=""
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file"
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Fan;

  record HeatExchanger
    extends Modelica.Icons.Record;
    outer parameter String funStr
      "String used to fetch coil parameters";
    outer parameter String id=""
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file"
      annotation (Placement(transformation(extent={{70,70},{90,90}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end HeatExchanger;

  record Sensor
    extends Modelica.Icons.Record;
    parameter Types.Branch bra
      "Branch where the equipment is installed"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    outer parameter String id=""
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file"
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Sensor;
end Data;
