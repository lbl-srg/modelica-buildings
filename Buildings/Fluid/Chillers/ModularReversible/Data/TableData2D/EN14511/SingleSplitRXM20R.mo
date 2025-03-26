within Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511;
record SingleSplitRXM20R "Daikin_FTXM20R_RXM20R cooling mode"
  extends Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic(
    dpEva_nominal=0,
    dpCon_nominal=0,
    tabPEle=[0,298.15,303.15,308.15,313.15; 293.15,340,370,400,410,430,470;
        295.15,340,370,400,420,430,470; 298.15,340,370,400,420,440,470; 300.15,
        340,370,410,420,440,470; 303.15,340,380,410,420,440,470; 305.15,350,380,
        410,420,440,470],
    tabQEva_flow=[0,298.15,303.15,308.15,313.15; 293.15,-2050,-1960,-1860,-1830,-1770,
        -1680; 295.15,-2140,-2050,-1950,-1920,-1860,-1770; 298.15,-2230,-2140,-2050,-2010,
        -1950,-1860; 300.15,-2280,-2190,-2090,-2060,-2000,1910; 303.15,-2420,-2320,-2230,
        -2190,-2140,-2050; 305.15,-2510,-2420,-2320,-2290,-2230,-2140],
    mCon_flow_nominal=36*1.2/60,
    mEva_flow_nominal=(9.642*1.2)/60,
    tabLowBou=[263.15,291.15; 323.15,291.15],
    devIde="DaikinRXM20R",
    use_TConOutForOpeEnv=false,
    use_TEvaOutForOpeEnv=false,
    use_TConOutForTab=false,
    use_TEvaOutForTab=false);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  Performance data for Daikin FTXM20R_RXM20R for the cooling mode.
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
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>"));
end SingleSplitRXM20R;
