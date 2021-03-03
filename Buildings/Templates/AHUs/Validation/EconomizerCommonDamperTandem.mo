within Buildings.Experimental.Templates.AHUs.Validation;
model EconomizerCommonDamperTandem
  extends BaseNoEquipment(redeclare
      UserProject.AHUs.EconomizerCommonDamperTandem ahu(redeclare record
        RecordEco =
          Buildings.Experimental.Templates.AHUs.Economizers.Data.CommonDamperTandem
          (mExh_flow_nominal=1)));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end EconomizerCommonDamperTandem;
