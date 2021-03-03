within Buildings.Experimental.Templates.AHUs.Validation;
model SupplyFanBlowSingleConstant
  extends BaseNoEquipment(
                      ahu(
    have_draThr=false,
    redeclare record RecordFanSup = Fans.Data.SingleConstant,
    redeclare Fans.SingleConstant fanSupBlo));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end SupplyFanBlowSingleConstant;
