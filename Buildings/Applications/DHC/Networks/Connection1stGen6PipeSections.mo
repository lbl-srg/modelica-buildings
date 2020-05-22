within Buildings.Applications.DHC.Networks;
model Connection1stGen6PipeSections
  "Terminal connection for a first generation DHC network with 6 pipe sections"
  extends
    Buildings.Applications.DHC.Networks.BaseClasses.PartialConnection2Pipe2Medium(
    redeclare model Model_pip_aDisSup = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsSup,
      lambdaIns=lambdaIns,
      length=lengthDisSup_a,
      energyDynamics=energyDynamics,
      p_start=p_start,
      T_start=T_start),
    redeclare model Model_pip_bDisRet = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsRet,
      lambdaIns=lambdaIns,
      length=lengthDisRet_b,
      energyDynamics=energyDynamics,
      p_start=p_start,
      T_start=T_start),
    redeclare model Model_pip_bDisSup = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsSup,
      lambdaIns=lambdaIns,
      length=lengthDisSup_b,
      energyDynamics=energyDynamics,
      p_start=p_start,
      T_start=T_start),
    redeclare model Model_pip_aDisRet = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsRet,
      lambdaIns=lambdaIns,
      length=lengthDisRet_a,
      energyDynamics=energyDynamics,
      p_start=p_start,
      T_start=T_start),
    redeclare model Model_pipConSup = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsSup,
      lambdaIns=lambdaIns,
      length=lengthConSup,
      energyDynamics=energyDynamics,
      p_start=p_start,
      T_start=T_start),
    redeclare model Model_pipConRet = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsRet,
      lambdaIns=lambdaIns,
      length=lengthConRet,
      energyDynamics=energyDynamics,
      p_start=p_start,
      T_start=T_start));

  parameter Integer nSeg "Number of volume segments";
  parameter Modelica.SIunits.Length thicknessInsSup
    "Thickness of insulation on supply pipes";
  parameter Modelica.SIunits.Length thicknessInsRet
    "Thickness of insulation on return pipes";
  parameter Modelica.SIunits.ThermalConductivity lambdaIns
    "Heat conductivity of insulation";

  parameter Modelica.SIunits.Length lengthDisSup_a "Length of district supply pipe";
  parameter Modelica.SIunits.Length lengthDisRet_b "Length of district return pipe";
  parameter Modelica.SIunits.Length lengthDisSup_b "Length of district supply pipe";
  parameter Modelica.SIunits.Length lengthDisRet_a "Length of district return pipe";
  parameter Modelica.SIunits.Length lengthConSup "Length of connection supply pipe";
  parameter Modelica.SIunits.Length lengthConRet "Length of connection return pipe";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{66,12},{88,-12}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{66,-48},{88,-72}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-25,8},{25,-8}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={0,45},
          rotation=90),
        Rectangle(
          extent={{-25.5,7.5},{25.5,-7.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={59.5,45.5},
          rotation=90)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Connection1stGen6PipeSections;
