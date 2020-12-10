within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Loads;
model BuildingRCZ6WithETS
  "Model of a building (RC 6 zones) with an energy transfer station"
  extends BaseClasses.PartialBuildingWithETS(
    redeclare DHC.Loads.Examples.BaseClasses.BuildingRCZ6 bui,
    ets(
      have_hotWat=false,
      QChiWat_flow_nominal=sum(bui.terUni.QCoo_flow_nominal),
      QHeaWat_flow_nominal=sum(bui.terUni.QHea_flow_nominal)),
    enaHeaCoo(t=1e-4 .* {ets.mHeaWat_flow_nominal,ets.mChiWat_flow_nominal}),
    reqHeaCoo(y={bui.disFloHea.mReqTot_flow,bui.disFloCoo.mReqTot_flow}));
equation
  connect(enaHeaCoo[1].y, ets.uHea) annotation (Line(points={{-58,-100},{-48,
          -100},{-48,-46},{-34,-46}}, color={255,0,255}));
  connect(enaHeaCoo[2].y, ets.uCoo) annotation (Line(points={{-58,-100},{-44,
          -100},{-44,-50},{-34,-50}}, color={255,0,255}));
  annotation (Line(
      points={{-1,100},{0.1,100},{0.1,59.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
end BuildingRCZ6WithETS;
