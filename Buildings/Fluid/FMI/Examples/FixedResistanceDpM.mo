within Buildings.Fluid.FMI.Examples;
block FixedResistanceDpM "FMU declaration for a fixed resistance"
   extends Buildings.Fluid.FMI.TwoPortSingleComponent(
     redeclare package Medium = Buildings.Media.Water,
     redeclare final Buildings.Fluid.FixedResistances.FixedResistanceDpM com(
      m_flow_nominal=m_flow_nominal,
      final dp_nominal=dp_nominal));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(start=1)
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_nominal=10 "Pressure";
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{70,68},{90,88}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end FixedResistanceDpM;
