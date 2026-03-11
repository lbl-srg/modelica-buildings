within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block SelectLargestTemperatureDifference "temDifSelectionMin"
             parameter Integer nZon=3
    "Number of values to compare";
    parameter Integer nSel=1;
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCur[nZon] annotation (
      Placement(transformation(extent={{-140,46},{-100,86}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAcnFla[nZon]
    "action flag" annotation (Placement(transformation(extent={{100,-20},{140,
            20}}), iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uIgnFla[nZon]
    "ignore flag" annotation (Placement(transformation(extent={{-140,-90},{-100,
            -50}}), iconTransformation(extent={{-140,-78},{-100,-38}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nZon]
    annotation (Placement(transformation(extent={{-16,32},{4,52}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nZon](k=-1000)
    annotation (Placement(transformation(extent={{-76,62},{-56,82}})));
  CDL.Interfaces.RealInput TSetCur[nZon] annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},
            {-100,20}})));
  CDL.Reals.Subtract sub[nZon]
    annotation (Placement(transformation(extent={{-52,-4},{-32,16}})));
  SelectLargestValues  selectLargestValues( nNum=nZon, nSel=nSel)
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
equation
  connect(uIgnFla, swi.u2) annotation (Line(points={{-120,-70},{-84,-70},{-84,
          42},{-18,42}}, color={255,0,255}));
  connect(con.y, swi.u1) annotation (Line(points={{-54,72},{-34,72},{-34,50},{
          -18,50}}, color={0,0,127}));
  connect(TCur, sub.u1) annotation (Line(points={{-120,66},{-94,66},{-94,38},{
          -54,38},{-54,12}},
                        color={0,0,127}));
  connect(TSetCur, sub.u2) annotation (Line(points={{-120,0},{-54,0}},
                color={0,0,127}));
  connect(sub.y, swi.u3)
    annotation (Line(points={{-30,6},{-18,6},{-18,34}}, color={0,0,127}));
  connect(swi.y, selectLargestValues.u) annotation (Line(points={{6,42},{26,42},
          {26,0},{44,0}},       color={0,0,127}));
  connect(selectLargestValues.y, yAcnFla) annotation (Line(points={{68,0},{120,
          0}},                  color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        grid={2,2})),
    Documentation(info="<html>
hello
</html>"));
end SelectLargestTemperatureDifference;
