within Buildings.Fluid.Movers;
model FlowMachine_m_flow
  "Fan or pump with ideally controlled mass flow rate as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.ControlledFlowMachine(
  final control_m_flow=true);
  annotation (defaultComponentName="fan",
  Documentation(
   info="<HTML>
<p>
This model describes a fan or pump with prescribed mass flow rate.
The efficiency of the device is computed based
on the efficiency curves that take as an argument
the actual volume flow rate divided by the maximum possible volume flow rate.
</p>
<p>
See the 
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
User's Guide</a> for more information.
</p>
</HTML>",
      revisions="<html>
<ul>
<li>
July 27, 2010, by Michael Wetter:<br>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24, 2010, by Michael Wetter:<br>
Revised implementation to allow zero flow rate.
</li>
<li>October 1, 2009
    by Michael Wetter:<br>
       Model added to the Buildings library.
</ul>
</html>"),
    Icon(graphics={Text(extent={{-24,114},{68,70}}, textString="m_flow_in")}));
end FlowMachine_m_flow;
