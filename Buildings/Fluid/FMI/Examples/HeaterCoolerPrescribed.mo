within Buildings.Fluid.FMI.Examples;
block HeaterCoolerPrescribed "FMU declaration for an ideal heater or cooler"
   extends Buildings.Fluid.FMI.TwoPortSingleComponent(
     redeclare package Medium = Buildings.Media.ConstantPropertyLiquidWater,
     redeclare final Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed com(
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal,
      Q_flow_nominal=Q_flow_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_nominal=10 "Pressure";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 1000
    "Heat flow rate at u=1, positive for heating";
  Modelica.Blocks.Interfaces.RealInput u(min=0, max=1, unit="1")
    "Control input"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
equation
  connect(com.u, u) annotation (Line(
      points={{-12,6},{-40,6},{-40,60},{-120,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end HeaterCoolerPrescribed;
