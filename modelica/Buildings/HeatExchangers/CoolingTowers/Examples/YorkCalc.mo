model YorkCalc 
  extends BaseClasses.PartialStaticFourPortCoolingTower(
    redeclare Buildings.HeatExchangers.CoolingTowers.YorkCalc tow(
    mAir0_flow=mAir0_flow, mWat0_flow=mWat0_flow),
    res_2(m0_flow=0.0015*1000),
    res_1(
      m0_flow=mWat0_flow, 
      dp0=100, 
      dh=0.1), 
    sou_1(p=101335), 
    PWatIn(k=101325 + 100));
  annotation(Diagram, Commands(file="YorkCalc.mos" "run"));
  
end YorkCalc;
