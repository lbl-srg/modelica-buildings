within Buildings.Fluid.HeatPumps.Data.ReverseWaterToWater;
record EnergyPlus =
 Buildings.Fluid.HeatPumps.Data.ReverseWaterToWater.Generic (
    TRefHeaLoa=10 + 273.15,
    TRefHeaSou=10 + 273.15,
    TRefCooSou=10 + 273.15,
    TRefCooLoa=10 + 273.15,
    QHea_flow_nominal=39040.92,
    QCoo_flow_nominal=-39890.91,
    mLoa_flow_nominal=1.89,
    mSou_flow_nominal=1.89,
    P_nominal_hea=5130,
    P_nominal_coo=4790,
    LRCH={-3.33491153,-0.51451946,4.51592706,0.01797107,0.155797661},
    LRCC={-1.52030596,3.46625667,-1.32267797,0.09395678,0.038975504},
    PRCH={-8.93121751,8.57035762,1.29660976,-0.21629222,0.033862378},
    PRCC={-8.59564386,0.96265085,8.69489229,0.02501669,-0.20132665})
   "EnergyPlus"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="EPdataHP",
  defaultComponentPrefixes="parameter",
  Documentation(info= "<html>
<p>
This data corresponds to the EnergyPlus example file <code>GSHPSimple-GLHE.idf</code>
from EnergyPlus 9.1, with a nominal cooling capacity of <i>39890</i> Watts and
nominal heating capacity of <i>39040</i> Watt.
</p>
</html>"));
