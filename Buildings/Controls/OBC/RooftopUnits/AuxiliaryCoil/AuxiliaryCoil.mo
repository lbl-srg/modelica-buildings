within Buildings.Controls.OBC.RooftopUnits.AuxiliaryCoil;
block AuxiliaryCoil
  "Sequences to control auxiliary heating coils"

  parameter Integer nCoi(min=1)
    "Number of DX coils"
    annotation (Dialog(group="DX coil parameters"));

  parameter Real TLocOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=273.15-12.2
    "Minimum outdoor dry-bulb lockout temperature";

  parameter Real dTHys(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=0.05
    "Small temperature difference used in comparison blocks"
    annotation(Dialog(tab="Advanced"));

  parameter Real kLocOut=1
    "Gain of auxiliary heating controller when the DX heating coils are locked out"
    annotation (Dialog(group="P controller"));

  parameter Real kOpe=10
    "Gain of auxiliary heating controller when the DX heating coils are operational"
    annotation (Dialog(group="P controller"));

  parameter Real uThrHeaCoi(
    final min=0,
    final max=1)=0.9
    "Threshold of heating coil valve position signal above which auxiliary coil is enabled";

  parameter Real dUHys=0.01
    "Coil valve position comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uDXCoi[nCoi]
    "DX coil signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Heating coil valve position"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDXCoi[nCoi]
    "DX coil signal"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAuxHea(
    final min=0,
    final max=1,
    final unit="1")
    "Auxiliary heating coil signal"
    annotation (Placement(transformation(extent={{100,-40},{140,0}}),
      iconTransformation(extent={{100,-40},{140,0}})));

protected
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P
    "Type of auxiliary heating controller"
    annotation (Dialog(group="P controller"));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=nCoi)
    "Boolean scalar replicator"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));

  Buildings.Controls.Continuous.LimPID conPHeaHig(
    final controllerType=controllerType,
    final k=kOpe,
    final yMax=1,
    final yMin=0,
    final reverseActing=false)
    "Regulate supply air temperature at or above its setpoint when load is unmet by DX heating"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));

  Buildings.Controls.OBC.CDL.Logical.And and2[nCoi]
    "Logical And"
    annotation (Placement(transformation(extent={{60,78},{80,98}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1[nCoi]
    "Logical Not"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulSupHeaEng
    "Enable auxiliary heating if DX coil is unable to meet heating load"
    annotation (Placement(transformation(extent={{30,-96},{50,-76}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThrLocOut(
    final t=TLocOut,
    final h=dTHys)
    "Check if outdoor air lockout temperature is less than threshold"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThrHeaCoi(
    final t=uThrHeaCoi,
    final h=dUHys)
    "Check if heating coil signal is equal to or greater than threshold"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaSupHeaHig
    "Convert Boolean auxiliary heating enable signal to real value"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

  Buildings.Controls.OBC.CDL.Logical.And andLocOut
    "Check for heating coil signal and outdoor air temperature lockout"
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Max maxSupHea
    "Output higher of the two auxiliary heating signals"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHeaCoiSig(
    final k=uThrHeaCoi)
    "Constant heating coil signal"
    annotation (Placement(transformation(extent={{-50,-100},{-30,-80}})));

  Buildings.Controls.Continuous.LimPID conPHeaLocOut(
    final controllerType=controllerType,
    final k=kLocOut,
    final yMax=1,
    final yMin=0,
    final reverseActing=false)
    "Regulate supply air temperature at or above its setpoint"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulSupHeaEng1
    "Enable auxiliary heating when DX coil is locked out"
    annotation (Placement(transformation(extent={{30,44},{50,64}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaSupHeaLocOut
    "Convert Boolean auxiliary heating enable signal to real value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHeaCoiSigZer(
    final k=0)
    "Constant zero heating coil signal"
    annotation (Placement(transformation(extent={{-46,40},{-26,60}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThrHeaCoi1(
    final t=dUHys,
    final h=dUHys/2)
    "Check if heating coil signal is greater than zero during lockout mode"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

equation
  connect(lesThrLocOut.u, TOut)
    annotation (Line(points={{-82,0},{-120,0}}, color={0,0,127}));
  connect(uHeaCoi, greThrHeaCoi.u)
    annotation (Line(points={{-120,-40},{-90,-40},{-90,-60},{-82,-60}},
                                                    color={0,0,127}));
  connect(lesThrLocOut.y, andLocOut.u1)
    annotation (Line(points={{-58,0},{-48,0}}, color={255,0,255}));
  connect(conPHeaHig.y, mulSupHeaEng.u1)
    annotation (Line(points={{11,-90},{20,-90},{20,-80},{28,-80}},
                                                 color={0,0,127}));
  connect(mulSupHeaEng.y, maxSupHea.u2)
    annotation (Line(points={{52,-86},{60,-86},{60,-26},{68,-26}}, color={0,0,127}));
  connect(maxSupHea.y, yAuxHea)
    annotation (Line(points={{92,-20},{120,-20}}, color={0,0,127}));
  connect(conPHeaHig.u_s, conHeaCoiSig.y)
    annotation (Line(points={{-12,-90},{-28,-90}}, color={0,0,127}));
  connect(uHeaCoi, conPHeaHig.u_m)
    annotation (Line(points={{-120,-40},{-90,-40},{-90,-110},{0,-110},{0,-102}},color={0,0,127}));
  connect(booToReaSupHeaHig.y, mulSupHeaEng.u2)
    annotation (Line(points={{2,-50},{24,-50},{24,-92},{28,-92}},  color={0,0,127}));
  connect(conPHeaLocOut.y, mulSupHeaEng1.u1)
    annotation (Line(points={{11,50},{20,50},{20,60},{28,60}}, color={0,0,127}));
  connect(booToReaSupHeaLocOut.y, mulSupHeaEng1.u2)
    annotation (Line(points={{12,0},{ 20,0},{20,48},{28,48}}, color={0,0,127}));
  connect(greThrHeaCoi.y, booToReaSupHeaHig.u)
    annotation (Line(points={{-58,-60},{-40,-60},{-40,-50},{-22,-50}},
                                                   color={255,0,255}));
  connect(andLocOut.y, booToReaSupHeaLocOut.u)
    annotation (Line(points={{-24,0},{-12,0}}, color={255,0,255}));
  connect(mulSupHeaEng1.y, maxSupHea.u1)
    annotation (Line(points={{52,54},{60,54},{60,-14},{68,-14}}, color={0,0,127}));
  connect(conHeaCoiSigZer.y, conPHeaLocOut.u_s)
    annotation (Line(points={{-24,50},{-12,50}}, color={0,0,127}));
  connect(uHeaCoi, conPHeaLocOut.u_m)
    annotation (Line(points={{-120,-40},{-90,-40},{-90,28},{0,28},{0,38}}, color={0,0,127}));

  connect(lesThrLocOut.y, booScaRep.u) annotation (Line(points={{-58,0},{-52,0},
          {-52,100},{-42,100}}, color={255,0,255}));
  connect(booScaRep.y, not1.u)
    annotation (Line(points={{-18,100},{-2,100}}, color={255,0,255}));
  connect(not1.y, and2.u1) annotation (Line(points={{22,100},{50,100},{50,88},{58,
          88}}, color={255,0,255}));
  connect(and2.y, yDXCoi) annotation (Line(points={{82,88},{90,88},{90,60},{120,
          60}}, color={255,0,255}));
  connect(uDXCoi, and2.u2)
    annotation (Line(points={{-120,80},{58,80}}, color={255,0,255}));
  connect(uHeaCoi, greThrHeaCoi1.u) annotation (Line(points={{-120,-40},{-90,-40},
          {-90,-30},{-82,-30}}, color={0,0,127}));
  connect(greThrHeaCoi1.y, andLocOut.u2) annotation (Line(points={{-58,-30},{-52,
          -30},{-52,-8},{-48,-8}}, color={255,0,255}));
  annotation (defaultComponentName="conAuxCoi",
    Icon(coordinateSystem(preserveAspectRatio=false),
      graphics={
        Text(
          extent={{-100,6},{-66,-8}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOut"),
        Text(
          extent={{-98,-52},{-46,-66}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHeaCoi"),
        Text(
          extent={{42,-6},{94,-32}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yAuxHea"),
          Text(
            extent={{-98,66},{-52,52}},
            textColor={255,0,255},
          textString="uDXCoi"),
          Text(
            extent={{54,26},{96,12}},
            textColor={255,0,255},
            textString="yDXCoi"),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                        Text(
        extent={{-150,140},{150,100}},
        textString="%name",
        textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}})),
  Documentation(info="<html>
  <p>
  This is a control module for adjusting auxiliary heating coil operation signal. 
  The control module is operated as follows: 
  </p>
  <ul>
  <li>
  When the outdoor air temperature <code>TOut</code> falls below a outdoor air lockout temperature 
  <code>TLocOut</code>, the controller deactivates DX coils. It then utilizes the heating coil valve 
  position signal <code>uHeaCoi</code> as an auxiliary heating coil operation signal 
  <code>yAuxHea</code> if <code>uHeaCoi</code> exceeds the heating coil valve signal threshold 
  <code>uThrHeaCoi</code> with a hysteresis value <code>dTHys</code>. Conversely, the controller 
  disables the auxiliary heating if <code>uHeaCoi</code> falls below <code>uThrHeaCoi</code>.
  </li>
  <li>
  When <code>TOut</code> exceeds <code>TLocOut</code>, the controller maps <code>yAuxHea</code> 
  from <code>uThrHeaCoi</code> to 100% of <code>uHeaCoi</code> if <code>uHeaCoi</code> exceeds 
  <code>uThrHeaCoi</code>. This ensures that the auxiliary heating is only employed during coil 
  staging or when the coils are unable to meet the heating load.
  </li>
  </ul>
  </html>", revisions="<html>
  <ul>
  <li>
  July 3, 2023, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end AuxiliaryCoil;
