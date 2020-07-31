within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model Chiller "Chiller controller"
  extends Modelica.Blocks.Icons.Block;

  parameter Boolean have_res = true
    "Set to true in case of internal reset of chilled water supply temperature"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.Temperature TChiWatSupSetMin(
    displayUnit="degC") = 2 + 273.15
    "Minimum value of chilled water supply temperature set point"
    annotation(Dialog(enable=have_res));
  parameter Modelica.SIunits.Temperature TConWatEntMin(
    displayUnit="degC")
    "Minimum value of condenser water entering temperature";
  parameter Modelica.SIunits.Temperature TEvaWatEntMax(
    displayUnit="degC")
    "Maximum value of evaporator water entering temperature";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling mode enabled signal"
    annotation (Placement(transformation(extent={
            {-200,20},{-160,60}}), iconTransformation(extent={{-140,40},{-100,
            80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating mode enabled signal"
    annotation (Placement(transformation(extent={
            {-200,60},{-160,100}}), iconTransformation(extent={{-140,60},{-100,
            100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K", displayUnit="degC") if have_res
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupPreSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSup(
    final unit="K", displayUnit="degC") if have_res
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatEnt(
    final unit="K", displayUnit="degC")
    "Condenser water entering temperature"
    annotation (Placement(transformation(extent={{-200,-320},{-160,-280}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaWatEnt(
    final unit="K", displayUnit="degC")
   "Evaporator water entering temperature"
    annotation (Placement(transformation(extent={{-200,-260},{-160,-220}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiWatSupSet(
    final unit="K", displayUnit="degC")
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{160,-60},{200,-20}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValCon
    "Condenser mixing valve control signal"
    annotation (Placement(transformation(extent={{160,-300},{200,-260}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEva
    "Evaporator mixing valve control signal"
    annotation (Placement(transformation(extent={{160,-240},{200,-200}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi
    "Chiller enabled signal"
    annotation (Placement(transformation(extent={{160,40},
    {200,80}}), iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Logical.Or heaOrCoo
    "Heating or cooling mode enabled"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "Pass through maximum set-point value if cooling only, otherwise reset"
    annotation (Placement(transformation(extent={{130,-30},{150,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Line mapFun2 if have_res
    "Mapping function resetting heating water supply temperature"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x1(k=0)
    "PI minimum output"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x2(k=1)
    "PI maximum output"
    annotation (Placement(transformation(extent={{30,-106},{50,-86}})));
  Buildings.Controls.Continuous.LimPID conValEva(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final yMax=1,
    final yMin=0,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0,
    k=0.1,
    Ti(displayUnit="s") = 60,
    final reverseActing=true)
    "Evaporator three-way valve control"
    annotation (Placement(transformation(extent={{50,-230},{70,-210}})));
  Buildings.Controls.Continuous.LimPID conValCon(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final yMax=1,
    final yMin=0,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0,
    k=0.1,
    Ti(displayUnit="s") = 60,
    final reverseActing=false)
    "Condenser three-way valve control"
    annotation (Placement(transformation(extent={{50,-290},{70,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTChiWatSup(
    y(final unit="K", displayUnit="degC"),
    final k=TChiWatSupSetMin)
    "Minimum value of chilled water supply temperature"
    annotation (Placement(transformation(extent={{30,-138},{50,-118}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTEvaWatEnt(
    y(final unit="K", displayUnit="degC"),
    final k=TEvaWatEntMax)
    "Maximum value of evaporator water entering temperature"
  annotation (Placement(transformation(extent={{-10,-230},{10,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTConWatEnt(
    y(final unit="K", displayUnit="degC"),
    final k=TConWatEntMin)
    "Minimum value of condenser water entering temperature"
    annotation (Placement(transformation(extent={{-10,-290},{10,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=1,
    Ti=60,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter) if have_res
    "Controller for HWS reset"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch actVal
    "Enable mixing valve control"
    annotation (Placement(transformation(extent={{120,-210},{140,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Switch actVal1
    "Enable mixing valve control"
    annotation (Placement(transformation(extent={{120,-270},{140,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(k=false) if
                                                             not have_res
    "Always true"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Modelica.Blocks.Routing.BooleanPassThrough booThr if have_res
    "Pass through uHea if have_res"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dum(k=0) if not have_res
    "Dummy u2 value if not have_res"
    annotation (Placement(transformation(extent={{30,-170},{50,-150}})));
equation
  connect(swi2.y,TChiWatSupSet)
    annotation (Line(points={{152,-40},{180,-40}},
                                               color={0,0,127}));
  connect(x1.y, mapFun2.x1) annotation (Line(points={{52,-60},{80,-60},{80,-72},
          {88,-72}}, color={0,0,127}));
  connect(x2.y, mapFun2.x2) annotation (Line(points={{52,-96},{60,-96},{60,-84},
          {88,-84}}, color={0,0,127}));
  connect(TEvaWatEnt, conValEva.u_m) annotation (Line(points={{-180,-240},{60,-240},
          {60,-232}}, color={0,0,127}));
  connect(TConWatEnt, conValCon.u_m) annotation (Line(points={{-180,-300},{60,-300},
          {60,-292}}, color={0,0,127}));
  connect(heaOrCoo.y, conValEva.trigger) annotation (Line(points={{-78,0},{-40,0},
          {-40,-236},{52,-236},{52,-232}}, color={255,0,255}));
  connect(heaOrCoo.y, conValCon.trigger) annotation (Line(points={{-78,0},{-40,0},
          {-40,-296},{52,-296},{52,-292}}, color={255,0,255}));
  connect(heaOrCoo.y, yChi) annotation (Line(points={{-78,0},{140,0},{140,60},{180,
          60}}, color={255,0,255}));
  connect(uHea,heaOrCoo. u1) annotation (Line(points={{-180,80},{-140,80},{-140,
          0},{-102,0}}, color={255,0,255}));
  connect(uCoo,heaOrCoo. u2) annotation (Line(points={{-180,40},{-120,40},{-120,
          -8},{-102,-8}}, color={255,0,255}));
  connect(maxTEvaWatEnt.y, conValEva.u_s)
    annotation (Line(points={{12,-220},{48,-220}}, color={0,0,127}));
  connect(minTConWatEnt.y, conValCon.u_s)
    annotation (Line(points={{12,-280},{48,-280}}, color={0,0,127}));
  connect(minTChiWatSup.y, mapFun2.f2) annotation (Line(points={{52,-128},{64,
          -128},{64,-88},{88,-88}},
                              color={0,0,127}));
  connect(THeaWatSupSet, conPID.u_s)
    annotation (Line(points={{-180,-80},{-92,-80}},    color={0,0,127}));
  connect(THeaWatSup, conPID.u_m) annotation (Line(points={{-180,-120},{-80,-120},
          {-80,-92}},         color={0,0,127}));
  connect(conPID.y, mapFun2.u) annotation (Line(points={{-68,-80},{88,-80}},
                             color={0,0,127}));
  connect(uHea, conPID.trigger) annotation (Line(points={{-180,80},{-140,80},{-140,
          -100},{-86,-100},{-86,-92}},         color={255,0,255}));
  connect(TChiWatSupPreSet, mapFun2.f1) annotation (Line(points={{-180,-40},{20,
          -40},{20,-76},{88,-76}}, color={0,0,127}));
  connect(conValEva.y, actVal.u1) annotation (Line(points={{71,-220},{100,-220},
          {100,-228},{118,-228}}, color={0,0,127}));
  connect(conValCon.y, actVal1.u1) annotation (Line(points={{71,-280},{100,-280},
          {100,-288},{118,-288}}, color={0,0,127}));
  connect(x1.y, actVal.u3) annotation (Line(points={{52,-60},{80,-60},{80,-212},
          {118,-212}}, color={0,0,127}));
  connect(x1.y, actVal1.u3) annotation (Line(points={{52,-60},{80,-60},{80,-272},
          {118,-272}}, color={0,0,127}));
  connect(heaOrCoo.y, actVal.u2) annotation (Line(points={{-78,0},{-40,0},{-40,
          -200},{110,-200},{110,-220},{118,-220}}, color={255,0,255}));
  connect(heaOrCoo.y, actVal1.u2) annotation (Line(points={{-78,0},{-40,0},{-40,
          -200},{110,-200},{110,-280},{118,-280}}, color={255,0,255}));
  connect(actVal.y, yValEva) annotation (Line(points={{142,-220},{150,-220},{
          150,-220},{180,-220}}, color={0,0,127}));
  connect(actVal1.y, yValCon)
    annotation (Line(points={{142,-280},{180,-280}}, color={0,0,127}));
  connect(TChiWatSupPreSet, swi2.u3) annotation (Line(points={{-180,-40},{100,
          -40},{100,-32},{128,-32}}, color={0,0,127}));
  connect(mapFun2.y, swi2.u1) annotation (Line(points={{112,-80},{120,-80},{120,
          -48},{128,-48}}, color={0,0,127}));
  connect(tru.y, swi2.u2) annotation (Line(points={{52,-20},{110,-20},{110,-40},
          {128,-40}}, color={255,0,255}));
  connect(uHea, booThr.u)
    annotation (Line(points={{-180,80},{28,80}}, color={255,0,255}));
  connect(booThr.y, swi2.u2) annotation (Line(points={{51,80},{120,80},{120,-40},
          {128,-40}}, color={255,0,255}));
  connect(dum.y, swi2.u1) annotation (Line(points={{52,-160},{120,-160},{120,-48},
          {128,-48}}, color={0,0,127}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-160,-320},{160,100}})),
  defaultComponentName="con",
  Documentation(
revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This is a controller for the chiller system, which includes the dedicated
condenser and evaporator pumps.
</p>
<p>
The system is enabled if any of the input control signals <code>uHea</code>
or <code>uCoo</code> is true.
When enabled,
</p>
<ul>
<li>
the condenser and evaporator pumps are operated at constant speed,
</li>
<li>
the condenser (resp. evaporator) mixing valve is modulated with a PI
loop controlling the minimum (resp. maximum) inlet temperature,
</li>
</ul>
<p>
Optionally, a chilled water supply temperature reset can be activated.
In this case, if there is an actual heating demand, the chilled water
supply temperature is reset with a PI loop controlling the heating
water supply temperature.
This has two effects, which occur in sequence.
</p>
<ol>
<li>
First a \"false load\" is generated on the evaporator: the part load ratio
of the chiller increases, and so does the heat flow rate rejected by the
condenser.
This is true until the volume of the evaporator loop and the chilled
water tank is fully recirculated.
</li>
<li>
Then the temperature difference accross the evaporator reaches back its
original value (for an unvarying building load).
However, the evaporator inlet temperature (corresponding to the tank top
temperature) is now lowered. This will eventually trigger a cold
rejection demand by
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideCold1\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.SideCold1</a>.
The ambient sources are then used to \"false load\" the chiller.
</li>
</ol>
</html>"));
end Chiller;
