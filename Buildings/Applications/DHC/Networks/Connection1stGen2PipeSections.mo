within Buildings.Applications.DHC.Networks;
model Connection1stGen2PipeSections
  "Connection for a first generation DHC network with 2 pipe sections"
  extends
    Buildings.Applications.DHC.Networks.BaseClasses.PartialConnection2Pipe2Medium(
    redeclare model Model_pip_aDisSup = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsSup,
      lambdaIns=lambdaIns,
      length=lengthDisSup,
      energyDynamics=energyDynamics,
      p_start=p_start,
      T_start=T_start),
    redeclare model Model_pip_bDisRet = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsSup,
      lambdaIns=lambdaIns,
      length=lengthDisSup,
      energyDynamics=energyDynamics,
      p_start=p_start,
      T_start=T_start),
    redeclare final model Model_pip_bDisSup =
        Buildings.Fluid.FixedResistances.LosslessPipe,
    redeclare final model Model_pip_aDisRet =
        Buildings.Fluid.FixedResistances.LosslessPipe,
    redeclare final model Model_pipConSup =
        Buildings.Fluid.FixedResistances.LosslessPipe,
    redeclare final model Model_pipConRet =
        Buildings.Fluid.FixedResistances.LosslessPipe);

  parameter Integer nSeg "Number of volume segments";
  parameter Modelica.SIunits.Length thicknessInsSup
    "Thickness of insulation on supply pipes";
  parameter Modelica.SIunits.Length thicknessInsRet
    "Thickness of insulation on return pipes";
  parameter Modelica.SIunits.ThermalConductivity lambdaIns
    "Heat conductivity of insulation";

  parameter Modelica.SIunits.Length lengthDisSup "Length of connection supply pipe";
  parameter Modelica.SIunits.Length lengthDisRet "Length of connection return pipe";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Connection1stGen2PipeSections;
