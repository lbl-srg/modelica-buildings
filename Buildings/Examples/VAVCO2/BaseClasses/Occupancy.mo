within Buildings.Examples.VAVCO2.BaseClasses;
model Occupancy "Model for occupancy"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  Modelica.Blocks.Sources.CombiTimeTable office1(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableOnFile=false,
    table=[-6,0.0;
            8,2;
            9,3;
            12,2;
            13,6;
            15,3;
            16,4;
            18,0],
    timeScale=3600) "Office with double occupancy"
    annotation (Placement(transformation(extent=[-60,10; -40,30])));

  Modelica.Blocks.Sources.CombiTimeTable office2(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableOnFile=false,
    table=[-6,0.0;
            8,2;
            9,3;
            12,2;
            13,5;
            15,3;
            16,6;
            18,0],
    timeScale=3600) "Office with double occupancy"
    annotation (Placement(transformation(extent=[-60,-30; -40,-10])));

  Modelica.Blocks.Sources.CombiTimeTable cla1(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableOnFile=false,
    table=[-6,0.0;
            8,25;
            9,20;
            10,30;
            12,0;
            13,30;
            15,40;
            16,20;
            18,0],
    timeScale=3600) "Class room"
    annotation (Placement(transformation(extent=[-60,80; -40,100])));

  Modelica.Blocks.Sources.CombiTimeTable cla2(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableOnFile=false,
    table=[-6,0.0;
            8,20;
            9,10;
            10,20;
            11,15;
            12,0;
            13,30;
            15,20;
            16,25;
            18,0],
    timeScale=3600) "Class room"
    annotation (Placement(transformation(extent=[-60,50; -40,70])));

  Modelica.Blocks.Sources.CombiTimeTable smaRoo1(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableOnFile=false,
    table=[-6,0.0;
            8,0.4;
            9,1;
            12,1;
            13,0.5;
            14,1.0;
            16,0.5;
            18,0],
    timeScale=3600) "Small rooms"
    annotation (Placement(transformation(extent=[-60,-70; -40,-50])));

  Modelica.Blocks.Sources.CombiTimeTable smaRoo2(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableOnFile=false,
    table=[-6,0.0;
            8,0.4;
            9,1;
            10,0.4;
            12,1;
            13,0.3;
            14,0.4;
            16,0.2;
            18,0],
    timeScale=3600) "Small rooms"
    annotation (Placement(transformation(extent=[-60,-100; -40,-80])));

  Modelica.Blocks.Interfaces.RealOutput y1[2]
    "Connector of Real output signals"
    annotation (Placement(transformation(extent=[100,60; 120,80])));
  Modelica.Blocks.Interfaces.RealOutput y2[2]
    "Connector of Real output signals"
    annotation (Placement(transformation(extent=[100,-10; 120,10])));
  Modelica.Blocks.Interfaces.RealOutput y3[2]
    "Connector of Real output signals"
    annotation (Placement(transformation(extent=[100,-80; 120,-60])));
  Modelica.Blocks.Math.Gain sca1(k=2) "Scaling for occupancy"
    annotation (Placement(transformation(extent=[20,80; 40,100])));
  Modelica.Blocks.Math.Gain sca2(k=3) "Scaling for occupancy"
    annotation (Placement(transformation(extent=[20,10; 40,30])));
  Modelica.Blocks.Math.Gain sca3(k=3) "Scaling for occupancy"
    annotation (Placement(transformation(extent=[20,-70; 40,-50])));
  Modelica.Blocks.Math.Gain sca4(k=2) "Scaling for occupancy"
    annotation (Placement(transformation(extent=[20,50; 40,70])));
  Modelica.Blocks.Math.Gain sca5(k=3) "Scaling for occupancy"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Modelica.Blocks.Math.Gain sca6(k=3) "Scaling for occupancy"
    annotation (Placement(transformation(extent=[20,-100; 40,-80])));
  Modelica.Blocks.Routing.Multiplex2 mul1(
    final n1=1,
    final n2=1)
    "Multiplex to route signals"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Routing.Multiplex2 mul2(
    final n1=1,
    final n2=1)
    "Multiplex to route signals"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Routing.Multiplex2 mul3(
    final n1=1,
    final n2=1)
    "Multiplex to route signals"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
equation
  connect(y1, mul1.y)
    annotation (Line(points={{110,70},{96,70},{81,70}}, color={0,0,127}));
  connect(mul1.u1[1], sca1.y) annotation (Line(points={{58,76},{50,76},{50,90},{
          41,90}}, color={0,0,127}));
  connect(mul1.u2[1], sca4.y) annotation (Line(points={{58,64},{50,64},{50,60},{
          41,60}}, color={0,0,127}));
  connect(mul2.y, y2)
    annotation (Line(points={{81,0},{110,0},{110,0}}, color={0,0,127}));
  connect(mul3.y, y3)
    annotation (Line(points={{81,-70},{110,-70},{110,-70}}, color={0,0,127}));
  connect(sca2.y, mul2.u1[1])
    annotation (Line(points={{41,20},{48,20},{48,6},{58,6}}, color={0,0,127}));
  connect(sca5.y, mul2.u2[1]) annotation (Line(points={{41,-20},{48,-20},{48,-6},
          {48,-6},{58,-6}}, color={0,0,127}));
  connect(sca3.y, mul3.u1[1]) annotation (Line(points={{41,-60},{48,-60},{48,
          -64},{58,-64}}, color={0,0,127}));
  connect(sca6.y, mul3.u2[1]) annotation (Line(points={{41,-90},{48,-90},{48,
          -76},{58,-76}}, color={0,0,127}));
  connect(cla1.y[1], sca1.u)
    annotation (Line(points={{-39,90},{18,90},{18,90}}, color={0,0,127}));
  connect(cla2.y[1], sca4.u)
    annotation (Line(points={{-39,60},{18,60},{18,60}}, color={0,0,127}));
  connect(office1.y[1], sca2.u)
    annotation (Line(points={{-39,20},{-10,20},{18,20}}, color={0,0,127}));
  connect(office2.y[1], sca5.u)
    annotation (Line(points={{-39,-20},{-10,-20},{18,-20}}, color={0,0,127}));
  connect(smaRoo1.y[1], sca3.u)
    annotation (Line(points={{-39,-60},{-10,-60},{18,-60}}, color={0,0,127}));
  connect(smaRoo2.y[1], sca6.u)
    annotation (Line(points={{-39,-90},{-10,-90},{18,-90}}, color={0,0,127}));
  annotation (Icon(graphics={
    Line(points={{-80,58},{-80,-90}},
      color={192,192,192}),
    Line(points={{-90,-80},{82,-80}},
      color={192,192,192}),
    Polygon(lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid,
      points={{-80,80},{-88,58},{-72,58},{-80,80}}),
    Polygon(lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid,
      points={{90,-80},{68,-72},{68,-88},{90,-80}}),
    Rectangle(lineColor={255,255,255},
      fillColor={255,215,136},
      fillPattern=FillPattern.Solid,
      extent={{-48,-60},{2,60}}),
    Line(points={{-48,-60},{-48,60},{52,60},{52,-60},{-48,-60},{-48,-30},{52,-30},
              {52,0},{-48,0},{-48,30},{52,30},{52,60},{2,60},{2,-61}})}));
end Occupancy;
