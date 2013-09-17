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
  outer Modelica.Fluid.System system "System wide properties";

  parameter Boolean allowFlowReversal1 = system.allowFlowReversal
    "= true to allow flow reversal in medium 1, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversal2 = system.allowFlowReversal
    "= true to allow flow reversal in medium 2, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Integer nPipPar(min=1)=2
    "Number of parallel pipes in each register";
  parameter Integer nPipSeg(min=1)=3
    "Number of pipe segments per register used for discretization";
  final parameter Integer nEle = nPipPar * nPipSeg
    "Number of heat exchanger elements";

  replaceable Buildings.Fluid.HeatExchangers.BaseClasses.HexElementSensible ele[nPipPar, nPipSeg]
    constrainedby Buildings.Fluid.HeatExchangers.BaseClasses.PartialHexElement(
    redeclare each package Medium1 = Medium1,
    redeclare each package Medium2 = Medium2,
    each allowFlowReversal1=allowFlowReversal1,
    each allowFlowReversal2=allowFlowReversal2,
    each tau1=tau1/nPipSeg,
    each m1_flow_nominal=m1_flow_nominal/nPipPar,
    each tau2=tau2,
    each m2_flow_nominal=m2_flow_nominal/nPipPar/nPipSeg,
    each tau_m=tau_m,
    each UA_nominal=UA_nominal/nPipPar/nPipSeg,
    each energyDynamics1=energyDynamics1,
    each energyDynamics2=energyDynamics2,
    each from_dp1=from_dp1,
    each linearizeFlowResistance1=linearizeFlowResistance1,
    each deltaM1=deltaM1,
    each from_dp2=from_dp2,
    each linearizeFlowResistance2=linearizeFlowResistance2,
    each deltaM2=deltaM2,
    each dp1_nominal=dp1_nominal,
    each dp2_nominal=dp2_nominal) "Element of a heat exchanger"
    annotation (Placement(transformation(extent={{-10,20},{10,40}}, rotation=0)));

  Modelica.Fluid.Interfaces.FluidPort_a[nPipPar] port_a1(
        redeclare each package Medium = Medium1,
        each m_flow(start=0, min=if allowFlowReversal1 then -Constants.inf else 0))
    "Fluid connector a for medium 1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}, rotation=
            0)));
  Modelica.Fluid.Interfaces.FluidPort_b[nPipPar] port_b1(
        redeclare each package Medium = Medium1,
        each m_flow(start=0, max=if allowFlowReversal1 then +Constants.inf else 0))
    "Fluid connector b for medium 1 (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,50},{90,70}}, rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_a[nPipPar,nPipSeg] port_a2(
        redeclare each package Medium = Medium2,
        each m_flow(start=0, min=if allowFlowReversal2 then -Constants.inf else 0))
    "Fluid connector a for medium 2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}, rotation=
            0)));
  Modelica.Fluid.Interfaces.FluidPort_b[nPipPar,nPipSeg] port_b2(
        redeclare each package Medium = Medium2,
        each m_flow(start=0, max=if allowFlowReversal2 then +Constants.inf else 0))
    "Fluid connector b for medium 2 (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-72},{-110,-52}},
          rotation=0)));

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
  annotation(Dialog(group = "Nominal condition", enable=not steadyState_1));
  parameter Modelica.SIunits.Time tau2=1
    "Time constant at nominal flow for medium 2"
  annotation(Dialog(group = "Nominal condition", enable=not steadyState_2));
  parameter Boolean steadyState_1=false
    "Set to true for steady state model for fluid 1"
    annotation (Dialog(group="Fluid 1"));
  parameter Boolean steadyState_2=false
    "Set to true for steady state model for fluid 2"
    annotation (Dialog(group="Fluid 2"));
  Modelica.SIunits.HeatFlowRate Q1_flow
    "Heat transfered from solid into medium 1";
  Modelica.SIunits.HeatFlowRate Q2_flow
    "Heat transfered from solid into medium 2";
  parameter Modelica.SIunits.Time tau_m=60
    "Time constant of metal at nominal UA value"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics1=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for volume 1"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics2=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for volume 2"
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
    annotation (Placement(transformation(extent={{-34,48},{-22,62}}, rotation=0)));
  Modelica.Blocks.Math.Gain gai_2(k=1/nEle)
    "Gain medium-side 2 to take discretization into account"
    annotation (Placement(transformation(extent={{24,-76},{12,-62}}, rotation=0)));
equation
  Q1_flow = sum(ele[i,j].Q1_flow for i in 1:nPipPar, j in 1:nPipSeg);
  Q2_flow = sum(ele[i,j].Q2_flow for i in 1:nPipPar, j in 1:nPipSeg);
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
extent=[-20,80; 0,100], Diagram(coordinateSystem(preserveAspectRatio=true,
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
end CoilRegister;
