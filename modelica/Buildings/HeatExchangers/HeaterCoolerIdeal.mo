model HeaterCoolerIdeal 
  "Ideal electric heater or cooler, no losses, no dynamics" 
  extends Fluids.Interfaces.PartialStaticTwoPortHeatMassTransfer;
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Icon(
      Rectangle(extent=[-70,80; 70,-80], style(
          pattern=0,
          fillColor=10,
          rgbfillColor={95,95,95})),
      Rectangle(extent=[-102,5; 99,-5],   style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0},
          fillPattern=1)),
      Text(
        extent=[-56,-12; 54,-72],
        style(color=3, rgbcolor={0,0,255}),
        string="Q=%Q0_flow"),
      Rectangle(extent=[-100,61; -70,58], style(
          color=3,
          rgbcolor={0,0,255},
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Text(
        extent=[-122,106; -78,78],
        style(color=3, rgbcolor={0,0,255}),
        string="u")),
Documentation(info="<html>
<p>
Model for an ideal heater or cooler.
</p>
<p>
This model adds heat in the amount of <tt>Q_flow = u Q0_flow</tt> to the medium.
The input signal <tt>u</tt> and the nominal heat flow rate <tt>Q0_flow</tt> 
can be positive or negative.
</p>
<p>
Note that if the mass flow rate tends to zero, the temperature difference over this 
component tends to infinity for non-zero <tt>Q_flow</tt>, so add proper control
when using this component.
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
  
  parameter Modelica.SIunits.HeatFlowRate Q0_flow 
    "Heat flow rate at u=1, positive for heating";
  Modelica.Blocks.Interfaces.RealInput u annotation (extent=[-140,40; -100,80]);
equation 
  dp = 0;
  Q_flow = Q0_flow * u;
  mXi_flow = zeros(Medium.nXi); // no mass added or removed (sensible heat only)
end HeaterCoolerIdeal;
