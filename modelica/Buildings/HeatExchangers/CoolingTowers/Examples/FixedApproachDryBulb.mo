model FixedApproachDryBulb 
  extends 
    Buildings.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTower(
    redeclare Buildings.HeatExchangers.CoolingTowers.FixedApproach tow);
  annotation(Diagram, Commands(file="FixedApproachDryBulb.mos" "run"));
equation 
  connect(TOut.y, tow.TAir) annotation (points=[-39,90; -32,90; -32,-4; -20,-4],
      style(color=74, rgbcolor={0,0,127}));
end FixedApproachDryBulb;
