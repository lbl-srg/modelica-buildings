within Buildings.Fluid.FMI.Examples;
block FlowMachine_m_flow "FMU declaration for a fixed resistance"
   extends Buildings.Fluid.FMI.TwoPortSingleComponent(
     redeclare final package Medium =
        Buildings.Media.GasesConstantDensity.MoistAirUnsaturated,
     redeclare final Movers.FlowMachine_m_flow com(filteredSpeed=false,
      final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      final tau=0,
      final dynamicBalance=false));
        // fixme: This model is structurally singular.
        // Probably because there is no equation that links
        // the pressures of the two ports.
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(start=1) = 1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_nominal=10
    "Pressure drop at nominal mass flow rate";

  Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s",
                                                 nominal=m_flow_nominal)
    "Prescribed mass flow rate"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}),   iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-2,120})));

equation
  connect(com.m_flow_in, m_flow_in) annotation (Line(
      points={{-0.2,12},{-0.2,56},{0,56},{0,120}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Documentation(info="<html>
<p>
This example demonstrates how to export an FMU with a fluid flow component.
The FMU has an instance of
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_m_flow\">
Buildings.Fluid.Movers.FlowMachine_m_flow</a>.
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FlowMachine_m_flow.mos"
        "Export FMU"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end FlowMachine_m_flow;
