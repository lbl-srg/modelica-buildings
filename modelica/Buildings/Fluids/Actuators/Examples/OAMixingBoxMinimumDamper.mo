within Buildings.Fluids.Actuators.Examples;
model OAMixingBoxMinimumDamper

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Commands(file=
          "OAMixingBoxMinimumDamper.mos" "run"));

 package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir
    "Medium in the component" 
         annotation (choicesAllMatching = true);

  Buildings.Fluids.Actuators.Dampers.OAMixingBoxMinimumDamper mixBox(
    AOutMin=0.3,
    AOut=0.7,
    AExh=1,
    ARec=1,
    m0OutMin_flow=0.3,
    dp0OutMin=20,
    m0Out_flow=1,
    dp0Out=20,
    m0Rec_flow=1,
    dp0Rec=20,
    m0Exh_flow=1,
    dp0Exh=20,
    redeclare package Medium = Medium) "mixing box" 
                            annotation (Placement(transformation(extent={{14,
            -22},{34,-2}}, rotation=0)));
    Modelica_Fluid.Sources.Boundary_pT bouIn(             redeclare package
      Medium = Medium, T=273.15 + 10,
    use_p_in=true,
    nPorts=3)                                             annotation (Placement(
        transformation(extent={{-60,2},{-40,22}},  rotation=0)));
    Modelica_Fluid.Sources.Boundary_pT bouSup(             redeclare package
      Medium = Medium, T=273.15 + 26,
    use_p_in=true,
    nPorts=1)                                                                       annotation (Placement(
        transformation(extent={{68,-10},{48,10}}, rotation=0)));
    Modelica_Fluid.Sources.Boundary_pT bouRet(             redeclare package
      Medium = Medium, T=273.15 + 20,
    use_p_in=true,
    nPorts=1)                                                         annotation (Placement(
        transformation(extent={{68,-90},{48,-70}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PAtm(k=101325) 
      annotation (Placement(transformation(extent={{-100,10},{-80,30}},
          rotation=0)));
    Modelica.Blocks.Sources.Constant yDamMin(k=0.5) 
      annotation (Placement(transformation(extent={{-40,70},{-20,90}},rotation=
            0)));
    Modelica.Blocks.Sources.Ramp PSup(
    offset=101320,
    height=-10,
    startTime=0,
    duration=20) annotation (Placement(transformation(extent={{60,40},{80,60}},
          rotation=0)));
    Modelica.Blocks.Sources.Ramp PRet(
    height=10,
    offset=101330,
    duration=20,
    startTime=20) 
                 annotation (Placement(transformation(extent={{60,-50},{80,-30}},
          rotation=0)));
    Modelica.Blocks.Sources.Ramp yDam(
    duration=20,
    startTime=40,
    height=0.1,
    offset=0.45) annotation (Placement(transformation(extent={{-40,40},{-20,60}},
          rotation=0)));

  inner Modelica_Fluid.System system 
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation
  connect(yDamMin.y, mixBox.yOutMin) 
                               annotation (Line(points={{-19,80},{4,80},{4,-2},
          {12,-2}},color={0,0,127}));
  connect(yDam.y, mixBox.y) annotation (Line(points={{-19,50},{-4,50},{-4,-6},{
          12,-6}}, color={0,0,127}));
  connect(bouIn.p_in, PAtm.y) annotation (Line(points={{-62,20},{-72,20},{-79,
          20}},          color={0,0,127}));
  connect(PRet.y, bouRet.p_in) annotation (Line(points={{81,-40},{90,-40},{90,
          -72},{70,-72}}, color={0,0,127}));
  connect(bouSup.p_in, PSup.y) annotation (Line(points={{70,8},{92,8},{92,50},{
          81,50}}, color={0,0,127}));
  connect(bouIn.ports[1], mixBox.port_OutMin) annotation (Line(
      points={{-40,14.6667},{-14,14.6667},{-14,-10},{13.8,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouIn.ports[2], mixBox.port_Out) annotation (Line(
      points={{-40,12},{-16,12},{-16,-14},{13.8,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouIn.ports[3], mixBox.port_Exh) annotation (Line(
      points={{-40,9.33333},{-18,9.33333},{-18,-20},{13.8,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouSup.ports[1], mixBox.port_Sup) annotation (Line(
      points={{48,0},{42,0},{42,-10},{33.8,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouRet.ports[1], mixBox.port_Ret) annotation (Line(
      points={{48,-80},{42,-80},{42,-20},{34,-20}},
      color={0,127,255},
      smooth=Smooth.None));
end OAMixingBoxMinimumDamper;
