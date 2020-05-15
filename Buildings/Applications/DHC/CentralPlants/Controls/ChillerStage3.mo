within Buildings.Applications.DHC.CentralPlants.Controls;
model ChillerStage3 "Stage controller for chillers"
  parameter Real tWai "Waiting time";

  parameter Real thehol "Threshold";

  parameter Real CooCap "Normal Cooling Capacity";

  Modelica.Blocks.Interfaces.RealOutput y[3](min=0, max=2)
    "Output of stage control"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.StateGraph.StepWithSignal
                            AllOff(
    nOut=1, nIn=1) "Both of the two compressors are off"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={0,70})));
  Modelica.Blocks.Interfaces.BooleanInput
                                       on "On signal of the chillers"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput Status[3] "Compressor speed ratio"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.StateGraph.InitialStepWithSignal
                                     OneOn(       nOut=2, nIn=3)
                                                          annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,18})));
  Modelica.StateGraph.StepWithSignal TwoOn(nIn=3, nOut=3) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-20})));
  Modelica.StateGraph.Transition Off2One(condition=on) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,44})));
  Modelica.StateGraph.Transition One2Two(
    enableTimer=true,
    waitTime=tWai,
    condition=PLR1.y > thehol*0.9 and OneOn.active)
                   annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,0})));
  Modelica.StateGraph.Transition Two2One(
    enableTimer=true,
    waitTime=tWai,
    condition=(PLR1.y < thehol*0.9/2 and PLR2.y < thehol*0.9/2 and TwoOn.active))
                               annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={54,6})));
  Modelica.StateGraph.Transition One2Off(condition=not on) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={52,48})));
  Modelica.StateGraph.StepWithSignal ThreeOn(nOut=2)
                                             annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-70})));
  Modelica.StateGraph.Transition Two2Three(
    enableTimer=true,
    waitTime=tWai,
    condition=PLR1.y > thehol and PLR2.y > thehol and TwoOn.active)
                   annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,-50})));
  Modelica.StateGraph.Transition Three2Two(
    waitTime=tWai,
    enableTimer=true,
    condition=(PLR1.y < thehol*0.9*2/3 and PLR2.y < thehol*0.9*2/3 and PLR3.y < thehol*0.9*2/3 and
        ThreeOn.active))                                  annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={50,-62})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  WaterSide.BaseClasses.Control.MultiSwitch multiSwitch1(nu=4, expr={0,1,2,3})
    annotation (Placement(transformation(extent={{60,-34},{76,-14}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D(table=[0,0,0,0; 1,1,0,0; 2,
        1,1,0; 3,1,1,1])
    annotation (Placement(transformation(extent={{84,-70},{104,-50}})));
  Modelica.StateGraph.Transition Two2One_short(condition=not on) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={84,6})));
  Modelica.StateGraph.Transition Three2Two_short(
    waitTime=tWai,
    enableTimer=false,
    condition=not on) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={80,-80})));
  Modelica.Blocks.Interfaces.RealInput CooLoa
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Sources.RealExpression PLR1(y=CooLoa/CooCap/(Status[1] +
        Status[2] + Status[3]))
    annotation (Placement(transformation(extent={{-94,12},{-74,32}})));
  Modelica.Blocks.Sources.RealExpression PLR2(y=if Status[3] > 0 then CooLoa/3/
        CooCap else (if Status[2] > 0 then CooLoa/2/CooCap else 0))
    annotation (Placement(transformation(extent={{-92,-10},{-72,10}})));
  Modelica.Blocks.Sources.RealExpression PLR3(y=if Status[3] > 0 then CooLoa/3/
        CooCap else 0)
    annotation (Placement(transformation(extent={{-92,-30},{-72,-10}})));
equation
  connect(AllOff.outPort[1], Off2One.inPort) annotation (Line(points={{0,59.5},
          {0,59.5},{0,54},{0,52},{-50,52},{-50,48}}, color={0,0,0}));
  connect(Off2One.outPort, OneOn.inPort[1]) annotation (Line(points={{-50,42.5},
          {-50,36},{-0.666667,36},{-0.666667,29}},
                                         color={0,0,0}));
  connect(OneOn.outPort[1], One2Two.inPort) annotation (Line(points={{-0.25,7.5},
          {-0.25,8},{-50,8},{-50,4}}, color={0,0,0}));
  connect(One2Two.outPort, TwoOn.inPort[1]) annotation (Line(points={{-50,-1.5},
          {-50,-6},{-0.666667,-6},{-0.666667,-9}},
                                         color={0,0,0}));
  connect(TwoOn.outPort[1], Two2Three.inPort) annotation (Line(points={{
          -0.333333,-30.5},{-0.333333,-40},{-50,-40},{-50,-46}},
                                                   color={0,0,0}));
  connect(Two2Three.outPort, ThreeOn.inPort[1]) annotation (Line(points={{-50,-51.5},
          {-50,-56},{0,-56},{0,-59}}, color={0,0,0}));
  connect(ThreeOn.outPort[1], Three2Two.inPort) annotation (Line(points={{-0.25,
          -80.5},{-0.25,-88},{50,-88},{50,-66}},
                                      color={0,0,0}));
  connect(Three2Two.outPort, TwoOn.inPort[2]) annotation (Line(points={{50,
          -60.5},{50,-60.5},{50,-6},{7.21645e-016,-6},{7.21645e-016,-9}},
                                                        color={0,0,0}));
  connect(Two2One.outPort, OneOn.inPort[2]) annotation (Line(points={{54,7.5},{
          54,7.5},{54,32},{7.21645e-016,32},{7.21645e-016,29}},
                                              color={0,0,0}));
  connect(One2Off.outPort, AllOff.inPort[1]) annotation (Line(points={{52,49.5},
          {52,49.5},{52,86},{52,88},{1.9984e-015,88},{1.9984e-015,81}}, color={
          0,0,0}));
  connect(OneOn.outPort[2], One2Off.inPort) annotation (Line(points={{0.25,7.5},
          {2,7.5},{2,0},{30,0},{30,38},{52,38},{52,44}}, color={0,0,0}));
  connect(Two2One.inPort, TwoOn.outPort[2]) annotation (Line(points={{54,2},{54,
          -40},{-6.10623e-016,-40},{-6.10623e-016,-30.5}},
                                         color={0,0,0}));
  connect(multiSwitch1.u[2], OneOn.active) annotation (Line(points={{60,-23.25},
          {36,-23.25},{36,18},{11,18}}, color={255,0,255}));
  connect(TwoOn.active, multiSwitch1.u[3]) annotation (Line(points={{11,-20},{
          24,-20},{24,-24.75},{60,-24.75}},
                                         color={255,0,255}));
  connect(ThreeOn.active, multiSwitch1.u[4]) annotation (Line(points={{11,-70},
          {34,-70},{52,-70},{52,-26.25},{60,-26.25}},color={255,0,255}));
  connect(AllOff.active, multiSwitch1.u[1]) annotation (Line(points={{11,70},{
          24,70},{44,70},{44,-21.75},{60,-21.75}},
                                                color={255,0,255}));
  connect(combiTable1D.y, y) annotation (Line(points={{105,-60},{116,-60},{116,
          -22},{88,-22},{88,0},{110,0}}, color={0,0,127}));
  connect(multiSwitch1.y, combiTable1D.u) annotation (Line(points={{76.4,-24},{
          78,-24},{78,-60},{82,-60}}, color={0,0,127}));
  connect(ThreeOn.outPort[2], Three2Two_short.inPort) annotation (Line(points={
          {0.25,-80.5},{2,-80.5},{2,-92},{2,-94},{80,-94},{80,-84}}, color={0,0,
          0}));
  connect(Three2Two_short.outPort, TwoOn.inPort[3]) annotation (Line(points={{
          80,-78.5},{80,-9},{0.666667,-9}}, color={0,0,0}));
  connect(Two2One_short.inPort, TwoOn.outPort[3]) annotation (Line(points={{84,
          2},{84,-34},{0.333333,-34},{0.333333,-30.5}}, color={0,0,0}));
  connect(Two2One_short.outPort, OneOn.inPort[3]) annotation (Line(points={{84,
          7.5},{84,7.5},{84,52},{6,52},{6,29},{0.666667,29}}, color={0,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255})}),
    Documentation(revisions="<html>
<ul>
<li>
March 19, 2014 by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerStage3;
