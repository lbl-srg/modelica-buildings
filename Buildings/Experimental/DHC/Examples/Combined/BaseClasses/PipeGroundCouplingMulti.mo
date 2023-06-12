within Buildings.Experimental.DHC.Examples.Combined.BaseClasses;
model PipeGroundCouplingMulti
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=8,
    f=1/31536000,
    phase=-2.3561944901923,
    offset=273.15 + 10)
    annotation (Placement(transformation(extent={{62,-50},{42,-30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                         groundTemperature2
    annotation (Placement(transformation(extent={{-6,-50},{-26,-30}})));
  Buildings.HeatTransfer.Conduction.SingleLayerCylinder lay1[nSeg](
    redeclare Buildings.HeatTransfer.Data.Soil.Sandstone material,
    h=lpip,
    r_a=rpip,
    r_b=rgroLay,
    nSta=5,
    TInt_start=280.15,
    TExt_start=283.15,
    steadyStateInitial=false) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-52,0})));

  BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    undisturbedSoilTemperature(dep=10,
    soiDat=soiDat,
    cliCon=cliCon)
    annotation (Placement(transformation(extent={{32,28},{52,48}})));
  parameter Modelica.Units.SI.Height lpip=100 "Pipe length";
  parameter Modelica.Units.SI.Radius rpip=0.5 "Pipe internal radius";
  parameter Modelica.Units.SI.Radius rgroLay=1.5 "External radius";
  parameter Integer nSeg(min=1) = 10 "Number of volume segments";
  replaceable parameter Buildings.Experimental.DHC.Examples.Combined.BaseClasses.Zurich cliCon
    "Surface temperature climatic conditions";
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soiDat(
    k=1.58,c=1150,d=1600) "Soil thermal properties";
  Modelica.Blocks.Sources.RealExpression SoilTem(y=undisturbedSoilTemperature.T)
                                                           "Soil temperature"
    annotation (Placement(transformation(extent={{68,-12},{38,12}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature groundTemperature1[nSeg]
    annotation (Placement(transformation(extent={{-6,-10},{-26,10}})));
  Modelica.Fluid.Interfaces.HeatPorts_a heatPorts[nSeg]
                                                       "Multiple heat ports that connect to outside of pipe wall (enabled if useMultipleHeatPorts=true)"
    annotation (Placement(transformation(extent={{-10.5,-10},{10.5,10}},
        rotation=90,
        origin={-99.5,0}),
        iconTransformation(extent={{-30,-60},{30,-40}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=nSeg)
    annotation (Placement(transformation(extent={{24,-10},{4,10}})));
equation
  connect(sine1.y, groundTemperature2.T)
    annotation (Line(points={{41,-40},{-4,-40}}, color={0,0,127}));
  connect(groundTemperature1.T, replicator.y)
    annotation (Line(points={{-4,0},{3,0}}, color={0,0,127}));
  connect(replicator.u, SoilTem.y)
    annotation (Line(points={{26,0},{36.5,0}}, color={0,0,127}));
  connect(heatPorts, lay1.port_a)
    annotation (Line(points={{-99.5,0},{-62,0}}, color={127,0,0}));
  connect(lay1.port_b, groundTemperature1.port)
    annotation (Line(points={{-42,0},{-26,0}}, color={191,0,0}));
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
          pattern=LinePattern.Dash)}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})));
end PipeGroundCouplingMulti;
