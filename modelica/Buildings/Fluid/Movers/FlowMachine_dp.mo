within Buildings.Fluid.Movers;
model FlowMachine_dp "Pump or fan with ideally controlled pressure difference"
  extends Buildings.Fluid.Movers.BaseClasses.FlowMachine(
  final control_m_flow = false,
  final use_dp_set=true,
  final use_m_flow_set=false);
  annotation (defaultComponentName="fan",
  Documentation(info="<HTML>
<p>This model describes a centrifugal pump (or a group of <tt>nParallel</tt> pumps) 
   with prescribed pressure difference across the ports, either fixed or provided by an external signal.
   The model is identical to 
   <a href=\"Modelica:Modelica.Fluid.Machines.ControlledPump\">
   Modelica:Modelica.Fluid.Machines.ControlledPump</a>
   but it defines parameters for easier configuration, and input is the pressure
<it>difference</it> between the ports, and not the pressure at the <code>port_b</code>.
</HTML>",
      revisions="<html>
<ul>
<li>October 1, 2009
    by Michael Wetter:<br>
       Model added to the Buildings library.
</ul>
</html>"));
end FlowMachine_dp;
