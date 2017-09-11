within Buildings.Controls.OBC.ASHRAE.G36.Atomic;
block SystemRequestsReheatBox
  "Output systems requests for VAV reheat terminal unit control"
  CDL.Interfaces.RealInput TRoo "Zone temperature" annotation (Placement(
        transformation(extent={{-300,350},{-260,390}}), iconTransformation(
          extent={{-484,164},{-444,204}})));
  CDL.Interfaces.RealInput TCooSet "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-300,320},{-260,360}}),
        iconTransformation(extent={{-484,164},{-444,204}})));
  CDL.Continuous.Add add2(k2=-1)
    "Calculate difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-220,350},{-200,370}})));
  CDL.Continuous.Hysteresis hys(uLow=2.7, uHigh=2.9)
    "Check if zone temperature is greater than cooling setpoint by 2.8 degC"
    annotation (Placement(transformation(extent={{-160,350},{-140,370}})));
  CDL.Logical.Timer tim
    annotation (Placement(transformation(extent={{-120,350},{-100,370}})));
  CDL.Continuous.Hysteresis hys1(uLow=110, uHigh=130)
    "Check if it is more than 2 minutes"
    annotation (Placement(transformation(extent={{-80,350},{-60,370}})));
equation
  connect(TRoo, add2.u1) annotation (Line(points={{-280,370},{-240,370},{-240,
          366},{-222,366}}, color={0,0,127}));
  connect(TCooSet, add2.u2) annotation (Line(points={{-280,340},{-240,340},{
          -240,354},{-222,354}}, color={0,0,127}));
  connect(hys.y, tim.u)
    annotation (Line(points={{-139,360},{-122,360}}, color={255,0,255}));
  connect(tim.y, hys1.u)
    annotation (Line(points={{-99,360},{-82,360}}, color={0,0,127}));
  connect(add2.y, hys.u)
    annotation (Line(points={{-199,360},{-162,360}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-260,
            -380},{260,380}})), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-260,-380},{260,380}})));
end SystemRequestsReheatBox;
