within Buildings.Experimental.DHC.Plants.Combined.Controls;
package ModeCondenserLoop "Condenser loop operating modes"

  constant Integer tankCharge = 1 "Tank Charge/Discharge";
  constant Integer chargeAssist = 2  "Charge Assist";
  constant Integer heatRejection = 3 "Heat Rejection";

  annotation (Documentation(info="<html>
<p>
This package contains constant definitions representing
the operating modes of the condenser water loop.
</p>
</html>"));
end ModeCondenserLoop;
