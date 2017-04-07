within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model EconModulation "Based on measured and requred minimum outdoor airflow the controller resets 
  the min limit of the economizer damper and the max limit of the return air 
  damper in order to maintain the minimum required outdoor airflow."
  // fixme: add keep previous pos if VOut>VOutSet AND EcoDamPos>EcoDamPosMin
  // to avoid non-realistic setting of say econ min limit to 0 because the
  // measured flow is higher while the economizer is open wider (enabled or
  // modulating above the min)

  CDL.Interfaces.RealInput TCoo
    "Measured supply air temperature. Sensor output."
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput TCooSet
    "Output of a ***TSupSet sequence. The economizer modulates to the TCoo rather than to the THea. If Zone State is Cooling, economizer modulates to a temperture slightly lower than the TCoo."
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  CDL.Continuous.Constant RetDamPhyPosMin(k=0)
    "Physical or at the comissioning fixed minimum opening of the return air damper. Assuming 0 airflow through the damper at this position."
    annotation (Placement(transformation(extent={{-78,-372},{-58,-352}})));
  //fixme add units, should be percentage
  CDL.Continuous.Constant EcoDamPhyPosMin(k=0)
    "Physical or at the comissioning fixed minimum position of the economizer damper - economizer damper closed. Assuming VOut = 0 at this condition. This is the initial position of the economizer damper."
    annotation (Placement(transformation(extent={{-78,-452},{-58,-432}})));
  CDL.Continuous.LimPID MinOutAirDamPosController(
    yMax=1,
    yMin=0,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PID,
    Ti=0.9,
    Td=0.1,
    Nd=1,
    k=0.02)
    "Contoller that outputs a signal based on the error between the measured outdoor airflow and the minimum outdoor airflow requirement."
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-140,-240},{-100,-200}})));
  CDL.Interfaces.RealOutput yEcoDamPosMin
    "Minimum economizer damper position limit." annotation (Placement(
        transformation(extent={{100,-30},{120,-10}}),iconTransformation(extent={{100,-30},
            {120,-10}})));
  CDL.Interfaces.RealOutput yRetDamPosMax
    "Maximum return air damper position limit" annotation (Placement(
        transformation(extent={{100,-10},{120,10}}),iconTransformation(extent={{100,-10},
            {120,10}})));
  CDL.Continuous.Constant RetDamPhyPosMax(k=1)
    "Physical or at the comissioning fixed maximum opening of the return air damper. This is the initial condition of the return air damper."
    annotation (Placement(transformation(extent={{-78,-332},{-58,-312}})));
  CDL.Continuous.Constant EcoDamPhyPosMax(k=1)
    "Physical or at the comissioning fixed maximum position of the economizer damper - economizer damper fully open."
    annotation (Placement(transformation(extent={{-78,-412},{-58,-392}})));
  CDL.Continuous.Line EcoDamPosMin(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Continuous.Line RetDamPosMax(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  CDL.Logical.Nand nand
    "If any of the input signals is not true, the block outputs true, damper modulation gets supressed and dampers are kept in their initial positions."
    annotation (Placement(transformation(extent={{-78,-302},{-58,-282}})));
  CDL.Logical.Switch RetDamPosMin
    "Set to RetDamPhyPosMax if the supply fan is off or the AHU mode is disabled to prevent any modulation"
    annotation (Placement(transformation(extent={{-38,-372},{-18,-352}})));
  CDL.Logical.Switch EcoDamPosMax
    "Set to EcoDamPhyPosMin if the supply fan is off or the AHU mode is disabled to prevent any modulation"
    annotation (Placement(transformation(extent={{-38,-412},{-18,-392}})));
  CDL.Continuous.Constant minSignalLimit(k=0)
    "Identical to controller parameter - Lower limit of output. fixme - set equal to yMin from PID"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  CDL.Continuous.Constant maxSignalLimit(k=1)
    "Identical to controller parameter - Upper limit of output. foxme - set equal to param yMax from PID"
    annotation (Placement(transformation(extent={{-20,-260},{0,-240}})));
  CDL.Interfaces.RealInput uHea
    "Heating control signal. fixme: we may instead use the Zone State, pg. 33, which takes 3 string values: Cooling, Heating, Deadband. This would merge the uCool and uHeat input."
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealInput uCoo
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.RealInput uEcoDamPosMin
    "Minimum economizer damper position limit as returned by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput uEcoDamPosMax
    "Maximum economizer damper position limit as returned by the EconEnableDisable sequence. If the economizer is disabled, this value equals uEcoDamPosMin"
    annotation (Placement(transformation(extent={{-140,-130},{-100,-90}})));
  CDL.Interfaces.RealInput uRetDamPosMin
    "fixme - check out: Minimum return air damper position limit as returned by the EconDamPosLimits sequence. This is a fixed value and the mentioned sequence assignes the value, which should in principle always be 0, but I'd like to avoid setting the value in multiple places."
    annotation (Placement(transformation(extent={{-140,-160},{-100,-120}})));
  CDL.Interfaces.RealInput uRetDamPosMax
    "Minimum economizer damper position limit as returned by the EconDamPosLimits sequence."
    annotation (Placement(transformation(extent={{-140,-190},{-100,-150}})));
equation
  connect(TCoo, MinOutAirDamPosController.u_m) annotation (Line(points={{-120,
          40},{-60,40},{-60,-2},{-60,-58},{-30,-58},{-30,-42}}, color={0,0,127}));
  connect(uSupFan, nand.u1) annotation (Line(points={{-120,-220},{-94,-220},{
          -94,-292},{-80,-292}},
                             color={255,0,255}));
  connect(nand.y, EcoDamPosMax.u2) annotation (Line(points={{-57,-292},{-48,
          -292},{-48,-402},{-40,-402}},
                                  color={255,0,255}));
  connect(nand.y, RetDamPosMin.u2) annotation (Line(points={{-57,-292},{-48,
          -292},{-48,-362},{-40,-362}},
                                  color={255,0,255}));
  connect(EcoDamPhyPosMax.y, EcoDamPosMax.u3) annotation (Line(points={{-57,
          -402},{-48,-402},{-48,-410},{-40,-410}},
                                             color={0,0,127}));
  connect(EcoDamPhyPosMin.y, EcoDamPosMax.u1) annotation (Line(points={{-57,
          -442},{-50,-442},{-50,-394},{-40,-394}},
                                             color={0,0,127}));
  connect(RetDamPhyPosMax.y, RetDamPosMin.u1) annotation (Line(points={{-57,
          -322},{-48,-322},{-48,-354},{-40,-354}},
                                            color={0,0,127}));
  connect(RetDamPhyPosMin.y, RetDamPosMin.u3) annotation (Line(points={{-57,
          -362},{-54,-362},{-54,-270},{-40,-270},{-40,-370}},
                                                        color={0,0,127}));
  connect(EcoDamPosMin.y, yEcoDamPosMin) annotation (Line(points={{81,10},{88,
          10},{88,-20},{110,-20}},
                                 color={0,0,127}));
  connect(RetDamPosMax.y, yRetDamPosMax) annotation (Line(points={{81,50},{92,
          50},{92,0},{110,0}},     color={0,0,127}));
  connect(RetDamPhyPosMax.y, RetDamPosMax.f1) annotation (Line(points={{-57,
          -322},{14,-322},{14,54},{58,54}},
                                          color={0,0,127}));
  connect(RetDamPosMin.y, RetDamPosMax.f2) annotation (Line(points={{-17,-362},
          {22,-362},{22,42},{58,42}},    color={0,0,127}));
  connect(maxSignalLimit.y, RetDamPosMax.x2) annotation (Line(points={{1,-250},
          {34,-250},{34,46},{58,46}},    color={0,0,127}));
  connect(MinOutAirDamPosController.y, RetDamPosMax.u) annotation (Line(points={{-19,-30},
          {-12,-30},{-12,50},{58,50}},             color={0,0,127}));
  connect(EcoDamPosMax.y, EcoDamPosMin.f2) annotation (Line(points={{-17,-402},
          {48,-402},{48,2},{58,2}},      color={0,0,127}));
  connect(EcoDamPhyPosMin.y, EcoDamPosMin.f1) annotation (Line(points={{-57,
          -442},{34,-442},{34,14},{58,14}},
                                          color={0,0,127}));
  connect(minSignalLimit.y, EcoDamPosMin.x1) annotation (Line(points={{1,70},{
          38,70},{38,18},{58,18}},     color={0,0,127}));
  connect(MinOutAirDamPosController.y, EcoDamPosMin.u) annotation (Line(points={{-19,-30},
          {-6,-30},{-6,10},{26,10},{26,10},{58,10}},
                                                   color={0,0,127}));
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
        Line(points={{20,58}}, color={28,108,200}),
        Line(points={{-74,-64},{-28,-64},{34,62},{78,62}}, color={28,108,200}),

        Line(
          points={{-54,62},{-10,62},{60,-60},{82,-60}},
          color={28,108,200},
          pattern=LinePattern.Dash)}),
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
