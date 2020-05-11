within Buildings.Applications.DHC.Networks;
model Connection1stGen2PipeSections
  "Connection for a first generation DHC network with 2 pipe sections"
  extends
    Buildings.Applications.DHC.Networks.BaseClasses.PartialConnection2Pipe2Medium(
    redeclare model Model_pip_aDisSup = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsSup,
      lambdaIns=lambdaIns,
      length=lengthDisSup),
    redeclare model Model_pip_bDisRet = Buildings.Fluid.FixedResistances.Pipe (
      thicknessIns=thicknessInsSup,
      lambdaIns=lambdaIns,
      length=lengthDisSup),
    redeclare final model Model_pip_bDisSup =
        Fluid.Interfaces.PartialTwoPortInterface,
    redeclare final model Model_pip_aDisRet =
        Fluid.Interfaces.PartialTwoPortInterface,
    redeclare final model Model_pipConSup =
        Fluid.Interfaces.PartialTwoPortInterface,
    redeclare final model Model_pipConRet =
        Fluid.Interfaces.PartialTwoPortInterface);

  parameter Integer nSeg "Number of volume segments";
  parameter Modelica.SIunits.Length thicknessInsSup
    "Thickness of insulation on supply pipes";
  parameter Modelica.SIunits.Length thicknessInsRet
    "Thickness of insulation on return pipes";
  parameter Modelica.SIunits.ThermalConductivity lambdaIns
    "Heat conductivity of insulation";

  parameter Modelica.SIunits.Length lengthDisSup "Length of connection supply pipe";
  parameter Modelica.SIunits.Length lengthDisRet "Length of connection return pipe";

equation
  connect(pip_bDisSup.port_a, pip_bDisSup.port_b)
    annotation (Line(points={{60,-40},{80,-40}}, color={0,127,255}));
  connect(pip_aDisRet.port_b, pip_aDisRet.port_a)
    annotation (Line(points={{60,-80},{80,-80}}, color={0,127,255}));
  connect(pipConSup.port_a, pipConSup.port_b)
    annotation (Line(points={{-20,-20},{-20,0},{-20,0}}, color={0,127,255}));
  connect(pipConRet.port_b, pipConRet.port_a)
    annotation (Line(points={{20,-20},{20,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Connection1stGen2PipeSections;
