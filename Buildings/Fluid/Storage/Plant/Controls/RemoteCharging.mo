within Buildings.Fluid.Storage.Plant.Controls;
block RemoteCharging
  "Control block for the supply pump and nearby valves that allows remote charging"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Time tDelValSup=45 "Delay time for the supply valve"
    annotation (Dialog(group="Singal Delays"));
  parameter Modelica.Units.SI.Time tDelPumSup=120 "Delay time for the supply pump"
    annotation (Dialog(group="Singal Delays"));

  Modelica.Blocks.Sources.Constant zero(k=0) "Constant 0"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRemCha
    "Tank is being charged remotely" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,30}),                iconTransformation(extent={{-20,-20},
            {20,20}},
        rotation=0,
        origin={-120,20})));
  Modelica.Blocks.Interfaces.RealInput mTanSet_flow
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,-10}),iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva
    "= true if plant is available"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,90}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60})));
  Modelica.Blocks.Interfaces.RealOutput yPum "Speed input of the pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={190,-70}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPumSup
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValSupToNet
    "True = 1, false = 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,-10})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValFroNet
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,30})));
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
        origin={-110,-60})));
  Buildings.Controls.Continuous.LimPID conPI_valCha(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=50,
    reverseActing=false)                   "PI controller"
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-10})));
  Buildings.Controls.Continuous.LimPID conPI_pumSup(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.2,
    Ti=5,
    reverseActing=true)  "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-50})));
  Modelica.Blocks.Interfaces.RealOutput yVal[2] "Control signals for valves"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={190,30}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-20})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay delPum(final delayTime=
        tDelPumSup) "Delays the pump signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-70})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delVal(final delayTime=
        tDelValSup) "Delays the valve signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-10})));
  Buildings.Controls.OBC.CDL.Logical.Not notPum1
    "Reverses the pump signal around the delay block" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-70})));
  Buildings.Controls.OBC.CDL.Logical.Not notPum2
    "Reverses the pump signal around the delay block" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-70})));

equation
  connect(swiPumSup.y, yPum)
    annotation (Line(points={{162,-70},{190,-70}}, color={0,0,127}));
  connect(zero.y, swiPumSup.u3) annotation (Line(points={{-39,-90},{134,-90},{134,
          -78},{138,-78}},
                      color={0,0,127}));
  connect(uRemCha, notRemCha.u)
    annotation (Line(points={{-110,30},{-90,30},{-90,70},{-62,70}},
                                                        color={255,0,255}));
  connect(notRemCha.y, andOut.u2) annotation (Line(points={{-38,70},{-34,70},{-34,
          62},{-22,62}}, color={255,0,255}));

  connect(andOut.u1, uAva)
    annotation (Line(points={{-22,70},{-26,70},{-26,90},{-110,90}},
                                                          color={255,0,255}));

  connect(conPI_pumSup.y, swiPumSup.u1) annotation (Line(points={{-39,-50},{128,
          -50},{128,-62},{138,-62}},
                                 color={0,0,127}));
  connect(booToReaValSupToNet.y, yVal[1]) annotation (Line(points={{162,-10},{
          170,-10},{170,27.5},{190,27.5}},
                                       color={0,0,127}));
  connect(andCha.u2, uRemCha) annotation (Line(points={{-62,22},{-90,22},{-90,30},
          {-110,30}},
        color={255,0,255}));
  connect(andCha.u1, uAva)
    annotation (Line(points={{-62,30},{-80,30},{-80,90},{-110,90}},
                                                          color={255,0,255}));
  connect(conPI_pumSup.u_m, mTan_flow) annotation (Line(points={{-50,-62},{-50,-70},
          {-110,-70}},             color={0,0,127}));
  connect(swiValFroNet.u1, conPI_valCha.y) annotation (Line(points={{138,38},{-30,
          38},{-30,-10},{-39,-10}},
                                  color={0,0,127}));
  connect(swiValFroNet.u3, zero.y) annotation (Line(points={{138,22},{134,22},{134,
          -90},{-39,-90}}, color={0,0,127}));
  connect(conPI_valCha.u_m, mTan_flow) annotation (Line(points={{-50,-22},{-50,-28},
          {-70,-28},{-70,-70},{-110,-70}},
                              color={0,0,127}));
  connect(swiValFroNet.y, yVal[2]) annotation (Line(points={{162,30},{176,30},{
          176,32.5},{190,32.5}},
                             color={0,0,127}));
  connect(booToReaValSupToNet.u, delVal.y)
    annotation (Line(points={{138,-10},{122,-10}}, color={255,0,255}));
  connect(delVal.u, andOut.y) annotation (Line(points={{98,-10},{10,-10},{10,70},
          {2,70}}, color={255,0,255}));
  connect(andOut.y, notPum1.u) annotation (Line(points={{2,70},{10,70},{10,-70},
          {18,-70}}, color={255,0,255}));
  connect(notPum1.y, delPum.u)
    annotation (Line(points={{42,-70},{58,-70}}, color={255,0,255}));
  connect(delPum.y, notPum2.u)
    annotation (Line(points={{82,-70},{98,-70}},   color={255,0,255}));
  connect(notPum2.y, swiPumSup.u2)
    annotation (Line(points={{122,-70},{138,-70}}, color={255,0,255}));
  connect(swiValFroNet.u2, andCha.y)
    annotation (Line(points={{138,30},{-38,30}}, color={255,0,255}));
  connect(conPI_pumSup.u_s, mTanSet_flow) annotation (Line(points={{-62,-50},{-88,
          -50},{-88,-10},{-110,-10}}, color={0,0,127}));
  connect(mTanSet_flow, conPI_valCha.u_s)
    annotation (Line(points={{-110,-10},{-62,-10}}, color={0,0,127}));
  annotation (
  defaultComponentName="conRemCha",
  Diagram(coordinateSystem(extent={{-100,-100},{180,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{60,60},{60,-60},{-40,-60},{-40,0}},
          color={28,108,200},
          thickness=1),
        Polygon(
          points={{-40,0},{-30,-30},{-50,-30},{-40,0}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,0},{-20,60}},
          lineColor={200,200,0},
          lineThickness=3,
          fillPattern=FillPattern.None)}),
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
This is a control block for the pump and valves in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.NetworkConnection\">
Buildings.Fluid.Storage.Plant.NetworkConnection</a>
when remote charging of the storage plant is allowed.
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
    <td>Supply pump</td>
    <td>Outputs CHW from the plant;<br/>
        tracks the flow rate setpoint at the tank</td>
  </tr>
  <tr>
    <td>Valve in series with the pump</td>
    <td>Opens when the supply pump is on to allow flow,<br/>
        otherwise closes to isolate the pump</td>
  </tr>
  <tr>
    <td>Valve in parallel with the pump</td>
    <td>When the tank is being charged remotely,
        tracks a negative flow rate,<br/>
        otherwise it is closed</td>
  </tr>
</tbody>
</table>
</html>"));
end RemoteCharging;
