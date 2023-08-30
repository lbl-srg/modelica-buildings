within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Validation;
model DirectCalculations
  Modelica.Blocks.Sources.Constant Tsupwb(k = 286) annotation (
    Placement(visible = true, transformation(origin = {-80, 118}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Tsupdb(k = 305) annotation (
    Placement(visible = true, transformation(origin = {-80, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Tsupdb1(k = 305) annotation (
    Placement(visible = true, transformation(origin = {20, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Tsupwb2(k = 286) annotation (
    Placement(visible = true, transformation(origin = {36, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp Tsupwb1(duration = 60, height = 20, offset = 286, startTime = 0) annotation (
    Placement(visible = true, transformation(origin = {20, 116}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp Tsupdb2(duration = 60, height = 40, offset = 273, startTime = 0) annotation (
    Placement(visible = true, transformation(origin = {36, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  .Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations
    directEvapCooler(redeclare package Medium = Buildings.Media.Air)
    annotation (Placement(visible=true, transformation(
        origin={-34,48},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  .Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations
    directEvapCooler1(redeclare package Medium = Buildings.Media.Air)
    annotation (Placement(visible=true, transformation(
        origin={74,58},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  .Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations
    directEvapCooler2(redeclare package Medium = Buildings.Media.Air)
    annotation (Placement(visible=true, transformation(
        origin={134,-20},
        extent={{-10,-10},{10,10}},
        rotation=0)));
Modelica.Blocks.Sources.Constant Vol_flow1(k = 10) annotation (
    Placement(visible = true, transformation(origin = {20, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Blocks.Sources.Constant Vol_flow2(k = 10) annotation (
    Placement(visible = true, transformation(origin = {38, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Blocks.Sources.Ramp Vol_flow(duration = 60, height = 5, offset = 10, startTime = 0) annotation (
    Placement(visible = true, transformation(origin = {-80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  .Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations
    directEvapCooler3(redeclare package Medium = Buildings.Media.Air)
    annotation (Placement(visible=true, transformation(
        origin={-22,-34},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Sources.Constant Tsupwb3(k = 286) annotation (
    Placement(visible = true, transformation(origin = {-82, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Tsupdb3(k = 305) annotation (
    Placement(visible = true, transformation(origin = {-82, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Vol_flow3(k = 10) annotation (
    Placement(visible = true, transformation(origin = {-82, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant pressure2(k = 10) annotation (
    Placement(visible = true, transformation(origin = {22, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant pressure(k = 10) annotation (
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant pressure_3(k = 10) annotation (
    Placement(visible = true, transformation(origin = {40, -116}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp pressure_variable(duration = 60, height = 5, offset = 10, startTime = 0) annotation (
    Placement(visible = true, transformation(origin = {-84, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
connect(Tsupwb.y, directEvapCooler.Tsupwb) annotation (
    Line(points={{-69,118},{-52,118},{-52,56.2},{-45.8,56.2}},    color = {0, 0, 127}));
connect(Tsupdb.y, directEvapCooler.Tsupdp) annotation (
    Line(points={{-69,84},{-54,84},{-54,51.2},{-46,51.2}},      color = {0, 0, 127}));
connect(Vol_flow.y, directEvapCooler.Vol_Flow) annotation (
    Line(points={{-69,50},{-54,50},{-54,46.2},{-46,46.2}},      color = {0, 0, 127}));
connect(Tsupwb1.y, directEvapCooler1.Tsupwb) annotation (
    Line(points={{31,116},{46,116},{46,66.2},{62.2,66.2}},    color = {0, 0, 127}));
connect(Tsupdb1.y, directEvapCooler1.Tsupdp) annotation (
    Line(points={{31,82},{50,82},{50,61.2},{62,61.2}},      color = {0, 0, 127}));
connect(Vol_flow1.y, directEvapCooler1.Vol_Flow) annotation (
    Line(points={{31,50},{54,50},{54,56.2},{62,56.2}},      color = {0, 0, 127}));
  connect(pressure.y, directEvapCooler.pressure) annotation (
    Line(points = {{-68, 20}, {-56, 20}, {-56, 42}, {-46, 42}}, color = {0, 0, 127}));
  connect(pressure2.y, directEvapCooler1.pressure) annotation (
    Line(points = {{34, 20}, {56, 20}, {56, 52}, {62, 52}}, color = {0, 0, 127}));
  connect(Tsupwb2.y, directEvapCooler2.Tsupwb) annotation (
    Line(points = {{48, -16}, {54, -16}, {54, -12}, {122, -12}}, color = {0, 0, 127}));
  connect(Tsupdb2.y, directEvapCooler2.Tsupdp) annotation (
    Line(points = {{48, -50}, {96, -50}, {96, -16}, {122, -16}}, color = {0, 0, 127}));
  connect(Vol_flow2.y, directEvapCooler2.Vol_Flow) annotation (
    Line(points = {{50, -84}, {112, -84}, {112, -22}, {122, -22}}, color = {0, 0, 127}));
  connect(pressure_3.y, directEvapCooler2.pressure) annotation (
    Line(points = {{52, -116}, {116, -116}, {116, -26}, {122, -26}}, color = {0, 0, 127}));
  connect(Tsupwb3.y, directEvapCooler3.Tsupwb) annotation (
    Line(points = {{-70, -16}, {-42, -16}, {-42, -26}, {-34, -26}}, color = {0, 0, 127}));
  connect(Tsupdb3.y, directEvapCooler3.Tsupdp) annotation (
    Line(points = {{-70, -50}, {-50, -50}, {-50, -30}, {-34, -30}}, color = {0, 0, 127}));
  connect(Vol_flow3.y, directEvapCooler3.Vol_Flow) annotation (
    Line(points = {{-70, -86}, {-42, -86}, {-42, -36}, {-34, -36}}, color = {0, 0, 127}));
  connect(pressure_variable.y, directEvapCooler3.pressure) annotation (
    Line(points = {{-72, -120}, {-40, -120}, {-40, -40}, {-34, -40}}, color = {0, 0, 127}));
end DirectCalculations;
