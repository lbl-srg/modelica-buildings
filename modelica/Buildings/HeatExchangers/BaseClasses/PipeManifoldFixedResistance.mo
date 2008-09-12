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
September 10, 2008, by Michael Wetter:<br>
Added additional parameters.
</li>
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
  
  parameter Boolean use_dh = false "Set to true to specify hydraulic diameter" 
       annotation(Evaluate=true, Dialog(enable = not linearized));
  parameter Modelica.SIunits.Length dh=0.025 "Hydraulic diameter for each pipe"
        annotation(Dialog(enable = use_dh and not linearized));
  parameter Real ReC=4000 "Reynolds number where transition to laminar starts" 
   annotation(Dialog(enable = use_dh and not linearized));
  parameter Boolean linearized = false 
    "= true, use linear relation between m_flow and dp for any flow rate" 
    annotation(Dialog(tab="Advanced"));
  parameter Real deltaM(min=0) = 0.3 
    "Fraction of nominal mass flow rate where transition to laminar occurs" 
       annotation(Dialog(enable = not use_dh and not linearized));
  parameter Boolean from_dp = false 
    "= true, use m_flow = f(dp) else dp = f(m_flow)" 
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  
  Fluids.FixedResistances.FixedResistanceDpM[nPipPar] fixRes(
    redeclare each package Medium = Medium,
    each m0_flow=m0_flow/nPipPar,
    each m_flow(start=mStart_flow_a),
    each dp0=dp0,
    each dh=dh,
    each from_dp=from_dp,
    each deltaM=deltaM,
    each ReC=ReC,
    each use_dh=use_dh,
    each linearized=linearized) "Fixed resistance for each duct" 
    annotation (extent=[-10,-10; 10,10]);
equation 
  for i in 1:nPipPar loop
    connect(port_a, fixRes[i].port_a) annotation (points=[-100,5.55112e-16; -56,
          5.55112e-16; -56,6.10623e-16; -10,6.10623e-16], style(color=69,
          rgbcolor={0,127,255}));
    connect(fixRes[i].port_b, port_b[i]) annotation (points=[10,6.10623e-16; 52,
          6.10623e-16; 52,5.55112e-16; 100,5.55112e-16],
                                     style(color=69, rgbcolor={0,127,255}));
  end for;
end PipeManifoldFixedResistance;
