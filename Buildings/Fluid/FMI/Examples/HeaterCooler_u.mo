within Buildings.Fluid.FMI.Examples;
block HeaterCooler_u "FMU declaration for an ideal heater or cooler"
   extends Buildings.Fluid.FMI.TwoPortSingleComponent(
     redeclare final package Medium =
        Buildings.Media.GasesConstantDensity.MoistAirUnsaturated,
     redeclare final Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed com(
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=dp_nominal,
      final Q_flow_nominal=Q_flow_nominal,
      final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState));
      // fixme: for Buildings.Media.GasesConstantDensity.MoistAirUnsaturated and
      // dynamic balance with fixed initial values, this model does not translate
      // due to the index reduction requiring derivatives for the inputs.
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
            -100},{100,100}}), graphics),
  Documentation(info="<html>
<p>
This example demonstrates how to export an FMU with a fluid flow component.
The FMU has an instance of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u</a>.
</p>
<p>
In Dymola, to export the model as an FMU,
select from the pull down menu <code>Commands - Export FMU</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 3, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/HeaterCooler_u.mos"
        "Export FMU"));
end HeaterCooler_u;
