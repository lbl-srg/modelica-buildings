within Buildings.Fluid.HeatPumps.Examples;
model ReverseWaterToWater "Test model for reverse heat pump based on performance curves"
 package Medium = Buildings.Media.Water "Medium model";

    parameter Data.ReverseWaterToWater.Trane_Axiom_EXW240 per
     "Reverse heat pump performance data"
     annotation (Placement(transformation(extent={{28,68},{48,88}})));
    parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=per.mSou_flow_nominal
     "Source heat exchanger nominal mass flow rate";
    parameter Modelica.SIunits.MassFlowRate mLoa_flow_nominal=per.mLoa_flow_nominal
     "Load heat exchanger nominal mass flow rate";
    parameter Boolean reverseCycle=true
     "= true, if reversing the heat pump to cooling mode is required";

    Buildings.Fluid.HeatPumps.ReverseWaterToWater heaPum(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      redeclare package Medium1 = Medium,
      redeclare package Medium2 = Medium,
      show_T=true,
    dp1_nominal=6000,
    dp2_nominal=6000,
    T1_start=281.4,
      per=per,
      scaling_factor=1,
      reverseCycle=true)
     "Water to Water heat pump"
     annotation (Placement(transformation(extent={{30,-10},{50,10}})));
    Modelica.Blocks.Math.RealToInteger reaToInt
      "Real to integer conversion"
     annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));
    Sources.MassFlowSource_T loaPum(
      use_m_flow_in=false,
      m_flow=mLoa_flow_nominal,
      nPorts=1,
      use_T_in=true,
      redeclare package Medium = Medium)
     "Load Side water pump"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-32,70})));
    Sources.MassFlowSource_T souPum(
      m_flow=mSou_flow_nominal,
      nPorts=1,
      use_T_in=true,
        redeclare package Medium = Medium)
     "Source side water pump"
     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-6})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TLoaEnt(
      height=20,
      duration(displayUnit="h") = 14400,
      offset=20 + 273.15,
      startTime=0)
     "Load side entering water temperature"
     annotation (Placement(transformation(extent={{-94,56},{-74,76}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TSouEnt(
      height=4,
      duration(displayUnit="h") = 14400,
      offset=12 + 273.15,
      startTime=0)
     "Source side entering water temperature"
     annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
    Modelica.Fluid.Sources.FixedBoundary loaVol(
       redeclare package Medium = Medium, nPorts=1)
     "Volume for the load side"
     annotation (Placement(transformation(extent={{100,60},{80,80}})));
    Modelica.Fluid.Sources.FixedBoundary souVol(
       redeclare package Medium = Medium, nPorts=1)
     "Volume for source side"
     annotation (Placement(transformation(extent={{-74,-80},{-54,-60}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp THeaLoaSet(
    height=20,
    duration(displayUnit="h") = 14400,
    offset=40 + 273.15,
    startTime=0)
     "Heating load side setpoint water temperature"
     annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp uMod(
      height=2,
      duration(displayUnit="h") = 14400,
      offset=-1,
      startTime=0)
     "heat pump operational mode input signal"
     annotation (Placement(transformation(extent={{-94,-10},{-74,10}})));
    Controls.OBC.CDL.Continuous.Sources.Ramp TCooSet(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=6 + 273.15,
    startTime=0) if   reverseCycle
     "Cooling load setpoint water temperature"
     annotation (Placement(transformation(extent={{-20,-38},{0,-18}})));
equation
    connect(heaPum.port_a1,loaPum. ports[1])
     annotation (Line(points={{30,6},{22,6},{22,70},{-22,70}},color={0,127,255}));
    connect(TSouEnt.y,souPum. T_in)
     annotation (Line(points={{82,-70},{92,-70},{92,-10},{82,-10}},color={0,0,127}));
    connect(souPum.ports[1], heaPum.port_a2)
     annotation (Line(points={{60,-6},{50,-6}},color={0,127,255}));
    connect(uMod.y, reaToInt.u)
     annotation (Line(points={{-72,0},{-50,0}},color={0,0,127}));
    connect(reaToInt.y, heaPum.uMod)
     annotation (Line(points={{-27,0},{29,0}},color={255,127,0}));
    connect(loaPum.T_in,TLoaEnt. y)
     annotation (Line(points={{-44,66},{-72,66}},color={0,0,127}));
    connect(THeaLoaSet.y, heaPum.THeaLoaSet)
     annotation (Line(points={{2,30},{10,30},{10,9},{28.6,9}},color={0,0,127}));
    connect(TCooSet.y, heaPum.TCooLoaSet)
     annotation (Line(points={{2,-28},{12,-28},{12,-9},{28.6,-9}}, color={0,0,127}));
  connect(heaPum.port_b1, loaVol.ports[1]) annotation (Line(points={{50,6},{60,
          6},{60,70},{80,70}}, color={0,127,255}));
  connect(heaPum.port_b2, souVol.ports[1]) annotation (Line(points={{30,-6},{22,
          -6},{22,-70},{-54,-70}}, color={0,127,255}));
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
  file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/ReverseWaterToWater.mos"
        "Simulate and plot"),
         experiment(Tolerance=1e-6, StopTime=14400),
Documentation(info="<html>
  <p>
  Example that simulates the performance of <a href=\"modelica://Buildings.Fluid.HeatPumps.ReverseWaterToWater\">
  Buildings.Fluid.HeatPumps.ReverseWaterToWater </a> based on the equation fit method.
  The heat pump takes as an input the heating or the chilled leaving water temperature and an integer input to
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
end ReverseWaterToWater;
