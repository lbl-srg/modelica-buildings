within Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511;
record Vitocal251A08 "A2W Vitocal 251 by Viessmann"
  extends GenericAirToWater(
    dpEva_nominal=0,
    dpCon_nominal=0,
    tabUppBou=[253.15,333.15; 263.15,363.15; 313.15,363.15],
    use_TConOutForOpeEnv=true,
    use_TEvaOutForOpeEnv=false,
    tabQCon_flow=[
      0, 253.15, 258.15, 266.15, 275.15, 280.15, 283.15, 293.15, 303.15, 308.15;
      308.15, 4490, 5170, 6470, 6790, 8000, 10210, 12330, 12310, 13090;
      318.15, 4230, 4900, 6260, 6780, 8370, 9970, 11520, 13040, 12640;
      328.15, 3780, 4710, 6030, 6830, 8380, 9940, 11500, 13070, 13110;
      338.15, 0, 3170, 4610, 6320, 8140, 9550, 11290, 12100, 12180;
      343.15, 0, 0, 3830, 5560, 7600, 8700, 11290, 12500, 12590],
    tabPEle=[
      0, 253.15, 258.15, 266.15, 275.15, 280.15, 283.15, 293.15, 303.15, 308.15;
      308.15, 2128, 2238, 2396, 1835, 1633, 2006, 1720, 1465, 1558;
      318.15, 2299, 2402, 2641, 2173, 2244, 2462, 2110, 1734, 1584;
      328.15, 2305, 2631, 2899, 2493, 2669, 2915, 2556, 2164, 2081;
      338.15, 0, 2032, 2478, 2760, 3095, 3375, 3085, 2521, 2511;
      343.15, 0, 0, 2201, 2699, 3193, 3398, 3330, 2822, 2817],
    mEva_flow_nominal=2125/3600/1.204,
    mCon_flow_nominal=5600/5/4184,
    use_TConOutForTab=true,
    use_TEvaOutForTab=false,
    devIde="Vitocal251A08");
  annotation (Documentation(info="<html>
<p>
  Data from the planning book (Planungshandbuch) from Viessmann.
</p>
<p>
  While the product exists in different sizes,
  this record contains the data for the subtype 251-A08.
  If you want to model the pressure losses of the device,
  check out the data sheet and the installed pumps.
  The pressure loss depends mostly on the hydraulic system
  according to the datasheet.
</p>
<p>
  The nominal mass flow rate is calculated for the nominal point A7/W35,
  with a temperature spread of 5 K.
</p>
<h4>References</h4>
<p>
Viessmann, Planungshandbuch.
<a href=\"https://www.haustechnik-handrich.de/media/pdf/54/c4/14/vie-pa-z022164.pdf\">
https://www.haustechnik-handrich.de/media/pdf/54/c4/14/vie-pa-z022164.pdf</a>.
</p>

</html>"));
end Vitocal251A08;
