within Buildings.Templates.ZoneEquipment.Validation.UserProject;
block BASControlPoints "Emulation of control points from the BAS"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer nZon = 2
    "Number of served zones";

  Interfaces.Bus busTer[nZon]
    "Terminal unit control bus" annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,0}), iconTransformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,0})));
  Controls.OBC.CDL.Logical.Sources.Constant y1OccSch[nZon](
    each k=true)
    "Scheduled occupancy"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Controls.OBC.CDL.Integers.Sources.Constant yOveFloSet[nZon](each k=0)
    "FIXME #1913: Testing and commissioning overrides should be Booleans"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Controls.OBC.CDL.Logical.Sources.Constant y1OveHeaOff[nZon](
    each k=false)
    "Testing and commissioning override - Heating coil"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Controls.OBC.CDL.Integers.Sources.Constant yOveDamPos[nZon](each k=0)
    "FIXME #1913: Testing and commissioning overrides should be Booleans"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation
  connect(y1OccSch.y, busTer.y1OccSch);
  connect(yOveFloSet.y, busTer.yOveFloSet);
  connect(yOveDamPos.y, busTer.yOveDamPos);
  connect(y1OveHeaOff.y, busTer.y1OveHeaOff);

  annotation (
    defaultComponentName="sigBAS",
    Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-200,-180},{200,180}})));
end BASControlPoints;
