within Buildings.Fluid.Storage.Plant.Controls;
block RemoteCharging
  "Control block for the supply pump and nearby valves that allows remote charging"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Time tDelValSup=45 "Delay time for the supply valve"
    annotation (Dialog(group="Singal Delays"));
  parameter Modelica.Units.SI.Time tDelPumSup=120 "Delay time for the supply pump"
    annotation (Dialog(group="Singal Delays"));

  Modelica.Blocks.Sources.Constant zero(k=0) "Constant 0"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRemCha
    "Tank is being charged remotely" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,30}),                iconTransformation(extent={{20,-20},{
            -20,20}},
        rotation=0,
        origin={120,80})));
  Modelica.Blocks.Interfaces.RealInput mTanSet_flow
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,-10}),iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,80})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva
    "= true if plant is available"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,90}),
        iconTransformation(extent={{20,-20},{-20,20}},
        rotation=0,
        origin={120,40})));
  Modelica.Blocks.Interfaces.RealOutput yPum "Speed input of the pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={230,-70}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPumSup
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={190,-70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValSupToNet
    "True = 1, false = 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={190,-10})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValFroNet
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={190,30})));
  Buildings.Controls.OBC.CDL.Logical.And andOut
    "Outputting = plant available AND no remote charging command" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,70})));
  Buildings.Controls.OBC.CDL.Logical.Not notRemCha
    "Tank is not being charged remotely" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,70})));
  Buildings.Controls.OBC.CDL.Logical.And andCha
    "Charging = plant available AND remote charging command" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,30})));

  Modelica.Blocks.Interfaces.RealInput mTan_flow "Flow rate of the tank"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-70}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  Buildings.Controls.Continuous.LimPID conPI_valCha(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false)                   "PI controller"
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-10})));
  Buildings.Controls.Continuous.LimPID conPI_pumSup(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.2,
    Ti=5,
    reverseActing=true)  "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-50})));
  Modelica.Blocks.Interfaces.RealOutput yVal[2] "Control signals for valves"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={230,30}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-110})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay delPum(final delayTime=
        tDelPumSup) "Delays the pump signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-70})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delVal(final delayTime=
        tDelValSup) "Delays the valve signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-10})));
  Buildings.Controls.OBC.CDL.Logical.Not notPum1
    "Reverses the pump signal around the delay block" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-70})));
  Buildings.Controls.OBC.CDL.Logical.Not notPum2
    "Reverses the pump signal around the delay block" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-70})));
  Buildings.Controls.OBC.CDL.Continuous.Max pos
    "Only allows non-negative flow setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-50})));
  Buildings.Controls.OBC.CDL.Continuous.Min neg
    "Only allows non-positive flow setpoint" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-10})));

equation
  connect(swiPumSup.y, yPum)
    annotation (Line(points={{202,-70},{230,-70}}, color={0,0,127}));
  connect(zero.y, swiPumSup.u3) annotation (Line(points={{-79,-90},{174,-90},{174,
          -78},{178,-78}},
                      color={0,0,127}));
  connect(uRemCha, notRemCha.u)
    annotation (Line(points={{-110,30},{-90,30},{-90,70},{-62,70}},
                                                        color={255,0,255}));
  connect(notRemCha.y, andOut.u2) annotation (Line(points={{-38,70},{-34,70},{-34,
          62},{-22,62}}, color={255,0,255}));

  connect(andOut.u1, uAva)
    annotation (Line(points={{-22,70},{-26,70},{-26,90},{-110,90}},
                                                          color={255,0,255}));

  connect(conPI_pumSup.y, swiPumSup.u1) annotation (Line(points={{1,-50},{168,-50},
          {168,-62},{178,-62}},  color={0,0,127}));
  connect(booToReaValSupToNet.y, yVal[1]) annotation (Line(points={{202,-10},{212,
          -10},{212,27.5},{230,27.5}}, color={0,0,127}));
  connect(andCha.u2, uRemCha) annotation (Line(points={{-62,22},{-90,22},{-90,30},
          {-110,30}},
        color={255,0,255}));
  connect(andCha.u1, uAva)
    annotation (Line(points={{-62,30},{-80,30},{-80,90},{-110,90}},
                                                          color={255,0,255}));
  connect(conPI_pumSup.u_m, mTan_flow) annotation (Line(points={{-10,-62},{-10,-70},
          {-110,-70}},             color={0,0,127}));
  connect(swiValFroNet.u1, conPI_valCha.y) annotation (Line(points={{178,38},{46,
          38},{46,-10},{41,-10}}, color={0,0,127}));
  connect(swiValFroNet.u3, zero.y) annotation (Line(points={{178,22},{174,22},{174,
          -90},{-79,-90}}, color={0,0,127}));
  connect(conPI_valCha.u_m, mTan_flow) annotation (Line(points={{30,-22},{30,-70},
          {-110,-70}},        color={0,0,127}));
  connect(swiValFroNet.y, yVal[2]) annotation (Line(points={{202,30},{216,30},{216,
          32.5},{230,32.5}}, color={0,0,127}));
  connect(booToReaValSupToNet.u, delVal.y)
    annotation (Line(points={{178,-10},{162,-10}}, color={255,0,255}));
  connect(delVal.u, andOut.y) annotation (Line(points={{138,-10},{54,-10},{54,70},
          {2,70}}, color={255,0,255}));
  connect(andOut.y, notPum1.u) annotation (Line(points={{2,70},{54,70},{54,-70},
          {58,-70}}, color={255,0,255}));
  connect(notPum1.y, delPum.u)
    annotation (Line(points={{82,-70},{98,-70}}, color={255,0,255}));
  connect(delPum.y, notPum2.u)
    annotation (Line(points={{122,-70},{138,-70}}, color={255,0,255}));
  connect(notPum2.y, swiPumSup.u2)
    annotation (Line(points={{162,-70},{178,-70}}, color={255,0,255}));
  connect(conPI_pumSup.u_s, pos.y)
    annotation (Line(points={{-22,-50},{-38,-50}},
                                                 color={0,0,127}));
  connect(conPI_valCha.u_s, neg.y)
    annotation (Line(points={{18,-10},{-38,-10}}, color={0,0,127}));
  connect(swiValFroNet.u2, andCha.y)
    annotation (Line(points={{178,30},{-38,30}}, color={255,0,255}));
  connect(pos.u1, mTanSet_flow) annotation (Line(points={{-62,-44},{-80,-44},{-80,
          -10},{-110,-10}}, color={0,0,127}));
  connect(zero.y, pos.u2) annotation (Line(points={{-79,-90},{-70,-90},{-70,-56},
          {-62,-56}}, color={0,0,127}));
  connect(mTanSet_flow, neg.u1) annotation (Line(points={{-110,-10},{-80,-10},{-80,
          -4},{-62,-4}}, color={0,0,127}));
  connect(neg.u2, zero.y) annotation (Line(points={{-62,-16},{-70,-16},{-70,-90},
          {-79,-90}}, color={0,0,127}));
  annotation (
  defaultComponentName="conRemCha",
  Diagram(coordinateSystem(extent={{-100,-100},{220,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>", info="<html>
<p>
[fixme: Update documentation.]
[fixme: Change icon and graphic to make this block left-to-right.]
This is a control block for the group of pump and valves in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.NetworkConnection\">
Buildings.Fluid.Storage.Plant.NetworkConnection</a>
when remote charging of the storage plant is allowed.
It uses <code>plaTyp</code> to select components used for an open or closed tank.
This block implements the following control objectives:
</p>
<table summary= \"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Component in <code>NetworkConnection</code></th>
    <th>Control Objective</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Supply pump<br/>
        <code>pumSup</code></td>
    <td>Outputs CHW from the plant;<br/>
        tracks a positive flow rate setpoint at tank</td>
  </tr>
  <tr>
    <td>Supply output valve<br/>
        <code>intValSup.valToNet</code></td>
    <td>Opens when the supply pump is on to allow flow,<br/>
        otherwise closes to isolate the pump</td>
  </tr>
  <tr>
    <td>Supply charging valve<br/>
        <code>intValSup.valFroNet</code></td>
    <td>For a closed tank, when charging,
        tracks a negative flow rate, otherwise closed;<br/>
        For an open tank, opens when the tank is charging
        and closes otherwise</td>
  </tr>
  <tr>
    <td>Auxiliary pump<br/>
        <code>pumRet</code></td>
    <td>Pumps water to the pressurised return line<br/>
        from the open tank when it is being charged remotely</td>
  </tr>
  <tr>
    <td>Return charging valve<br/>
        <code>intValRet.valToNet</code></td>
    <td>Opens when the auxiliary pump is on to allow flow,<br/>
        otherwise closes to isolate the pump</td>
  </tr>
  <tr>
    <td>Return output valve<br/>
        <code>intValRet.valFroNet</code></td>
    <td>Opens when the tank discharges and closes otherwise</td>
  </tr>
</tbody>
</table>
</html>"));
end RemoteCharging;
