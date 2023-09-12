within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Validation;
model DirectCalculations
  "Validation of the DirectCalculations block"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Area padAre = 0.6
    "Area of the rigid media evaporative pad";

  parameter Modelica.Units.SI.Length dep = 0.2
    "Depth of the rigid media evaporative pad";

  parameter Modelica.Units.SI.Length preAtm = 101325
    "Atmospheric pressure";

  parameter Modelica.Units.SI.ThermodynamicTemperature TSupDb_nominal = 296.15
    "Nominal supply air drybulb temperature";

  parameter Modelica.Units.SI.ThermodynamicTemperature TSupWb_nominal = 289.3
    "Nominal supply air wetbulb temperature";

  parameter Modelica.Units.SI.VolumeFlowRate VAir_flow_nominal = 1
    "Nominal supply air volume flowrate";

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations
    dirEvaCoo(redeclare package Medium = Buildings.Media.Air,
    padAre=padAre,
    dep=dep) "Instance with time-varying volume flowrate signal"
                             annotation (Placement(visible=true, transformation(
        origin={30,50},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations
    dirEvaCoo1(redeclare package Medium = Buildings.Media.Air,
    padAre=padAre,
    dep=dep) "Instance with time-varying wetbulb temperature signal"
                                                               annotation (
      Placement(visible=true, transformation(
        origin={30,0},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations
    dirEvaCoo2(redeclare package Medium = Buildings.Media.Air,
    padAre=padAre,
    dep=dep) "Instance with time-varying drybulb temperature signal"
                                                               annotation (
      Placement(visible=true, transformation(
        origin={30,-50},
        extent={{-10,-10},{10,10}},
        rotation=0)));

protected
  Modelica.Blocks.Sources.Constant conTSupWb(k=TSupWb_nominal)
    "Constant wet bulb temperature signal" annotation (Placement(visible=true,
        transformation(
        origin={-80,80},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Modelica.Blocks.Sources.Constant conTSupDb(k=TSupDb_nominal)
    "Constant drybulb temperature signal" annotation (Placement(visible=true,
        transformation(
        origin={-80,30},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Modelica.Blocks.Sources.Ramp ramTsupWb(
    duration=60,
    height=5,
    offset=TSupWb_nominal,
    startTime=0) "Ramp signal for wet-bulb temperature" annotation (Placement(
        visible=true, transformation(
        origin={-10,20},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Sources.Ramp ramTSupDb(
    duration=60,
    height=15,
    offset=TSupDb_nominal,
    startTime=0) "Ramp signal for drybulb temperature" annotation (Placement(
        visible=true, transformation(
        origin={-10,-26},
        extent={{-10,-10},{10,10}},
        rotation=0)));

Modelica.Blocks.Sources.Constant conVol_flow(k=VAir_flow_nominal)
    "Constant volume flowrate signal" annotation (Placement(visible=true,
        transformation(
        origin={-80,-30},
        extent={{-10,-10},{10,10}},
        rotation=0)));
Modelica.Blocks.Sources.Ramp ramVol_flow(
    duration=60,
    height=0.5,
    offset=VAir_flow_nominal,
    startTime=0) "Ramp signal for volume flowrate" annotation (Placement(
        visible=true, transformation(
        origin={-10,80},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Sources.Constant conPre(k=preAtm) "Constant pressure signal"
    annotation (Placement(visible=true, transformation(
        origin={-80,-80},
        extent={{-10,-10},{10,10}},
        rotation=0)));
equation
  connect(conTSupWb.y, dirEvaCoo.TWetBulIn) annotation (Line(points={{-69,80},{-40,
          80},{-40,56},{18,56}}, color={0,0,127}));
  connect(conTSupDb.y, dirEvaCoo.TDryBulIn) annotation (Line(points={{-69,30},{-30,
          30},{-30,52},{18,52}}, color={0,0,127}));
  connect(ramVol_flow.y, dirEvaCoo.V_flow) annotation (Line(points={{1,80},{10,80},
          {10,48},{18,48}}, color={0,0,127}));
  connect(ramTsupWb.y, dirEvaCoo1.TWetBulIn)
    annotation (Line(points={{1,20},{10,20},{10,6},{18,6}}, color={0,0,127}));
  connect(conVol_flow.y, dirEvaCoo1.V_flow) annotation (Line(points={{-69,-30},{
          -60,-30},{-60,-2},{18,-2}}, color={0,0,127}));
  connect(conPre.y, dirEvaCoo.p) annotation (Line(points={{-69,-80},{-50,-80},{-50,
          44},{18,44}}, color={0,0,127}));
  connect(ramTSupDb.y, dirEvaCoo2.TDryBulIn) annotation (Line(points={{1,-26},{10,
          -26},{10,-48},{18,-48}}, color={0,0,127}));
  connect(conTSupWb.y, dirEvaCoo2.TWetBulIn) annotation (Line(points={{-69,80},{
          -40,80},{-40,-44},{18,-44}}, color={0,0,127}));
  connect(conTSupDb.y, dirEvaCoo1.TDryBulIn) annotation (Line(points={{-69,30},{
          -30,30},{-30,2},{18,2}}, color={0,0,127}));
  connect(conVol_flow.y, dirEvaCoo2.V_flow) annotation (Line(points={{-69,-30},{
          -60,-30},{-60,-52},{18,-52}}, color={0,0,127}));
  connect(conPre.y, dirEvaCoo1.p) annotation (Line(points={{-69,-80},{-50,-80},{
          -50,-6},{18,-6}}, color={0,0,127}));
  connect(conPre.y, dirEvaCoo2.p) annotation (Line(points={{-69,-80},{-50,-80},{
          -50,-56},{18,-56}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>This model implements a validation of the block <a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations</a> that applies the peformance curve to calucalte the water mass flow rate. </p>
</html>"),
experiment(
    StopTime=60,
    Interval=1),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/Baseclasses/Validation/DirectCalculations.mos"
        "Simulate and plot"));
end DirectCalculations;
