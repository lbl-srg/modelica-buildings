within Buildings.Fluid.FixedResistances.BaseClasses;
model PartialPipe
  "A partial model of a thermal hydraulics pipe with 1D-discretization"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model within the pipe" annotation (choicesAllMatching=true);
  parameter Integer nSeg(min=2) = 2 "Number of volume segments";
  parameter Modelica.SIunits.Length thicknessIns "Thickness of insulation";
  parameter Modelica.SIunits.ThermalConductivity lambdaIns
    "Heat conductivity of insulation";
  parameter Modelica.SIunits.Length diameter
    "Pipe diameter (without insulation)";
  parameter Modelica.SIunits.Length length "Length of the pipe";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    annotation (Dialog(group="Nominal condition"));

  Buildings.Fluid.FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium,
    from_dp=true,
    use_dh=true,
    show_T=true,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal) annotation (Placement(transformation(extent={{-30,-10},
            {-10,10}}, rotation=0)));
  Buildings.Fluid.MixingVolumes.MixingVolume[nSeg] vol(
    redeclare each package Medium = Medium,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each V=VPipe/nSeg,
    each nPorts=2,
    each m_flow_nominal=m_flow_nominal,
    each prescribedHeatFlowRate=true,
    each p_start=p_start,
    each T_start=T_start) "Volume for pipe fluid" annotation (Placement(
        transformation(extent={{-1,-18},{19,-38}}, rotation=0)));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
protected
  parameter Modelica.SIunits.Volume VPipe=Modelica.Constants.pi*(diameter/2.0)^
      2*length "Pipe volume";

equation
  connect(port_a, res.port_a) annotation (Line(
      points={{-100,5.55112e-16},{-72,5.55112e-16},{-72,1.16573e-15},{-58,
          1.16573e-15},{-58,6.10623e-16},{-30,6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, vol[1].ports[1]) annotation (Line(
      points={{-10,6.10623e-16},{7,6.10623e-16},{7,-18}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:(nSeg - 1) loop
    connect(vol[i].ports[2], vol[i + 1].ports[1]);
  end for;
  connect(vol[nSeg].ports[2], port_b) annotation (Line(
      points={{11,-18},{12,-18},{12,5.55112e-16},{100,5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Icon(graphics={
        Text(
          extent={{-46,-60},{38,-94}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,50},{100,-48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={217,236,256}),
        Text(
          extent={{-42,12},{40,-12}},
          lineColor={0,0,0},
          textString="%nSeg")}),
    Documentation(info="<html>
<p>
Partial model of a pipe with flow resistance and heat storage.
This model can be used for modeling the heat exchange between the pipe and environment.
</p>
</html>", revisions="<html>
<ul>
<li>
February 12, 2012 by Wagnda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialPipe;
