within Buildings.Templates.Interfaces;
partial block ControllerAHU

  parameter Types.ControllerAHU typ
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

  final parameter String idTerArr[nZon]=
    dat.getStringArray1D(id + ".Identification.Terminal unit identifiers.value", nZon)
    "Served terminal units - Array of system identifiers"
    annotation(Evaluate=true);
  final parameter String namGro[nGro]=
    dat.getStringArray1D(id + ".Identification.Zone group names.value", nGro)
    "Array of group names"
    annotation(Evaluate=true);

  BaseClasses.Connectors.BusAHU busAHU
    "AHU control bus"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-200,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,0})));
  BaseClasses.Connectors.BusAHU busTer[nZon]
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
end ControllerAHU;
