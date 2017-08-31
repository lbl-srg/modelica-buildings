within Buildings.ChillerWSE.Examples.BaseClasses;
partial model DataCenterControl
  "Example that implements a chilled water cooling system with controls for a data center room"
  extends Buildings.ChillerWSE.Examples.BaseClasses.DataCenter;

  Modelica.Blocks.Sources.Constant CHWSTSet(k(
    final unit="K",
    displayUnit="degC") = 279.71)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-190,150},{-170,170}})));
  Buildings.ChillerWSE.Examples.BaseClasses.Controls.ChillerStageControl
    chiStaCon(QEva_nominal=-300*3517, tWai=0)
    "Chiller staging control"
    annotation (Placement(transformation(extent={{-50,130},{-30,150}})));
  Modelica.Blocks.Math.RealToBoolean chiOn[numChi](each threshold=0.5)
    "Real value to boolean value"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Modelica.Blocks.Math.RealToBoolean reaToBoo(threshold=1.5)
    "Inverse on/off signal for the WSE"
    annotation (Placement(transformation(extent={{-50,100},{-30,120}})));
  Modelica.Blocks.Logical.Not wseOn
    "True: WSE is on; False: WSE is off "
    annotation (Placement(transformation(extent={{-10,100},{10,120}})));
  Buildings.ChillerWSE.Examples.BaseClasses.Controls.ConstantSpeedPumpStageControl
    CWPumCon(tWai=0)
    "Condenser water pump controller"
    annotation (Placement(transformation(extent={{-52,60},{-32,80}})));
  Modelica.Blocks.Sources.RealExpression chiNumOn(y=sum(chiStaCon.y))
    "The number of running chillers"
    annotation (Placement(transformation(extent={{-182,64},{-162,84}})));
  Modelica.Blocks.Math.Gain gai[numChi](each k=m1_flow_chi_nominal)
    "Gain effect"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingTowerSpeedControl
    cooTowSpeCon(controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=40,
    k=5)
    "Cooling tower speed control"
    annotation (Placement(transformation(extent={{-50,170},{-30,186}})));
  Modelica.Blocks.Sources.Constant CWSTSet(k(
    final unit="K",
    displayUnit="degC") = 293.15)
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-130,170},{-110,190}})));

  Modelica.Blocks.Sources.Constant SATSet(k(
    final unit="K",
    displayUnit="degC") = 289.15)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-98},{-60,-78}})));
  Modelica.Blocks.Sources.Constant SAXSet(k(
    final unit="1") = MediumA.X_default[1])
    "Supply air mass fraction setpoint"
    annotation (Placement(transformation(extent={{-12,-136},{8,-116}})));
  Modelica.Blocks.Sources.Constant uFan(k = 1)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-12,-176},{8,-156}})));
  Buildings.ChillerWSE.Examples.BaseClasses.Controls.VariableSpeedPumpStageControl
    varSpeCon(tWai=tWai, m_flow_nominal=m2_flow_chi_nominal)
    "Speed controller"
    annotation (Placement(transformation(extent={{-48,-14},{-28,6}})));
  Modelica.Blocks.Sources.RealExpression mPum_flow(y=chiWSE.port_b2.m_flow)
    "Mass flowrate of variable speed pumps"
    annotation (Placement(transformation(extent={{-126,-6},{-106,14}})));
  Buildings.Controls.Continuous.LimPID pumSpe(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=40,
    yMin=0.2) "Pump speed controller"
    annotation (Placement(transformation(extent={{-126,-30},{-106,-10}})));
  Modelica.Blocks.Sources.Constant dpSet(k=0.3*dp2_chi_nominal)
    "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{-176,-30},{-156,-10}})));
  Modelica.Blocks.Math.Product pumSpeSig[numChi] "Pump speed signal"
    annotation (Placement(transformation(extent={{-4,-22},{12,-6}})));
  Buildings.Controls.Continuous.LimPID ahuValSig(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=40,
    yMin=0.2,
    reverseAction=true) "Valve position signal for the AHU"
    annotation (Placement(transformation(extent={{-12,-98},{8,-78}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort SAT(
    redeclare replaceable package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal) "Supply air temperature"
    annotation (Placement(transformation(extent={{114,-150},{94,-130}})));
  Modelica.Blocks.Math.Product cooTowSpe[numChi]
    "Cooling tower speed"
    annotation (Placement(transformation(extent={{60,166},{76,182}})));
equation
  connect(chiWSE.port_b2, CHWST.port_a)
    annotation (Line(
      points={{126,26},{112,26},{112,0},{104,0}},
      color={0,127,255},
      thickness=0.5));
  connect(weaData.weaBus, weaBus.TWetBul)
    annotation (Line(
      points={{-200,-68},{-200,-28}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(chiWSE.port_b1, CWRT.port_a)
    annotation (Line(
      points={{146,38},{160,38},{160,60},{202,60}},
      color={0,127,255},
      thickness=0.5));
  connect(CWRT.port_b, expVesCW.port_a)
    annotation (Line(
      points={{222,60},{240,60},{240,125}},
      color={0,127,255},
      thickness=0.5));
   for i in 1:numChi loop
    connect(CWST.port_a, cooTow[i].port_b)
      annotation (Line(points={{120,140},{132,
            140},{132,139},{131,139}}, color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_b, chiWSE.port_a1)
      annotation (Line(
        points={{70,90},{70,58},{110,58},{110,38},{126,38}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_a, CWST.port_b)
      annotation (Line(points={{70,110},{70,
            140},{100,140}},color={0,127,255},
        thickness=0.5));
    connect(chiOn[i].y, chiWSE.on[i])
      annotation (Line(points={{11,140},{40,140},
            {40,39.6},{124.4,39.6}}, color={255,0,255}));
   connect(cooTowSpeCon.y, cooTowSpe[i].u1)
     annotation (Line(points={{-29,178.889},{36,178.889},{36,178.8},{58.4,178.8}},
                                                  color={0,0,127}));
   end for;
  connect(chiStaCon.y, chiOn.u)
    annotation (Line(points={{-29,140},{-20.5,140},{
          -12,140}},  color={0,0,127}));
  connect(reaToBoo.y, wseOn.u)
    annotation (Line(points={{-29,110},{-20.5,110},{-12,
          110}},color={255,0,255}));
  connect(wseOn.y, chiWSE.on[numChi + 1])
    annotation (Line(points={{11,110},{40,110},
          {40,39.6},{124.4,39.6}}, color={255,0,255}));
  connect(chiNumOn.y, CWPumCon.chiNumOn)
    annotation (Line(points={{-161,74},{-161,74},{-54,74}},
       color={0,0,127}));
  connect(CWPumCon.y, gai.u)
    annotation (Line(points={{-31,70},{-12,70}},       color={0,0,127}));
  connect(gai.y, pumCW.m_flow_in)
    annotation (Line(points={{11,70},{40,70},{40,100},
          {58,100}}, color={0,0,127}));
  connect(CWSTSet.y, cooTowSpeCon.CWSTSet) annotation (Line(points={{-109,180},
          {-70,180},{-70,186},{-52,186}}, color={0,0,127}));
  connect(CHWSTSet.y, cooTowSpeCon.CHWSTSet) annotation (Line(points={{-169,160},
          {-150,160},{-150,200},{-70,200},{-70,178.889},{-52,178.889}}, color={
          0,0,127}));
  connect(CWST.T, cooTowSpeCon.CWST)
    annotation (Line(points={{110,151},{110,160},{122,160},{122,200},{-70,200},
          {-70,175.333},{-52,175.333}},
          color={0,0,127}));
  connect(CHWST.T, cooTowSpeCon.CHWST)
    annotation (Line(points={{94,11},{94,36},{40,36},{40,200},{-70,200},{-70,
          171.778},{-52,171.778}},
          color={0,0,127}));
  connect(chiWSE.TSet, CHWSTSet.y)
    annotation (Line(points={{124.4,42.8},{40,42.8},
          {40,200},{-150,200},{-150,160},{-169,160}}, color={0,0,127}));
  connect(SAXSet.y, ahu.XSet_w)
    annotation (Line(points={{9,-126},{60,-126},{60,-119},{153,-119}},
      color={0,0,127}));
  connect(uFan.y, ahu.uFan)
    annotation (Line(points={{9,-166},{60,-166},{60,-124},
          {153,-124}},color={0,0,127}));
  connect(expVesChi.port_a, ahu.port_b1)
    annotation (Line(
      points={{270,-59},{270,-59},{270,-114},{174,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(mPum_flow.y, varSpeCon.masFloPum)
    annotation (Line(points={{-105,4},{-50,4}},color={0,0,127}));
  connect(senRelPre.port_a, ahu.port_a1)
    annotation (Line(points={{150,-96},{72,-96},{72,-114},{154,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(pumSpe.y, varSpeCon.speSig)
    annotation (Line(points={{-105,-20},{-76,-20},
          {-76,0},{-50,0}}, color={0,0,127}));
  connect(senRelPre.p_rel, pumSpe.u_m)
    annotation (Line(points={{160,-87},{162,-87},{162,-66},{-116,-66},{-116,-32}},
      color={0,0,127}));
  connect(dpSet.y, pumSpe.u_s)
    annotation (Line(points={{-155,-20},{-128,-20}},color={0,0,127}));
  connect(pumSpe.y, pumSpeSig[1].u2)
    annotation (Line(points={{-105,-20},{-76,-20},
          {-76,-34},{-16,-34},{-16,-18.8},{-5.6,-18.8}},
          color={0,0,127}));
  connect(pumSpe.y, pumSpeSig[2].u2)
    annotation (Line(points={{-105,-20},{-105,-20},
          {-76,-20},{-76,-34},{-16,-34},{-16,-18.8},{-5.6,-18.8}},
          color={0,0,127}));
  connect(varSpeCon.y, pumSpeSig.u1)
    annotation (Line(points={{-27,-4},{-27,-4},
          {-16,-4},{-16,-9.2},{-5.6,-9.2}},color={0,0,127}));
  connect(SATSet.y, ahuValSig.u_s)
    annotation (Line(points={{-59,-88},{-48,-88},{-14,-88}}, color={0,0,127}));
  connect(SAT.port_a, ahu.port_b2)
    annotation (Line(points={{114,-140},{140,-140},{140,-126},{154,-126}},
      color={0,127,255},
      thickness=0.5));
  connect(SAT.T, ahuValSig.u_m)
    annotation (Line(points={{104,-129},{104,-129},{
          104,-122},{60,-122},{60,-106},{-2,-106},{-2,-100}},
          color={0,0,127}));
  connect(ahu.port_a2, roo.airPorts[1])
    annotation (Line(points={{174,-126},{174,
          -126},{194,-126},{194,-140},{242,-140},{242,-158},{167.85,-158}},
         color={0,127,255},
      thickness=0.5));
  connect(SAT.port_b, roo.airPorts[2])
    annotation (Line(points={{94,-140},{94,-140},
          {74,-140},{74,-158},{164.15,-158}},color={0,127,255},
      thickness=0.5));
  connect(ahuValSig.y, ahu.uWatVal)
    annotation (Line(points={{9,-88},{60,-88},{60,-116},{60,-116},{154,-116},{154,
          -116},{153,-116}},                              color={0,0,127}));
  connect(SATSet.y, ahu.TSet)
    annotation (Line(points={{-59,-88},{-40,-88},{-40,
          -66},{60,-66},{60,-121},{153,-121}},color={0,0,127}));
  connect(CWPumCon.y, val.y)
    annotation (Line(points={{-31,70},{-22,70},{-22,94},
          {40,94},{40,200},{180,200},{180,152}}, color={0,0,127}));
  connect(CWPumCon.y, cooTowSpe.u2)
    annotation (Line(points={{-31,70},{-22,70},{
          -22,94},{40,94},{40,169.2},{58.4,169.2}}, color={0,0,127}));
  connect(cooTowSpe.y, cooTow.y)
    annotation (Line(points={{76.8,174},{100,174},{
          100,200},{160,200},{160,147},{153,147}}, color={0,0,127}));
  connect(CHWRT.port_a, ahu.port_b1)
    annotation (Line(
      points={{240,0},{250,0},{250,-62},{250,-114},{174,-114}},
      color={0,127,255},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-180},{280,
            200}})),
    __Dymola_Commands(file="Resources/Scripts/Dymola/ChillerWSE/Examples/NonIntegratedPrimarySecondary.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This is a partial model that implements a chilled water cooling system with controls for a data center room.
</p>
</html>", revisions="<html>
<ul>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DataCenterControl;
