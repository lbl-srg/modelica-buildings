within Buildings.ThermalZones.Detailed.BaseClasses;
record ConstructionRecords "Data records for construction data"
  extends Buildings.ThermalZones.Detailed.BaseClasses.ConstructionNumbers;

  parameter ParameterConstruction datConExt[NConExt](
    each A=0,
    each layers = dummyCon,
    each til=0,
    each azi=0) "Data for exterior construction"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})), HideResult=true);
  parameter Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstructionWithWindow
    datConExtWin[NConExtWin](
    each A=0,
    each layers = dummyCon,
    each til=0,
    each azi=0,
    each hWin=0,
    each wWin=0,
    each glaSys=dummyGlaSys) "Data for exterior construction with window"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})), HideResult=true);
  parameter Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstruction datConPar[NConPar](
    each A=0,
    each layers = dummyCon,
    each til=0,
    each azi=0) "Data for partition construction"
    annotation (Placement(transformation(extent={{-140,-200},{-120,-180}})), HideResult=true);
  parameter Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstruction datConBou[NConBou](
    each A=0,
    each layers = dummyCon,
    each til=0,
    each azi=0) "Data for construction boundary"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})), HideResult=true);

  parameter Buildings.ThermalZones.Detailed.BaseClasses.OpaqueSurface surBou[NSurBou](
    each A=0,
    each til=0)
    "Record for data of surfaces whose heat conduction is modeled outside of this room"
    annotation (Placement(transformation(extent={{-80,-160},{-100,-140}})), HideResult=true);

  // Dummy constructions to assign values to parameters.
  // The actual assignments will be overwritten by models that extend this model.
  // Note that parameters in records cannot be protected. However, we set the
  // annotation HideResult=true to avoid that they show up in the output file.
  parameter HeatTransfer.Data.OpaqueConstructions.Brick120 dummyCon
    "Dummy construction to assign a parameter to the instance"
    annotation (HideResult=true);
  parameter Buildings.HeatTransfer.Data.GlazingSystems.SingleClear3 dummyGlaSys
    "Dummy construction to assign a parameter to the instance"
    annotation (HideResult=true);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-200},
            {100,100}})),       Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}})),
Documentation(
info="<html>
<p>
Record that defines the number of constructions that are
used in the room model.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 14, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end ConstructionRecords;
