within Buildings.Fluid.HeatExchangers.BaseClasses;
model CoilRegister "Register for a heat exchanger"
  import Modelica.Constants;
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
     final computeFlowResistance1=true, final computeFlowResistance2=true);
  replaceable package Medium1 =
      Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component"
      annotation (choicesAllMatching = true);
  replaceable package Medium2 =
      Modelica.Media.Interfaces.PartialMedium "Medium 2 in the component"
      annotation (choicesAllMatching = true);

  parameter Boolean initialize_p1 = not Medium1.singleState
    "Set to true to initialize the pressure of volume 1"
    annotation(HideResult=true, Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean initialize_p2 = not Medium2.singleState
    "Set to true to initialize the pressure of volume 2"
    annotation(HideResult=true, Evaluate=true, Dialog(tab="Advanced"));

  parameter Integer nPipPar(min=1)=2
    "Number of parallel pipes in each register";
  parameter Integer nPipSeg(min=1)=3
    "Number of pipe segments per register used for discretization";
  final parameter Integer nEle = nPipPar * nPipSeg
    "Number of heat exchanger elements";

  parameter Modelica.SIunits.ThermalConductance UA_nominal
    "Thermal conductance at nominal flow, used to compute time constant"
     annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
    "Mass flow rate medim 1"
  annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
    "Mass flow rate medium 2"
  annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.Time tau1=20
    "Time constant at nominal flow for medium 1"
  annotation(Dialog(group = "Nominal condition", enable=not (energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Time tau2=1
    "Time constant at nominal flow for medium 2"
  annotation(Dialog(group = "Nominal condition", enable=not (energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState)));

  parameter Boolean allowFlowReversal1 = true
    "= true to allow flow reversal in medium 1, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal2 = true
    "= true to allow flow reversal in medium 2, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  replaceable Buildings.Fluid.HeatExchangers.BaseClasses.HexElementSensible ele[nPipPar, nPipSeg]
    constrainedby Buildings.Fluid.HeatExchangers.BaseClasses.PartialHexElement(
    redeclare each package Medium1 = Medium1,
    redeclare each package Medium2 = Medium2,
    initialize_p1 = {{(i == 1 and j == 1 and initialize_p1) for i in 1:nPipSeg} for j in 1:nPipPar},
    initialize_p2 = {{(i == 1 and j == 1 and initialize_p2) for i in 1:nPipSeg} for j in 1:nPipPar},
    each allowFlowReversal1=allowFlowReversal1,
    each allowFlowReversal2=allowFlowReversal2,
    each tau1=tau1/nPipSeg,
    each m1_flow_nominal=m1_flow_nominal/nPipPar,
    each tau2=tau2,
    each m2_flow_nominal=m2_flow_nominal/nPipPar/nPipSeg,
    each tau_m=tau_m,
    each UA_nominal=UA_nominal/nPipPar/nPipSeg,
    each energyDynamics=energyDynamics,
    each from_dp1=from_dp1,
    each linearizeFlowResistance1=linearizeFlowResistance1,
    each deltaM1=deltaM1,
    each from_dp2=from_dp2,
    each linearizeFlowResistance2=linearizeFlowResistance2,
    each deltaM2=deltaM2,
    each dp1_nominal=dp1_nominal,
    each dp2_nominal=dp2_nominal) "Element of a heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a[nPipPar] port_a1(
        redeclare each package Medium = Medium1,
        each m_flow(start=0, min=if allowFlowReversal1 then -Constants.inf else 0))
    "Fluid connector a for medium 1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b[nPipPar] port_b1(
        redeclare each package Medium = Medium1,
        each m_flow(start=0, max=if allowFlowReversal1 then +Constants.inf else 0))
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,50},{90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a[nPipPar,nPipSeg] port_a2(
        redeclare each package Medium = Medium2,
        each m_flow(start=0, min=if allowFlowReversal2 then -Constants.inf else 0))
    "Fluid connector a for medium 2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b[nPipPar,nPipSeg] port_b2(
        redeclare each package Medium = Medium2,
        each m_flow(start=0, max=if allowFlowReversal2 then +Constants.inf else 0))
    "Fluid connector b for medium 2 (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-72},{-110,-52}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPor1[nPipPar, nPipSeg]
    "Heat port for heat exchange with the control volume 1"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPor2[nPipPar, nPipSeg]
    "Heat port for heat exchange with the control volume 2"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  Modelica.SIunits.HeatFlowRate Q1_flow
    "Heat transferred from solid into medium 1";
  Modelica.SIunits.HeatFlowRate Q2_flow
    "Heat transferred from solid into medium 2";
  parameter Modelica.SIunits.Time tau_m=60
    "Time constant of metal at nominal UA value"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  Modelica.Blocks.Interfaces.RealInput Gc_2
    "Signal representing the convective thermal conductance medium 2 in [W/K]"
    annotation (Placement(transformation(
        origin={40,-100},
        extent={{-20,-20},{20,20}},
        rotation=90)));
  Modelica.Blocks.Interfaces.RealInput Gc_1
    "Signal representing the convective thermal conductance medium 1 in [W/K]"
    annotation (Placement(transformation(
        origin={-40,100},
        extent={{-20,-20},{20,20}},
        rotation=270)));
protected
  Modelica.Blocks.Math.Gain gai_1(k=1/nEle)
    "Gain medium-side 1 to take discretization into account"
    annotation (Placement(transformation(extent={{-34,18},{-22,32}})));
  Modelica.Blocks.Math.Gain gai_2(k=1/nEle)
    "Gain medium-side 2 to take discretization into account"
    annotation (Placement(transformation(extent={{36,-76},{24,-62}})));

equation
  // As OpenModelica does not support multiple iterators as of August 2014, we
  // use here two sum(.) functions
  Q1_flow = sum(sum(ele[i,j].Q1_flow for i in 1:nPipPar) for j in 1:nPipSeg);
  Q2_flow = sum(sum(ele[i,j].Q2_flow for i in 1:nPipPar) for j in 1:nPipSeg);
  for i in 1:nPipPar loop
    connect(ele[i,1].port_a1,       port_a1[i])
       annotation (Line(points={{-10,6},{-68,6},{-68,60},{-100,60}},   color={0,
            127,255}));
    connect(ele[i,nPipSeg].port_b1, port_b1[i])
       annotation (Line(points={{10,6},{44,6},{44,60},{100,60}},   color={0,127,
            255}));
    for j in 1:nPipSeg-1 loop
      connect(ele[i,j].port_b1, ele[i,j+1].port_a1)
       annotation (Line(points={{10,6},{10,16},{-10,16},{-10,6}},   color={0,
              127,255}));
    end for;

    for j in 1:nPipSeg loop
      connect(ele[i,j].port_a2, port_a2[i,j])
       annotation (Line(points={{10,-6},{40,-6},{40,-60},{100,-60}}, color={0,
              127,255}));
      connect(ele[i,j].port_b2, port_b2[i,j])
       annotation (Line(points={{-10,-6},{-68,-6},{-68,-62},{-100,-62}}, color=
              {0,127,255}));
    end for;
  end for;

  connect(Gc_1, gai_1.u)  annotation (Line(points={{-40,100},{-40,25},{-35.2,25}},
        color={0,0,127}));
  connect(Gc_2, gai_2.u)  annotation (Line(points={{40,-100},{40,-69},{37.2,-69}},
        color={0,0,127}));
  for i in 1:nPipPar loop

     for j in 1:nPipSeg loop
      connect(gai_1.y, ele[i,j].Gc_1)  annotation (Line(points={{-21.4,25},{-4,25},
              {-4,10}},     color={0,0,127}));
      connect(gai_2.y, ele[i,j].Gc_2)  annotation (Line(points={{23.4,-69},{20,-69},
              {20,-68},{20,-18},{4,-18},{4,-10}},
                            color={0,0,127}));
     end for;
  end for;

  connect(ele.heaPor1, heaPor1)
    annotation (Line(points={{0,10},{0,100}}, color={191,0,0}));
  connect(ele.heaPor2, heaPor2)
    annotation (Line(points={{0,-10},{0,-100}}, color={191,0,0}));
  annotation (
    Documentation(info="<html>
<p>
Register of a heat exchanger with dynamics on the fluids and the solid.
The register represents one array of pipes that are perpendicular to the
air stream.
The <i>hA</i> value for both fluids is an input.
The driving force for the heat transfer is the temperature difference
between the fluid volumes and the solid in each heat exchanger element.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 19, 2017, by Michael Wetter:<br/>
Changed initialization of pressure from a <code>constant</code> to a <code>parameter</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1013\">Buildings, issue 1013</a>.
</li>
<li>
February 5, 2015, by Michael Wetter:<br/>
Changed <code>initalize_p</code> from a <code>parameter</code> to a
<code>constant</code>. This is only required in finite volume models
of heat exchangers (to avoid consistent but redundant initial conditions)
and hence it should be set as a <code>constant</code>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
August 10, 2014, by Michael Wetter:<br/>
Reformulated the multiple iterators in the <code>sum</code> function
as this language construct is not supported in OpenModelica.
</li>
<li>
July 3, 2014, by Michael Wetter:<br/>
Added parameters <code>initialize_p1</code> and <code>initialize_p2</code>.
This is required to enable the coil models to initialize the pressure in the
first volume, but not in the downstream volumes. Otherwise,
the initial equations will be overdetermined, but consistent.
This change was done to avoid a long information message that appears
when translating models.
</li>
<li>
June 26, 2014, by Michael Wetter:<br/>
Removed parameters <code>energyDynamics1</code> and <code>energyDynamics2</code>,
and used instead of these two parameters the new parameter <code>energyDynamics</code>.
Removed parameters <code>steadyState_1</code> and <code>steadyState_2</code>.
This was done as this complexity is not required.
</li>
<li>
August 12, 2008 by Michael Wetter:<br/>
Introduced option to compute each medium using a steady state model or
a dynamic model.
</li>
<li>
March 25, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
extent={{-20,80},{ 0,100}},    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,65},{101,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,80},{40,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,80},{-36,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,80},{2,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,4},{70,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{62,-94},{88,-122}},
          lineColor={0,0,255},
          textString="h"),
        Text(
          extent={{-80,112},{-58,84}},
          lineColor={0,0,255},
          textString="h")}),
    Placement(transformation(extent={{-20,80},{0,100}})));
end CoilRegister;
