within Buildings.Experimental.Templates.AHUs.Validation;
model SupplyFanDrawSingleVariable
  extends BaseNoEquipment(
                      ahu(redeclare record RecordFanSup =
          Fans.Data.SingleVariable, redeclare Fans.SingleVariable fanSupDra));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end SupplyFanDrawSingleVariable;
