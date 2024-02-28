within Buildings.Templates.Plants.Controls.StagingRotation;
block EquipmentAvailability_state
  "Alternative implementation with state machine"
  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation(Evaluate=true);
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation(Evaluate=true);
  parameter Real dtOff(
    final min=0,
    final unit="s")=900
    "Off time required before equipment is deemed available again";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1_actual
    "Equipment status" annotation (Placement(transformation(extent={{-240,-20},{
            -200,20}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Hea if have_heaWat
    "Equipment available for heating" annotation (Placement(transformation(
          extent={{200,-20},{240,20}}), iconTransformation(extent={{100,40},{
            140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea_actual
    if have_heaWat and have_chiWat
    "Equipment operating mode" annotation (Placement(transformation(extent={{-240,
            -140},{-200,-100}}), iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Coo if have_chiWat
    "Equipment available for cooling" annotation (Placement(transformation(
          extent={{200,-140},{240,-100}}), iconTransformation(extent={{100,-80},{
            140,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHea
    "Return true if equipment on and in heating mode"
    annotation (Placement(transformation(extent={{-110,-150},{-90,-130}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndCoo
    "Return true if equipment on and in cooling mode"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not coo
    "Return true if equipment in cooling mode"
    annotation (Placement(transformation(extent={{-150,-110},{-130,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava
    "Equipment available signal" annotation (Placement(transformation(extent={{-240,
            -80},{-200,-40}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Utilities.PlaceHolder pla(final have_inp=have_heaWat and have_chiWat, final
      u_internal=have_heaWat or not have_chiWat)
    "Replace with placeholder value if input signal is not available"
    annotation (Placement(transformation(extent={{-190,-130},{-170,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not off "Return true if equipment is off"
    annotation (Placement(transformation(extent={{-150,-50},{-130,-30}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-160,160},{-140,180}})));
  Modelica.StateGraph.StepWithSignal onHea(nOut=2, nIn=1)
    annotation (Placement(transformation(extent={{10,150},{30,170}})));
  Modelica.StateGraph.InitialStepWithSignal avaMod(nOut=3, nIn=2)
    "Initial state – Equipment available for all modes"
    annotation (Placement(transformation(extent={{-70,150},{-50,170}})));
  Modelica.StateGraph.TransitionWithSignal trnToOff "Transition to off state"
    annotation (Placement(transformation(extent={{50,150},{70,170}})));
  Modelica.StateGraph.StepWithSignal onCoo(nOut=2, nIn=1)
    annotation (Placement(transformation(extent={{70,110},{90,130}})));
  Modelica.StateGraph.TransitionWithSignal trnToCoo
    "Transition to cooling mode"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Modelica.StateGraph.TransitionWithSignal trnToHea
    "Transition to heating mode"
    annotation (Placement(transformation(extent={{-30,150},{-10,170}})));
  Modelica.StateGraph.TransitionWithSignal trnToOff1 "Transition to off state"
    annotation (Placement(transformation(extent={{110,110},{130,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or  avaAllHea
    "Return true if equipment available for all modes or in heating mode"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or  avaAllCoo
    "Return true if equipment available for all modes or in cooling mode"
    annotation (Placement(transformation(extent={{170,-130},{190,-110}})));
  Modelica.StateGraph.Step offSta(nOut=1, nIn=2) "Off state"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Modelica.StateGraph.Transition trnToAvaTim(enableTimer=true, final waitTime=
        dtOff) "Transition back to available state after off time elapsed"
    annotation (Placement(transformation(extent={{160,170},{140,190}})));
  Modelica.StateGraph.Step unaSta(nOut=1, nIn=3) "Unavailable state"
    annotation (Placement(transformation(extent={{140,90},{160,110}})));
  Modelica.StateGraph.TransitionWithSignal trnToUna
    "Transition to unavailable state"
    annotation (Placement(transformation(extent={{-36,70},{-16,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not una
    "Return true if equipment is unavailable"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Modelica.StateGraph.TransitionWithSignal trnToAva
    "Transition back to available state"
    annotation (Placement(transformation(extent={{170,90},{190,110}})));
  Modelica.StateGraph.TransitionWithSignal trnToUna2
    "Transition to unavailable state"
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Modelica.StateGraph.TransitionWithSignal trnToUna3
    "Transition to unavailable state"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
equation
  connect(coo.y, onAndCoo.u2) annotation (Line(points={{-128,-100},{-116,-100},{
          -116,-8},{-112,-8}},
                           color={255,0,255}));
  connect(u1_actual, onAndHea.u1)
    annotation (Line(points={{-220,0},{-120,0},{-120,-140},{-112,-140}},
                                                color={255,0,255}));
  connect(u1_actual, onAndCoo.u1) annotation (Line(points={{-220,0},{-112,0}},
                           color={255,0,255}));
  connect(u1Hea_actual, pla.u)
    annotation (Line(points={{-220,-120},{-192,-120}},
                                                    color={255,0,255}));
  connect(pla.y, onAndHea.u2) annotation (Line(points={{-168,-120},{-140,-120},{
          -140,-148},{-112,-148}},
                           color={255,0,255}));
  connect(pla.y, coo.u) annotation (Line(points={{-168,-120},{-160,-120},{-160,-100},
          {-152,-100}},
                      color={255,0,255}));
  connect(u1_actual, off.u) annotation (Line(points={{-220,0},{-160,0},{-160,-40},
          {-152,-40}},color={255,0,255}));
  connect(avaMod.outPort[1], trnToCoo.inPort) annotation (Line(points={{-49.5,
          159.833},{-40,159.833},{-40,120},{-4,120}},
                                             color={0,0,0}));
  connect(onAndCoo.y, trnToCoo.condition) annotation (Line(points={{-88,0},{-80,
          0},{-80,40},{0,40},{0,108}}, color={255,0,255}));
  connect(onHea.outPort[1], trnToOff.inPort) annotation (Line(points={{30.5,159.875},
          {44,159.875},{44,160},{56,160}}, color={0,0,0}));
  connect(off.y, trnToOff.condition) annotation (Line(points={{-128,-40},{60,-40},
          {60,148}}, color={255,0,255}));
  connect(onCoo.outPort[1], trnToOff1.inPort) annotation (Line(points={{90.5,119.875},
          {104,119.875},{104,120},{116,120}}, color={0,0,0}));
  connect(trnToCoo.outPort, onCoo.inPort[1])
    annotation (Line(points={{1.5,120},{69,120}}, color={0,0,0}));
  connect(onAndHea.y, trnToHea.condition) annotation (Line(points={{-88,-140},{-20,
          -140},{-20,148}}, color={255,0,255}));
  connect(avaMod.outPort[2], trnToHea.inPort)
    annotation (Line(points={{-49.5,160},{-24,160}}, color={0,0,0}));
  connect(avaMod.active, avaAllHea.u1)
    annotation (Line(points={{-60,149},{-60,0},{148,0}}, color={255,0,255}));
  connect(onHea.active, avaAllHea.u2)
    annotation (Line(points={{20,149},{20,-8},{148,-8}}, color={255,0,255}));
  connect(avaAllHea.y, y1Hea)
    annotation (Line(points={{172,0},{220,0}}, color={255,0,255}));
  connect(avaAllCoo.y, y1Coo)
    annotation (Line(points={{192,-120},{220,-120}}, color={255,0,255}));
  connect(off.y, trnToOff1.condition) annotation (Line(points={{-128,-40},{120,-40},
          {120,108}}, color={255,0,255}));
  connect(trnToHea.outPort, onHea.inPort[1])
    annotation (Line(points={{-18.5,160},{9,160}}, color={0,0,0}));
  connect(offSta.outPort[1], trnToAvaTim.inPort) annotation (Line(points={{160.5,
          140},{170,140},{170,180},{154,180}}, color={0,0,0}));
  connect(trnToOff.outPort, offSta.inPort[1]) annotation (Line(points={{61.5,160},
          {130,160},{130,139.75},{139,139.75}}, color={0,0,0}));
  connect(trnToOff1.outPort, offSta.inPort[2]) annotation (Line(points={{121.5,120},
          {130,120},{130,140},{134,140},{134,140.25},{139,140.25}}, color={0,0,0}));
  connect(trnToAvaTim.outPort, avaMod.inPort[1]) annotation (Line(points={{148.5,
          180},{-80,180},{-80,159.75},{-71,159.75}}, color={0,0,0}));
  connect(u1Ava, una.u) annotation (Line(points={{-220,-60},{-140,-60},{-140,-80},
          {-112,-80}}, color={255,0,255}));
  connect(avaMod.outPort[3], trnToUna.inPort) annotation (Line(points={{-49.5,
          160.167},{-49.5,160},{-40,160},{-40,80},{-30,80}},
                                                    color={0,0,0}));
  connect(una.y, trnToUna.condition) annotation (Line(points={{-88,-80},{-26,-80},
          {-26,68}}, color={255,0,255}));
  connect(trnToUna.outPort, unaSta.inPort[1]) annotation (Line(points={{-24.5,
          80},{50,80},{50,99.6667},{139,99.6667}},
                                               color={0,0,0}));
  connect(unaSta.outPort[1], trnToAva.inPort)
    annotation (Line(points={{160.5,100},{176,100}}, color={0,0,0}));
  connect(u1Ava, trnToAva.condition) annotation (Line(points={{-220,-60},{180,-60},
          {180,88}}, color={255,0,255}));
  connect(trnToAva.outPort, avaMod.inPort[2]) annotation (Line(points={{181.5,100},
          {190,100},{190,200},{-70,200},{-70,160.25},{-71,160.25}}, color={0,0,0}));
  connect(avaMod.active, avaAllCoo.u1) annotation (Line(points={{-60,149},{-60,-120},
          {168,-120}}, color={255,0,255}));
  connect(onCoo.active, avaAllCoo.u2) annotation (Line(points={{80,109},{80,-128},
          {168,-128}}, color={255,0,255}));
  connect(onHea.outPort[2], trnToUna2.inPort) annotation (Line(points={{30.5,160.125},
          {32,160.125},{32,100},{36,100}}, color={0,0,0}));
  connect(trnToUna2.outPort, unaSta.inPort[2]) annotation (Line(points={{41.5,100},
          {90,100},{90,100},{139,100}}, color={0,0,0}));
  connect(una.y, trnToUna2.condition)
    annotation (Line(points={{-88,-80},{40,-80},{40,88}}, color={255,0,255}));
  connect(onCoo.outPort[2], trnToUna3.inPort) annotation (Line(points={{90.5,120.125},
          {92,120.125},{92,80},{96,80}}, color={0,0,0}));
  connect(trnToUna3.outPort, unaSta.inPort[3]) annotation (Line(points={{101.5,
          80},{130,80},{130,100.333},{139,100.333}},
                                                 color={0,0,0}));
  connect(una.y, trnToUna3.condition) annotation (Line(points={{-88,-80},{100,-80},
          {100,68}}, color={255,0,255}));
annotation (
 __cdl(extensionBlock=true),
 defaultComponentName="avaHeaCoo",
 Icon(
  coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}),
  graphics={
    Line(
      points={{-90,-80.3976},{68,-80.3976}},
      color={192,192,192}),
    Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}})),
    Documentation(info="<html>
FIXME: Check if the commanded mode should be used,
or rather the active operating mode as reported by the equipment itself.
</html>"));
end EquipmentAvailability_state;
