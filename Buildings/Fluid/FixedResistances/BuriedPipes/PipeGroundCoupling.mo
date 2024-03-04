within Buildings.Fluid.FixedResistances.BuriedPipes;
model PipeGroundCoupling
  parameter Modelica.Units.SI.Height lPip = 100 "Pipe length";
  parameter Modelica.Units.SI.Radius rPip = 0.5 "Pipe external radius";
  parameter Modelica.Units.SI.Radius thiGroLay = 1.0 "Dynamic ground layer thickness";
  final parameter Modelica.Units.SI.Radius rGroLay = rPip + thiGroLay "Pipe radius plus dynamic ground layer";
  parameter Integer nSeg(min=1) = 10 "Number of pipe discretization segments axial direction";
  parameter Integer nSta=1 "Number of state variables for dynamic ground layer";
  parameter Modelica.Units.SI.Temperature TpipSta = 280.15
    "Initial temperature for the pipe, used if steadyStateInitial = false" annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Modelica.Units.SI.Temperature TGrouBouSta = 283.15
    "Initial temperature at ground final layer, used if steadyStateInitial = false" annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Boolean steadyStateInitial = false
    "true initializes dT(0)/dt=0, false initializes T(0) at fixed temperature using TpipSta and TGrouBouSta" annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Modelica.Units.SI.Length dep = 10 "Depth of buried pipe to calculate ground temperature";
  replaceable parameter Buildings.Experimental.DHC.Examples.Combined.BaseClasses.Zurich cliCon
    "Surface temperature climatic conditions";
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soiDat(
    k=1.58,c=1150,d=1600) "Soil thermal properties" annotation (Placement(transformation(extent={{-90,72},{-70,92}})));
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
    cliCon=cliCon) annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Modelica.Blocks.Sources.RealExpression soiTemExp(y=soiTem.T)
    "Soil undisturbed temperature" annotation (Placement(transformation(extent={{74,-12},{44,12}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature groTem[nSeg]
    "Prescribed ground temperature"
    annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
  Modelica.Fluid.Interfaces.HeatPorts_a heatPorts[nSeg]
    "Multiple heat ports that connect to outside of pipe wall" annotation (Placement(transformation(extent={{-10.5,-10},{10.5,10}},
        rotation=90,
        origin={-99.5,0}),
        iconTransformation(extent={{-30,-60},{30,-40}})));
  Modelica.Blocks.Routing.Replicator groTemDup(nout=nSeg)
    "Ground temperature replicator"                       annotation (Placement(transformation(extent={{20,-10},{0,10}})));

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
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,38},{100,-100}},
          fillColor={154,139,114},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{100,44},{-100,38}},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{100,100},{-100,44}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-100,-14},{100,-48}},
          fillColor={138,138,138},
          fillPattern=FillPattern.HorizontalCylinder,
          pattern=LinePattern.None),
        Line(
          points={{-88,-14},{-88,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{-72,-14},{-72,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{-40,-14},{-40,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{-56,-14},{-56,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{-24,-14},{-24,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{-8,-14},{-8,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{8,-14},{8,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{24,-14},{24,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{88,-14},{88,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{72,-14},{72,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{56,-14},{56,-48}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{40,-14},{40,-48}},
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
This model considers the conduction heat transfer between the buried pipe 
wall and the undisturbed ground temperature by adding a dynamic ground layer.
The dynamic ground layer is modeled using the radial heat conduction model 
through a hollow cylinder 
<a href=\"modelica://Buildings.HeatTransfer.Conduction.SingleLayerCylinder\"> Buildings.HeatTransfer.Conduction.SingleLayerCylinder</a>. 
The undisturbed ground temperature is calculated
by the model 
<a href=\"modelica://Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature\">Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature</a>. 
This model can consider an axial discretization of the pipe.  
A figure highlighting the main variables and parameters is shown below:
</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/FixedResistances/BuriedPipes/PipeGroundCoupling.png\" style = \"max-width:50%;\" />
</p>
<h4>References</h4>
<p>
Ettore Zanetti, David Blum, Michael Wetter (2023) <a href=\"https://https://2023.international.conference.modelica.org/proceedings.html\">
Control development and sizing analysis for a 5th generation district heating and cooling network using Modelica</a>, 
In Proceedings of the 15th International Modelica Conference. Aachen, Germany, Oct 9-11, 2023. 
</p>
</html>"));
end PipeGroundCoupling;
