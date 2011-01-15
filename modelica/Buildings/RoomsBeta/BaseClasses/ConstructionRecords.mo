within Buildings.RoomsBeta.BaseClasses;
record ConstructionRecords "Data records for construction data"
  extends Buildings.RoomsBeta.BaseClasses.ConstructionNumbers;

  parameter Buildings.RoomsBeta.BaseClasses.ParameterConstruction datConExt[NConExt](
    each A=0,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120 layers,
    each til=0,
    each azi=0) "Data for exterior construction"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  parameter Buildings.RoomsBeta.BaseClasses.ParameterConstructionWithWindow
    datConExtWin[NConExtWin](
    each A=0,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120 layers,
    each til=0,
    each azi=0,
    each AWin=0,
    redeclare Buildings.HeatTransfer.Data.GlazingSystems.SingleClear3 glaSys)
    "Data for exterior construction with window"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  parameter Buildings.RoomsBeta.BaseClasses.ParameterConstruction datConPar[
              NConPar](
    each A=0,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120 layers,
    each til=0,
    each azi=0) "Data for partition construction"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
  parameter Buildings.RoomsBeta.BaseClasses.ParameterConstruction datConBou[NConBou](
    each A=0,
    redeclare Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120 layers,
    each til=0,
    each azi=0) "Data for construction boundary"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  ParameterSurface surBou[                        NSurBou](each A=0, each til=0)
    "Record for data of surfaces whose heat conduction is modeled outside of this room"
    annotation (Placement(transformation(extent={{-80,-140},{-100,-120}})));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,
            -180},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-200,-180},{100,100}})));
end ConstructionRecords;
