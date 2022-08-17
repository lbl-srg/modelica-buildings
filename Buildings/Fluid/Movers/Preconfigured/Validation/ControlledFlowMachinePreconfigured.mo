within Buildings.Fluid.Movers.Preconfigured.Validation;
model ControlledFlowMachinePreconfigured
  "Preconfigured fans with different control signals"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Movers.Validation.BaseClasses.ControlledFlowMachine(
    redeclare Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y fan1(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal),
    redeclare Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow fan2(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal),
    redeclare Buildings.Fluid.Movers.Preconfigured.FlowControlled_dp fan3(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal),
    redeclare Buildings.Fluid.Movers.Preconfigured.SpeedControlled_Nrpm fan4(
      redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal,
      speed_rpm_nominal=3580));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=2
    "Nominal mass flow rate for each fan";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=500
    "Nominal pressure head for each fan";

      annotation (
experiment(Tolerance=1e-6, StopTime=600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Preconfigured/Validation/ControlledFlowMachinePreconfigured.mos"
        "Simulate and plot"),
    Documentation(info="<html>
pending
</html>"));
end ControlledFlowMachinePreconfigured;
