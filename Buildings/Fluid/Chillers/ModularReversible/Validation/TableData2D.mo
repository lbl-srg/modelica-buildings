within Buildings.Fluid.Chillers.ModularReversible.Validation;
model TableData2D "Validation case for table data approach"
  extends BaseClasses.PartialModularComparison(
    TEva_nominal=TEvaIn_nominal,
    TCon_nominal=TConIn_nominal,
    chi(redeclare model RefrigerantCycleChillerCooling =
          Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D (
            datTab(
            tabPEle=[0,293.15,303.15; 288.15,14122.8,14122.8; 298.15,14122.8,14122.8],
            mCon_flow_nominal=m1_flow_nominal,
            mEva_flow_nominal=m2_flow_nominal,
            dpCon_nominal=0,
            dpEva_nominal=0,
            devIde="CarnotTableData",
            use_TEvaOutForTab=false,
            use_TConOutForTab=false,
            tabQEva_flow=[0,293.15,303.15; 288.15,-35499.7,-30000; 298.15,0,-36220.8],
            tabLowBou=[273.15,273.15; 273.15,273.15],
            use_TEvaOutForOpeEnv=false,
            use_TConOutForOpeEnv=false))));

  extends Modelica.Icons.Example;

  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/ModularReversible/Validation/TableData2D.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
November 13, 2023 by Fabian Wuellhorst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Validation case for <a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D\">
Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D</a>.
</p>
</html>"));
end TableData2D;
