within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.SetPoints;
block OperatingMode
  "Block with sequences for picking system operating mode"

  parameter Integer nSchRow = 4
    "Number of rows in schedule table";

  parameter Real schTab[nSchRow,2] = [0,1; 6,1; 18,1; 24,1]
    "Table defining schedule for enabling plant";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDetOcc
    "Detected occupancy" annotation (Placement(transformation(extent={{-180,70},
            {-140,110}}), iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDoasEna
    "DOAS enable signal"
    annotation (Placement(transformation(extent={{140,-90},{180,-50}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiBeaEna
    "Chilled beam system enable signal"
    annotation (Placement(transformation(extent={{140,50},{180,90}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod
    "System operating mode signal"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable enaSch(
    final table=schTab,
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final timeScale=3600)
    "Table defining when occupancy is expected"
    annotation (Placement(transformation(extent={{-130,30},{-110,50}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi "Integer switch"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

protected
  parameter Integer modInt[3] = {Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.Types.OperationModeTypes.occupied,
                                 Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.Types.OperationModeTypes.unoccupiedScheduled,
                                 Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.Types.OperationModeTypes.unoccupiedUnscheduled}
    "Array of integer constants associated with each mode";

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.Types.OperationModeTypes.occupied)
    "Constant integer for occupied mode"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi1
    "Integer switch"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.Types.OperationModeTypes.unoccupiedScheduled)
    "Constant integer for unoccupiedScheduled mode"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeamSystem.Types.OperationModeTypes.unoccupiedUnscheduled)
    "Constant integer for unoccupiedUnscheduled mode"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[3]
    "Check which mode is currently active"
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3[3](
    final k=modInt)
    "Constant integer source with operation mode enumeration"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(
    final nout=3)
    "Integer replicator"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi[3]
    "Logical switch for chilled beam system enable"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[3](
    final k={true,true,true})
    "Constant Boolean source with chilled beam system enable signals"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[3](
    final k={true,false,true})
    "Constant Boolean source with DOAS enable signals"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[3](
    final k=fill(false, 3))
    "Constant Boolean source with disable signals"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1[3]
    "Logical switch for DOAS enable"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nu=3)
    "Multi Or"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr2(
    final nu=3)
    "Multi Or"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.5)
    "Convert Real signal to Boolean"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

equation
  connect(enaSch.y[1],greThr. u)
    annotation (Line(points={{-108,40},{-102,40}},     color={0,0,127}));
  connect(conInt.y, intSwi.u1) annotation (Line(points={{-38,120},{10,120},{10,98},
          {18,98}}, color={255,127,0}));
  connect(conInt1.y, intSwi1.u1) annotation (Line(points={{-38,70},{-30,70},{-30,
          48},{-22,48}}, color={255,127,0}));
  connect(conInt2.y, intSwi1.u3) annotation (Line(points={{-38,10},{-30,10},{-30,
          32},{-22,32}},
                       color={255,127,0}));
  connect(intSwi1.y, intSwi.u3) annotation (Line(points={{2,40},{10,40},{10,82},
          {18,82}}, color={255,127,0}));
  connect(intSwi.y, intRep.u)
    annotation (Line(points={{42,90},{50,90},{50,-10},{-130,-10},{-130,-30},{-122,
          -30}},                               color={255,127,0}));
  connect(intRep.y, intEqu.u1) annotation (Line(points={{-98,-30},{-80,-30},{-80,
          -50},{-72,-50}},                color={255,127,0}));
  connect(conInt3.y, intEqu.u2) annotation (Line(points={{-98,-70},{-90,-70},{-90,
          -58},{-72,-58}}, color={255,127,0}));
  connect(intEqu.y, logSwi.u2)
    annotation (Line(points={{-48,-50},{-2,-50}}, color={255,0,255}));
  connect(con.y, logSwi.u1) annotation (Line(points={{-18,-30},{-10,-30},{-10,-42},
          {-2,-42}}, color={255,0,255}));
  connect(con2.y, logSwi.u3) annotation (Line(points={{-18,-70},{-10,-70},{-10,-58},
          {-2,-58}}, color={255,0,255}));
  connect(con1.y, logSwi1.u1) annotation (Line(points={{-18,-110},{-6,-110},{-6,
          -82},{-2,-82}}, color={255,0,255}));
  connect(intEqu.y, logSwi1.u2) annotation (Line(points={{-48,-50},{-14,-50},{-14,
          -90},{-2,-90}}, color={255,0,255}));
  connect(con2.y, logSwi1.u3) annotation (Line(points={{-18,-70},{-10,-70},{-10,
          -98},{-2,-98}}, color={255,0,255}));
  connect(logSwi.y, mulOr1.u[1:3]) annotation (Line(points={{22,-50},{30,-50},{
          30,-54.6667},{38,-54.6667}},
                                    color={255,0,255}));
  connect(logSwi1.y, mulOr2.u[1:3]) annotation (Line(points={{22,-90},{30,-90},
          {30,-94.6667},{38,-94.6667}},color={255,0,255}));
  connect(mulOr1.y, yChiBeaEna) annotation (Line(points={{62,-50},{120,-50},{120,
          70},{160,70}}, color={255,0,255}));
  connect(mulOr2.y, yDoasEna) annotation (Line(points={{62,-90},{120,-90},{120,-70},
          {160,-70}}, color={255,0,255}));
  connect(intSwi.y, yOpeMod) annotation (Line(points={{42,90},{50,90},{50,0},{160,
          0}}, color={255,127,0}));
  connect(greThr.y, not1.u)
    annotation (Line(points={{-78,40},{-72,40}}, color={255,0,255}));
  connect(not1.y, intSwi1.u2)
    annotation (Line(points={{-48,40},{-22,40}}, color={255,0,255}));
  connect(uDetOcc, intSwi.u2)
    annotation (Line(points={{-160,90},{18,90}}, color={255,0,255}));
  annotation (defaultComponentName="opeMod",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
            Text(
              extent={{-100,150},{100,110}},
              lineColor={0,0,255},
              textString="%name"),
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={28,108,200},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-50,20},{50,-20}},
              lineColor={28,108,200},
              fillColor={255,255,255},
              fillPattern=FillPattern.None,
          textString="sysOpeMod")}),                             Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
        Documentation(info="<html>
        <p>
        Sequences for calculating system operating mode in chilled beam systems.
        </p>
        <p>
        The block determines the system operating mode setpoint <code>yOpeMod</code>
        as well as the enable signals for the chilled beam system <code>yChiBeaEna</code>
        and the DOAS <code>yDoasEna</code>. To do this, it uses the detected 
        occupancy signal from the zones <code>uDetOcc</code> and the expected 
        occupancy schedule <code>schTab</code>.
        </p>
        <p>
        The operating mode setpoint and the enable signals based on the inputs 
        are as follows:
        <br>
        <table summary=\"allowedConfigurations\" border=\"1\">
          <thead>
            <tr>
              <th>Detected occupancy</th>
              <th>Expected occupancy schedule</th>
              <th>System operating mode</th>
              <th>Chilled beam system enable status</th>
              <th>DOAS enable status</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Occupied</td>
              <td>-</td>
              <td>1</td>
              <td>True</td>
              <td>True</td>
            </tr>
            <tr>
              <td>Unoccupied</td>
              <td>Unoccupied</td>
              <td>2</td>
              <td>True</td>
              <td>False</td>
            </tr>
            <tr>
              <td>Unoccupied</td>
              <td>Occupied</td>
              <td>3</td>
              <td>True</td>
              <td>True</td>
            </tr>
          </tbody>
        </table>
        </p>
        </html>"));
end OperatingMode;
