within Buildings.Fluid.Storage.Plant.Controls;
block RemoteCharging
  "Control block for the supply pump and nearby valves that allows remote charging"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup plaTyp=
    Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    "Type of plant setup";

  parameter Modelica.Units.SI.Time tDelValSup=45 "Delay time for the supply valve"
    annotation (Dialog(group="Singal Delays"));
  parameter Modelica.Units.SI.Time tDelPumSup=120 "Delay time for the supply pump"
    annotation (Dialog(group="Singal Delays"));
  parameter Modelica.Units.SI.Time tDelValRet=45 "Delay time for the return valve"
    annotation (Dialog(group="Singal Delays",
    enable= plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Modelica.Units.SI.Time tDelPumRet=120 "Delay time for the return pump"
    annotation (Dialog(group="Singal Delays",
    enable= plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));

  Modelica.Blocks.Sources.Constant zero(k=0) "Constant 0"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRemCha
    "Tank is being charged remotely" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
        rotation=180,
        origin={170,70}),                 iconTransformation(extent={{20,-20},{
            -20,20}},
        rotation=0,
        origin={120,80})));
  Modelica.Blocks.Interfaces.RealInput mTanSet_flow
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,110}),iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,80})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva
    "= true if plant is available"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={170,30}),
        iconTransformation(extent={{20,-20},{-20,20}},
        rotation=0,
        origin={120,40})));
  Modelica.Blocks.Interfaces.RealOutput yPumSup
    "Speed input of the supply pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-230}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPumSup
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-190})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValSupToNet
    "True = 1, false = 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-190})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValCha
    "True = on (y>0); false = off (y=0)."         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,-192})));
  Buildings.Controls.OBC.CDL.Logical.And andOut
    "Outputting = plant available AND no remote charging command" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={130,10})));
  Buildings.Controls.OBC.CDL.Logical.Not notRemCha
    "Tank is not being charged remotely" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={122,50})));
  Buildings.Controls.OBC.CDL.Logical.And andCha
    "Charging = plant available AND remote charging command" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,10})));

  Modelica.Blocks.Interfaces.RealInput mTan_flow "Flow rate of the tank"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,90}), iconTransformation(
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
        rotation=-90,
        origin={50,10})));
  Buildings.Controls.Continuous.LimPID conPI_pumSup(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.2,
    Ti=5,
    reverseActing=true)  "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,10})));
  Modelica.Blocks.Interfaces.RealOutput yValSup[2]
    "Control signals for valves on the supply line"
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-230}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-110})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay delPumSup(
    final delayTime=tDelPumSup) "Delays the pump signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-110})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delValSup(
    final delayTime=tDelValSup) "Delays the valve signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-110})));
  Buildings.Controls.OBC.CDL.Logical.Not notPumSup1
    "Reverses the pump signal around the delay block"
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-70})));
  Buildings.Controls.OBC.CDL.Logical.Not notPumSup2
    "Reverses the pump signal around the delay block"
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-150})));
  Buildings.Controls.OBC.CDL.Continuous.Max pos
    "Only allows non-negative flow setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,50})));
  Buildings.Controls.OBC.CDL.Continuous.Min negValCha
    "Only allows non-positive flow setpoint" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,50})));
initial equation
  assert(plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
  or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote,
  "To use this block, the only values allowed for plaTyp is
  .Open or .ClosedRemote");
equation
  connect(swiPumSup.y, yPumSup)
    annotation (Line(points={{-50,-202},{-50,-230}}, color={0,0,127}));
  connect(zero.y, swiPumSup.u3) annotation (Line(points={{-79,-30},{-70,-30},{-70,
          -170},{-58,-170},{-58,-178}},
                      color={0,0,127}));
  connect(uRemCha, notRemCha.u)
    annotation (Line(points={{170,70},{122,70},{122,62}},
                                                        color={255,0,255}));
  connect(notRemCha.y, andOut.u2) annotation (Line(points={{122,38},{122,22}},
                         color={255,0,255}));

  connect(andOut.u1, uAva)
    annotation (Line(points={{130,22},{130,30},{170,30}}, color={255,0,255}));

  connect(conPI_pumSup.y, swiPumSup.u1) annotation (Line(points={{-30,-1},{-30,-172},
          {-42,-172},{-42,-178}},color={0,0,127}));
  connect(booToReaValSupToNet.y, yValSup[1]) annotation (Line(points={{-10,-202},
          {-10,-210},{10,-210},{10,-232.5}},
                                           color={0,0,127}));
  connect(andCha.u2, uRemCha) annotation (Line(points={{82,22},{82,70},{170,70}},
        color={255,0,255}));
  connect(andCha.u1, uAva)
    annotation (Line(points={{90,22},{90,30},{170,30}},   color={255,0,255}));
  connect(conPI_pumSup.u_m, mTan_flow) annotation (Line(points={{-42,10},{-48,10},
          {-48,90},{-110,90}},     color={0,0,127}));
  connect(swiValCha.u1, conPI_valCha.y) annotation (Line(points={{38,-180},{38,-170},
          {50,-170},{50,-1}},color={0,0,127}));
  connect(swiValCha.u3, zero.y)
    annotation (Line(points={{22,-180},{22,-30},{-79,-30}},color={0,0,127}));
  connect(conPI_valCha.u_m, mTan_flow) annotation (Line(points={{38,10},{30,10},
          {30,90},{-110,90}}, color={0,0,127}));
  connect(swiValCha.y, yValSup[2]) annotation (Line(points={{30,-204},{30,-210},
          {10,-210},{10,-227.5}},
                             color={0,0,127}));
  connect(booToReaValSupToNet.u, delValSup.y)
    annotation (Line(points={{-10,-178},{-10,-122}}, color={255,0,255}));
  connect(delValSup.u, andOut.y) annotation (Line(points={{-10,-98},{-10,-40},{130,
          -40},{130,-2}}, color={255,0,255}));
  connect(andOut.y, notPumSup1.u) annotation (Line(points={{130,-2},{130,-40},{-50,
          -40},{-50,-58}}, color={255,0,255}));
  connect(notPumSup1.y, delPumSup.u)
    annotation (Line(points={{-50,-82},{-50,-98}}, color={255,0,255}));
  connect(delPumSup.y, notPumSup2.u)
    annotation (Line(points={{-50,-122},{-50,-138}}, color={255,0,255}));
  connect(notPumSup2.y, swiPumSup.u2)
    annotation (Line(points={{-50,-162},{-50,-178}}, color={255,0,255}));
  connect(pos.u2, mTanSet_flow)
    annotation (Line(points={{-36,62},{-36,110},{-110,110}}, color={0,0,127}));
  connect(zero.y, pos.u1) annotation (Line(points={{-79,-30},{-10,-30},{-10,70},
          {-24,70},{-24,62}}, color={0,0,127}));
  connect(conPI_pumSup.u_s, pos.y)
    annotation (Line(points={{-30,22},{-30,38}}, color={0,0,127}));
  connect(negValCha.u2, mTanSet_flow)
    annotation (Line(points={{44,62},{44,110},{-110,110}}, color={0,0,127}));
  connect(conPI_valCha.u_s, negValCha.y)
    annotation (Line(points={{50,22},{50,38}}, color={0,0,127}));
  connect(zero.y, negValCha.u1) annotation (Line(points={{-79,-30},{70,-30},{70,
          68},{56,68},{56,62}}, color={0,0,127}));
  connect(swiValCha.u2, andCha.y) annotation (Line(points={{30,-180},{30,-50},{
          90,-50},{90,-2}}, color={255,0,255}));
  annotation (
  defaultComponentName="conRemCha",
  Diagram(coordinateSystem(extent={{-100,-220},{160,120}})), Icon(
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
