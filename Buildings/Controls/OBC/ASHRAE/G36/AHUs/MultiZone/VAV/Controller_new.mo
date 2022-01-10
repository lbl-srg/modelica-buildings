within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV;
block Controller_new "Multizone VAV air handling unit controller"
  FreezeProtection mulAHUFrePro
    annotation (Placement(transformation(extent={{-48,-76},{-28,-36}})));
  PlantRequests mulAHUPlaReq
    annotation (Placement(transformation(extent={{94,-148},{114,-128}})));
  Economizers.Controller ecoCon
    annotation (Placement(transformation(extent={{-144,174},{-124,214}})));
  SetPoints.SupplyFan conSupFan
    annotation (Placement(transformation(extent={{-848,134},{-828,154}})));
  SetPoints.SupplySignals supSig
    annotation (Placement(transformation(extent={{-846,-30},{-826,-10}})));
  SetPoints.SupplyTemperature conTSupSet
    annotation (Placement(transformation(extent={{-876,-170},{-856,-150}})));
  SetPoints.OutdoorAirFlow.AHU ahuOutAirSet
    annotation (Placement(transformation(extent={{-970,266},{-950,286}})));
  SetPoints.OutdoorAirFlow.SumZone zonToSys
    annotation (Placement(transformation(extent={{-1020,130},{-1000,150}})));
  SetPoints.OutdoorAirFlow.Zone zonOutAirSet
    annotation (Placement(transformation(extent={{-1088,34},{-1068,54}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-340,
            -480},{360,480}})), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-340,-480},{360,480}})));
end Controller_new;
