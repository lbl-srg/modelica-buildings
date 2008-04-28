partial model PartialHA 
  "Partial model for convective heat transfer coefficients" 
  extends Buildings.BaseClasses.BaseIcon;
annotation (Diagram,
Documentation(info="<html>
<p>
Partial model for sensible convective heat transfer coefficients.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 16, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
  parameter Modelica.SIunits.ThermalConductance UA0(min=0) 
    "Thermal conductance at nominal flow" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  
  parameter Modelica.SIunits.MassFlowRate m0_flow_w "Water mass flow rate" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m0_flow_a "Air mass flow rate" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  
  Modelica.Blocks.Interfaces.RealSignal m_flow_1(redeclare type SignalType = 
        Modelica.SIunits.MassFlowRate) "Mass flow rate medium 1" 
    annotation (extent=[-120,60; -100,80]);
  Modelica.Blocks.Interfaces.RealSignal m_flow_2(redeclare type SignalType = 
        Modelica.SIunits.MassFlowRate) "Mass flow rate medium 2" 
    annotation (extent=[-120,-80; -100,-60]);
  Modelica.Blocks.Interfaces.RealSignal hA_1(redeclare type SignalType = 
        Modelica.SIunits.ThermalConductance) 
    "Convective heat transfer medium 1" annotation (extent=[100,60; 120,80]);
  Modelica.Blocks.Interfaces.RealSignal hA_2(redeclare type SignalType = 
        Modelica.SIunits.ThermalConductance) 
    "Convective heat transfer medium 2" annotation (extent=[100,-80; 120,-60]);
  Modelica.Blocks.Interfaces.RealSignal T_1(redeclare type SignalType = 
        Modelica.SIunits.Temperature) "Temperature medium 1" 
    annotation (extent=[-120,20; -100,40]);
  Modelica.Blocks.Interfaces.RealSignal T_2(redeclare type SignalType = 
        Modelica.SIunits.Temperature) "Temperature medium 2" 
    annotation (extent=[-120,-40; -100,-20]);
  annotation (Icon(
      Rectangle(extent=[-36,-36; -24,-72],   style(
          color=0,
          fillColor=8,
          fillPattern=8)),
      Line(points=[-12,-52; 26,-52],    style(color=42, fillColor=45)),
      Line(points=[-4,-40; -4,-68],    style(color=69, fillColor=47)),
      Line(points=[-4,-68; -10,-58],    style(color=69, fillColor=47)),
      Line(points=[-4,-68; 2,-58],      style(color=69, fillColor=47)),
      Line(points=[14,-58; 26,-52],    style(color=42, fillColor=45)),
      Line(points=[14,-46; 26,-52],    style(color=42, fillColor=45)),
      Line(points=[16,-40; 16,-68],    style(color=69, fillColor=47)),
      Line(points=[16,-68; 10,-58],     style(color=69, fillColor=47)),
      Line(points=[16,-68; 22,-58],     style(color=69, fillColor=47)),
      Rectangle(extent=[-36,66; -24,30],     style(
          color=0,
          fillColor=8,
          fillPattern=8)),
      Line(points=[-12,50; 26,50],      style(color=42, fillColor=45)),
      Line(points=[-4,62; -4,34],      style(color=69, fillColor=47)),
      Line(points=[-4,34; -10,44],      style(color=69, fillColor=47)),
      Line(points=[-4,34; 2,44],        style(color=69, fillColor=47)),
      Line(points=[14,44; 26,50],      style(color=42, fillColor=45)),
      Line(points=[14,56; 26,50],      style(color=42, fillColor=45)),
      Line(points=[16,62; 16,34],      style(color=69, fillColor=47)),
      Line(points=[16,34; 10,44],       style(color=69, fillColor=47)),
      Line(points=[16,34; 22,44],       style(color=69, fillColor=47))));
end PartialHA;
