within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Loads;
model BuildingRCZ1WithETS
  "Model of a building (RC 1 zone) with an energy transfer station"
  extends BaseClasses.PartialBuildingWithETS(
    enaHeaCoo(t=1e-4 .* {ets.mHeaWat_flow_nominal,ets.mChiWat_flow_nominal}),
    reqHeaCoo(y={bui.disFloHea.mReqTot_flow,bui.disFloCoo.mReqTot_flow}),
    redeclare DHC.Loads.Examples.BaseClasses.BuildingRCZ1Valve bui,
    ets(
      have_hotWat=false,
      QChiWat_flow_nominal=bui.terUni.QCoo_flow_nominal,
      QHeaWat_flow_nominal=bui.terUni.QHea_flow_nominal));

  annotation (Line(
      points={{-1,100},{0.1,100},{0.1,59.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
end BuildingRCZ1WithETS;
