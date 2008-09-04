model PipeManifoldFixedResistance 
  "Pipe manifold for a heat exchanger connection" 
  extends PartialPipeManifold;
annotation (Diagram,
Documentation(info="<html>
<p>
Pipe manifold with a fixed flow resistance.</p>
</p>
<p>
This model causes the flow to be distributed equally
into each flow path by using a fixed flow resistance
for each flow path.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 22, 2008, by Michael Wetter:<br>
Added start value for resistance mass flow rate.
</li>
<li>
April 14, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
Icon( Rectangle(extent=[30,68; 74,52], style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0})),
      Rectangle(extent=[32,8; 76,-8], style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0})),
      Rectangle(extent=[32,-52; 76,-68], style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0}))));
  
  parameter Modelica.SIunits.MassFlowRate m0_flow "Mass flow rate at port_a" 
                                                               annotation(Dialog(group = "Nominal Condition"));
  parameter Modelica.SIunits.Pressure dp0(min=0) "Pressure" 
                                              annotation(Dialog(group = "Nominal Condition"));
  parameter Modelica.SIunits.Length dh=1 "Hydraulic diameter for each pipe";
  parameter Real ReC=4000 "Reynolds number where transition to laminar starts";
  parameter Boolean linearized = false 
    "= true, use linear relation between m_flow and dp for any flow rate" 
    annotation(Dialog(tab="Advanced"));
  
  Fluids.FixedResistances.FixedResistanceDpM[nPipPar] fixRes(
    redeclare each package Medium = Medium,
    each m0_flow=m0_flow/nPipPar,
    each m_flow(start=mStart_flow_a),
    each dp0=dp0,
    each dh=dh,
    each from_dp=false,
    each linearized=linearized) "Fixed resistance for each duct" 
    annotation (extent=[-12,-10; 8,10]);
equation 
  for i in 1:nPipPar loop
    connect(port_a, fixRes[i].port_a) annotation (points=[-100,5.55112e-16; -56,
          5.55112e-16; -56,6.10623e-16; -12,6.10623e-16], style(color=69,
          rgbcolor={0,127,255}));
    connect(fixRes[i].port_b, port_b[i]) annotation (points=[8,6.10623e-16; 52,
          6.10623e-16; 52,5.55112e-16; 100,5.55112e-16],
                                     style(color=69, rgbcolor={0,127,255}));
  end for;
end PipeManifoldFixedResistance;
