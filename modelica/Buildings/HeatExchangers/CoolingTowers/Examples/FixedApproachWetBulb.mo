model FixedApproachWetBulb 
  import Buildings;
  extends BaseClasses.PartialStaticFourPortCoolingTower(
    redeclare Buildings.HeatExchangers.CoolingTowers.FixedApproachWetBulb tow);
  annotation(Diagram, Commands(file="FixedApproachWetBulb.mos" "run"));
end FixedApproachWetBulb;
