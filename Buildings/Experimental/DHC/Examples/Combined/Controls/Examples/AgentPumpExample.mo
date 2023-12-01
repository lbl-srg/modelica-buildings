within Buildings.Experimental.DHC.Examples.Combined.Controls.Examples;
model AgentPumpExample
    extends Modelica.Icons.Example;
  .Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(k=273.15 + 10)
    annotation (Placement(transformation(extent={{-98,2},{-78,22}})));
  Modelica.Blocks.Sources.CombiTimeTable HXtemperature(table=[0,14; 60*86400,12;
        210*86400,8; 365*86400,14],  extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-94,38},{-74,58}})));
  Modelica.Blocks.Sources.Constant TSewWat(k=273.15)
    "Sewage water temperature"
    annotation (Placement(transformation(extent={{-94,70},{-74,90}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-24,68},{-4,88}})));
  Modelica.Blocks.Sources.CombiTimeTable HXtemperature1(table=[0,13; 182*86400,
        8; 365*86400,13], extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-92,-36},{-72,-16}})));
  Modelica.Blocks.Sources.CombiTimeTable HXtemperature2(table=[0,8; 182*86400,
        14; 365*86400,8], extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-96,-64},{-76,-44}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{-26,-24},{-6,-4}})));
  Modelica.Blocks.Math.Add add2
    annotation (Placement(transformation(extent={{-24,-66},{-4,-46}})));
  Buildings.Experimental.DHC.Examples.Combined.Controls.AgentPump
    pumPlantControlN(
    yPumMin=0,
    dTnom=0.5,
    k=0.1,
    Ti=600) annotation (Placement(transformation(extent={{46,10},{66,30}})));
equation
  connect(HXtemperature.y[1], add.u2) annotation (Line(points={{-73,48},{-32,48},
          {-32,72},{-26,72}}, color={0,0,127}));
  connect(TSewWat.y, add.u1) annotation (Line(points={{-73,80},{-34,80},{-34,84},
          {-26,84}}, color={0,0,127}));
  connect(HXtemperature2.y[1], add2.u2) annotation (Line(points={{-75,-54},{-34,
          -54},{-34,-62},{-26,-62}}, color={0,0,127}));
  connect(HXtemperature1.y[1], add1.u2) annotation (Line(points={{-71,-26},{-36,
          -26},{-36,-20},{-28,-20}}, color={0,0,127}));
  connect(TSewWat.y, add1.u1) annotation (Line(points={{-73,80},{-62,80},{-62,
          76},{-48,76},{-48,-8},{-28,-8}}, color={0,0,127}));
  connect(add2.u1, add1.u1) annotation (Line(points={{-26,-50},{-46,-50},{-46,
          -8},{-28,-8}}, color={0,0,127}));
  connect(add.y, pumPlantControlN.TSou) annotation (Line(points={{-3,78},{38,78},
          {38,24.3333},{47.4286,24.3333}},
                            color={0,0,127}));
  connect(con1.y, pumPlantControlN.TSouIn) annotation (Line(points={{-76,12},{
          36,12},{36,21.6667},{47.4286,21.6667}},
                                   color={0,0,127}));
  connect(add.y, pumPlantControlN.TsupPla) annotation (Line(points={{-3,78},{2,
          78},{2,18},{47.4286,18},{47.4286,19.1667}}, color={0,0,127}));
  connect(add1.y, pumPlantControlN.TretDis) annotation (Line(points={{-5,-14},{
          42,-14},{42,15.8333},{47.4286,15.8333}}, color={0,0,127}));
  connect(add2.y, pumPlantControlN.TsupDis) annotation (Line(points={{-3,-56},{
          47.4286,-56},{47.4286,12.5}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=31536000, __Dymola_Algorithm="Dassl"));
end AgentPumpExample;
