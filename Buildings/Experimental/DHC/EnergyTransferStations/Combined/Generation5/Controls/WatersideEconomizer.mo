within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model WatersideEconomizer
  "Waterside economizer controller"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
    "Heat exchanger secondary mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1_nominal
    "Nominal water inlet temperature on district side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b2_nominal
    "Nominal water outlet temperature on building side"
    annotation (Dialog(group="Nominal condition"));
  parameter Real y1Min(final unit="1")=0.05
    "Minimum pump flow rate or valve opening for temperature measurement (fractional)"
    annotation (Dialog(group="Controls"));
  parameter Modelica.SIunits.TemperatureDifference dTEna = 1
    "Minimum delta-T above predicted heat exchanger leaving water temperature to enable WSE"
    annotation (Dialog(group="Controls"));
  parameter Modelica.SIunits.TemperatureDifference dTDis = 0.5
    "Minimum delta-T across heat exchanger before disabling WSE"
    annotation (Dialog(group="Controls"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T1WatEnt(
    final unit="K",
    displayUnit="degC") "Heat exchanger primary water entering temperature"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m2_flow(
    final unit="kg/s")
    "Heat exchanger secondary mass flow rate" annotation (
      Placement(transformation(extent={{-220,80},{-180,120}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2WatLvg(
    final unit="K", displayUnit="degC")
    "Heat exchanger secondary water leaving temperature"
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}}),
                     iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2WatEnt(
    final unit="K", displayUnit="degC")
    "Heat exchanger secondary water entering temperature"
    annotation (Placement(transformation(extent={{-220,-100},{-180,-60}}),
                    iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y1(final unit="1")
    "Primary control signal (pump or valve)" annotation (Placement(
        transformation(extent={{180,80},{220,120}}), iconTransformation(extent=
            {{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal2(
    final unit="1")
    "Secondary valve control signal"
    annotation (Placement(transformation(extent={{180,-60},{220,-20}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addDelTem(
    final p=dTEna,
    final k=1)
    "Add threshold for enabling WSE"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.StateGraph.InitialStepWithSignal iniSta "Initial state "
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Modelica.StateGraph.TransitionWithSignal ena "Transition to enabled state"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Modelica.StateGraph.StepWithSignal actSta "Active WSE"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Modelica.StateGraph.TransitionWithSignal dis "Transition to disabled state"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add delT1(k2=-1) "Add delta-T"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold delTemDis(t=dTDis)
    "Compare to threshold for disabling WSE"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  PredictLeavingTemperature calTemLvg(
    final dTApp_nominal=abs(T_a1_nominal - T_b2_nominal),
    final m2_flow_nominal=m2_flow_nominal)
    "Compute predicted leaving water temperature"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Less delTemDis1
    "Compare to threshold for enabling WSE"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0)
    "Convert to real signal (close bypass valve when WSE enabled)"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot "Root of state graph"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant min1(
    final k=y1Min)
    "Minimum signal"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Linear variation bounded by minimum and 1"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOff1
    "Output zero if cooling not enabled or isolation valve open (cold rejection)"
    annotation (Placement(transformation(extent={{100,150},{120,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0) "Zero"
    annotation (Placement(transformation(extent={{60,130},{80,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-220,140},{-180,180}}),
    iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(nin=4)
    "Enable if cooling enabled and temperature criterion verified"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr or1(nin=3)
    "Cooling disabled or temperature criterion verified"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Cooling disabled"
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(t=1200)
    "True when WSE active for more than t" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-70})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(t=1200)
    "True when WSE inactive for more than t"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90)));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Cooling disabled or temperature criterion verified"
    annotation (Placement(transformation(extent={{70,-102},{90,-82}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isValIsoEvaClo(
    final t=1E-6, h=0.5E-6)
    "True if valve closed"
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIsoEva_actual(final unit="1")
    "Return position of evaporator to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
    iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "True if valve open"
    annotation (Placement(transformation(extent={{-50,-150},{-30,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Cooling disabled or temperature criterion verified"
    annotation (Placement(transformation(extent={{-90,150},{-70,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain nor2(k=1/m2_flow_nominal)
    "Normalize"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiOff2
    "Switch between enabled and disabled mode"
    annotation (Placement(transformation(extent={{140,90},{160,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1) "One"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
equation
  connect(T2WatEnt, delT1.u1)
    annotation (Line(points={{-200,-80},{-160,-80},{-160,-94},{-142,-94}}, color={0,0,127}));
  connect(T2WatLvg, delT1.u2)
    annotation (Line(points={{-200,-120},{-160,-120},{-160,-106},{-142,-106}},
                                                                             color={0,0,127}));
  connect(delT1.y, delTemDis.u) annotation (Line(points={{-118,-100},{-52,-100}},color={0,0,127}));
  connect(T1WatEnt, calTemLvg.T1WatEnt)
    annotation (Line(points={{-200,-40},{-160,-40},{-160,-45},{-142,-45}},
                                                                     color={0,0,127}));
  connect(calTemLvg.T2WatLvg, addDelTem.u) annotation (Line(points={{-118,-40},{-92,-40}}, color={0,0,127}));
  connect(addDelTem.y, delTemDis1.u1) annotation (Line(points={{-68,-40},{-52,-40}},
                                                                                  color={0,0,127}));
  connect(T2WatEnt, delTemDis1.u2)
    annotation (Line(points={{-200,-80},{-60,-80},{-60,-48},{-52,-48}},
                                                                      color={0,0,127}));
  connect(iniSta.outPort[1], ena.inPort) annotation (Line(points={{-9.5,40},{16,40}},   color={0,0,0}));
  connect(ena.outPort, actSta.inPort[1]) annotation (Line(points={{21.5,40},{49,40}}, color={0,0,0}));
  connect(actSta.outPort[1], dis.inPort) annotation (Line(points={{70.5,40},{96,40}}, color={0,0,0}));
  connect(dis.outPort, iniSta.inPort[1])
    annotation (Line(points={{101.5,40},{120,40},{120,60},{-40,60},{-40,40},{-31,40}}, color={0,0,0}));
  connect(booToRea.y, yVal2) annotation (Line(points={{162,-40},{200,-40}}, color={0,0,127}));
  connect(zer.y, swiOff1.u3) annotation (Line(points={{82,140},{90,140},{90,152},
          {98,152}},                                                                    color={0,0,127}));
  connect(mulAnd.y, ena.condition) annotation (Line(points={{22,-40},{30,-40},{
          30,18},{20,18},{20,28}},                                                      color={255,0,255}));
  connect(uCoo, not2.u) annotation (Line(points={{-200,160},{-170,160},{-170,-70},{-52,-70}},   color={255,0,255}));
  connect(actSta.active, booToRea.u) annotation (Line(points={{60,29},{60,-40},{138,-40}}, color={255,0,255}));
  connect(delTemDis1.y, mulAnd.u[1])
    annotation (Line(points={{-28,-40},{-2,-40},{-2,-34.75}},                    color={255,0,255}));
  connect(iniSta.active, tim1.u) annotation (Line(points={{-20,29},{-20,20},{
          2.22045e-15,20},{2.22045e-15,12}},                                  color={255,0,255}));
  connect(tim1.passed, mulAnd.u[2])
    annotation (Line(points={{-8,-12},{-8,-36},{-2,-36},{-2,-38.25}},  color={255,0,255}));
  connect(uCoo, mulAnd.u[3]) annotation (Line(points={{-200,160},{-170,160},{
          -170,0},{-20,0},{-20,-38},{-2,-38},{-2,-41.75}},
                          color={255,0,255}));
  connect(actSta.active, tim.u) annotation (Line(points={{60,29},{60,-40},{50,-40},{50,-58}},
                                                                            color={255,0,255}));
  connect(tim.passed, and2.u1) annotation (Line(points={{42,-82},{42,-92},{68,-92}},    color={255,0,255}));
  connect(or1.y, and2.u2) annotation (Line(points={{22,-100},{68,-100}},                     color={255,0,255}));
  connect(and2.y, dis.condition) annotation (Line(points={{92,-92},{100,-92},{100,28}}, color={255,0,255}));
  connect(m2_flow, calTemLvg.m2_flow) annotation (Line(points={{-200,100},{-160,
          100},{-160,-35},{-142,-35}}, color={0,0,127}));
  connect(yValIsoEva_actual,isValIsoEvaClo.u)
    annotation (Line(points={{-200,-160},{-142,-160}},color={0,0,127}));
  connect(isValIsoEvaClo.y, mulAnd.u[4])
    annotation (Line(points={{-118,-160},{-100,-160},{-100,-20},{-24,-20},{-24,
          -42},{-2,-42},{-2,-45.25}},                                           color={255,0,255}));
  connect(isValIsoEvaClo.y, not1.u)
    annotation (Line(points={{-118,-160},{-60,-160},{-60,-140},{-52,-140}}, color={255,0,255}));
  connect(delTemDis.y, or1.u[1])
    annotation (Line(points={{-28,-100},{-2,-100},{-2,-95.3333}},                 color={255,0,255}));
  connect(not2.y, or1.u[2]) annotation (Line(points={{-28,-70},{-20,-70},{-20,
          -96},{-2,-96},{-2,-100}},                                                             color={255,0,255}));
  connect(not1.y, or1.u[3])
    annotation (Line(points={{-28,-140},{-20,-140},{-20,-104},{-2,-104},{-2,
          -104.667}},                                                             color={255,0,255}));
  connect(uCoo, and1.u1) annotation (Line(points={{-200,160},{-92,160}}, color={255,0,255}));
  connect(and1.y, swiOff1.u2) annotation (Line(points={{-68,160},{98,160}},                   color={255,0,255}));
  connect(isValIsoEvaClo.y, and1.u2)
    annotation (Line(points={{-118,-160},{-100,-160},{-100,152},{-92,152}}, color={255,0,255}));
  connect(m2_flow, nor2.u)
    annotation (Line(points={{-200,100},{-142,100}}, color={0,0,127}));
  connect(min1.y, swiOff1.u1) annotation (Line(points={{12,140},{40,140},{40,
          168},{98,168}}, color={0,0,127}));
  connect(swiOff2.y, y1)
    annotation (Line(points={{162,100},{200,100}}, color={0,0,127}));
  connect(swiOff1.y, swiOff2.u1) annotation (Line(points={{122,160},{130,160},{
          130,108},{138,108}}, color={0,0,127}));
  connect(iniSta.active, swiOff2.u2) annotation (Line(points={{-20,29},{-20,20},
          {130,20},{130,100},{138,100}}, color={255,0,255}));
  connect(lin.y, swiOff2.u3) annotation (Line(points={{82,100},{120,100},{120,
          92},{138,92}}, color={0,0,127}));
  connect(nor2.y, lin.u)
    annotation (Line(points={{-118,100},{58,100}}, color={0,0,127}));
  connect(one.y, lin.x2) annotation (Line(points={{12,80},{40,80},{40,96},{58,
          96}}, color={0,0,127}));
  connect(one.y, lin.f2) annotation (Line(points={{12,80},{50,80},{50,92},{58,
          92}}, color={0,0,127}));
  connect(zer.y, lin.x1) annotation (Line(points={{82,140},{90,140},{90,120},{
          50,120},{50,108},{58,108}}, color={0,0,127}));
  connect(min1.y, lin.f1) annotation (Line(points={{12,140},{40,140},{40,104},{
          58,104}}, color={0,0,127}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-180,-180},{180,180}})),
    defaultComponentName="conWSE",
    Documentation(
      revisions="<html>
<ul>
<li>
July 14, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This block implements the control logic for the waterside economizer.
</p>
<p>
The system is enabled if
</p>
<ul>
<li>
it has been disabled for more than 20 minutes, and
</li>
<li>
the \"cooling enabled\" input signal is <code>true</code>, and
</li>
<li>
the evaporator isolation valve is closed (i.e., the system is not in cold
rejection mode), and
</li>
<li>
the predicted leaving water temperature is lower than the entering water
temperature minus <code>dTEna</code>.
</li>
</ul>
<p>
The system is disabled if
</p>
<ul>
<li>
it has been enabled for more than 20 minutes, and
</li>
<li>
the \"cooling enabled\" input signal is <code>false</code>, or
</li>
<li>
the evaporator isolation valve is open, or
</li>
<li>
the leaving water temperature is higher than the entering water
temperature minus <code>dTDis</code>.
</li>
</ul>
<p>
When the system is enabled
</p>
<ul>
<li>
the primary side is controlled so that the primary flow rate
varies linearly with the secondary flow rate,
</li>
<li>
the bypass valve on the secondary side is fully closed.
</li>
</ul>
<p>
When the system is disabled
</p>
<ul>
<li>
if the \"cooling enabled\" input signal is <code>true</code> and
the evaporator isolation valve is closed,
the primary pump (resp. valve) is operated at its minimum speed
(resp. opening), otherwise it is switched off (resp. fully closed):
this is needed to yield a representative measurement of the
service water entering temperature,
</li>
<li>
the bypass valve on the secondary side is fully open.
</li>
</ul>
</html>"));
end WatersideEconomizer;
