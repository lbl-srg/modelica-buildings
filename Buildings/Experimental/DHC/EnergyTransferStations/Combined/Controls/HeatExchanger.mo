within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls;
model HeatExchanger
  "District heat exchanger controller"
  extends Modelica.Blocks.Icons.Block;
  parameter DHC.EnergyTransferStations.Types.ConnectionConfiguration conCon
    "District connection configuration" annotation (Evaluate=true);
  parameter Real spePum1Min(
    final unit="1",
    min=0)=0.1
    "Heat exchanger primary pump minimum speed (fractional)"
    annotation (Dialog(enable=not have_val1));
  parameter Real spePum2Min(
    final unit="1",
    min=0.01)=0.1
    "Heat exchanger secondary pump minimum speed (fractional)";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso[2]
    "Isolation valves return position (index 1 for condenser)"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),
                                                                       iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y1(final unit="1")
    "District heat exchanger primary control signal" annotation (Placement(
        transformation(extent={{220,20},{260,60}}), iconTransformation(extent={
            {100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPum2(
    final unit="1")
    "District heat exchanger secondary pump control signal"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),
                                                                     iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal2(
    final unit="1")
    "District heat exchanger secondary valve control signal"
    annotation (Placement(transformation(extent={{220,-80},{260,-40}}),iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    "Maximum between control signal and minimum speed or opening"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiOff1
    "Output zero if not enabled"
    annotation (Placement(transformation(extent={{160,-70},{180,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant min1(
    final k=if have_val1 then 0 else spePum1Min)
    "Minimum pump speed or actuator opening"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Control signal for secondary side (from supervisory)"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),  iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=0.01,
    final h=0.005)
    "Check for heat or cold rejection demand"
    annotation (Placement(transformation(extent={{-170,30},{-150,50}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "At least one valve is open and HX circuit is enabled"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold heaRej(
    final t=0.9,
    final h=0.1)
    "Heat rejection if condenser isolation valve is open"
    annotation (Placement(transformation(extent={{-170,-10},{-150,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold cooRej(
    final t=0.9,
    final h=0.1)
    "Cold rejection if evaporator isolation valve is open"
    annotation (Placement(transformation(extent={{-170,-50},{-150,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "At least one valve is open "
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant speMin(
    final k=spePum2Min)
    "Minimum pump speed"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiOff2
    "Output zero if not enabled"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));
  Buildings.Controls.OBC.CDL.Reals.Line mapSpe
    "Mapping function for pump speed"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1)
    "One"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Zero"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hal(
    final k=0.3)
    "Control signal value for full opening of the valve"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Controls.OBC.CDL.Reals.Line mapVal
    "Mapping function for valve opening"
    annotation (Placement(transformation(extent={{90,10},{110,30}})));
protected
  parameter Boolean have_val1=conCon ==
    DHC.EnergyTransferStations.Types.ConnectionConfiguration.TwoWayValve
    "True in case of control valve on district side, false in case of a pump";
equation
  connect(swiOff1.y, y1) annotation (Line(points={{182,-60},{200,-60},{200,40},
          {240,40}}, color={0,0,127}));
  connect(max1.y,swiOff1.u1)
    annotation (Line(points={{112,-60},{126,-60},{126,-52},{158,-52}},color={0,0,127}));
  connect(u,greThr.u)
    annotation (Line(points={{-240,40},{-172,40}},  color={0,0,127}));
  connect(greThr.y,and2.u1)
    annotation (Line(points={{-148,40},{-80,40},{-80,0},{-62,0}},    color={255,0,255}));
  connect(and2.y,swiOff1.u2)
    annotation (Line(points={{-38,0},{140,0},{140,-60},{158,-60}},  color={255,0,255}));
  connect(cooRej.y,or1.u2)
    annotation (Line(points={{-148,-40},{-120,-40},{-120,-28},{-112,-28}},
                                                                      color={255,0,255}));
  connect(heaRej.y,or1.u1)
    annotation (Line(points={{-148,0},{-120,0},{-120,-20},{-112,-20}},color={255,0,255}));
  connect(or1.y,and2.u2)
    annotation (Line(points={{-88,-20},{-80,-20},{-80,-8},{-62,-8}},
                                                                  color={255,0,255}));
  connect(min1.y,max1.u2)
    annotation (Line(points={{62,-80},{80,-80},{80,-66},{88,-66}},  color={0,0,127}));
  connect(swiOff2.y,yPum2)
    annotation (Line(points={{182,60},{190,60},{190,0},{240,0}},      color={0,0,127}));
  connect(one.y,mapSpe.x2)
    annotation (Line(points={{62,20},{70,20},{70,56},{88,56}},    color={0,0,127}));
  connect(one.y,mapSpe.f2)
    annotation (Line(points={{62,20},{70,20},{70,52},{88,52}},    color={0,0,127}));
  connect(u,mapSpe.u)
    annotation (Line(points={{-240,40},{-180,40},{-180,60},{88,60}},    color={0,0,127}));
  connect(speMin.y,mapSpe.f1)
    annotation (Line(points={{12,80},{70,80},{70,64},{88,64}},    color={0,0,127}));
  connect(mapSpe.y,swiOff2.u1)
    annotation (Line(points={{112,60},{120,60},{120,68},{158,68}},    color={0,0,127}));
  connect(zer.y,swiOff2.u3)
    annotation (Line(points={{12,-40},{120,-40},{120,52},{158,52}},color={0,0,127}));
  connect(zer.y,swiOff1.u3)
    annotation (Line(points={{12,-40},{120,-40},{120,-68},{158,-68}},
                                                                   color={0,0,127}));
  connect(hal.y,mapSpe.x1)
    annotation (Line(points={{12,20},{20,20},{20,68},{88,68}},    color={0,0,127}));
  connect(u,mapVal.u)
    annotation (Line(points={{-240,40},{-180,40},{-180,60},{84,60},{84,20},{88,20}},      color={0,0,127}));
  connect(zer.y,mapVal.x1)
    annotation (Line(points={{12,-40},{80,-40},{80,28},{88,28}},color={0,0,127}));
  connect(zer.y,mapVal.f1)
    annotation (Line(points={{12,-40},{80,-40},{80,24},{88,24}},color={0,0,127}));
  connect(one.y,mapVal.f2)
    annotation (Line(points={{62,20},{70,20},{70,12},{88,12}},  color={0,0,127}));
  connect(hal.y,mapVal.x2)
    annotation (Line(points={{12,20},{20,20},{20,4},{84,4},{84,16},{88,16}},    color={0,0,127}));
  connect(mapVal.y,yVal2)
    annotation (Line(points={{112,20},{210,20},{210,-60},{240,-60}},  color={0,0,127}));
  connect(and2.y,swiOff2.u2)
    annotation (Line(points={{-38,0},{-20,0},{-20,40},{130,40},{130,60},{158,60}},      color={255,0,255}));
  connect(u, max1.u1)
    annotation (Line(points={{-240,40},{-200,40},{-200,-60},{80,-60},{80,-54},{
          88,-54}},                                                                        color={0,0,127}));
  connect(yValIso[1], heaRej.u)
    annotation (Line(points={{-240,-50},{-238,-40},{-180,-40},{-180,0},{-172,0}}, color={0,0,127}));
  connect(yValIso[2], cooRej.u) annotation (Line(points={{-240,-30},{-240,-40},{-172,-40}}, color={0,0,127}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-220,-120},{220,120}})),
    defaultComponentName="con",
    Documentation(
      revisions="<html>
<ul>
<li>
July 14, 2021, by Antoine Gautier:<br/>
Updated the control logic.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2561\">issue #2561</a>.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This block implements the control logic for the district heat exchanger,
which realizes the interface between the building system and the district system.
</p>
<p>
The input signal <code>u</code> is yielded by the supervisory controller, see
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.Supervisory\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Controls.Supervisory</a>.
The primary and secondary circuits are enabled to operate if this input signal
is greater than zero and the return position of at least one isolation valve
is greater than 90%.
When enabled,
</p>
<ul>
<li>
the secondary circuit is controlled based on the input signal <code>u</code>,
which is mapped to modulate in sequence the mixing valve
(from full bypass to closed bypass for a control signal varying between
0% and 30%) and the pump speed (from the minimum to the maximum value
for a control signal varying between 30% and 100%),
</li>
<li>
the primary pump speed (or valve opening) is directly modulated with
the input signal <code>u</code>.
</li>
</ul>
<p>
Note that the valve on the secondary side is needed to stabilize the control
of the system when the secondary mass flow rate required to meet the heat or
cold rejection demand is below the flow rate corresponding to the minimum pump speed.
</p>
</html>"));
end HeatExchanger;
