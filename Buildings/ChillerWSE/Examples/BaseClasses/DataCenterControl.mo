within Buildings.ChillerWSE.Examples.BaseClasses;
partial model DataCenterControl
  "Example that implements a chilled water cooling system with controls for a data center room"
  extends Buildings.ChillerWSE.Examples.BaseClasses.DataCenter(ahu(yValLow=
          yValMin_AHU + 0.05, yValHig=yValMin_AHU + 0.1));

 parameter Real yValMin_AHU=0.2 "Minimum waterside valve position in the AHU";

  Modelica.Blocks.Sources.Constant TCHWSupSet(k(
    final unit="K",
    displayUnit="degC") = 279.71)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-190,150},{-170,170}})));
  Buildings.ChillerWSE.Examples.BaseClasses.Controls.ChillerStageControl
  chiStaCon(
    tWai=tWai,
    QEva_nominal=QEva_nominal)
    "Chiller staging control"
    annotation (Placement(transformation(extent={{-50,130},{-30,150}})));
  Modelica.Blocks.Math.RealToBoolean chiOn[numChi]
    "Real value to boolean value"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Modelica.Blocks.Math.IntegerToBoolean reaToBoo(threshold=3)
    "Inverse on/off signal for the WSE"
    annotation (Placement(transformation(extent={{-50,100},{-30,120}})));
  Modelica.Blocks.Logical.Not wseOn
    "True: WSE is on; False: WSE is off "
    annotation (Placement(transformation(extent={{-10,100},{10,120}})));
  Buildings.ChillerWSE.Examples.BaseClasses.Controls.ConstantSpeedPumpStageControl
    CWPumCon(tWai=tWai)
    "Condenser water pump controller"
    annotation (Placement(transformation(extent={{-52,60},{-32,80}})));
  Modelica.Blocks.Sources.IntegerExpression chiNumOn(
    y=integer(sum(chiStaCon.y)))
    "The number of running chillers"
    annotation (Placement(transformation(extent={{-182,64},{-162,84}})));
  Modelica.Blocks.Math.Gain gai[numChi](
    each k=m1_flow_chi_nominal)
    "Gain effect"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Buildings.ChillerWSE.Examples.BaseClasses.Controls.CoolingTowerSpeedControl
    cooTowSpeCon(controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=40,
    k=5)
    "Cooling tower speed control"
    annotation (Placement(transformation(extent={{-50,170},{-30,186}})));
  Modelica.Blocks.Sources.RealExpression TCWSupSet(
    y=min(29.44 + 273.15, max(273.15 + 15.56, cooTow[1].TAir + 3)))
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-130,170},{-110,190}})));

  Modelica.Blocks.Sources.Constant TAirSupSet(k(
      final unit="K",
      displayUnit="degC") = 289.15)
      "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-98},{-60,-78}})));
  Modelica.Blocks.Sources.Constant XAirSupSet(
    k(final unit="1") = MediumA.X_default[1])
    "Supply air mass fraction setpoint"
    annotation (Placement(transformation(extent={{-12,-136},{8,-116}})));
  Modelica.Blocks.Sources.Constant uFan(k = 1)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-12,-176},{8,-156}})));
  Buildings.ChillerWSE.Examples.BaseClasses.Controls.VariableSpeedPumpStageControl
  varSpeCon(
    tWai=tWai,
    m_flow_nominal=m2_flow_chi_nominal,
    deaBanSpe=0.45)
    "Speed controller"
    annotation (Placement(transformation(extent={{-48,-14},{-28,6}})));
  Modelica.Blocks.Sources.RealExpression mPum_flow(
    y=chiWSE.port_b2.m_flow)
    "Mass flowrate of variable speed pumps"
    annotation (Placement(transformation(extent={{-126,-6},{-106,14}})));
  Buildings.Controls.Continuous.LimPID pumSpe(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=40,
    yMin=0.2)
    "Pump speed controller"
    annotation (Placement(transformation(extent={{-126,-30},{-106,-10}})));
  Modelica.Blocks.Sources.Constant dpSet(
    k=0.3*dp2_chi_nominal)
    "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{-176,-30},{-156,-10}})));
  Modelica.Blocks.Math.Product pumSpeSig[numChi]
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-4,-22},{12,-6}})));
  Buildings.Controls.Continuous.LimPID ahuValSig(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=40,
    reverseAction=true,
    yMin=yValMin_AHU)
    "Valve position signal for the AHU"
    annotation (Placement(transformation(extent={{-12,-98},{8,-78}})));
  Modelica.Blocks.Math.Product cooTowSpe[numChi]
    "Cooling tower speed"
    annotation (Placement(transformation(extent={{60,166},{76,182}})));
equation
  connect(chiWSE.port_b2, TCHWSup.port_a)
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
  connect(chiWSE.port_b1, TCWRet.port_a)
    annotation (Line(
      points={{146,38},{160,38},{160,60},{202,60}},
      color={0,127,255},
      thickness=0.5));
   for i in 1:numChi loop
    connect(TCWSup.port_a, cooTow[i].port_b)
      annotation (Line(
        points={{120,140},{132,140},{132,139},{131,139}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_b, chiWSE.port_a1)
      annotation (Line(
        points={{70,90},{70,58},{110,58},{110,38},{126,38}},
        color={0,127,255},
        thickness=0.5));
    connect(pumCW[i].port_a, TCWSup.port_b)
      annotation (Line(
        points={{70,110},{70,140},{100,140}},
        color={0,127,255},
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
  connect(CWPumCon.y, gai.u)
    annotation (Line(points={{-31,70},{-12,70}},       color={0,0,127}));
  connect(gai.y, pumCW.m_flow_in)
    annotation (Line(points={{11,70},{40,70},{40,100},
          {58,100}}, color={0,0,127}));
  connect(TCWSupSet.y, cooTowSpeCon.TCWSupSet)
    annotation (Line(points={{-109,180},
          {-70,180},{-70,186},{-52,186}}, color={0,0,127}));
  connect(TCHWSupSet.y, cooTowSpeCon.TCHWSupSet)
    annotation (Line(points={{-169,160},{-150,160},{-150,200},{-70,200},{-70,
          178.889},{-52,178.889}},
        color={0,0,127}));
  connect(TCWSup.T, cooTowSpeCon.TCWSup)
    annotation (Line(points={{110,151},{110,160},{122,160},{122,200},{-70,200},
          {-70,175.333},{-52,175.333}},
        color={0,0,127}));
  connect(TCHWSup.T, cooTowSpeCon.TCHWSup)
    annotation (Line(points={{94,11},{94,36},{40,36},{40,200},{-70,200},{-70,
          171.778},{-52,171.778}},                                     color={0,
          0,127}));
  connect(chiWSE.TSet, TCHWSupSet.y)
    annotation (Line(points={{124.4,42.8},{40,42.8},
          {40,200},{-150,200},{-150,160},{-169,160}}, color={0,0,127}));
  connect(XAirSupSet.y, ahu.XSet_w)
    annotation (Line(points={{9,-126},{60,-126},
          {60,-119},{153,-119}}, color={0,0,127}));
  connect(uFan.y, ahu.uFan)
    annotation (Line(points={{9,-166},{60,-166},{60,-124},
          {153,-124}},color={0,0,127}));
  connect(mPum_flow.y, varSpeCon.masFloPum)
    annotation (Line(points={{-105,4},{-50,4}},color={0,0,127}));
  connect(senRelPre.port_a, ahu.port_a1)
    annotation (Line(points={{152,-94},{72,-94},{72,-114},{154,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(pumSpe.y, varSpeCon.speSig)
    annotation (Line(points={{-105,-20},{-76,-20},
          {-76,0},{-50,0}}, color={0,0,127}));
  connect(senRelPre.p_rel, pumSpe.u_m)
    annotation (Line(points={{162,-85},{162,-85},{162,-66},{-116,-66},{-116,-32}},
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
  connect(TAirSupSet.y, ahuValSig.u_s)
    annotation (Line(points={{-59,-88},{-48,-88},{-14,-88}}, color={0,0,127}));
  connect(TAirSup.port_a, ahu.port_b2)
    annotation (Line(
      points={{114,-140},{140,-140},{140,-126},{154,-126}},
      color={0,127,255},
      thickness=0.5));
  connect(TAirSup.T, ahuValSig.u_m)
    annotation (Line(points={{104,-129},{104,-129},
          {104,-122},{60,-122},{60,-106},{-2,-106},{-2,-100}}, color={0,0,127}));
  connect(ahu.port_a2, roo.airPorts[1])
    annotation (Line(points={{174,-126},{174,-126},{194,-126},{194,-140},{242,-140},
          {242,-176.7},{168.475,-176.7}},
         color={0,127,255},
      thickness=0.5));
  connect(TAirSup.port_b, roo.airPorts[2])
    annotation (Line(
      points={{94,-140},{94,-140},{74,-140},{74,-176.7},{164.425,-176.7}},
      color={0,127,255},
      thickness=0.5));
  connect(ahuValSig.y, ahu.uWatVal)
    annotation (Line(points={{9,-88},{60,-88},{60,-116},{154,-116},{153,-116}},
                                                          color={0,0,127}));
  connect(TAirSupSet.y, ahu.TSet)
    annotation (Line(points={{-59,-88},{-40,-88},{
          -40,-66},{60,-66},{60,-121},{153,-121}}, color={0,0,127}));
  connect(CWPumCon.y, val.y)
    annotation (Line(points={{-31,70},{-22,70},{-22,94},
          {40,94},{40,200},{180,200},{180,152}}, color={0,0,127}));
  connect(CWPumCon.y, cooTowSpe.u2)
    annotation (Line(points={{-31,70},{-22,70},{
          -22,94},{40,94},{40,169.2},{58.4,169.2}}, color={0,0,127}));
  connect(cooTowSpe.y, cooTow.y)
    annotation (Line(points={{76.8,174},{100,174},{
          100,200},{160,200},{160,147},{153,147}}, color={0,0,127}));
  connect(TCHWRet.port_a, ahu.port_b1)
    annotation (Line(
      points={{240,0},{250,0},{250,-62},{250,-114},{174,-114}},
      color={0,127,255},
      thickness=0.5));
  connect(chiNumOn.y, CWPumCon.numOnChi)
    annotation (Line(points={{-161,74},{-54,74}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-180},{280,
            200}})),
    __Dymola_Commands,
    Documentation(info="<html>
    <p>This is a partial model that implements a chilled water cooling system 
    with controls for a data center room.
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
