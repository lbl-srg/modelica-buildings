within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model EconModulation "Based on measured and requred minimum outdoor airflow the controller resets 
  the min limit of the economizer damper and the max limit of the return air 
  damper in order to maintain the minimum required outdoor airflow."
  // fixme: add keep previous pos if VOut>VOutSet AND EcoDamPos>EcoDamPosMin
  // to avoid non-realistic setting of say econ min limit to 0 because the
  // measured flow is higher while the economizer is open wider (enabled or
  // modulating above the min)

  CDL.Interfaces.RealInput uVOut
    "Measured outdoor airflow rate. Sensor output. Location: after the economizer damper intake."
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput uVOutMinSet
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  CDL.Continuous.Constant RetDamPhyPosMin(k=0)
    "Physical or at the comissioning fixed minimum opening of the return air damper. Assuming 0 airflow through the damper at this position."
    annotation (Placement(transformation(extent={{-78,-272},{-58,-252}})));
  //fixme add units, should be percentage
  CDL.Continuous.Constant EcoDamPhyPosMin(k=0)
    "Physical or at the comissioning fixed minimum position of the economizer damper - economizer damper closed. Assuming VOut = 0 at this condition. This is the initial position of the economizer damper."
    annotation (Placement(transformation(extent={{-78,-352},{-58,-332}})));
  CDL.Continuous.LimPID MinOutAirDamPosController(
    yMax=1,
    yMin=0,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PID,
    Ti=0.9,
    Td=0.1,
    Nd=1,
    k=0.02)
    "Contoller that outputs a signal based on the error between the measured outdoor airflow and the minimum outdoor airflow requirement."
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  CDL.Continuous.Constant SigFraForEconDam(k=0.6)
    "Fraction of the control signal for which the economizer damper is and stays fully open and above which the return air damper modulates downwards."
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-138,-192},{-98,-152}})));
  CDL.Interfaces.BooleanInput uAHUMod
    "AHU Mode, fixme: see pg. 103 in G36 for the full list of modes, here we use true = \"occupied\""
    annotation (Placement(transformation(extent={{-138,-232},{-98,-192}})));
  CDL.Interfaces.RealOutput yEcoDamPosMin
    "Minimum economizer damper position limit." annotation (Placement(
        transformation(extent={{100,-10},{120,10}}), iconTransformation(extent=
            {{100,-10},{120,10}})));
  CDL.Interfaces.RealOutput yRetDamPosMax
    "Maximum return air damper position limit" annotation (Placement(
        transformation(extent={{100,20},{120,40}}), iconTransformation(extent={
            {100,20},{120,40}})));
  CDL.Continuous.Constant RetDamPhyPosMax(k=1)
    "Physical or at the comissioning fixed maximum opening of the return air damper. This is the initial condition of the return air damper."
    annotation (Placement(transformation(extent={{-78,-232},{-58,-212}})));
  CDL.Continuous.Constant EcoDamPhyPosMax(k=1)
    "Physical or at the comissioning fixed maximum position of the economizer damper - economizer damper fully open."
    annotation (Placement(transformation(extent={{-78,-312},{-58,-292}})));
  CDL.Continuous.Line EcoDamPosMin(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{62,-252},{82,-232}})));
  CDL.Continuous.Line RetDamPosMax(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{62,-212},{82,-192}})));
  CDL.Logical.Nand nand
    "If any of the input signals is not true, the block outputs true, damper modulation gets supressed and dampers are kept in their initial positions."
    annotation (Placement(transformation(extent={{-78,-202},{-58,-182}})));
  CDL.Logical.Switch RetDamPosMin
    "Set to RetDamPhyPosMax if the supply fan is off or the AHU mode is disabled to prevent any modulation"
    annotation (Placement(transformation(extent={{-38,-272},{-18,-252}})));
  CDL.Logical.Switch EcoDamPosMax
    "Set to EcoDamPhyPosMin if the supply fan is off or the AHU mode is disabled to prevent any modulation"
    annotation (Placement(transformation(extent={{-38,-312},{-18,-292}})));
  CDL.Continuous.Constant minSignalLimit(k=0)
    "Identical to controller parameter - Lower limit of output. fixme - set equal to yMin from PID"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  CDL.Continuous.Constant maxSignalLimit(k=1)
    "Identical to controller parameter - Upper limit of output. foxme - set equal to param yMax from PID"
    annotation (Placement(transformation(extent={{-18,-132},{2,-112}})));
  CDL.Interfaces.RealInput fixmename
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-140,-16},{-100,24}})));
  CDL.Interfaces.RealInput uVOut1
    "Measured outdoor airflow rate. Sensor output. Location: after the economizer damper intake."
    annotation (Placement(transformation(extent={{-140,-56},{-100,-16}})));
  CDL.Interfaces.RealInput uVOutMinSet2
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-140,-96},{-100,-56}})));
  CDL.Interfaces.RealInput uVOut2
    "Measured outdoor airflow rate. Sensor output. Location: after the economizer damper intake."
    annotation (Placement(transformation(extent={{-140,-136},{-100,-96}})));
equation
  connect(uVOutMinSet, MinOutAirDamPosController.u_s)
    annotation (Line(points={{-120,80},{-120,80},{-82,80}}, color={0,0,127}));
  connect(uVOut, MinOutAirDamPosController.u_m)
    annotation (Line(points={{-120,40},{-70,40},{-70,68}}, color={0,0,127}));
  connect(uSupFan, nand.u1) annotation (Line(points={{-118,-172},{-94,-172},{-94,
          -192},{-80,-192}}, color={255,0,255}));
  connect(uAHUMod, nand.u2) annotation (Line(points={{-118,-212},{-94,-212},{-94,
          -200},{-80,-200}}, color={255,0,255}));
  connect(nand.y, EcoDamPosMax.u2) annotation (Line(points={{-57,-192},{-48,-192},
          {-48,-302},{-40,-302}}, color={255,0,255}));
  connect(nand.y, RetDamPosMin.u2) annotation (Line(points={{-57,-192},{-48,-192},
          {-48,-262},{-40,-262}}, color={255,0,255}));
  connect(EcoDamPhyPosMax.y, EcoDamPosMax.u3) annotation (Line(points={{-57,-302},
          {-48,-302},{-48,-310},{-40,-310}}, color={0,0,127}));
  connect(EcoDamPhyPosMin.y, EcoDamPosMax.u1) annotation (Line(points={{-57,-342},
          {-50,-342},{-50,-294},{-40,-294}}, color={0,0,127}));
  connect(RetDamPhyPosMax.y, RetDamPosMin.u1) annotation (Line(points={{-57,-222},
          {-48,-222},{-48,-254},{-40,-254}},color={0,0,127}));
  connect(RetDamPhyPosMin.y, RetDamPosMin.u3) annotation (Line(points={{-57,-262},
          {-54,-262},{-54,-270},{-50,-270},{-40,-270}}, color={0,0,127}));
  connect(EcoDamPosMin.y, yEcoDamPosMin) annotation (Line(points={{83,-242},{96,
          -242},{96,0},{110,0}}, color={0,0,127}));
  connect(RetDamPosMax.y, yRetDamPosMax) annotation (Line(points={{83,-202},{92,
          -202},{92,30},{110,30}}, color={0,0,127}));
  connect(RetDamPhyPosMax.y, RetDamPosMax.f1) annotation (Line(points={{-57,-222},
          {14,-222},{14,-198},{60,-198}}, color={0,0,127}));
  connect(RetDamPosMin.y, RetDamPosMax.f2) annotation (Line(points={{-17,-262},
          {22,-262},{22,-210},{60,-210}},color={0,0,127}));
  connect(SigFraForEconDam.y, RetDamPosMax.x1) annotation (Line(points={{1,70},
          {44,70},{44,-194},{60,-194}},color={0,0,127}));
  connect(maxSignalLimit.y, RetDamPosMax.x2) annotation (Line(points={{3,-122},
          {34,-122},{34,-206},{60,-206}},color={0,0,127}));
  connect(MinOutAirDamPosController.y, RetDamPosMax.u) annotation (Line(points=
          {{-59,80},{-26,80},{-26,-202},{60,-202}},color={0,0,127}));
  connect(EcoDamPosMax.y, EcoDamPosMin.f2) annotation (Line(points={{-17,-302},
          {48,-302},{48,-250},{60,-250}},color={0,0,127}));
  connect(EcoDamPhyPosMin.y, EcoDamPosMin.f1) annotation (Line(points={{-57,-342},
          {34,-342},{34,-238},{60,-238}}, color={0,0,127}));
  connect(minSignalLimit.y, EcoDamPosMin.x1) annotation (Line(points={{1,40},{
          38,40},{38,-234},{60,-234}}, color={0,0,127}));
  connect(SigFraForEconDam.y, EcoDamPosMin.x2) annotation (Line(points={{1,70},
          {20,70},{20,-246},{60,-246}},color={0,0,127}));
  connect(MinOutAirDamPosController.y, EcoDamPosMin.u) annotation (Line(points=
          {{-59,80},{-36,80},{-36,-242},{60,-242}},color={0,0,127}));
  annotation (
    defaultComponentName = "ecoMod",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,100},{-26,64}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uVOutMin"),
        Text(
          extent={{112,70},{182,34}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPosMax"),
        Text(
          extent={{-96,62},{-26,26}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uVOut"),
        Text(
          extent={{112,6},{182,-30}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPosMin"),
        Text(
          extent={{-96,-20},{-26,-56}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uAHUMod"),
        Text(
          extent={{-96,22},{-26,-14}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uSupFan"),
        Line(
          points={{0,64},{-66,-64},{64,-64},{0,64}},
          color={28,108,200},
          thickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-240},{
            100,100}})),
    Documentation(info="<html>      
    <p>
    fixme status: initiate inputs and outputs
This atomic sequence sets the economizer and
return air damper position. The implementation is according
to ASHRAE Guidline 36 (G36), PART5.N.2.c and functionaly it represents the 
final sequence in the composite economizer control sequence.
</p>   
<p>
The controller is enabled indirectly through the output of the the EconEnableDisable 
sequence, which defines the maximum economizer damper position. Thus, strictly 
speaking, the modulation sequence remains active, but if the economizer gets
disabled, the range of economizer damper modulation equals zero.
fixme: return air damper may be modulated even if econ disable, according to
this control loop. Check if that is desired. Last time I reflected on this
it seemed it would not pose functional dificulties.
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconModulationStateMachineChart.png\"/>
</p>
<p>
fixme: interpret corresponding text from G36 as implemented here.
</p>
<p>
Control charts below show the input-output structure and an economizer damper 
modulation sequence assuming a well tuned controller. Control diagram:
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconModulationLimitsControlDiagram.png\"/>
</p>
<p>
Expected control performance, upon tuning:
<br>
</br>
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconModulationLimitsControlChart.png\"/>
</p>
<p>
bla
</p>

</html>", revisions="<html>
<ul>
<li>
April 04, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconModulation;
