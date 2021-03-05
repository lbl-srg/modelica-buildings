within Buildings.Templates.AHUs.Interfaces;
package Data
  extends Modelica.Icons.MaterialPropertiesPackage;

  record Coil
    extends Modelica.Icons.Record;

    inner parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal(min=0)=
      dat.getReal(varName=id + "." + funStr + " coil.Air mass flow rate")
      "Air mass flow rate"
      annotation(Dialog(group = "Nominal condition"));
    inner parameter Modelica.SIunits.PressureDifference dpAir_nominal(
      displayUnit="Pa")=
      dat.getReal(varName=id + "." + funStr + " coil.Air pressure drop")
      "Air pressure drop"
      annotation(Dialog(group = "Nominal condition"));

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
      annotation (Placement(transformation(extent={{76,76},{96,96}})));

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
      annotation (Placement(transformation(extent={{76,76},{96,96}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Fan;

  record HeatExchangerDX
    extends HeatExchangerWater;
  end HeatExchangerDX;

  record HeatExchangerWater
    extends Modelica.Icons.Record;

    outer parameter String funStr
      "String used to fetch coil parameters";
    outer parameter String id=""
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file"
      annotation (Placement(transformation(extent={{76,76},{96,96}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end HeatExchangerWater;

  record Sensor
    extends Modelica.Icons.Record;
    parameter Types.Branch bra
      "Branch where the equipment is installed"
      annotation (Evaluate=true, Dialog(group="Configuration"));
    outer parameter String id=""
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file"
      annotation (Placement(transformation(extent={{76,76},{96,96}})));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Sensor;
end Data;
