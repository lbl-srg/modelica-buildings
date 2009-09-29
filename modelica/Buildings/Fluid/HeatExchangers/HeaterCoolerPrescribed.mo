within Buildings.Fluid.HeatExchangers;
model HeaterCoolerPrescribed "Heater or cooler with prescribed heat flow rate"
  extends Fluid.Interfaces.PartialStaticTwoPortHeatMassTransfer;
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,5},{99,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,-12},{54,-72}},
          lineColor={0,0,255},
          textString="Q=%Q_flow_nominal"),
        Rectangle(
          extent={{-100,61},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-122,106},{-78,78}},
          lineColor={0,0,255},
          textString="u")}),
Documentation(info="<html>
<p>
Model for an ideal heater or cooler with prescribed heat flow rate to the medium.
</p>
<p>
This model adds heat in the amount of <tt>Q_flow = u Q_flow_nominal</tt> to the medium.
The input signal <tt>u</tt> and the nominal heat flow rate <tt>Q_flow_nominal</tt> 
can be positive or negative.
</p>
<p>
Note that for non-zero <tt>Q_flow</tt>,
if the mass flow rate tends to zero, the temperature difference over this 
component tends to infinity.
Hence, using a proper control for <tt>u</tt> is essential when using this component.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 17, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Heat flow rate at u=1, positive for heating";
  Modelica.Blocks.Interfaces.RealInput u "Control input" 
    annotation (Placement(transformation(
          extent={{-140,40},{-100,80}}, rotation=0)));
equation
  Q_flow = Q_flow_nominal * u;
  mXi_flow = zeros(Medium.nXi); // no mass added or removed (sensible heat only)
end HeaterCoolerPrescribed;
