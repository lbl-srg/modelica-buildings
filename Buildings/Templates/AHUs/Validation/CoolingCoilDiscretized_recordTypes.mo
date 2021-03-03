within Buildings.Experimental.Templates.AHUs.Validation;
model CoolingCoilDiscretized_recordTypes
  extends BaseNoEquipment( redeclare
    UserProject.AHUs.CoolingCoilDiscretized ahu(
    redeclare record RecordCoiCoo=datAhu.RecordCoiCoo));

  Fluid.Sources.Boundary_pT bou2(
    redeclare final package Medium = MediumCoo,
    nPorts=2)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  UserProject.AHUs.Data.CoolingCoilDiscretized datAhu(
    redeclare record RecordCoiCoo =
      Buildings.Experimental.Templates.AHUs.Coils.Data.WaterBased (redeclare
        Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Data.Discretized
        datHex(UA_nominal=500)))
    annotation (Placement(transformation(extent={{-10,42},{10,62}})));
equation
  connect(bou2.ports[1], ahu.port_coiCooSup)
    annotation (Line(points={{-40,-48},{-2,-48},{-2,-20}}, color={0,127,255}));
  connect(bou2.ports[2], ahu.port_coiCooRet)
    annotation (Line(points={{-40,-52},{2,-52},{2,-20}}, color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This model fails to compile due to the following statement
<code>ahu(redeclare record RecordCoiCoo=datAhu.RecordCoiCoo)</code>.
This illustrates that record types alone cannot be used to 
propagate parameters from the top-level simulation model to 
the AHU model.
We need record instances for that, but then we end up with the 
hefty structure based on both a replaceable record type and 
a replaceable record component in the AHU template.
</p>
</html>"));
end CoolingCoilDiscretized_recordTypes;
