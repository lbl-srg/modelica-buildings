within Buildings.Fluid.Movers;
model FlowMachine_m_flow "Pump or fan with ideally controlled mass flow rate"
  extends Buildings.Fluid.Movers.BaseClasses.FlowMachine(
  final control_m_flow=true,
  final use_m_flow_set=true,
  final use_dp_set=false);
  annotation (defaultComponentName="fan",
  Documentation(
   info="<HTML>
<p>This model describes a centrifugal pump (or a group of <tt>nParallel</tt> pumps) 
   with prescribed mass flow rate, either fixed or provided by an external signal.
   The model is identical to 
   <a href=\"Modelica://Modelica.Fluid.Machines.ControlledPump\">
   Modelica.Fluid.Machines.ControlledPump</a>
   but it defines parameters for easier configuration.
</HTML>",
      revisions="<html>
<ul>
<li>October 1, 2009
    by Michael Wetter:<br>
       Model added to the Buildings library.
</ul>
</html>"));
end FlowMachine_m_flow;
