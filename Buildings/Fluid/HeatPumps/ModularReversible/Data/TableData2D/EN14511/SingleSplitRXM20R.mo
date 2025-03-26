within Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511;
record SingleSplitRXM20R "Daikin_FTXM20R_RXM20R heating mode"
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump(
    use_TConOutForOpeEnv=true,
    use_TEvaOutForOpeEnv=false,
    dpEva_nominal=0,
    dpCon_nominal=0,
    tabQCon_flow=[0,258.15, 263.15, 268.15, 273.15, 280.15, 283.15;
      288.15,1190,1430,1670,1940,2590,2810;
      293.15,1120,1360,1600, 1860,2500,2730;
      295.15,1090,1330,1570,1830,2470,2690;
      297.15,1060,1300,1540,1800,2430,2660;
      298.15,1040,1280,1520,1780,2410,2640;
      300.15,1010,1250,1490,1760,2380,2610],
    tabPEle=[0,258.15, 263.15, 268.15, 273.15, 280.15, 283.15;
      288.15,320,340,360,460,490,510;
      293.15,330,350,370,470,500,520;
      295.15,340,360,370,480,500,520;
      297.15,340,360,380,480,510,530;
      298.15,340, 360,380,490,510,530;
      300.15,350,370,380,490,520,540],
    mCon_flow_nominal=(9.33*1.2)/60,
    mEva_flow_nominal=(28.3*1.2)/60,
    tabUppBou=[253.15,303.15; 291.15,303.15],
    devIde="DaikinRXM20R",
    use_TConOutForTab=false,
    use_TEvaOutForTab=false);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  Performance data for Daikin FTXM20R_RXM20R for the heating mode.
</p>
<p>
  Boundaries are for dry-bulb temperature. Pressure drops are not provided
  in the datasheet.
</p>
<h4>References</h4>
<p>
Daikin, Technical data book RXM-R
<a href=\"https://www.heizman24.de/media/pdf/fa/50/2c/Daikin-RXM-R-Produktdatenbuch.pdf\">
https://www.heizman24.de/media/pdf/fa/50/2c/Daikin-RXM-R-Produktdatenbuch.pdf</a>
</p>

</html>", revisions="<html>
<ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end SingleSplitRXM20R;
