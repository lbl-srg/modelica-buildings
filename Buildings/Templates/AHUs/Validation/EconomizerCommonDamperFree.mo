within Buildings.Experimental.Templates.AHUs.Validation;
model EconomizerCommonDamperFree
  extends BaseNoEquipment(redeclare UserProject.AHUs.EconomizerCommonDamperFree
      ahu(datEco=datAhu.datEco));
  UserProject.AHUs.Data.EconomizerCommonDamperFree datAhu(datEco(
        mExh_flow_nominal=1))
    annotation (Placement(transformation(extent={{-10,42},{10,62}})));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end EconomizerCommonDamperFree;
