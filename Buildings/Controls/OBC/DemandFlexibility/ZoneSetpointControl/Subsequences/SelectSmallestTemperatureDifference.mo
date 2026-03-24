within Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.Subsequences;
block SelectSmallestTemperatureDifference "temDifSelectionMin"
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
    annotation (Placement(transformation(extent={{-14,32},{6,52}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nZon](k=1000)
    annotation (Placement(transformation(extent={{-68,74},{-48,94}})));
  CDL.Interfaces.RealInput TSetCur[nZon] annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},
            {-100,20}})));
  CDL.Reals.Subtract sub[nZon]
    annotation (Placement(transformation(extent={{-48,-4},{-28,16}})));
  Generic.SelectSmallestValues selectSmallestValues(nNum=nZon, nSel=nSel)
    annotation (Placement(transformation(extent={{38,-10},{58,10}})));
equation
  connect(uIgnFla, swi.u2) annotation (Line(points={{-120,-70},{-84,-70},{-84,
          42},{-16,42}}, color={255,0,255}));
  connect(con.y, swi.u1) annotation (Line(points={{-46,84},{-32,84},{-32,50},{
          -16,50}}, color={0,0,127}));
  connect(TCur, sub.u1) annotation (Line(points={{-120,66},{-70,66},{-70,12},{
          -50,12}},     color={0,0,127}));
  connect(TSetCur, sub.u2) annotation (Line(points={{-120,0},{-50,0}},
                color={0,0,127}));
  connect(sub.y, swi.u3)
    annotation (Line(points={{-26,6},{-16,6},{-16,34}}, color={0,0,127}));
  connect(swi.y, selectSmallestValues.u) annotation (Line(points={{8,42},{26,42},
          {26,0},{36,0}},   color={0,0,127}));
  connect(selectSmallestValues.y, yAcnFla) annotation (Line(points={{60,0},{120,
          0}},                  color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        grid={2,2})),
    Documentation(info="<html>
<p>This block is used to select the nSel smallest temperature difference values, then output the action flag yAcnFla on which temperature difference values are selected to take some output action. The temperature difference is calculated by the current temperature (TCur) minus the current tempearture setpoint (TSetCur).</p>
<p>The inputs also include an ignore flag uIgnFla. This is especially useful when controlling temperature ratchets. When a temperature setpoint has reached the target temperature setpoint, it is possible that the tamperature difference is still one of the smallest. Therefore, we would like this temperature setpoint to be temporarily ignored such that we can give the priority to other temperature setpoints</p>
</html>"));
end SelectSmallestTemperatureDifference;
