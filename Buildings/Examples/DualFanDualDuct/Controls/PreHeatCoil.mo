within Buildings.Examples.DualFanDualDuct.Controls;
model PreHeatCoil "Controller for preheat coil"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.Continuous.LimPID preHeaCoiCon(
    yMax=1,
    yMin=0,
    Td=60,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    Ti=120,
    strict=true,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1) "Controller for pre-heating coil"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Modelica.Blocks.Sources.Constant zero(k=0) "Zero output signal"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Logical.Switch swiPumPreCoi "Switch for preheat coil pump"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Modelica.Blocks.Logical.OnOffController preHeaOn(bandwidth=1)
    "Switch to enable preheat coil"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Constant TPreHeaOn(k=273.15 + 10)
    "Temperature when preheat coil is switched on."
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Constant one(k=1) "Outputs 1"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Interfaces.RealInput TAirSup(unit="K")
    "Supply air temperature after the coil" annotation (Placement(
        transformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealInput TSupSetHea(unit="K")
    "Heating set point temperature for supply air" annotation (Placement(
        transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealOutput yVal(unit="1")
    "Control signal for valve" annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Interfaces.RealInput TMix(unit="K")
    "Mixed air temperature upstream of coil" annotation (Placement(
        transformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealOutput yPum(unit="1")
    "Control signal for pump" annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Logical.Switch swiValOp
    "Switch to close valve if pump is not running"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Modelica.StateGraph.InitialStep pumOff "Pump is off"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.StateGraph.TransitionWithSignal toOn "Switch pump on"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
    inner Modelica.StateGraph.StateGraphRoot
                         stateGraphRoot
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.StateGraph.StepWithSignal pumOn "Pump on"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.StateGraph.TransitionWithSignal toOff(enableTimer=true, waitTime=30*
        60) "Switch pump off"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
equation
  connect(preHeaOn.reference,TPreHeaOn. y) annotation (Line(points={{-42,36},{
          -52,36},{-52,40},{-59,40}},    color={0,0,127}));
  connect(zero.y, swiPumPreCoi.u3) annotation (Line(
      points={{1,-30},{40,-30},{40,2},{58,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(one.y, swiPumPreCoi.u1) annotation (Line(
      points={{1,0},{30,0},{30,18},{58,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TAirSup, preHeaCoiCon.u_m) annotation (Line(points={{-110,-60},{-110,
          -60},{-90,-60},{-90,-80},{-10,-80},{-10,-72}},
                                                   color={0,0,127}));
  connect(TSupSetHea, preHeaCoiCon.u_s) annotation (Line(points={{-110,0},{-80,
          0},{-80,-60},{-22,-60}},                 color={0,0,127}));
  connect(TMix, preHeaOn.u) annotation (Line(points={{-110,60},{-110,60},{-94,
          60},{-94,24},{-42,24}},               color={0,0,127}));
  connect(yPum, swiPumPreCoi.y) annotation (Line(points={{110,50},{88,50},{88,
          10},{81,10}},
                    color={0,0,127}));
  connect(zero.y, swiValOp.u3) annotation (Line(points={{1,-30},{16,-30},{40,
          -30},{40,-68},{58,-68}},
                                color={0,0,127}));
  connect(swiValOp.y, yVal)
    annotation (Line(points={{81,-60},{90,-60},{90,-50},{98,-50},{110,-50}},
                                                            color={0,0,127}));
  connect(pumOff.outPort[1], toOn.inPort)
    annotation (Line(points={{-19.5,70},{-11.75,70},{-4,70}}, color={0,0,0}));
  connect(toOn.condition, preHeaOn.y)
    annotation (Line(points={{0,58},{0,30},{-19,30}}, color={255,0,255}));
  connect(pumOn.inPort[1], toOn.outPort)
    annotation (Line(points={{19,70},{1.5,70}}, color={0,0,0}));
  connect(toOff.inPort, pumOn.outPort[1])
    annotation (Line(points={{66,70},{40.5,70}}, color={0,0,0}));
  connect(preHeaOn.y, not1.u)
    annotation (Line(points={{-19,30},{-19,30},{8,30}}, color={255,0,255}));
  connect(not1.y, toOff.condition)
    annotation (Line(points={{31,30},{70,30},{70,58}}, color={255,0,255}));
  connect(toOff.outPort, pumOff.inPort[1]) annotation (Line(points={{71.5,70},{
          88,70},{88,92},{-50,92},{-50,70},{-41,70}}, color={0,0,0}));
  connect(pumOn.active, swiPumPreCoi.u2) annotation (Line(points={{30,59},{30,
          59},{30,52},{36,52},{48,52},{48,10},{58,10}}, color={255,0,255}));
  connect(pumOn.active, swiValOp.u2) annotation (Line(points={{30,59},{30,52},{
          48,52},{48,-60},{58,-60}}, color={255,0,255}));
  connect(preHeaCoiCon.y, swiValOp.u1) annotation (Line(points={{1,-60},{20,-60},
          {20,-52},{58,-52}}, color={0,0,127}));
  annotation (    Documentation(info="<html>
<p>
Controller for the preheat coil. If the air inlet temperature is below
a minimum temperature, such as <i>10</i>&deg;C, the preheat coil is activated.
It then switches the pump on, and regulates the valve
to meet the set point temperature for the supply air.
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PreHeatCoil;
