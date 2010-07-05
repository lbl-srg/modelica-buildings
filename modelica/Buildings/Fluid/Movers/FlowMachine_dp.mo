within Buildings.Fluid.Movers;
model FlowMachine_dp
  "Fan or pump with ideally controlled head dp as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.ControlledFlowMachine(
  final control_m_flow = false);
equation
  assert(dp_in >= -0.1,
    "dp_in cannot be negative. Obtained dp_in = " + realString(dp_in));

  annotation (defaultComponentName="fan",
  Documentation(info="<HTML>
<p>
This model describes a fan or pump with prescribed head.
The input connector provides the difference between 
outlet minus inlet pressure.
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
<li>July 5, 2010, by Michael Wetter:<br>
Changed <code>assert(dp_in >= 0, ...)</code> to <code>assert(dp_in >= -0.1, ...)</code>.
The former implementation triggered the assert if <code>dp_in</code> was solved for
in a nonlinear equation since the solution can be slightly negative while still being
within the solver tolerance.
</li>
<li>March 24, 2010, by Michael Wetter:<br>
Revised implementation to allow zero flow rate.
</li>
<li>October 1, 2009,
    by Michael Wetter:<br>
       Added model to the Buildings library.
</ul>
</html>"),
    Icon(graphics={Text(extent={{-56,114},{28,80}}, textString="dp_in")}));
end FlowMachine_dp;
