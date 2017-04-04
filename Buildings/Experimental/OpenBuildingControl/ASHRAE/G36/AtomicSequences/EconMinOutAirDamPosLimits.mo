within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model EconMinOutAirDamPosLimits
  "Based on measured and requred minimum outdoor airflow the controller resets 
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
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
    //fixme add units, should be percentage
  CDL.Continuous.Constant EcoDamPhyPosMin(k=0)
    "Physical or at the comissioning fixed minimum position of the economizer damper - economizer damper closed. Assuming VOut = 0 at this condition. This is the initial position of the economizer damper."
    annotation (Placement(transformation(extent={{-80,-220},{-60,-200}})));
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
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.BooleanInput uAHUMod
    "AHU Mode, fixme: see pg. 103 in G36 for the full list of modes, here we use true = \"occupied\""
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.RealOutput yEcoDamPosMin
    "Minimum economizer damper position limit."
    annotation (Placement(transformation(extent={{100,-40},{120,-20}}),
        iconTransformation(extent={{100,-40},{120,-20}})));
  CDL.Interfaces.RealOutput yRetDamPosMax
    "Maximum return air damper position limit"
    annotation (Placement(transformation(extent={{100,20},{120,40}}),
        iconTransformation(extent={{100,20},{120,40}})));
  CDL.Continuous.Constant RetDamPhyPosMax(k=1)
    "Physical or at the comissioning fixed maximum opening of the return air damper. This is the initial condition of the return air damper."
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  CDL.Continuous.Constant EcoDamPhyPosMax(k=1)
    "Physical or at the comissioning fixed maximum position of the economizer damper - economizer damper fully open."
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));
  CDL.Continuous.Line EcoDamPosMin(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
  CDL.Continuous.Line RetDamPosMax(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  CDL.Logical.Nand nand
    "If any of the input signals is not true, the block outputs true, damper modulation gets supressed and dampers are kept in their initial positions."
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  CDL.Logical.Switch RetDamPosMin
    "Set to RetDamPhyPosMax if the supply fan is off or the AHU mode is disabled to prevent any modulation"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  CDL.Logical.Switch EcoDamPosMax
    "Set to EcoDamPhyPosMin if the supply fan is off or the AHU mode is disabled to prevent any modulation"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  CDL.Continuous.Constant minSignalLimit(k=0)
    "Identical to controller parameter - Lower limit of output. fixme - set equal to yMin from PID"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  CDL.Continuous.Constant maxSignalLimit(k=1)
    "Identical to controller parameter - Upper limit of output. foxme - set equal to param yMax from PID"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(uVOutMinSet, MinOutAirDamPosController.u_s)
    annotation (Line(points={{-120,80},{-120,80},{-82,80}}, color={0,0,127}));
  connect(uVOut, MinOutAirDamPosController.u_m)
    annotation (Line(points={{-120,40},{-70,40},{-70,68}}, color={0,0,127}));
  connect(uSupFan, nand.u1) annotation (Line(points={{-120,0},{-96,0},{-96,-20},
          {-82,-20}}, color={255,0,255}));
  connect(uAHUMod, nand.u2) annotation (Line(points={{-120,-40},{-96,-40},{-96,
          -28},{-82,-28}},
                      color={255,0,255}));
  connect(nand.y, EcoDamPosMax.u2) annotation (Line(points={{-59,-20},{-50,-20},
          {-50,-170},{-42,-170}}, color={255,0,255}));
  connect(nand.y, RetDamPosMin.u2) annotation (Line(points={{-59,-20},{-50,-20},
          {-50,-130},{-42,-130}}, color={255,0,255}));
  connect(EcoDamPhyPosMax.y, EcoDamPosMax.u3) annotation (Line(points={{-59,
          -170},{-50,-170},{-50,-178},{-42,-178}},
                                             color={0,0,127}));
  connect(EcoDamPhyPosMin.y, EcoDamPosMax.u1) annotation (Line(points={{-59,
          -210},{-52,-210},{-52,-162},{-42,-162}},
                                             color={0,0,127}));
  connect(RetDamPhyPosMax.y, RetDamPosMin.u1) annotation (Line(points={{-59,-90},
          {-50,-90},{-50,-122},{-42,-122}}, color={0,0,127}));
  connect(RetDamPhyPosMin.y, RetDamPosMin.u3) annotation (Line(points={{-59,-130},
          {-56,-130},{-56,-138},{-52,-138},{-42,-138}}, color={0,0,127}));
  connect(EcoDamPosMin.y, yEcoDamPosMin) annotation (Line(points={{81,-110},{94,
          -110},{94,-30},{110,-30}},  color={0,0,127}));
  connect(RetDamPosMax.y, yRetDamPosMax) annotation (Line(points={{81,-70},{90,
          -70},{90,30},{110,30}},    color={0,0,127}));
  connect(RetDamPhyPosMax.y, RetDamPosMax.f1) annotation (Line(points={{-59,-90},
          {12,-90},{12,-66},{58,-66}}, color={0,0,127}));
  connect(RetDamPosMin.y, RetDamPosMax.f2) annotation (Line(points={{-19,-130},
          {20,-130},{20,-78},{58,-78}}, color={0,0,127}));
  connect(SigFraForEconDam.y, RetDamPosMax.x1) annotation (Line(points={{1,70},{
          42,70},{42,-62},{58,-62}},  color={0,0,127}));
  connect(maxSignalLimit.y, RetDamPosMax.x2) annotation (Line(points={{1,10},{32,
          10},{32,-74},{58,-74}},    color={0,0,127}));
  connect(MinOutAirDamPosController.y, RetDamPosMax.u) annotation (Line(points={{-59,80},
          {-28,80},{-28,-70},{58,-70}},           color={0,0,127}));
  connect(EcoDamPosMax.y, EcoDamPosMin.f2) annotation (Line(points={{-19,-170},
          {46,-170},{46,-118},{58,-118}}, color={0,0,127}));
  connect(EcoDamPhyPosMin.y, EcoDamPosMin.f1) annotation (Line(points={{-59,
          -210},{32,-210},{32,-106},{58,-106}}, color={0,0,127}));
  connect(minSignalLimit.y, EcoDamPosMin.x1) annotation (Line(points={{1,40},{36,
          40},{36,-102},{58,-102}},    color={0,0,127}));
  connect(SigFraForEconDam.y, EcoDamPosMin.x2) annotation (Line(points={{1,70},{
          18,70},{18,-114},{58,-114}},  color={0,0,127}));
  connect(MinOutAirDamPosController.y, EcoDamPosMin.u) annotation (Line(points={{-59,80},
          {-38,80},{-38,-110},{58,-110}},           color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -240},{100,100}}),                                  graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),                                   Line(
          points={{2,50},{-46,-40},{48,-40},{2,50}},
          color={28,108,200},
          thickness=0.5),
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
          textString="uSupFan")}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-240},{100,
            100}})),
 Documentation(info="<html>      
<p>
This atomic sequence sets the minimum economizer damper position limit and
the maximum return air damper position limit. The implementation is according
to ASHRAE Guidline 36 (G36), PART5.M.6.c.
</p>   
<p>
The controller is enabled when the supply fan is proven on and the AHU is in
Occupied Mode. Otherwise the damper position limits are set to their corresponding
maximum and minimum physical or at comissioning fixed limits. The state machine
diagram below illustrates this.
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/fixme.png\"/>
</p>
<p>
According to mentioned article from G36, the outdoor airflow rate, uVOut,
shall be maintained at the minimum outdoor air setpoint, VOutMinSet, which is an output of
a separate atomic sequence, by a reverse-acting control loop whose output is 
mapped to the maximum return air damper position, yRetDamPosMax, and to the
minimum supply air damper position, yEcoDamPosMin.
</p>
<p>
Control charts below show the input-output structure and a damper limit 
position sequence assuming a well tuned controller.
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/fixme.png\"/>
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/fixme.png\"/>
</p>
<p>
fixme: additional text about the functioning of the sequence
Note that VOut depends on whether the economizer damper is controlled to a 
position higher than it's minimum limit. This is defined by the EconEnableDisable
and EconModulate [fixme check seq name] sequences. Fixme feature add: For this reason
we may want to implement something like:
while VOut > VOutSet and EcoDamPos>EcoDamPosMin, keep previous EcoDamPosMin.
</p>

</html>", revisions="<html>
<ul>
<li>
April 04, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconMinOutAirDamPosLimits;
