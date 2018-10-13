within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer;
block Tuning
  "Defines a value used to tune the economizer outlet temperature prediction"

  parameter Real step(min=-0.02, max=0.05)=0.02
  "Tuning step";

  final parameter Real tunPar_init = 0
  "Initial value of the tuning parameter";

  parameter Modelica.SIunits.Time ecoOnTimDec = 60*60
  "Economizer enable time needed to allow decrease of the tuning parameter";

  parameter Modelica.SIunits.Time ecoOnTimInc = 30*60
  "Economizer enable time needed to allow increase of the tuning parameter";


  CDL.Interfaces.BooleanInput uEcoSta
    "Water side economizer enable disable status"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  CDL.Logical.Timer tim
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  CDL.Logical.FallingEdge
                     falEdg
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  CDL.Continuous.GreaterEqual greEqu
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  CDL.Continuous.Sources.Constant ecoOnTim(k=ecoOnTimDec)
    "Check if econ was on for the defined time period"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  CDL.Continuous.Sources.Constant tunStep(k=step) "Tuning step"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  CDL.Discrete.TriggeredSampler triSam(y_start=0)
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  CDL.Interfaces.RealOutput yTunPar
    "Tuning parameter for the waterside economizer outlet temperature prediction "
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Continuous.Add add2(k1=-1)
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{-50,80},{-30,100}})));
  CDL.Logical.Timer tim1
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  CDL.Logical.FallingEdge
                     falEdg1
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  CDL.Logical.And3 and1
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  CDL.Continuous.LessEqual    lesEqu
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  CDL.Continuous.Sources.Constant ecoOnTim1(k=ecoOnTimInc)
    "Check if econ was on for the defined time period"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  CDL.Discrete.TriggeredSampler triSam1(y_start=tunPar_init)
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
  CDL.Logical.Pre pre1
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  CDL.Interfaces.RealInput uTowFanSpe "Water side economizer tower fan speed"
    annotation (Placement(transformation(extent={{-220,-170},{-180,-130}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  CDL.Continuous.LessEqual    lesEqu1
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  CDL.Continuous.Sources.Constant MaxTowFanSpe(k=1) "Maximal tower fan speed"
    annotation (Placement(transformation(extent={{-160,-190},{-140,-170}})));
  CDL.Discrete.TriggeredSampler triSam2(y_start=0)
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  CDL.Continuous.Sources.Constant Zero(k=0) "Maximal tower fan speed"
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}})));
  CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{-74,-200},{-54,-180}})));
  CDL.Continuous.GreaterEqualThreshold greEquThr(threshold=0.5)
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
equation
  connect(uEcoSta, tim.u)
    annotation (Line(points={{-200,60},{-160,60},{-160,90},{-122,90}},
                                                     color={255,0,255}));
  connect(uEcoSta, falEdg.u) annotation (Line(points={{-200,60},{-160,60},{-160,
          20},{-122,20}},
                      color={255,0,255}));
  connect(greEqu.u2, ecoOnTim.y) annotation (Line(points={{-82,82},{-90,82},{-90,
          60},{-99,60}}, color={0,0,127}));
  connect(tim.y, greEqu.u1)
    annotation (Line(points={{-99,90},{-82,90}},   color={0,0,127}));
  connect(triSam.u, tunStep.y) annotation (Line(points={{58,110},{40,110},{40,130},
          {21,130}},color={0,0,127}));
  connect(triSam.y, add2.u1) annotation (Line(points={{81,110},{90,110},{90,6},{
          98,6}},
                color={0,0,127}));
  connect(add2.y, yTunPar)
    annotation (Line(points={{121,0},{190,0}}, color={0,0,127}));
  connect(and2.y, triSam.trigger)
    annotation (Line(points={{21,90},{70,90},{70,98.2}}, color={255,0,255}));
  connect(falEdg.y, and2.u2) annotation (Line(points={{-99,20},{-20,20},{-20,82},
          {-2,82}}, color={255,0,255}));
  connect(greEqu.y, pre.u)
    annotation (Line(points={{-59,90},{-52,90}}, color={255,0,255}));
  connect(and2.u1, pre.y)
    annotation (Line(points={{-2,90},{-29,90}}, color={255,0,255}));
  connect(uEcoSta, tim1.u) annotation (Line(points={{-200,60},{-160,60},{-160,-40},
          {-122,-40}}, color={255,0,255}));
  connect(uEcoSta, falEdg1.u) annotation (Line(points={{-200,60},{-160,60},{-160,
          -110},{-122,-110}},
                        color={255,0,255}));
  connect(lesEqu.u2, ecoOnTim1.y) annotation (Line(points={{-82,-48},{-90,-48},{
          -90,-70},{-99,-70}}, color={0,0,127}));
  connect(tim1.y, lesEqu.u1)
    annotation (Line(points={{-99,-40},{-82,-40}}, color={0,0,127}));
  connect(and1.y, triSam1.trigger) annotation (Line(points={{41,-40},{60,-40},{60,
          -31.8}}, color={255,0,255}));
  connect(falEdg1.y, and1.u2) annotation (Line(points={{-99,-110},{-14,-110},{-14,
          -40},{18,-40}}, color={255,0,255}));
  connect(lesEqu.y, pre1.u)
    annotation (Line(points={{-59,-40},{-52,-40}}, color={255,0,255}));
  connect(and1.u1, pre1.y) annotation (Line(points={{18,-32},{-20,-32},{-20,-40},
          {-29,-40}}, color={255,0,255}));
  connect(tunStep.y, triSam1.u) annotation (Line(points={{21,130},{40,130},{40,-20},
          {48,-20}}, color={0,0,127}));
  connect(uTowFanSpe, lesEqu1.u1)
    annotation (Line(points={{-200,-150},{-122,-150}}, color={0,0,127}));
  connect(MaxTowFanSpe.y, lesEqu1.u2) annotation (Line(points={{-139,-180},{-130,
          -180},{-130,-158},{-122,-158}}, color={0,0,127}));
  connect(lesEqu1.y, triSam2.trigger) annotation (Line(points={{-99,-150},{-90,-150},
          {-90,-170},{-30,-170},{-30,-141.8}}, color={255,0,255}));
  connect(lesEqu.y, swi.u2) annotation (Line(points={{-59,-40},{-59,-116},{-86,-116},
          {-86,-190},{-76,-190}}, color={255,0,255}));
  connect(MaxTowFanSpe.y, swi.u1) annotation (Line(points={{-139,-180},{-98,-180},
          {-98,-182},{-76,-182}}, color={0,0,127}));
  connect(Zero.y, swi.u3) annotation (Line(points={{-99,-200},{-78,-200},{-78,-198},
          {-76,-198}}, color={0,0,127}));
  connect(swi.y, triSam2.u) annotation (Line(points={{-53,-190},{-50,-190},{-50,
          -130},{-42,-130}}, color={0,0,127}));
  connect(triSam2.y, greEquThr.u)
    annotation (Line(points={{-19,-130},{-2,-130}}, color={0,0,127}));
  connect(greEquThr.y, and1.u3) annotation (Line(points={{21,-130},{30,-130},{30,
          -72},{10,-72},{10,-48},{18,-48}}, color={255,0,255}));
  connect(triSam1.y, add2.u2) annotation (Line(points={{71,-20},{90,-20},{90,-6},
          {98,-6}}, color={0,0,127}));
  annotation (defaultComponentName = "wseTun",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-220},{180,180}})),
Documentation(info="<html>
<p>
Fixme
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Tuning;
