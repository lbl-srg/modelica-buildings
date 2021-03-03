within Buildings.Experimental.Templates.AHUs.Validation;
model SupplyFanDrawMultipleVariable
  extends BaseNoEquipment(
                      redeclare
    UserProject.AHUs.SupplyFanDrawMultipleVariable ahu);
  UserProject.AHUs.Data.SupplyFanDrawMultipleVariable datAhu(datFanSup(nFan=2))
    annotation (Placement(transformation(extent={{-10,42},{10,62}})));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end SupplyFanDrawMultipleVariable;
