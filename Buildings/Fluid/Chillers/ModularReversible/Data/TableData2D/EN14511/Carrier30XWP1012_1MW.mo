within Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511;
record Carrier30XWP1012_1MW
  "Carrier 30XW-P 1012 with roughly 1 MW cooling output"
  extends Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic(
    tabQEva_flow=[0,298.15,303.15,308.15,313.15,318.15; 278.15,-1003000,-968000,
        -932000,-894000,-854000; 280.15,-1054000,-1035000,-995000,-954000,-911000; 283.15,
        -1102000,-1120000,-1096000,-1050000,-1002000; 288.15,-1181000,-1199000,-1226000,
        -1227000,-1170000; 291.15,-1227000,-1244000,-1275000,-1311000,-1278000],
    tabPEle=[0,298.15,303.15,308.15,313.15,318.15; 278.15,158954,181955,208036,
        237766,271111; 280.15,159215,182218,208159,237905,271131; 283.15,159479,
        182708,208762,238095,271545; 288.15,160462,183333,209573,239648,272727;
        291.15,161024,183752,210396,240550,274249],
    mCon_flow_nominal=49.85,
    mEva_flow_nominal=49.85,
    dpCon_nominal=32000,
    dpEva_nominal=44000,
    tabLowBou=[293.15,276.15; 323.15,276.15],
    devIde="Carrier30XWP1012",
    use_TConOutForOpeEnv=true,
    use_TEvaOutForOpeEnv=true,
    use_TConOutForTab=false,
    use_TEvaOutForTab=true);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  Performance data for Daikin FTXM20R_RXM20R for the cooling mode.
</p>
<p>
  Boundaries are for dry-bulb temperature.
</p>
<h4>References</h4>
<p>
Carrier, Water-Cooled Liquid Chillers Pro-Dialog plus, 30XW- 30XWHDaikin
<a href=\"http://www.carrier.com.kw/pdf/pdf/Chilled%20Water%20Products/30XW.pdf\">
http://www.carrier.com.kw/pdf/pdf/Chilled%20Water%20Products/30XW.pdf</a>
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
end Carrier30XWP1012_1MW;
