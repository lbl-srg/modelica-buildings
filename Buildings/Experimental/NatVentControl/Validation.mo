within Buildings.Experimental.NatVentControl;
package Validation "Validation model for Nat Vent control"
  model NatVentRoo
    Fluid.MixingVolumes.MixingVolume           volA(
      redeclare package Medium = Medium,
      V=2.5*10*5,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      T_start=273.15 + 18,
      nPorts=2,
      m_flow_nominal=0.001)
      annotation (Placement(transformation(extent={{-2,-20},{18,0}})));
    Airflow.Multizone.Orifice           oriOutBot(
      redeclare package Medium = Medium,
      A=0.1,
      m=0.5,
      dp_turbulent=0.1)
      annotation (Placement(transformation(extent={{28,-30},{48,-10}})));
    Airflow.Multizone.MediumColumn           colOut(
      redeclare package Medium = Medium,
      h=3,
      densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
      annotation (Placement(transformation(extent={{79,10},{99,30}})));
    Airflow.Multizone.Orifice           oriOutTop(
      redeclare package Medium = Medium,
      A=0.1,
      m=0.5,
      dp_turbulent=0.1)
      annotation (Placement(transformation(extent={{31,40},{51,60}})));
    Airflow.Multizone.MediumColumn           colRooTop(
      redeclare package Medium = Medium,
      h=3,
      densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
      annotation (Placement(transformation(extent={{-22,10},{-1,30}})));
    Fluid.MixingVolumes.MixingVolume           volOut(
      redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      V=1E10,
      T_start=273.15 + 20,
      nPorts=2,
      m_flow_nominal=0.001)
      annotation (Placement(transformation(extent={{61,-20},{81,0}})));
    Modelica.Blocks.Sources.CombiTimeTable shaPos1(table=[0,1; 86400,1],
        tableOnFile=false) "Position of the shade"
      annotation (Placement(transformation(extent={{320,60},{340,80}})));
    Fluid.Sensors.TemperatureTwoPort temRoom1(
      redeclare package Medium = MediumA,
      m_flow_nominal=mRad_flow_nominal,
      transferHeat=false) "HeatingTemperature" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={372,-80})));
    Modelica.Blocks.Sources.CombiTimeTable airCon1(
      table=[0,0.001,293.15; 28800,0.05,293.15; 64800,0.001,293.15; 86400,
          0.001,293.15],
      tableOnFile=false,
      tableName="airCon",
      fileName=Modelica.Utilities.Files.loadResource(
          "modelica://Buildings/Resources/Data/ThermalZones/Detailed/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
      columns=2:3,
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      timeScale=1) "Inlet air conditions (y[1] = m_flow, y[4] = T)"
      annotation (Placement(transformation(extent={{256,-56},{276,-36}})));

    Fluid.Sources.MassFlowSource_T           airIn1(
      use_m_flow_in=true,
      use_T_in=true,
      redeclare package Medium = MediumA,
      nPorts=1) "Inlet air conditions (from AHU) for X3A"
      annotation (Placement(transformation(extent={{314,-36},{334,-16}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut1
      "Outside temperature"
      annotation (Placement(transformation(extent={{578,-84},{598,-64}})));
    Controls.OBC.CDL.Continuous.Sources.Constant           InteriorSetpoint2(k=294)
      annotation (Placement(transformation(extent={{520,-68},{564,-24}})));
    Modelica.Blocks.Sources.CombiTimeTable intGai1(
      table=[0,1.05729426,1.25089426,0; 3600,1.05729426,1.25089426,0; 7200,
          1.05729426,1.25089426,0; 10800,1.05729426,1.25089426,0; 14400,
          1.05729426,1.25089426,0; 18000,1.05729426,1.25089426,0; 21600,
          1.121827593,1.509027593,0; 25200,1.548281766,1.882174238,
          0.330986667; 28800,1.977743414,2.979420831,0.661973333; 32400,
          5.734675369,8.73970762,3.144373333; 36000,5.734675369,8.73970762,
          3.144373333; 39600,5.734675369,8.73970762,3.144373333; 43200,
          5.734675369,8.73970762,3.144373333; 46800,4.496245967,7.501278218,
          1.654933333; 50400,5.734675369,8.73970762,3.144373333; 54000,
          5.734675369,8.73970762,3.144373333; 57600,5.734675369,8.73970762,
          3.144373333; 61200,5.734675369,8.73970762,3.144373333; 64800,
          2.714734464,4.384196826,0.99296; 68400,1.770876747,2.772554164,
          0.330986667; 72000,1.770876747,2.772554164,0.330986667; 75600,
          1.659579257,2.327364201,0.330986667; 79200,1.659579257,2.327364201,
          0.330986667; 82800,1.444848433,1.778740905,0.165493333; 86400,
          1.389199687,1.556145923,0.165493333],
      tableOnFile=false,
      columns=2:4,
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      timeScale=1,
      startTime=0)
      "Internal gain heat flow (Radiant = 1, Convective = 2, Latent = 3)"
      annotation (Placement(transformation(extent={{328,8},{348,28}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBel3(G=0.2)
      "Combined convection and radiation resistance below the slab"
      annotation (Placement(transformation(extent={{432,-46},{452,-26}})));
    ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCell_Radiant_Interior
      testCell_Radiant_Interior(
      nConExtWin=0,
      nConBou=5,
      lat=0.72954762733363,
      nPorts=4,
      redeclare package Medium = MediumA)
      annotation (Placement(transformation(extent={{412,2},{452,42}})));
    Airflow.Multizone.Orifice           oriOutBot1(
      redeclare package Medium = Medium,
      A=0.1,
      m=0.5,
      dp_turbulent=0.1)
      annotation (Placement(transformation(extent={{202,82},{222,102}})));
    Airflow.Multizone.MediumColumn           colOut1(
      redeclare package Medium = Medium,
      h=3,
      densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
      annotation (Placement(transformation(extent={{253,122},{273,142}})));
    Airflow.Multizone.Orifice           oriOutTop1(
      redeclare package Medium = Medium,
      A=0.1,
      m=0.5,
      dp_turbulent=0.1)
      annotation (Placement(transformation(extent={{205,152},{225,172}})));
    Airflow.Multizone.MediumColumn           colRooTop1(
      redeclare package Medium = Medium,
      h=3,
      densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
      annotation (Placement(transformation(extent={{152,122},{173,142}})));
    Fluid.MixingVolumes.MixingVolume           volOut1(
      redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      V=1E10,
      T_start=273.15 + 20,
      nPorts=2,
      m_flow_nominal=0.001)
      annotation (Placement(transformation(extent={{235,92},{255,112}})));
  equation
    connect(oriOutBot.port_b,volOut. ports[1]) annotation (Line(
        points={{48,-20},{69,-20}},
        color={0,127,255}));
    connect(volA.ports[1],oriOutBot. port_a) annotation (Line(
        points={{6,-20},{28,-20}},
        color={0,127,255}));
    connect(volA.ports[2],colRooTop. port_b) annotation (Line(
        points={{10,-20},{-12,-20},{-12,10},{-11.5,10}},
        color={0,127,255}));
    connect(colRooTop.port_a,oriOutTop. port_a) annotation (Line(
        points={{-11.5,30},{-12,30},{-12,50},{31,50}},
        color={0,127,255}));
    connect(volOut.ports[2],colOut. port_b) annotation (Line(
        points={{73,-20},{89,-20},{89,10}},
        color={0,127,255}));
    connect(colOut.port_a,oriOutTop. port_b) annotation (Line(
        points={{89,30},{90,30},{90,50},{51,50}},
        color={0,127,255}));
    connect(airCon1.y[1],airIn1. m_flow_in) annotation (Line(points={{277,-46},
            {300,-46},{300,-18},{312,-18}},
                                         color={0,0,127}));
    connect(airCon1.y[2],airIn1. T_in) annotation (Line(points={{277,-46},{
            300,-46},{300,-22},{312,-22}},
                                    color={0,0,127}));
    connect(InteriorSetpoint2.y,TOut1. T) annotation (Line(points={{568.4,-46},
            {570,-46},{570,-74},{576,-74}},
                                       color={0,0,127}));
    connect(TOut1.port,conBel3. port_a)
      annotation (Line(points={{598,-74},{432,-74},{432,-36}}, color={191,0,0}));
    connect(conBel3.port_b,testCell_Radiant_Interior. surf_conBou[1]) annotation (
       Line(points={{452,-36},{446,-36},{446,5.2},{438,5.2}}, color={191,0,0}));
    connect(airIn1.ports[1],testCell_Radiant_Interior. ports[1]) annotation (Line(
          points={{334,-26},{376,-26},{376,9},{417,9}},         color={0,127,255}));
    connect(testCell_Radiant_Interior.ports[2],temRoom1. port_a) annotation (Line(
          points={{417,11},{417,-94},{372,-94},{372,-90}},      color={0,127,255}));
    connect(intGai1.y,testCell_Radiant_Interior. qGai_flow) annotation (Line(
          points={{349,18},{378,18},{378,30},{410.4,30}}, color={0,0,127}));
    connect(oriOutBot1.port_b, volOut1.ports[1])
      annotation (Line(points={{222,92},{243,92}}, color={0,127,255}));
    connect(colRooTop1.port_a, oriOutTop1.port_a) annotation (Line(points={{
            162.5,142},{162,142},{162,162},{205,162}}, color={0,127,255}));
    connect(volOut1.ports[2], colOut1.port_b) annotation (Line(points={{247,
            92},{263,92},{263,122}}, color={0,127,255}));
    connect(colOut1.port_a, oriOutTop1.port_b) annotation (Line(points={{263,
            142},{264,142},{264,162},{225,162}}, color={0,127,255}));
    connect(testCell_Radiant_Interior.ports[3], oriOutBot1.port_a)
      annotation (Line(points={{417,13},{178,13},{178,92},{202,92}}, color={0,
            127,255}));
    connect(testCell_Radiant_Interior.ports[4], colRooTop1.port_b)
      annotation (Line(points={{417,15},{115.5,15},{115.5,122},{162.5,122}},
          color={0,127,255}));
    annotation (Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
                     graphics={
          Ellipse(
            lineColor={75,138,73},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            extent={{-100,-100},{100,100}}),
          Polygon(lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              640,200}})));
  end NatVentRoo;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Validation;
