within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model EconMinOutAirDamPosLimits
  "Based on measured and requred minimum outdoor airflow the controller resets 
  the min limit of the economizer damper and the max limit of the return air 
  damper in order to maintain the minimum required outdoor airflow."

  CDL.Interfaces.RealInput uVOut
    "Measured outdoor airflow rate. Sensor output. Location: after the economizer damper intake."
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput uVOutMin
    "Minimum outdoor airflow requirement, output of a separate sequence that calculates this value based on ASHRAE Standard 62.1-2013 or California Title 24"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  CDL.Continuous.Constant RetDamPhyPosMin(k=0)
    "Physical or at the comissioning fixed minimum opening of the return air damper. Assuming 0 airflow through the damper at this position."
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
                                               //fixmi add units, should be percentage
  CDL.Continuous.Constant EcoDamPhyPosMin(k=0)
    "Physical or at the comissioning fixed minimum position of the economizer damper - economizer damper closed. Assuming VOut = 0 at this condition. This is the initial position of the economizer damper."
    annotation (Placement(transformation(extent={{-80,-218},{-60,-198}})));
  CDL.Continuous.LimPID MinOutAirDamPosController(
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,
    yMax=1,
    yMin=0)
    "Contoller that outputs a signal based on the error between the measured outdoor airflow and the minimum outdoor airflow requirement."
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));

  CDL.Continuous.Constant SigFraForEconDam(k=0.6)
    "Fraction of the control signal for which the economizer damper is and stays fully open and above which the return air damper modulates downwards."
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.BooleanInput uAHUMod "AHU Mode, occupied or not occupied"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.RealOutput yEcoDamPosMin
    "Minimum economizer damper position limit."
    annotation (Placement(transformation(extent={{200,-70},{220,-50}})));
  CDL.Interfaces.RealOutput yRetDamPosMax
    "Maximum return air damper position limit"
    annotation (Placement(transformation(extent={{200,-30},{220,-10}})));
  CDL.Continuous.Constant RetDamPhyPosMax(k=1)
    "Physical or at the comissioning fixed maximum opening of the return air damper. This is the initial condition of the return air damper."
    annotation (Placement(transformation(extent={{-80,-106},{-60,-86}})));
  CDL.Continuous.Constant EcoDamPhyPosMax(k=1)
    "Physical or at the comissioning fixed maximum position of the economizer damper - economizer damper fully open."
    annotation (Placement(transformation(extent={{-80,-182},{-60,-162}})));
  CDL.Continuous.Line EcoDamPosMin(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  CDL.Continuous.Line RetDamPosMax(limitBelow=true, limitAbove=true)
    "Damper position is linearly proportional to the control signal."
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
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
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  CDL.Continuous.Constant maxSignalLimit(k=1)
    "Identical to controller parameter - Upper limit of output. foxme - set equal to param yMax from PID"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
equation
  connect(uVOutMin, MinOutAirDamPosController.u_s)
    annotation (Line(points={{-120,80},{-120,80},{-72,80}}, color={0,0,127}));
  connect(uVOut, MinOutAirDamPosController.u_m)
    annotation (Line(points={{-120,40},{-60,40},{-60,68}}, color={0,0,127}));
  connect(uSupFan, nand.u1) annotation (Line(points={{-120,0},{-96,0},{-96,-20},
          {-82,-20}}, color={255,0,255}));
  connect(uAHUMod, nand.u2) annotation (Line(points={{-120,-40},{-96,-40},{-96,
          -28},{-82,-28}},
                      color={255,0,255}));
  connect(nand.y, EcoDamPosMax.u2) annotation (Line(points={{-59,-20},{-50,-20},
          {-50,-170},{-42,-170}}, color={255,0,255}));
  connect(nand.y, RetDamPosMin.u2) annotation (Line(points={{-59,-20},{-50,-20},
          {-50,-130},{-42,-130}}, color={255,0,255}));
  connect(EcoDamPhyPosMax.y, EcoDamPosMax.u3) annotation (Line(points={{-59,-172},
          {-50,-172},{-50,-178},{-42,-178}}, color={0,0,127}));
  connect(EcoDamPhyPosMin.y, EcoDamPosMax.u1) annotation (Line(points={{-59,-208},
          {-52,-208},{-52,-162},{-42,-162}}, color={0,0,127}));
  connect(RetDamPhyPosMax.y, RetDamPosMin.u1) annotation (Line(points={{-59,-96},
          {-50,-96},{-50,-122},{-42,-122}}, color={0,0,127}));
  connect(RetDamPhyPosMin.y, RetDamPosMin.u3) annotation (Line(points={{-59,-130},
          {-56,-130},{-56,-138},{-52,-138},{-42,-138}}, color={0,0,127}));
  connect(EcoDamPosMin.y, yEcoDamPosMin) annotation (Line(points={{121,-110},{160,
          -110},{160,-60},{210,-60}}, color={0,0,127}));
  connect(RetDamPosMax.y, yRetDamPosMax) annotation (Line(points={{121,-60},{140,
          -60},{140,-20},{210,-20}}, color={0,0,127}));
  connect(RetDamPhyPosMax.y, RetDamPosMax.f1) annotation (Line(points={{-59,-96},
          {20,-96},{20,-56},{98,-56}}, color={0,0,127}));
  connect(RetDamPosMin.y, RetDamPosMax.f2) annotation (Line(points={{-19,-130},
          {28,-130},{28,-68},{98,-68}}, color={0,0,127}));
  connect(SigFraForEconDam.y, RetDamPosMax.x1) annotation (Line(points={{21,80},
          {70,80},{70,-52},{98,-52}}, color={0,0,127}));
  connect(maxSignalLimit.y, RetDamPosMax.x2) annotation (Line(points={{21,20},{
          60,20},{60,-64},{98,-64}}, color={0,0,127}));
  connect(MinOutAirDamPosController.y, RetDamPosMax.u) annotation (Line(points=
          {{-49,80},{-20,80},{-20,-60},{98,-60}}, color={0,0,127}));
  connect(EcoDamPosMax.y, EcoDamPosMin.f2) annotation (Line(points={{-19,-170},
          {78,-170},{78,-118},{98,-118}}, color={0,0,127}));
  connect(EcoDamPhyPosMin.y, EcoDamPosMin.f1) annotation (Line(points={{-59,
          -208},{40,-208},{40,-106},{70,-106},{70,-106},{98,-106}}, color={0,0,
          127}));
  connect(minSignalLimit.y, EcoDamPosMin.x1) annotation (Line(points={{21,50},{
          64,50},{64,-102},{98,-102}}, color={0,0,127}));
  connect(SigFraForEconDam.y, EcoDamPosMin.x2) annotation (Line(points={{21,80},
          {46,80},{46,-114},{98,-114}}, color={0,0,127}));
  connect(MinOutAirDamPosController.y, EcoDamPosMin.u) annotation (Line(points=
          {{-49,80},{-30,80},{-30,-110},{-12,-110},{-12,-110},{98,-110}}, color
        ={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-240},
            {200,100}}),                                        graphics={
        Rectangle(
        extent={{-100,-200},{200,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),                                   Line(
          points={{52,46},{-44,-132},{142,-132},{52,46}},
          color={28,108,200},
          thickness=0.5)}),                                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-240},{200,100}})));
end EconMinOutAirDamPosLimits;
