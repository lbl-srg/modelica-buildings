within Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces;
partial block PartialController

  parameter AirHandlersFans.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  outer parameter Integer nZon
    "Number of served zones";
  outer parameter Integer nGro
    "Number of zone groups";
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  // See FIXME below for those parameters.
  parameter String idTerArr[nZon]={"Box_1", "Box_1"}
    "Array of tags of served terminal units"
    annotation(Evaluate=true);
  parameter String namGro[nGro]={"First floor"}
    "Array of group names"
    annotation(Evaluate=true);

  /*
  parameter String idTerArr[nZon]=
    dat.getStringArray1D(id + ".identification.idTerArr.value", nZon)
    "Served terminal units - Array of system identifiers"
    annotation(Evaluate=true);
  parameter String namGro[nGro]=
    dat.getStringArray1D(id + ".identification.namGro.value", nGro)
    "Array of group names"
    annotation(Evaluate=true);
    */

  Buildings.Templates.AirHandlersFans.Interfaces.Bus bus
    "AHU control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-200,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,0})));
  ZoneEquipment.Interfaces.Bus busTer[nZon]
    "Terminal unit control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={220,0}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));

  annotation (
    __Dymola_translate=true,
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,-114},{149,-154}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{220,
            200}})));
end PartialController;
