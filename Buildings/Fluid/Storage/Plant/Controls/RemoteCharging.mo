within Buildings.Fluid.Storage.Plant.Controls;
block RemoteCharging
  "Control block for the supply pump and nearby valves that allows remote charging"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup plaTyp=
    Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    "Type of plant setup";

  Modelica.Blocks.Sources.Constant zero(k=0) "Constant 0"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRemCha
    "Tank is being charged remotely" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
        rotation=180,
        origin={230,70}),                 iconTransformation(extent={{20,-20},{
            -20,20}},
        rotation=0,
        origin={120,80})));
  Modelica.Blocks.Interfaces.RealInput mTanSet_flow
    "Tank mass flow rate setpoint"   annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,70}), iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,80})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uAva
    "= true if plant is available"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={230,30}),
        iconTransformation(extent={{20,-20},{-20,20}},
        rotation=0,
        origin={120,40})));
  Modelica.Blocks.Interfaces.RealOutput yPumSup
    "Speed input of the supply pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPumSup
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,-70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValSupToNet
    "True = 1, false = 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValSupFroNet
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "True = 1, false = 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,-70})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiValCha
    if not plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "True = on (y>0); false = off (y=0)."         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,-70})));
  Buildings.Controls.OBC.CDL.Logical.And andOut
    "Outputting = plant available AND no remote charging command" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={190,10})));
  Buildings.Controls.OBC.CDL.Logical.Not notRemCha
    "Tank is not being charged remotely" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={182,50})));
  Buildings.Controls.OBC.CDL.Logical.And andCha
    "Charging = plant available AND remote charging command" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={150,10})));
  Buildings.Controls.Continuous.LimPID conPI_pumRet(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5,
    Ti=10,
    reverseActing=false)
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={110,10})));

  Modelica.Blocks.Interfaces.RealInput mTan_flow "Flow rate of the tank"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40})));
  Buildings.Controls.Continuous.LimPID conPI_valCha(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=500,
    Ti=50,
    reverseActing=false)                   "PI controller"
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,10})));
  Buildings.Controls.Continuous.LimPID conPI_pumSup(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=10,
    reverseActing=true)  "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,10})));
  Modelica.Blocks.Interfaces.RealOutput yValSup[2]
    "Control signals for valves on the supply line"
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-110})));
  Modelica.Blocks.Interfaces.RealOutput yValRet[2]
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Control signals for valves on the return line" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={170,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiPumRet
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "True = on (y>0); false = off (y=0)." annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={110,-70})));
  Modelica.Blocks.Interfaces.RealOutput yPumRet
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Speed input of the auxiliary pump on the return line" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={110,-110}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-110})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValRetToNet
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "True = 1, false = 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={150,-70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaValRetFroNet
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "True = 1, false = 0" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={190,-70})));

initial equation
  assert(plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
  or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote,
  "To use this block, the only values allowed for plaTyp is
  .Open or .ClosedRemote");
equation
  connect(swiPumSup.y, yPumSup)
    annotation (Line(points={{-50,-82},{-50,-110}},  color={0,0,127}));
  connect(zero.y, swiPumSup.u3) annotation (Line(points={{-79,-30},{-58,-30},{-58,
          -58}},      color={0,0,127}));
  connect(uRemCha, notRemCha.u)
    annotation (Line(points={{230,70},{182,70},{182,62}},
                                                        color={255,0,255}));
  connect(notRemCha.y, andOut.u2) annotation (Line(points={{182,38},{182,22}},
                         color={255,0,255}));
  connect(conPI_pumRet.u_s, mTanSet_flow)
    annotation (Line(points={{110,22},{110,70},{-110,70}},
                                                         color={0,0,127}));

  connect(andOut.u1, uAva)
    annotation (Line(points={{190,22},{190,30},{230,30}}, color={255,0,255}));

  connect(conPI_pumSup.u_s, mTanSet_flow)
    annotation (Line(points={{-50,22},{-50,70},{-110,70}}, color={0,0,127}));
  connect(andOut.y, swiPumSup.u2) annotation (Line(points={{190,-2},{190,-40},{-50,
          -40},{-50,-58}}, color={255,0,255}));
  connect(conPI_pumSup.y, swiPumSup.u1) annotation (Line(points={{-50,-1},{-50,-10},
          {-42,-10},{-42,-58}},  color={0,0,127}));
  connect(conPI_pumRet.y, swiPumRet.u1) annotation (Line(points={{110,-1},{110,-10},
          {118,-10},{118,-58}},
                              color={0,0,127}));
  connect(swiPumRet.u3, zero.y)
    annotation (Line(points={{102,-58},{102,-30},{-79,-30}},
                                                           color={0,0,127}));
  connect(swiPumRet.y, yPumRet)
    annotation (Line(points={{110,-82},{110,-110}},color={0,0,127}));
  connect(booToReaValSupToNet.u, andOut.y) annotation (Line(points={{-10,-58},{
          -10,-40},{190,-40},{190,-2}}, color={255,0,255}));
  connect(booToReaValSupToNet.y, yValSup[1]) annotation (Line(points={{-10,-82},
          {-10,-90},{30,-90},{30,-112.5}}, color={0,0,127}));
  connect(conPI_pumRet.u_m, mTan_flow) annotation (Line(points={{98,10},{90,10},
          {90,50},{-110,50}}, color={0,0,127}));
  connect(andCha.u2, uRemCha) annotation (Line(points={{142,22},{142,70},{230,70}},
        color={255,0,255}));
  connect(andCha.u1, uAva)
    annotation (Line(points={{150,22},{150,30},{230,30}}, color={255,0,255}));
  connect(booToReaValRetToNet.u, andCha.y)
    annotation (Line(points={{150,-58},{150,-2}}, color={255,0,255}));
  connect(andCha.y, swiPumRet.u2) annotation (Line(points={{150,-2},{150,-50},{110,
          -50},{110,-58}},color={255,0,255}));
  connect(booToReaValRetToNet.y, yValRet[1]) annotation (Line(points={{150,-82},
          {150,-90},{170,-90},{170,-112.5}}, color={0,0,127}));
  connect(booToReaValSupFroNet.u, andCha.y) annotation (Line(points={{30,-58},{
          30,-50},{150,-50},{150,-2}}, color={255,0,255}));
  connect(booToReaValSupFroNet.y, yValSup[2]) annotation (Line(points={{30,-82},
          {30,-107.5}},                   color={0,0,127}));
  connect(booToReaValRetFroNet.u, andOut.y)
    annotation (Line(points={{190,-58},{190,-2}}, color={255,0,255}));
  connect(booToReaValRetFroNet.y, yValRet[2]) annotation (Line(points={{190,-82},
          {190,-90},{170,-90},{170,-107.5}}, color={0,0,127}));
  connect(conPI_pumSup.u_m, mTan_flow) annotation (Line(points={{-62,10},{-68,10},
          {-68,50},{-110,50}},     color={0,0,127}));
  connect(swiValCha.u1, conPI_valCha.y) annotation (Line(points={{78,-58},{78,-10},
          {70,-10},{70,-1}}, color={0,0,127}));
  connect(swiValCha.u2, andCha.y) annotation (Line(points={{70,-58},{70,-50},{150,
          -50},{150,-2}}, color={255,0,255}));
  connect(swiValCha.u3, zero.y)
    annotation (Line(points={{62,-58},{62,-30},{-79,-30}}, color={0,0,127}));
  connect(conPI_valCha.u_m, mTan_flow) annotation (Line(points={{58,10},{50,10},
          {50,50},{-110,50}}, color={0,0,127}));
  connect(conPI_valCha.u_s, mTanSet_flow)
    annotation (Line(points={{70,22},{70,70},{-110,70}}, color={0,0,127}));
  connect(swiValCha.y, yValSup[2]) annotation (Line(points={{70,-82},{70,-90},{30,
          -90},{30,-107.5}}, color={0,0,127}));
  annotation (
  defaultComponentName="conRemCha",
  Diagram(coordinateSystem(extent={{-100,-100},{220,80}})),  Icon(
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
