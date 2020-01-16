within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model HydraulicHeader "Hydraulic header manifold."
 replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;

 parameter Modelica.SIunits.MassFlowRate m_flow_nominal
   "Nominal mass flow rate";
 parameter Integer nPorts_a=1
  "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
 parameter Integer nPorts_b=1
  "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
 Fluid.FixedResistances.LosslessPipe pip(redeclare package Medium = Medium,
     m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
 Modelica.Fluid.Interfaces.FluidPorts_a ports_a[nPorts_a](redeclare package
      Medium =Medium)
    annotation (Placement(
       transformation(extent={{-108,-40},{-88,40}}),iconTransformation(extent={{-4,-15},
            {4,15}},
       rotation=180,
       origin={-102,-3})));
 Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nPorts_b](redeclare package
      Medium =Medium)
    annotation (Placement(
       transformation(extent={{88,-40},{108,40}}),iconTransformation(extent={{-4,-15},
            {4,15}},
       rotation=0,
       origin={104,1})));

equation
  if nPorts_b> 1 then
    for i in 1:nPorts_b loop
      connect(pip.port_a, ports_b[nPorts_b])
    annotation (Line(points={{10,0},{98,0}},color={0,127,255}));
    end for;
  end if;
  if nPorts_a> 1 then
    for i in 1:nPorts_a loop
      connect(pip.port_b, ports_a[nPorts_a])
    annotation (Line(points={{-10,0},{-98,0}},color={0,127,255}));
    end for;
  end if;

  connect(pip.port_b, ports_a[1])
    annotation (Line(points={{-10,0},{-98,0}},  color={0,127,255}));
  connect(pip.port_a, ports_b[1])
    annotation (Line(points={{10,0},{98,0}}, color={0,127,255}));

    annotation (Icon(graphics={
       Rectangle(
         extent={{-92,8},{88,-6}},
         lineColor={255,170,255},
         lineThickness=0.5,
         fillColor={255,255,170},
         fillPattern=FillPattern.Solid),
       Rectangle(
         extent={{-98,20},{-86,-20}},
         lineColor={217,67,180},
         lineThickness=0.5,
         fillColor={255,170,213},
         fillPattern=FillPattern.Solid),
       Rectangle(
         extent={{88,20},{100,-20}},
         lineColor={217,67,180},
         lineThickness=0.5,
         fillColor={255,170,213},
         fillPattern=FillPattern.Solid),
                                Text(
         extent={{-149,93},{151,53}},
         lineColor={0,0,255},
         fillPattern=FillPattern.HorizontalCylinder,
         fillColor={0,127,255},
         textString="%name")}),
         defaultComponentName="hydHea",
Documentation(info="<html>
 <h4> Water hydraulic header </h4>
 <p>
 The model represents a header or a common pipe which hydraulically decouples
 different connected components at the system such as the EIR chiller and  stratified tanks, etc. 
</p>

</html>", revisions="<html>
<ul>
<li>
September 10, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end HydraulicHeader;
