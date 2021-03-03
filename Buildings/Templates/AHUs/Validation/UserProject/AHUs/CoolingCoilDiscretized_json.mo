within Buildings.Experimental.Templates.AHUs.Validation.UserProject.AHUs;
model CoolingCoilDiscretized_json
  extends VAVSingleDuct(
    final id="VAV_1",
    redeclare Coils.WaterBased coiCoo(
      redeclare
        Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Discretized
        coi),
      redeclare replaceable record RecordCoiCoo = Coils.Data.WaterBased (
        redeclare
          Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Data.Discretized
          datHex(UA_nominal=dataSource.getReal(varName=id + ".Cooling Coil.UA_nominal"))));
  outer parameter ExternData.JSONFile dataSource
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  annotation (
    defaultComponentName="ahu");
end CoolingCoilDiscretized_json;
