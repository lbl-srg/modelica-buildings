within Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511;
record Vitocal251A08 "A2W Vitocal 251 by Viessmann"
  extends Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic(
    tabLowBou=[283.15,280.15; 318.15,280.15],
    dpEva_nominal=0,
    dpCon_nominal=0,
    use_TConOutForOpeEnv=false,
    use_TEvaOutForOpeEnv=true,
    tabQEva_flow=[
      0, 293.15, 298.15, 300.15, 303.15, 308.15, 313.15, 318.15;
      280.15, -8500, -7800, -7000, -6000, -4500, -3100, -1900;
      291.15, -10300, -9900, -9700, -9300, -6900, -3400, -2800],
    tabPEle=[
      0, 293.15, 298.15, 300.15, 303.15, 308.15, 313.15, 318.15;
      280.15, 1735, 1902, 1842, 1765, 1607, 1348, 1056;
      291.15, 1493, 1707, 1764, 1860, 1725, 1259, 1037],
    mEva_flow_nominal=5600/5/4184,
    mCon_flow_nominal=2125/3600/1.204,
    use_TConOutForTab=false,
    use_TEvaOutForTab=true,
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
