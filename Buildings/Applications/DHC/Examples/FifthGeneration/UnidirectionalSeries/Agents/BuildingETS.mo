within Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Agents;
model BuildingETS "Building model with energy transfer station"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare replaceable package Medium=Buildings.Media.Water,
    final m_flow_small=1E-4*m_flow_nominal,
    final show_T=false,
    final allowFlowReversal=false);
  Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui(redeclare package
      Medium1 = MediumWater, nPorts1=2) "Building"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  EnergyTransferStation ets1(
    redeclare package Medium = MediumWater,
    QCoo_flow_nominal=sum(bui.terUni.QCoo_flow_nominal),
    QHea_flow_nominal=sum(bui.terUni.QHea_flow_nominal))
    "Energy transfer station"
    annotation (Placement(transformation(extent={{-20,-60},{20,-20}})));
  Modelica.Blocks.Interfaces.RealInput TSetChiWat "Chilled water set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,60})));
  Modelica.Blocks.Interfaces.RealInput TSetHeaWat "Heating water set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,100})));
equation
  connect(port_a, ets1.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,
          -40},{-20,-40}},
                 color={0,127,255}));
  connect(ets1.port_b, port_b) annotation (Line(points={{19.8571,-40},{80,-40},
          {80,0},{100,0}},
                    color={0,127,255}));
  connect(bui.ports_b1[1], ets1.port_aHeaWat) annotation (Line(points={{30,30},
          {60,30},{60,-14},{-40,-14},{-40,-48.5714},{-20,-48.5714}},color={0,127,
          255}));
  connect(ets1.port_bHeaWat, bui.ports_a1[1]) annotation (Line(points={{20,
          -48.5714},{40,-48.5714},{40,-80},{-60,-80},{-60,30},{-30,30}},
        color={0,127,255}));
  connect(bui.ports_b1[2], ets1.port_aChi) annotation (Line(points={{30,34},{54,
          34},{54,-8},{-46,-8},{-46,-57.1429},{-20,-57.1429}},      color={0,127,
          255}));
  connect(ets1.port_bChi, bui.ports_a1[2]) annotation (Line(points={{20,
          -57.2857},{34,-57.2857},{34,-74},{-54,-74},{-54,34},{-30,34}},
                                                               color={0,127,255}));
  connect(TSetChiWat, ets1.TSetChiWat) annotation (Line(points={{-120,40},{-74,
          40},{-74,-28.5714},{-21.4286,-28.5714}},
                                               color={0,0,127}));
  connect(TSetHeaWat, ets1.TSetHeaWat) annotation (Line(points={{-120,80},{-68,
          80},{-68,-22.8571},{-21.4286,-22.8571}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,140}}), graphics={
        Rectangle(
          extent={{0,6},{100,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,0},{0,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,0},{0,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-6},{100,0}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
      Polygon(
        points={{0,100},{-40,80},{40,80},{0,100}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
          extent={{-40,80},{40,-20}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
      Rectangle(
        extent={{-30,50},{-10,70}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{10,50},{30,70}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-30,10},{-10,30}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{10,10},{30,30}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BuildingETS;
