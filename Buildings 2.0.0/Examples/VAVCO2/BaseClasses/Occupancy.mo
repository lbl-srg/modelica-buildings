within Buildings.Examples.VAVCO2.BaseClasses;
model Occupancy "Model for occupancy"

  Modelica.Blocks.Sources.CombiTimeTable office1(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableOnFile=false,
    table=[-6*3600,0.0;
            8*3600,2;
            9*3600,3;
            12*3600, 2;
            13*3600,6;
            15*3600,3;
            16*3600,4;
            18*3600,0]) "Office with double occupancy"
    annotation (extent=[-60,10; -40,30]);

  Modelica.Blocks.Sources.CombiTimeTable office2(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableOnFile=false,
    table=[-6*3600,0.0;
            8*3600,2;
            9*3600,3;
            12*3600, 2;
            13*3600,5;
            15*3600,3;
            16*3600,6;
            18*3600,0]) "Office with double occupancy"
    annotation (extent=[-60,-30; -40,-10]);

  Modelica.Blocks.Sources.CombiTimeTable cla1(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableOnFile=false,
    table=[-6*3600,0.0;
            8*3600,25;
            9*3600,20;
            10*3600,30;
            12*3600, 0;
            13*3600,30;
            15*3600,40;
            16*3600,20;
            18*3600,0]) "Class room"
    annotation (extent=[-60,80; -40,100]);

  Modelica.Blocks.Sources.CombiTimeTable cla2(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableOnFile=false,
    table=[-6*3600,0.0;
            8*3600,20;
            9*3600,10;
            10*3600,20;
            11*3600,15;
            12*3600, 0;
            13*3600,30;
            15*3600,20;
            16*3600,25;
            18*3600,0]) "Class room"
    annotation (extent=[-60,50; -40,70]);

  Modelica.Blocks.Sources.CombiTimeTable smaRoo1(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableOnFile=false,
    table=[-6*3600,0.0;
            8*3600,0.4;
            9*3600,1;
            12*3600,1;
            13*3600,0.5;
            14*3600,1.0;
            16*3600,0.5;
            18*3600,0]) "Small rooms"
    annotation (extent=[-60,-70; -40,-50]);

  Modelica.Blocks.Sources.CombiTimeTable smaRoo2(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableOnFile=false,
    table=[-6*3600,0.0;
            8*3600,0.4;
            9*3600,1;
            10*3600,0.4;
            12*3600,1;
            13*3600,0.3;
            14*3600,0.4;
            16*3600,0.2;
            18*3600,0]) "Small rooms"
    annotation (extent=[-60,-100; -40,-80]);

  Modelica.Blocks.Interfaces.RealOutput y1[2]
    "Connector of Real output signals"
    annotation (extent=[100,60; 120,80]);
  Modelica.Blocks.Interfaces.RealOutput y2[2]
    "Connector of Real output signals"
    annotation (extent=[100,-10; 120,10]);
  Modelica.Blocks.Interfaces.RealOutput y3[2]
    "Connector of Real output signals"
    annotation (extent=[100,-80; 120,-60]);
  Modelica.Blocks.Math.Gain sca1(k=2) "Scaling for occupancy"
    annotation (extent=[20,80; 40,100]);
  Modelica.Blocks.Math.Gain sca2(k=3) "Scaling for occupancy"
    annotation (extent=[20,10; 40,30]);
  Modelica.Blocks.Math.Gain sca3(k=3) "Scaling for occupancy"
    annotation (extent=[20,-70; 40,-50]);
  Modelica.Blocks.Math.Gain sca4(k=2) "Scaling for occupancy"
    annotation (extent=[20,50; 40,70]);
  Modelica.Blocks.Math.Gain sca5(k=3) "Scaling for occupancy"
    annotation (extent=[18,-30; 38,-10]);
  Modelica.Blocks.Math.Gain sca6(k=3) "Scaling for occupancy"
    annotation (extent=[20,-100; 40,-80]);
equation
  connect(cla1.y[1], sca1.u)
    annotation (points=[-39,90; 18,90], style(color=74, rgbcolor={0,0,127}));
  connect(cla2.y[1], sca4.u)
    annotation (points=[-39,60; 18,60], style(color=74, rgbcolor={0,0,127}));
  connect(office1.y[1], sca2.u)
    annotation (points=[-39,20; 18,20], style(color=74, rgbcolor={0,0,127}));
  connect(office2.y[1], sca5.u)
    annotation (points=[-39,-20; 16,-20], style(color=74, rgbcolor={0,0,127}));
  connect(smaRoo1.y[1], sca3.u)
    annotation (points=[-39,-60; 18,-60], style(color=74, rgbcolor={0,0,127}));
  connect(smaRoo2.y[1], sca6.u)
    annotation (points=[-39,-90; 18,-90], style(color=74, rgbcolor={0,0,127}));
  connect(sca1.y, y1[1]) annotation (points=[41,90; 74,90; 74,65; 110,65],
      style(color=74, rgbcolor={0,0,127}));
  connect(sca4.y, y1[2]) annotation (points=[41,60; 76,60; 76,75; 110,75],
      style(color=74, rgbcolor={0,0,127}));
  connect(sca2.y, y2[1]) annotation (points=[41,20; 72,20; 72,-5; 110,-5],
      style(color=74, rgbcolor={0,0,127}));
  connect(sca5.y, y2[2]) annotation (points=[39,-20; 72,-20; 72,5; 110,5],
      style(color=74, rgbcolor={0,0,127}));
  connect(sca3.y, y3[1]) annotation (points=[41,-60; 72,-60; 72,-75; 110,-75],
      style(color=74, rgbcolor={0,0,127}));
  connect(sca6.y, y3[2]) annotation (points=[41,-90; 72,-90; 72,-65; 110,-65],
      style(color=74, rgbcolor={0,0,127}));
  annotation (Icon(
         Rectangle(extent=[-100,-100; 100,100],   style(
        color=74,
        rgbcolor={0,0,127},
        fillColor=7,
        rgbfillColor={255,255,255})),
      Polygon(points=[-80,90; -88,68; -72,68; -80,90],     style(color=8,
            fillColor=8)),
      Line(points=[-80,68; -80,-80],   style(color=8)),
      Line(points=[-90,-70; 82,-70],   style(color=8)),
      Polygon(points=[90,-70; 68,-62; 68,-78; 90,-70],     style(
          color=8,
          fillColor=8,
          fillPattern=1)),
      Rectangle(extent=[-48,70; 2,-50],   style(
          color=7,
          fillColor=49,
          fillPattern=1)),
      Line(points=[-48,-50; -48,70; 52,70; 52,-50; -48,-50; -48,-20; 52,-20; 52,
            10; -48,10; -48,40; 52,40; 52,70; 2,70; 2,-51],
          style(color=0)),
      Text(
        extent=[-42,140; 42,90],
        style(color=3, rgbcolor={0,0,255}),
        string="%name")), Diagram);
end Occupancy;
