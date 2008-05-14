model FixedApproachDryBulb 
  "Cooling tower with fixed approach temperature based on dry bulb temperature" 
  extends 
    Buildings.HeatExchangers.CoolingTowers.BaseClasses.PartialStaticFourPortCoolingTower;
  annotation (Icon(
      Text(
        extent=[-78,62; 98,-104],
        style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=58,
          rgbfillColor={0,127,0},
          fillPattern=1), 
        string="dry-bulb")),
                          Diagram);
equation 
  TApp    = TWatOut - TAirIn;
end FixedApproachDryBulb;
