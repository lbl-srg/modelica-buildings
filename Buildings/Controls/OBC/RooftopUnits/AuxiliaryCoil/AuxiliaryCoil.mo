within Buildings.Controls.OBC.RooftopUnits.AuxiliaryCoil;
block AuxiliaryCoil "Sequences to control auxiliary heating coils"
  extends Modelica.Blocks.Icons.Block;

  parameter Real TLocOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=273.15-12.2
    "Minimum outdoor dry-bulb temperature for compressor operation";

  parameter Real dTHys(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=0.05
    "Small temperature difference used in comparison blocks"
    annotation(Dialog(tab="Advanced"));

  parameter Real k1=1
    "Gain of auxiliary heating controller 1"
    annotation (Dialog(group="P controller"));

  parameter Real k2=10
    "Gain of auxiliary heating controller 2"
    annotation (Dialog(group="P controller"));

  parameter Real uThrHeaCoi(
    final min=0,
    final max=1)=0.9
    "Threshold of heating coil valve position signal above which auxiliary coil is enabled";

  parameter Real dUHys=0.01
    "Coil valve position comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Heating coil valve position"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAuxHea(
    final min=0,
    final max=1,
    final unit="1")
    "Auxiliary heating coil signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.Continuous.LimPID conPHeaHig(
    final controllerType=controllerType,
    final k=k2,
    final yMax=1,
    final yMin=0,
    final reverseActing=false)
    "Regulate supply air temperature at or above its setpoint when load is unmet by DX heating"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulSupHeaEng
    "Enable auxiliary heating if DX coil is unable to meet heating load"
    annotation (Placement(transformation(extent={{30,-76},{50,-56}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThrLocOut(
    final t=TLocOut,
    final h=dTHys)
    "Check if outdoor air lockout temperature is less than threshold"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThrHeaCoi(
    final t=uThrHeaCoi,
    final h=dUHys)
    "Check if heating coil signal is equal to or greater than threshold"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaSupHeaHig
    "Convert Boolean auxiliary heating enable signal to real value"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  Buildings.Controls.OBC.CDL.Logical.And andLocOut
    "Check for heating coil signal and outdoor air temperature lockout"
    annotation (Placement(transformation(extent={{-46,10},{-26,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Max maxSupHea
    "Output higher of the two auxiliary heating signals"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHeaCoiSig(
    final k=0.9)
    "Constant heating coil signal"
    annotation (Placement(transformation(extent={{-46,-70},{-26,-50}})));

  Buildings.Controls.Continuous.LimPID conPHeaLocOut(
    final controllerType=controllerType,
    final k=k1,
    final yMax=1,
    final yMin=0,
    final reverseActing=false)
    "Regulate supply air temperature at or above its setpoint"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulSupHeaEng1
    "Enable auxiliary heating when DX coil is locked out"
    annotation (Placement(transformation(extent={{30,54},{50,74}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaSupHeaLocOut
    "Convert Boolean auxiliary heating enable signal to real value"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHeaCoiSig1(
    final k=0)
    "Constant heating coil signal"
    annotation (Placement(transformation(extent={{-46,60},{-26,80}})));
protected
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P
    "Type of auxiliary heating controller"
    annotation (Dialog(group="P controller"));

equation
  connect(lesThrLocOut.u, TOut)
    annotation (Line(points={{-82,20},{-120,20}},   color={0,0,127}));
  connect(uHeaCoi, greThrHeaCoi.u)
    annotation (Line(points={{-120,-20},{-82,-20}}, color={0,0,127}));
  connect(lesThrLocOut.y, andLocOut.u1)
    annotation (Line(points={{-58,20},{-48,20}},   color={255,0,255}));
  connect(conPHeaHig.y, mulSupHeaEng.u1)
    annotation (Line(points={{11,-60},{28,-60}}, color={0,0,127}));
  connect(mulSupHeaEng.y, maxSupHea.u2) annotation (Line(points={{52,-66},{60,-66},
          {60,-6},{68,-6}}, color={0,0,127}));
  connect(maxSupHea.y, yAuxHea) annotation (Line(points={{92,0},{120,0}},
                    color={0,0,127}));
  connect(conPHeaHig.u_s, conHeaCoiSig.y)
    annotation (Line(points={{-12,-60},{-24,-60}}, color={0,0,127}));
  connect(uHeaCoi, conPHeaHig.u_m) annotation (Line(points={{-120,-20},{-90,-20},
          {-90,-80},{0,-80},{0,-72}}, color={0,0,127}));
  connect(booToReaSupHeaHig.y, mulSupHeaEng.u2) annotation (Line(points={{12,-20},
          {20,-20},{20,-72},{28,-72}}, color={0,0,127}));
  connect(conPHeaLocOut.y, mulSupHeaEng1.u1) annotation (Line(points={{11,70},{28,
          70}},                 color={0,0,127}));
  connect(booToReaSupHeaLocOut.y, mulSupHeaEng1.u2) annotation (Line(points={{12,20},
          {20,20},{20,58},{28,58}},     color={0,0,127}));
  connect(greThrHeaCoi.y, booToReaSupHeaHig.u) annotation (Line(points={{-58,-20},
          {-12,-20}},                     color={255,0,255}));
  connect(andLocOut.y, booToReaSupHeaLocOut.u)
    annotation (Line(points={{-24,20},{-12,20}}, color={255,0,255}));
  connect(greThrHeaCoi.y, andLocOut.u2) annotation (Line(points={{-58,-20},{-52,
          -20},{-52,12},{-48,12}}, color={255,0,255}));
  connect(mulSupHeaEng1.y, maxSupHea.u1)
    annotation (Line(points={{52,64},{60,64},{60,6},{68,6}}, color={0,0,127}));
  connect(conHeaCoiSig1.y, conPHeaLocOut.u_s)
    annotation (Line(points={{-24,70},{-12,70}}, color={0,0,127}));
  connect(uHeaCoi, conPHeaLocOut.u_m) annotation (Line(points={{-120,-20},{-90,-20},
          {-90,48},{0,48},{0,58}}, color={0,0,127}));

  annotation (defaultComponentName="conAuxCoi",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-100,26},{-62,12}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOut"),
        Text(
          extent={{-96,-12},{-44,-26}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHeaCoi"),
        Text(
          extent={{42,14},{94,-12}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yAuxHea")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
  <p>
  This is a control module for adjusting auxiliary heating coil operation signal. 
  The control module is operated as follows: 
  </p>
  <ul>
  <li>
  When the outdoor air temperature <code>TOut</code> falls below a outdoor air lockout temperature 
  <code>TLocOut</code>, the controller utilizes the heating coil valve position signal
  <code>uHeaCoi</code> as the auxiliary heating coil operation signal <code>yAuxHea</code>
  if <code>uHeaCoi</code> exceeds the heating coil valve signal threshold <code>uThrHeaCoi</code>
  with a hysteresis value <code>dTHys</code>. Conversely, the controller disables the auxiliary heatin if 
  <code>uHeaCoi</code> falls below <code>uThrHeaCoi</code>.
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
