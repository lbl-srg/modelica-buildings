within Buildings.Controls.OBC.DemandFlexibility.FanValveLimiting.Subsequences;
block SelectSmallestValvePosition "temDifSelectionMin"
             parameter Integer nChi=3
    "Number of values to compare";
    parameter Integer nSel=1;

    parameter Real movAvgTimRan(unit="s")=1800
    "time range for moving average";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAcnFla[nChi]
    "action flag" annotation (Placement(transformation(extent={{100,-20},{140,
            20}}), iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uIgnFla[nChi]
    "ignore flag" annotation (Placement(transformation(extent={{-140,-90},{-100,
            -50}}), iconTransformation(extent={{-140,-78},{-100,-38}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi]
    annotation (Placement(transformation(extent={{-6,30},{14,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nChi](k=1000)
    annotation (Placement(transformation(extent={{-88,62},{-68,82}})));
  CDL.Interfaces.RealInput uCooCoiValCur[nChi] annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  CDL.Reals.MovingAverage
                     movAve
                        [nChi](delta=movAvgTimRan)
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
  Generic.SelectSmallestValues selectSmallestValues(nNum=nChi, nSel=nSel)
    annotation (Placement(transformation(extent={{38,-10},{58,10}})));
equation
  connect(uIgnFla, swi.u2) annotation (Line(points={{-120,-70},{-84,-70},{-84,
          40},{-8,40}},  color={255,0,255}));
  connect(con.y, swi.u1) annotation (Line(points={{-66,72},{-52,72},{-52,48},{
          -8,48}},  color={0,0,127}));
  connect(movAve.y, swi.u3)
    annotation (Line(points={{-30,0},{-16,0},{-16,32},{-8,32}},
                                                            color={0,0,127}));
  connect(swi.y, selectSmallestValues.u) annotation (Line(points={{16,40},{26,
          40},{26,0},{36,0}},
                            color={0,0,127}));
  connect(selectSmallestValues.y, yAcnFla) annotation (Line(points={{60,0},{120,
          0}},                  color={255,0,255}));
  connect(uCooCoiValCur, movAve.u) annotation (Line(points={{-120,0},{-54,0}},
                           color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        grid={2,2})),
    Documentation(info="<html>
<p>This block is used to select the nSel smallest fan speed or valve position values, then output the 
action flag <code>yAcnFla</code> on which fans or valves are selected to take some output action. </p>
<p>The inputs also include an ignore flag <code>uIgnFla</code>. This is especially useful when controlling 
fan speed or valve position ratchets. When a fan speed or valve position has reached the target 
value, it is possible that the fan speed or valve position is still one of the smallest. Therefore, 
we would like this fan or valve to be temporarily ignored such that we can give the priority to other 
fans or valves.</p>
</html>"));
end SelectSmallestValvePosition;
