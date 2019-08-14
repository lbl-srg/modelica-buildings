within Buildings.Fluid.HeatPumps.Examples;
model EquationFitWaterToWater "example"
 package Medium = Buildings.Media.Water "Medium model";

    parameter Data.EquationFitWaterToWater.Trane_Axiom_EXW240 per
    "HeatPump performance data"
     annotation (Placement(transformation(extent={{28,68},{48,88}})));
    parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal=per.mEva_flow_nominal
    "Evaporator nominal mass flow rate";
    parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal=per.mCon_flow_nominal
    "Condenser nominal mass flow rate";

    Buildings.Fluid.HeatPumps.EquationFitWaterToWater heaPum(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      per=Data.EquationFitWaterToWater.Trane_Axiom_EXW240(),
      redeclare package Medium1 = Medium,
      redeclare package Medium2 = Medium,
      show_T=true,
      dp1_nominal=200,
      dp2_nominal=200,
      SF=1)
    "Water to Water heatpump"
     annotation (Placement(transformation(extent={{28,-10},{48,10}})));
    Modelica.Blocks.Math.RealToInteger reaToInt
     annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
    Sources.MassFlowSource_T conPum(
      use_m_flow_in=false,
      m_flow=mCon_flow_nominal,
      nPorts=1,
      use_T_in=true,
      redeclare package Medium = Medium)
    "Condenser water pump"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-32,70})));
    Sources.MassFlowSource_T evaPum(
      m_flow=mEva_flow_nominal,
      nPorts=1,
      use_T_in=true,
        redeclare package Medium = Medium)
    "Evaporator water pump"
     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-8})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TConEnt(
      height=20,
      duration(displayUnit="h") = 14400,
      offset=20 + 273.15,
      startTime=0)
    "Condesner entering water temperature"
     annotation (Placement(transformation(extent={{-94,56},{-74,76}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TEvaEnt(
      height=4,
      duration(displayUnit="h") = 14400,
      offset=12 + 273.15,
      startTime=0)
    "Evaporator entering water temperature"
     annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
    FixedResistances.PressureDrop res1(
      redeclare package Medium = Medium,
      m_flow_nominal=mCon_flow_nominal,
      dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{56,60},{76,80}})));
    FixedResistances.PressureDrop res2(
      redeclare package Medium = Medium,
       m_flow_nominal=mEva_flow_nominal,
       dp_nominal=6000)
    "Flow resistance"
     annotation (Placement(transformation(extent={{-22,-80},{-2,-60}})));
    Modelica.Fluid.Sources.FixedBoundary heaVol(
       redeclare package Medium = Medium,
       nPorts=1)
    "Volume for heating load"
     annotation (Placement(transformation(extent={{100,60},{80,80}})));
    Modelica.Fluid.Sources.FixedBoundary cooVol(
       redeclare package Medium = Medium,
       nPorts=1)
    "Volume for cooling load"
     annotation (Placement(transformation(extent={{-74,-80},{-54,-60}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TEvaSet(
      height=4,
      duration(displayUnit="h") = 14400,
      offset=6 + 273.15,
      startTime=0)
    "Evaporator setpoint water temperature"
     annotation (Placement(transformation(extent={{-22,-40},{-2,-20}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TConSet(
      height=20,
      duration(displayUnit="h") = 14400,
      offset=40 + 273.15,
      startTime=0)
    "Condenser setpoint water temperature"
     annotation (Placement(transformation(extent={{-22,20},{-2,40}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp uMod(
      height=2,
      duration(displayUnit="h") = 14400,
      offset=-1,
      startTime=0)
    "HeatPump operational mode input signal"
     annotation (Placement(transformation(extent={{-94,-10},{-74,10}})));

equation
  connect(heaPum.port_a1, conPum.ports[1])
  annotation (Line(points={{31.3333,6},{22,6},{22,70},{-22,70}},color={0,127,255}));
  connect(TEvaEnt.y, evaPum.T_in)
  annotation (Line(points={{82,-70},{92,-70},{92,-12},{82,-12}},color={0,0,127}));
  connect(evaPum.ports[1], heaPum.port_a2)
  annotation (Line(points={{60,-8},{54,-8},{54,-6},{48,-6}},color={0,127,255}));
  connect(cooVol.ports[1], res2.port_a)
  annotation (Line(points={{-54,-70},{-22,-70}}, color={0,127,255}));
  connect(res1.port_a, heaPum.port_b1)
  annotation (Line(points={{56,70},{56,6},{48,6}},color={0,127,255}));
  connect(res2.port_b, heaPum.port_b2)
  annotation (Line(points={{-2,-70},{22,-70},{22,-6},{31.3333,-6}},
                  color={0,127,255}));
  connect(TConSet.y, heaPum.TConSet)
  annotation (Line(points={{0,30},{14,30},{14,9},{30.1667,9}},
                  color={0,0,127}));
  connect(TEvaSet.y, heaPum.TEvaSet)
  annotation (Line(points={{0,-30},{14,-30},{14,-9},{30.1667,-9}},
                  color={0,0,127}));
  connect(res1.port_b, heaVol.ports[1])
  annotation (Line(points={{76,70},{80,70}},         color={0,127,255}));
  connect(uMod.y, reaToInt.u)
  annotation (Line(points={{-72,0},{-64,0}}, color={0,0,127}));
  connect(reaToInt.y, heaPum.uMod)
  annotation (Line(points={{-41,0},{-6,0},{-6,2.22045e-16},{30.1667,2.22045e-16}},
                  color={255,127,0}));
  connect(conPum.T_in, TConEnt.y) annotation (Line(points={{-44,66},{-72,66}},
                  color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{120,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-98,-100},{98,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),
              Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
             __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/EquationFitWaterToWater.mos"
        "Simulate and plot"),
         experiment(Tolerance=1e-6, StopTime=14400),
Documentation(info="<html>
  <p>
  Example that simulates the performance of <a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitWaterToWater\">
  Buildings.Fluid.HeatPumps.EquationFitWaterToWater </a> based on the equation fit method.
  The heat pump takes as an input the condenser or the evaporator leaving water temperature and an integer input to
  specify the heat pump operational mode.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
June 18, 2019, by Hagar Elarga:<br/>
First implementation.
 </li>
 </ul>
 </html>"));
end EquationFitWaterToWater;
