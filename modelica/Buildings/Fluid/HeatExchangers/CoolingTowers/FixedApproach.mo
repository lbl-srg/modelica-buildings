within Buildings.Fluid.HeatExchangers.CoolingTowers;
model FixedApproach "Cooling tower with constant approach temperature"
  extends Fluid.Interfaces.PartialStaticTwoPortHeatMassTransfer(sensibleOnly=true,
  final show_T = true);
  extends Buildings.BaseClasses.BaseIcon;
  parameter Modelica.SIunits.TemperatureDifference TApp(min=0, displayUnit="K") = 2
    "Approach temperature difference";
  Modelica.Blocks.Interfaces.RealInput TAir(min=0, unit="K")
    "Entering air dry or wet bulb temperature"
     annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}, rotation=0)));
equation
 Q_flow = m_flow * (Medium.specificEnthalpy(
                       Medium.setState_pTX(
                       p=port_b.p,
                       T=TAir+TApp,
                       X=inStream(port_b.Xi_outflow)))-inStream(port_a.h_outflow));
 // No mass added or remomved from water stream
 mXi_flow     = zeros(Medium.nXi);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Rectangle(
          extent={{-70,86},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,41},{-70,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-104,70},{-70,32}},
          lineColor={0,0,127},
          textString="TAir"),
        Rectangle(
          extent={{-102,5},{99,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                  graphics),
    Documentation(info="<html>
<p>
Model for a steady state cooling tower with constant approach temperature.
</p><p>
By connecting a signal that contains either the dry bulb or the wet bulb
temperature, this model can be used to estimate the water return temperature
from a cooling tower. 
For a more detailed model, use for example the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc\">YorkCalc</a>
model.
</p>
</html>", revisions="<html>
<ul>
<li>
March 8, 2011, by Michael Wetter:<br>
Removed base class and unused variables.
</li>
<li>
April 7, 2009, by Michael Wetter:<br>
Changed interface to new Modelica.Fluid stream concept.
</li>
<li>
May 14, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end FixedApproach;
