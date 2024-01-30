within Buildings.Fluid.HeatPumps.ModularReversible.Validation;
model TableData2D
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.Validation.BaseClasses.PartialValidation(
      heaPum(
      mCon_flow_nominal=mCon_flow_nominal,
      tauCon=VCon*heaPum.rhoCon/mCon_flow_nominal,
      redeclare model RefrigerantCycleInertia =
          Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.VariableOrder(
          refIneFreConst=refIneFreConst,
          nthOrd=2,
          initType=Modelica.Blocks.Types.Init.InitialState),
      redeclare model RefrigerantCycleHeatPumpHeating =
          Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D (
            datTab=
              Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump(
              tabPEle=[0,273.15,283.15; 308.15,1300,1500; 328.15,1900,2300],
              mCon_flow_nominal=6100/5/4184,
              mEva_flow_nominal=4800/5/4184,
              dpCon_nominal=0,
              dpEva_nominal=0,
              devIde="Vaillaint_VWL101",
              use_TEvaOutForTab=false,
              use_TConOutForTab=true,
              tabQCon_flow=[0,273.15,283.15; 308.15,6100,8400; 328.15,5700,7600],
              tabUppBou=[-40,70; 40,70]))));

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=0.404317
    "Condenser nominal mass flow rate";
  parameter Modelica.Units.SI.Volume VCon=0.004473
    "Condenser volume";
  parameter Modelica.Units.SI.Frequency refIneFreConst=0.011848
    "Cut off frequency for inertia of refrigerant cycle";

  annotation (experiment(Tolerance=1e-6, StopTime=14365),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Validation/TableData2D.mos"
            "Simulate and plot"),
    Documentation(info="<html>
<p>
  This validation case uses table-based data for the heat pump.
</p>
<p>
  The approach was calibrated as a comparison to constant Carnot effectiveness
  approach in the conference paper for the heat pump model:
  <a href=\"https://doi.org/10.3384/ecp21181561\">
  https://doi.org/10.3384/ecp21181561</a>
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end TableData2D;
