model PrescribedExtraPropertyFlowRate 
  "Source with mass flow that does not take part in medium mass balance (such as CO2)" 
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium = 
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source" 
     annotation (choicesAllMatching=true);
  annotation (Documentation(info="<html>
This model adds a mass flow rate to the port for an auxiliary
medium that does not take part in the mass balance of the medium
model. Instead, this mass transfer is tracked separately. A typical
use of this source is to add carbon dioxide to a room, since the 
carbon dioxide concentration is typically so small that it need not be added to the
room mass balance.
</html>", revisions="<html>
<ul>
<li>
September 18, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
  Modelica_Fluid.Interfaces.FluidPort_b port(redeclare package Medium = Medium,
      m_flow(min=-Modelica.Constants.inf, max=0)) 
    annotation (extent=[90,-10; 110,10],    rotation=0);
  
  annotation (Diagram, Icon(
      Rectangle(extent=[20,60; 100,-60],   style(
          color=0,
          gradient=2,
          fillColor=8)),
      Rectangle(extent=[38,40; 100,-40],   style(
          color=69,
          gradient=2,
          fillColor=69)),
      Ellipse(extent=[-100,80; 60,-80], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=7,
          rgbfillColor={255,255,255})),
      Polygon(points=[-60,70; 60,0; -60,-68; -60,70], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=0,
          rgbfillColor={0,0,0})),
      Text(
        extent=[-54,32; 16,-30],
        style(color=41, fillColor=41),
        string="m"),
      Ellipse(extent=[-26,30; -18,22],   style(color=1, fillColor=1)),
      Text(
        extent=[-210,102; -70,70],
        style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=7,
          rgbfillColor={255,255,255}),
        string="m_flow"),
      Text(
        extent=[-100,14; -60,-20],
        style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=7,
          rgbfillColor={255,255,255}),
        string="C")));
  parameter Medium.ExtraPropertyFlowRate mC_flow[Medium.nC] = ones(Medium.nC) 
    "Fixed mass flow rate for extra property going out of the fluid port";
  Modelica.Blocks.Interfaces.RealInput mC_flow_in[Medium.nC](redeclare type 
      SignalType = 
       Medium.ExtraPropertyFlowRate) 
    "Prescribed mass flow rate for extra property" 
    annotation (extent=[-141,-20; -101,20]);
equation 
  if cardinality(mC_flow_in)==0 then
    mC_flow_in = mC_flow;
  end if;
  assert(sum(mC_flow_in) >= 0, "Reverse flow for species source is not implemented yet.");
  port.m_flow = -Modelica.Constants.eps;
  port.C = mC_flow_in/Modelica.Constants.eps;
  port.h = Medium.h_default;
end PrescribedExtraPropertyFlowRate;
