within Buildings.Fluids.HeatExchangers.BaseClasses;
model CoilRegister "Register for a heat exchanger"
  import Modelica.Constants;
  replaceable package Medium_1 = 
      Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component" 
      annotation (choicesAllMatching = true);
  replaceable package Medium_2 = 
      Modelica.Media.Interfaces.PartialMedium "Medium 2 in the component" 
      annotation (choicesAllMatching = true);
  outer Modelica_Fluid.System system "System wide properties";
  annotation (
    Documentation(info="<html>
<p>
Register of a heat exchanger with dynamics on the fluids and the solid. 
The register represents one array of pipes that are perpendicular to the
air stream.
The <tt>hA</tt> value for both fluids is an input.
The driving force for the heat transfer is the temperature difference
between the fluid volumes and the solid in each heat exchanger element.
</p>
<p>
</p>
</html>",
revisions="<html>
<ul>
<li>
August 12, 2008 by Michael Wetter:<br>
Introduced option to compute each medium using a steady state model or
a dynamic model.
</li>
<li>
March 25, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
extent=[-20,80; 0,100], Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
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
    Placement(transformation(extent={{-20,80},{0,100}}, rotation=0)));

  parameter Boolean allowFlowReversal_1 = system.allowFlowReversal
    "= true to allow flow reversal in medium 1, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal_2 = system.allowFlowReversal
    "= true to allow flow reversal in medium 2, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Integer nPipPar(min=1)=2
    "Number of parallel pipes in each register";
  parameter Integer nPipSeg(min=1)=3
    "Number of pipe segments per register used for discretization";
  final parameter Integer nEle = nPipPar * nPipSeg
    "Number of heat exchanger elements";

  Buildings.Fluids.HeatExchangers.BaseClasses.HexElement[
                      nPipPar, nPipSeg] ele(
    redeclare each package Medium_1 = Medium_1,
    redeclare each package Medium_2 = Medium_2,
    each allowFlowReversal_1=allowFlowReversal_1,
    each allowFlowReversal_2=allowFlowReversal_2,
    each tau_1=tau_1/nPipSeg,
    each m0_flow_1=m0_flow_1/nPipPar,
    each tau_2=tau_2,
    each m0_flow_2=m0_flow_2/nPipPar/nPipSeg,
    each tau_m=tau_m,
    each UA0=UA0/nPipPar/nPipSeg,
    each energyDynamics_1=energyDynamics_1,
    each energyDynamics_2=energyDynamics_2,
    each allowCondensation=allowCondensation) "Element of a heat exchanger" 
    annotation (Placement(transformation(extent={{-10,20},{10,40}}, rotation=0)));

  Modelica_Fluid.Interfaces.FluidPort_a[nPipPar] port_a1(
        redeclare each package Medium = Medium_1,
        each m_flow(start=0, min=if allowFlowReversal_1 then -Constants.inf else 0))
    "Fluid connector a for medium 1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}, rotation=
            0)));
  Modelica_Fluid.Interfaces.FluidPort_b[nPipPar] port_b1(
        redeclare each package Medium = Medium_1,
        each m_flow(start=0, max=if allowFlowReversal_1 then +Constants.inf else 0))
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,50},{90,70}}, rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_a[nPipPar,nPipSeg] port_a2(
        redeclare each package Medium = Medium_2,
        each m_flow(start=0, min=if allowFlowReversal_2 then -Constants.inf else 0))
    "Fluid connector a for medium 2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}, rotation=
            0)));
  Modelica_Fluid.Interfaces.FluidPort_b[nPipPar,nPipSeg] port_b2(
        redeclare each package Medium = Medium_2,
        each m_flow(start=0, max=if allowFlowReversal_2 then +Constants.inf else 0))
    "Fluid connector b for medium 2 (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-72},{-110,-52}},
          rotation=0)));

  parameter Modelica.SIunits.ThermalConductance UA0
    "Thermal conductance at nominal flow, used to compute time constant" 
     annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m0_flow_1 "Mass flow rate medim 1" 
  annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m0_flow_2 "Mass flow rate medium 2" 
  annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.Time tau_1=20
    "Time constant at nominal flow for medium 1" 
  annotation(Dialog(group = "Nominal condition", enable=not steadyState_1));
  parameter Modelica.SIunits.Time tau_2=1
    "Time constant at nominal flow for medium 2" 
  annotation(Dialog(group = "Nominal condition", enable=not steadyState_2));
  parameter Boolean steadyState_1=false
    "Set to true for steady state model for fluid 1" 
    annotation (Dialog(group="Fluid 1"));
  parameter Boolean steadyState_2=false
    "Set to true for steady state model for fluid 2" 
    annotation (Dialog(group="Fluid 2"));
  Modelica.SIunits.HeatFlowRate Q_flow_1
    "Heat transfered from solid into medium 1";
  Modelica.SIunits.HeatFlowRate Q_flow_2
    "Heat transfered from solid into medium 2";
  parameter Modelica.SIunits.Time tau_m=60
    "Time constant of metal at nominal UA value" 
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean allowCondensation = true
    "Set to false to compute sensible heat transfer only";
  parameter Modelica_Fluid.Types.Dynamics energyDynamics_1=
    Modelica_Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for volume 1" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Modelica_Fluid.Types.Dynamics energyDynamics_2=
    Modelica_Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for volume 2" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
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
    annotation (Placement(transformation(extent={{-34,48},{-22,62}}, rotation=0)));
  Modelica.Blocks.Math.Gain gai_2(k=1/nEle)
    "Gain medium-side 2 to take discretization into account" 
    annotation (Placement(transformation(extent={{24,-76},{12,-62}}, rotation=0)));
equation
  Q_flow_1 = sum(ele[i,j].Q_flow_1 for i in 1:nPipPar, j in 1:nPipSeg);
  Q_flow_2 = sum(ele[i,j].Q_flow_2 for i in 1:nPipPar, j in 1:nPipSeg);
  for i in 1:nPipPar loop
    // liquid side (pipes)
    connect(ele[i,1].port_a1,       port_a1[i]) 
       annotation (Line(points={{-10,36},{-68,36},{-68,60},{-100,60}}, color={0,
            127,255}));
    connect(ele[i,nPipSeg].port_b1, port_b1[i]) 
       annotation (Line(points={{10,36},{44,36},{44,60},{100,60}}, color={0,127,
            255}));
    for j in 1:nPipSeg-1 loop
      connect(ele[i,j].port_b1, ele[i,j+1].port_a1) 
       annotation (Line(points={{10,36},{10,46},{-10,46},{-10,36}}, color={0,
              127,255}));
    end for;
    // gas side (duct)                                                                                      //water connections
    for j in 1:nPipSeg loop
      connect(ele[i,j].port_a2, port_a2[i,j]) 
       annotation (Line(points={{10,24},{40,24},{40,-60},{100,-60}}, color={0,
              127,255}));
      connect(ele[i,j].port_b2, port_b2[i,j]) 
       annotation (Line(points={{-10,24},{-68,24},{-68,-62},{-100,-62}}, color=
              {0,127,255}));
    end for;
  end for;

  connect(Gc_1, gai_1.u)  annotation (Line(points={{-40,100},{-40,55},{-35.2,55}},
        color={0,0,127}));
  connect(Gc_2, gai_2.u)  annotation (Line(points={{40,-100},{40,-69},{25.2,-69}},
        color={0,0,127}));
  for i in 1:nPipPar loop

     for j in 1:nPipSeg loop
      connect(gai_1.y, ele[i,j].Gc_1)  annotation (Line(points={{-21.4,55},{-4,
              55},{-4,40}}, color={0,0,127}));
      connect(gai_2.y, ele[i,j].Gc_2)  annotation (Line(points={{11.4,-69},{4,
              -69},{4,20}}, color={0,0,127}));
     end for;
  end for;

end CoilRegister;
