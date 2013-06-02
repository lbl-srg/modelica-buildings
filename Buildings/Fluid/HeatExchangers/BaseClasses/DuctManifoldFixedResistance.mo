within Buildings.Fluid.HeatExchangers.BaseClasses;
model DuctManifoldFixedResistance
  "Manifold for a heat exchanger air duct connection"
  extends PartialDuctManifold;

  parameter Boolean use_dh = false "Set to true to specify hydraulic diameter"
       annotation(Evaluate=true, Dialog(enable = not linearized));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Mass flow rate at port_a"                                 annotation(Dialog(group = "Nominal Condition"));
  parameter Modelica.SIunits.Pressure dp_nominal(min=0) "Pressure"
                                              annotation(Dialog(group = "Nominal Condition"));
  parameter Modelica.SIunits.Length dh=1 "Hydraulic diameter of duct"
        annotation(Dialog(enable= not linearized));
  parameter Real ReC=4000
    "Reynolds number where transition to turbulent starts"
   annotation(Dialog(enable = use_dh and not linearized));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Advanced"));
  parameter Real deltaM(min=0) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Dialog(enable = not use_dh and not linearized));
  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));

  Fluid.FixedResistances.FixedResistanceDpM[nPipPar,nPipSeg] fixRes(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal/nPipPar/nPipSeg,
    each m_flow(start=mStart_flow_a/nPipPar/nPipSeg),
    each dp_nominal=dp_nominal,
    each dh=dh/sqrt(nPipPar*nPipSeg),
    each from_dp=from_dp,
    each deltaM=deltaM,
    each ReC=ReC,
    each use_dh=use_dh,
    each linearized=linearized) "Fixed resistance for each duct"
    annotation (Placement(transformation(extent={{0,-10},{20,10}}, rotation=0)));
  parameter Modelica.SIunits.Length dl = 0.3 "Length of mixing volume";
  Fluid.MixingVolumes.MixingVolume vol(redeclare package Medium = Medium,
    final V=dh*dh*dl,
    final nPorts=1+nPipPar*nPipSeg,
    final energyDynamics=energyDynamics,
    final massDynamics=energyDynamics,
    m_flow_nominal=m_flow_nominal)
                       annotation (Placement(transformation(extent={{-60,0},{
            -40,20}}, rotation=0)));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for volume"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
equation
  for i in 1:nPipPar loop
    for j in 1:nPipSeg loop
      connect(vol.ports[1+(i-1)*nPipSeg+j], fixRes[i, j].port_a)
                                                             annotation (Line(
            points={{-50,0},{-23,0},{0,0}}, color={0,127,255}));
    end for;
  end for;

  connect(port_a, vol.ports[1])
                               annotation (Line(points={{-100,0},{-74,
          -4.87687e-022},{-74,0},{-50,0}},                           color={0,
          127,255}));
  connect(fixRes.port_b, port_b) annotation (Line(points={{20,0},{56,0},{56,0},
          {100,0}},                                            color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
Documentation(info="<html>
<p>
Duct manifold with a fixed flow resistance.
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
September 10, 2008, by Michael Wetter:<br/>
Added additional parameters.
</li>
<li>
August 22, 2008, by Michael Wetter:<br/>
Added start value for resistance mass flow rate.
</li>
<li>
August 21, 2008, by Michael Wetter:<br/>
Added mixing volume to break large nonlinear system of equations in model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilDiscretized\">
Buildings.Fluid.HeatExchangers.DryCoilDiscretized</a>.
</li><li>
April 14, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{28,68},{72,52}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,8},{74,-8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,-52},{74,-68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end DuctManifoldFixedResistance;
