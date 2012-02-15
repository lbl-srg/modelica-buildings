within Buildings.Fluid.FixedResistances;
model Pipe "Model of a thermal hydraulics pipe with 1D-discretization"

  extends Buildings.Fluid.FixedResistances.BaseClasses.PartialPipe;
  parameter Boolean useMultipleHeatPort=false
    "= true to use one heat port for each segment of the pipe, false to use a single heat port for the entire pipe.";

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conPipWal[nSeg](
      each G=2*Modelica.Constants.pi*lambdaIns*length/nSeg/Modelica.Math.log((
        diameter/2.0 + thicknessIns)/(diameter/2.0)))
    "Thermal conductance through pipe wall"
    annotation (Placement(transformation(extent={{-28,-38},{-8,-18}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector colAllToOne(m=nSeg)
    if not useMultipleHeatPort
    "Connector to assign multiple heat ports to one heat port" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-50,10})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a singleHeatPort if not
    useMultipleHeatPort
    "The single heat port for heat exchange with environment (default, enabled when useMultipleHeatPort is false)"
    annotation (Placement(transformation(extent={{-60,16},{-40,36}}),
        iconTransformation(extent={{-10,50},{10,70}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a multipleHeatPort[nSeg]
    if useMultipleHeatPort
    "Multiple heat ports for heat exchange with environment (enabled when useMultipleHeatPort is true)"
    annotation (Placement(transformation(extent={{-85,16},{-65,36}}),
        iconTransformation(extent={{-9,50},{11,70}})));
equation

  connect(conPipWal.port_b, vol.heatPort) annotation (Line(
      points={{-8,-28},{-1,-28}},
      color={191,0,0},
      smooth=Smooth.None));
  if useMultipleHeatPort then
    connect(multipleHeatPort, conPipWal.port_a) annotation (Line(
        points={{-75,26},{-75,-28},{-28,-28}},
        color={191,0,0},
        smooth=Smooth.None));
  else
    connect(colAllToOne.port_a, conPipWal.port_a) annotation (Line(
        points={{-50,4},{-50,-28},{-28,-28}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(colAllToOne.port_b, singleHeatPort) annotation (Line(
        points={{-50,16},{-50,26}},
        color={191,0,0},
        smooth=Smooth.None));

  end if;
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
    defaultComponentName="pip",
    Documentation(info="<html>
<p>
Model of a pipe with flow resistance and heat exchange with environment. 
If <code>useMultipleHeatPort</code> is false (default option), the pipe uses single heat port for heat exchange with environment; If <code>useMultipleHeatPort</code> is true, it assigns one heat port for each segment of the pipe for the heat exchange with environment.
</p>
</html>", revisions="<html>
<ul>
<li>
February 12, 2012 by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
end Pipe;
