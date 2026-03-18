within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block SelectSmallestValvePosition "temDifSelectionMin"
             parameter Integer nChi=3
    "Number of values to compare";
    parameter Integer nSel=1;
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAcnFla[nChi]
    "action flag" annotation (Placement(transformation(extent={{100,-20},{140,
            20}}), iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uIgnFla[nChi]
    "ignore flag" annotation (Placement(transformation(extent={{-140,-90},{-100,
            -50}}), iconTransformation(extent={{-140,-78},{-100,-38}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nChi]
    annotation (Placement(transformation(extent={{-42,32},{-22,52}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nChi](k=1000)
    annotation (Placement(transformation(extent={{-88,62},{-68,82}})));
  CDL.Interfaces.RealInput uCooCoiValCur[nChi] annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  CDL.Reals.MovingAverage
                     movAve
                        [nChi]
    annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));
  SelectSmallestValues selectSmallestValues(nNum=nChi, nSel=nSel)
    annotation (Placement(transformation(extent={{38,-10},{58,10}})));
equation
  connect(uIgnFla, swi.u2) annotation (Line(points={{-120,-70},{-84,-70},{-84,42},
          {-44,42}},     color={255,0,255}));
  connect(con.y, swi.u1) annotation (Line(points={{-66,72},{-52,72},{-52,50},{-44,
          50}},     color={0,0,127}));
  connect(movAve.y, swi.u3)
    annotation (Line(points={{-48,-10},{-44,-10},{-44,34}}, color={0,0,127}));
  connect(swi.y, selectSmallestValues.u) annotation (Line(points={{-20,42},{26,
          42},{26,0},{36,0}},
                            color={0,0,127}));
  connect(selectSmallestValues.y, yAcnFla) annotation (Line(points={{60,0},{120,
          0}},                  color={255,0,255}));
  connect(uCooCoiValCur, movAve.u) annotation (Line(points={{-120,0},{-98,0},{-98,
          -10},{-72,-10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        grid={2,2})),
    Documentation(info="<html>
hello
</html>"));
end SelectSmallestValvePosition;
