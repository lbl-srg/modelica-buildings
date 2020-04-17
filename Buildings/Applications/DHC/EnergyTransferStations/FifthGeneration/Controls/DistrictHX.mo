within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.Controls;
model DistrictHX "Controller for district heat exchanger loop"
  extends Modelica.Blocks.Icons.Block;

  parameter Real spePum2DisHexMin(final unit="1") = 0.1
    "District heat exchanger secondary pump minimum speed (fractional)";
  parameter Modelica.SIunits.TemperatureDifference dTHex
    "District heat exchanger secondary side deltaT";
  parameter Modelica.Blocks.Types.SimpleController
    controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="PID controller"));
  parameter Real k(final unit="1/K")=0.1
    "Gain of controller"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.SIunits.Time Ti(min=0)=60
    "Time constant of integrator block"
    annotation (Dialog(group="PID controller",
      enable=controllerType==Modelica.Blocks.Types.SimpleController.PI
         or  controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(group="PID controller",
      enable=controllerType==Modelica.Blocks.Types.SimpleController.PD
          or controllerType==Modelica.Blocks.Types.SimpleController.PID));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2DisHexEnt(final unit="K",
      displayUnit="degc")
    "District heat exchanger secondary water entering temperature" annotation (
      Placement(transformation(extent={{-260,-60},{-220,-20}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2DisHexLvg(final unit="K",
      displayUnit="degc")
    "District heat exchanger secondary water leaving temperature" annotation (
      Placement(transformation(extent={{-258,-100},{-218,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPum2DisHex(final unit="1")
    "District heat exchanger secondary pump control" annotation (Placement(
        transformation(extent={{220,-20},{260,20}}), iconTransformation(extent={{100,-20},
            {140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uColRej
    "Control signal enabling full cold rejection to ambient loop" annotation (
      Placement(transformation(extent={{-260,40},{-220,80}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaRej
    "Control signal enabling full heat rejection to ambient loop" annotation (
      Placement(transformation(extent={{-260,80},{-220,120}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.Continuous.LimPID hexPumCon(
    final k=k,
    final Ti=Ti,
    final Td=Td,
    reset=Buildings.Types.Reset.Parameter,
    reverseAction=true,
    final yMin=0,
    final yMax=1,
    final controllerType=controllerType)
    "District heat exchanger pump control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4(k2=-1)
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs3
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(k=dTHex)
    "Difference between the district heat exchanger leaving and entering water temperature(+ve)."
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch hexPumConOut
  "District heat exchanger pump control"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or  runHex
    "Output true if the heat exchanger of the substation needs to run"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSpe(
    final k=spePum2DisHexMin) "Minimum pump speed"
    annotation (Placement(transformation(extent={{-12,-90},{8,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant off(final k=0)
     "Zero pump speed representing off command"
    annotation (Placement(transformation(extent={{108,-90},{128,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax(nin=2)
    "Maximize pump control signal"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
equation
  connect(add4.y, abs3.u)  annotation (Line(points={{-138,-40},{-122,-40}},   color={0,0,127}));
  connect(abs3.y,hexPumCon. u_m) annotation (Line(points={{-98,-40},{0,-40},{0,-12}},
                       color={0,0,127}));
  connect(con3.y,hexPumCon. u_s) annotation (Line(points={{-98,0},{-12,0}},       color={0,0,127}));
  connect(T2DisHexEnt, add4.u1) annotation (Line(points={{-240,-40},{-180,-40},{
          -180,-34},{-162,-34}}, color={0,0,127}));
  connect(T2DisHexLvg, add4.u2) annotation (Line(points={{-238,-80},{-180,-80},{
          -180,-46},{-162,-46}}, color={0,0,127}));
  connect(hexPumConOut.y, yPum2DisHex)
    annotation (Line(points={{182,0},{240,0}}, color={0,0,127}));
  connect(uHeaRej, runHex.u1) annotation (Line(points={{-240,100},{-20,100},{-20,
          80},{-12,80}}, color={255,0,255}));
  connect(uColRej, runHex.u2) annotation (Line(points={{-240,60},{-20,60},{-20,72},
          {-12,72}}, color={255,0,255}));
  connect(runHex.y, hexPumConOut.u2) annotation (Line(points={{12,80},{150,80},{
          150,0},{158,0}},            color={255,0,255}));

  connect(runHex.y, hexPumCon.trigger) annotation (Line(points={{12,80},{20,80},
          {20,-20},{-8,-20},{-8,-12}}, color={255,0,255}));
  connect(off.y, hexPumConOut.u3) annotation (Line(points={{130,-80},{140,-80},{
          140,-8},{158,-8}}, color={0,0,127}));
  connect(hexPumCon.y, multiMax.u[1])
    annotation (Line(points={{11,0},{44,0},{44,1},{48,1}}, color={0,0,127}));
  connect(minSpe.y, multiMax.u[2]) annotation (Line(points={{10,-80},{40,-80},{40,
          -1},{48,-1}}, color={0,0,127}));
  connect(multiMax.y, hexPumConOut.u1) annotation (Line(points={{72,0},{140,0},{
          140,8},{158,8}}, color={0,0,127}));
annotation (Diagram(
  coordinateSystem(preserveAspectRatio=false,
  extent={{-220,-140},{220,140}})),
  defaultComponentName="conDis",
Documentation(info="<html>
<p>
This block computes the output integer <code>ModInd</code> which indicates the energy 
rejection index, i.e. heating or cooling energy is rejected and the control signals to turn
on/off and modulates the followings.
</p>
<h4>Heat exchanger district pump</h4>
<p>
The exchanger district <code>pumHexDis</code> is a variable speed pump. It turns on if either
the control signal of the isolation valve <code>uIsoCon</code> or <code>uIsoEva</code> and
<code>rejFulLoa</code> are true, and the flow rate is modulated using a reverse acting PI loop
to maintain the absolute measured temperature difference between <code>TDisHexEnt</code> and
<code>TDisHexLvg</code> equals to <code>dTHex</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2020, by Hagar Elarga:<br/>
Updated the heat exchanger pump controller to operate only if reject full load signal
is true.
</li>
<li>
November 2, 2019, by Hagar Elarga:<br/>
Added the three way valve controller and the documentation.
</li>

</ul>
</html>"));
end DistrictHX;
