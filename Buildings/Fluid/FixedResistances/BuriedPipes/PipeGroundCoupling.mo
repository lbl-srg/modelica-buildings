within Buildings.Fluid.FixedResistances.BuriedPipes;
model PipeGroundCoupling
  parameter Modelica.Units.SI.Height lPip = 100 "Pipe length";
  parameter Modelica.Units.SI.Radius rPip = 0.5 "Pipe external radius";
  parameter Modelica.Units.SI.Radius thiGroLay = 1.0 "Dynamic ground layer thickness";
  final parameter Modelica.Units.SI.Radius rGroLay = rPip + thiGroLay "Pipe radius plus dynamic ground layer";
  parameter Integer nSeg(min=1) = 10 "Number of pipe discretization segments axial direction";
  parameter Integer nSta=1 "Number of state variables for dynamic ground layer";
  parameter Modelica.Units.SI.Temperature TpipSta=280.15
    "Initial temperature for the pipe, used if steadyStateInitial = false" annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Modelica.Units.SI.Temperature TGrouBouSta=283.15
    "Initial temperature at ground final layer, used if steadyStateInitial = false" annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Boolean steadyStateInitial=false
    "true initializes dT(0)/dt=0, false initializes T(0) at fixed temperature using TpipSta and TGrouBouSta" annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Modelica.Units.SI.Length dep=10 "Depth of buried pipe to calculate ground temperature";
  replaceable parameter Buildings.Experimental.DHC.Examples.Combined.BaseClasses.Zurich cliCon
    "Surface temperature climatic conditions";
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soiDat(
    k=1.58,c=1150,d=1600)                      "Soil thermal properties"
    annotation (Placement(transformation(extent={{-90,72},{-70,92}})));
  Buildings.HeatTransfer.Conduction.SingleLayerCylinder groActLay[nSeg](
    each material = soiDat,
    each h = lPip,
    each r_a = rPip,
    each r_b = rGroLay,
    each nSta = nSta,
    each TInt_start = TpipSta,
    each TExt_start = TGrouBouSta,
    each steadyStateInitial=steadyStateInitial) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-68,0})));

  BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature soiTem(
    dep=dep,
    soiDat=soiDat,
    cliCon=cliCon)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Modelica.Blocks.Sources.RealExpression soiTemExp(y=soiTem.T)
    "Soil undisturbed temperature"
    annotation (Placement(transformation(extent={{74,-12},{44,12}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature groTem[nSeg]
    annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
  Modelica.Fluid.Interfaces.HeatPorts_a heatPorts[nSeg]
    "Multiple heat ports that connect to outside of pipe wall"
    annotation (Placement(transformation(extent={{-10.5,-10},{10.5,10}},
        rotation=90,
        origin={-99.5,0}),
        iconTransformation(extent={{-30,-60},{30,-40}})));
  Modelica.Blocks.Routing.Replicator groTemDup(nout=nSeg)
    annotation (Placement(transformation(extent={{20,-10},{0,10}})));

equation
  connect(groTem.T, groTemDup.y)
    annotation (Line(points={{-18,0},{-1,0}}, color={0,0,127}));
  connect(groTemDup.u, soiTemExp.y)
    annotation (Line(points={{22,0},{42.5,0}}, color={0,0,127}));
  connect(heatPorts, groActLay.port_a)
    annotation (Line(points={{-99.5,0},{-78,0}}, color={127,0,0}));
  connect(groActLay.port_b, groTem.port)
    annotation (Line(points={{-58,0},{-40,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {120,100}}), graphics={
        Rectangle(
          extent={{-104,38},{120,-100}},
          fillColor={154,139,114},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{120,44},{-104,38}},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{120,100},{-104,44}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-104,-14},{120,-48}},
          fillColor={138,138,138},
          fillPattern=FillPattern.HorizontalCylinder,
          pattern=LinePattern.None),
        Line(
          points={{-90,-14},{-90,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{-74,-14},{-74,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{-42,-14},{-42,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{-58,-14},{-58,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{-26,-14},{-26,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{-10,-14},{-10,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{6,-14},{6,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{22,-14},{22,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{102,-14},{102,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{86,-14},{86,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{70,-14},{70,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{54,-14},{54,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{38,-14},{38,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Text(
          extent={{-145,138},{155,98}},
          textColor={0,0,255},
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>
<ul>
<li>
April 10, 2023, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model considers the conduction heat transfer between the buried pipe wall and the undisutbred ground temperature by adding a dynamic ground layer.
The dynamic ground model uses the radial heat conduction model through a hollow cilinder <a href=\"modelica://Buildings.HeatTransfer.Conduction.SingleLayerCylinder\"> Buildings.HeatTransfer.Conduction.SingleLayerCylinder</a>. The undisturbed ground temperature is calculated
by the model <a href=\"modelica://Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature\">Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature</a>. This model can consider an axial discretization of the pipe, a figure highlighting the main variables and parameters is reported
below:
</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/FixedResistances/BuriedPipes/PipeGroundCoupling.png\" style = \"max-width:50%;\" />
</p>

<h4>References</h4>
<p>
 This model was first implemented in \"Control development and sizing analysis for a 5th generation district heating and cooling network using Modelica\", Zanetti et al., 2023 Modelica conference proceedings.
</p>

</html>"));
end PipeGroundCoupling;
