model DuctManifoldFixedResistance 
  "Manifold for a heat exchanger air duct connection" 
  extends PartialDuctManifold;
  
  annotation (Diagram,
Documentation(info="<html>
<p>
Duct manifold with a fixed flow resistance.</p>
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
August 21, 2008, by Michael Wetter:<br>
Added mixing volume to break large nonlinear system of equations in model
<a href=\"Modelica:Buildings.HeatExchangers.DryCoilDiscretized\">
Buildings.HeatExchangers.DryCoilDiscretized</a>.
</li><li>
April 14, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
Icon( Rectangle(extent=[28,68; 72,52], style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0})),
      Rectangle(extent=[30,8; 74,-8], style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0})),
      Rectangle(extent=[30,-52; 74,-68], style(
          pattern=0,
          fillColor=0,
          rgbfillColor={0,0,0}))));
  
  parameter Modelica.SIunits.MassFlowRate m0_flow "Mass flow rate at port_a" 
                                                               annotation(Dialog(group = "Nominal Condition"));
  parameter Modelica.SIunits.Pressure dp0(min=0) "Pressure" 
                                              annotation(Dialog(group = "Nominal Condition"));
  parameter Modelica.SIunits.Length dh=1 "Hydraulic diameter for duct";
  parameter Real ReC=4000 "Reynolds number where transition to laminar starts";
  parameter Boolean linearized = false 
    "= true, use linear relation between m_flow and dp for any flow rate" 
    annotation(Dialog(tab="Advanced"));
  
  Fluids.FixedResistances.FixedResistanceDpM[nPipPar,nPipSeg] fixRes(
    redeclare each package Medium = Medium,
    each m0_flow=m0_flow/nPipPar/nPipSeg,
    each m_flow(start=mStart_flow_a/nPipPar/nPipSeg),
    each dp0=dp0,
    each dh=dh/sqrt(nPipPar*nPipSeg),
    each from_dp=false,
    each linearized=linearized) "Fixed resistance for each duct" 
    annotation (extent=[0,-10; 20,10]);
  parameter Modelica.SIunits.Length dl = 0.3 "Length of mixing volume";
  Fluids.MixingVolumes.MixingVolume vol(redeclare package Medium =                       Medium,
    final V=dh*dh*dl,
    final nP=1+nPipPar*nPipSeg,
    final steadyState=steadyState) 
                       annotation (extent=[-56,-10; -36,10]);
  parameter Boolean steadyState=false "Set to true for steady state model";
equation 
  for i in 1:nPipPar loop
    for j in 1:nPipSeg loop
   connect(vol.port[1+(i-1)*nPipSeg+j], fixRes[i, j].port_a) annotation (points=[-46,
            5.55112e-16; -23,5.55112e-16; -23,6.10623e-16; -5.55112e-16,
            6.10623e-16],                                style(color=69,
        rgbcolor={0,127,255}));
    end for;
  end for;
  
  connect(port_a, vol.port[1]) annotation (points=[-100,5.55112e-16; -74,
        -4.87687e-22; -74,5.55112e-16; -46,5.55112e-16],
                                          style(color=69, rgbcolor={0,127,255}));
  connect(fixRes.port_b, port_b) annotation (points=[20,6.10623e-16; 56,
        6.10623e-16; 56,5.55112e-16; 100,5.55112e-16], style(color=69, rgbcolor=
         {0,127,255}));
end DuctManifoldFixedResistance;
