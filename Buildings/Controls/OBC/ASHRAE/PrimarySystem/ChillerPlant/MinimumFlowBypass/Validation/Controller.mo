within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Validation;
model Controller "Validate control of minimum bypass valve"

  parameter Integer nChi=3 "Total number of chillers";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller
    minBypValCon(
    final nChi=nChi,
    isParallelChiller=true,
    final byPasSetTim=1.5,
    final minFloSet={minFloChiOne,minFloChiTwo,minFloChiThr},
    final maxFloSet={maxFloChiOne,maxFloChiTwo,maxFloChiThr})
    "Minimum bypass valve position"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

protected
  final parameter Modelica.SIunits.VolumeFlowRate minFloChiOne = 0.005;
  final parameter Modelica.SIunits.VolumeFlowRate minFloChiTwo = 0.005;
  final parameter Modelica.SIunits.VolumeFlowRate minFloChiThr = 0.005;
  final parameter Modelica.SIunits.VolumeFlowRate maxFloChiOne = 0.025;
  final parameter Modelica.SIunits.VolumeFlowRate maxFloChiTwo = 0.025;
  final parameter Modelica.SIunits.VolumeFlowRate maxFloChiThr = 0.025;
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse upDev(
    final width=0.3,
    final period=4) "Status of upflow device"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse staCha(
    final width=0.25,
    final period=4) "Stage up command"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noStaCha(final k=false)
    "No stage change"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant haveOnOff(final k=true)
    "Have chiller on/off during the stage change"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaNexChi(
    final width=0.8,
    final period=4) "Enable next chiller"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiWatPum(
    final width=0.15,
    final period=4,
    final startTime=0.1) "Chilled water pump on command"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=minFloChiOne/2,
    final freqHz=1/2,
    final offset=(minFloChiOne + minFloChiTwo)/2) "Output sine wave value"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final height=minFloChiOne + minFloChiTwo + minFloChiThr,
    final duration=2,
    final startTime=1.2) "Output ramp value"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Measured minimum bypass flow rate"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiSta[nChi](
    final k={true,true,false})
    "Current chiller status"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch enaChi "Next enabling chiller"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=3)
    "Index of enabling chiller"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(final k=2)
    "Index of disabling chiller"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0) "Zero"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch disChi "Disabling chiller"
    annotation (Placement(transformation(extent={{-20,-170},{0,-150}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{20,-170},{40,-150}})));

equation
  connect(staCha.y, not1.u)
    annotation (Line(points={{-98,80},{-82,80}}, color={255,0,255}));
  connect(upDev.y, not2.u)
    annotation (Line(points={{-98,40},{-82,40}}, color={255,0,255}));
  connect(not1.y, minBypValCon.uStaUp)
    annotation (Line(points={{-58,80},{72,80},{72,-55},{98,-55}}, color={255,0,255}));
  connect(not2.y, minBypValCon.uUpsDevSta)
    annotation (Line(points={{-58,40},{68,40},{68,-57},{98,-57}}, color={255,0,255}));
  connect(haveOnOff.y, minBypValCon.uOnOff)
    annotation (Line(points={{-98,-80},{64,-80},{64,-61},{98,-61}},
      color={255,0,255}));
  connect(enaNexChi.y, not3.u)
    annotation (Line(points={{-98,-40},{-82,-40}}, color={255,0,255}));
  connect(not3.y, minBypValCon.uSubCha)
    annotation (Line(points={{-58,-40},{64,-40},{64,-59},{98,-59}}, color={255,0,255}));
  connect(noStaCha.y, minBypValCon.uStaDow)
    annotation (Line(points={{-98,-110},{80,-110},{80,-69},{98,-69}},
      color={255,0,255}));
  connect(chiWatPum.y, not4.u)
    annotation (Line(points={{-98,180},{-82,180}}, color={255,0,255}));
  connect(not4.y, minBypValCon.uChiWatPum)
    annotation (Line(points={{-58,180},{80,180},{80,-51},{98,-51}},
      color={255,0,255}));
  connect(sin.y, add2.u1)
    annotation (Line(points={{-98,150},{-90,150},{-90,146},{-82,146}},
      color={0,0,127}));
  connect(ram.y, add2.u2)
    annotation (Line(points={{-98,120},{-90,120},{-90,134},{-82,134}},
      color={0,0,127}));
  connect(add2.y, minBypValCon.VChiWat_flow)
    annotation (Line(points={{-58,140},{76,140},{76,-53},{98,-53}},
      color={0,0,127}));
  connect(not1.y, enaChi.u2)
    annotation (Line(points={{-58,80},{-40,80},{-40,-20},{-22,-20}},
      color={255,0,255}));
  connect(not1.y, disChi.u2)
    annotation (Line(points={{-58,80},{-40,80},{-40,-160},{-22,-160}},
      color={255,0,255}));
  connect(con.y, enaChi.u1)
    annotation (Line(points={{-98,0},{-44,0},{-44,-12},{-22,-12}},
      color={0,0,127}));
  connect(zer.y, enaChi.u3)
    annotation (Line(points={{-98,-180},{-44,-180},{-44,-28},{-22,-28}},
      color={0,0,127}));
  connect(zer.y, disChi.u3)
    annotation (Line(points={{-98,-180},{-44,-180},{-44,-168},{-22,-168}},
      color={0,0,127}));
  connect(con1.y, disChi.u1)
    annotation (Line(points={{-98,-140},{-60,-140},{-60,-152},{-22,-152}},
      color={0,0,127}));
  connect(enaChi.y, reaToInt.u)
    annotation (Line(points={{2,-20},{18,-20}}, color={0,0,127}));
  connect(disChi.y, reaToInt1.u)
    annotation (Line(points={{2,-160},{18,-160}}, color={0,0,127}));
  connect(chiSta.y, minBypValCon.uChi)
    annotation (Line(points={{2,20},{60,20},{60,-63},{98,-63}},
      color={255,0,255}));
  connect(reaToInt.y, minBypValCon.nexEnaChi)
    annotation (Line(points={{42,-20},{56,-20},{56,-65},{98,-65}},
      color={255,127,0}));
  connect(reaToInt1.y, minBypValCon.nexDisChi)
    annotation (Line(points={{42,-160},{56,-160},{56,-67},{98,-67}},
      color={255,127,0}));

annotation (
 experiment(StopTime=4.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/MinimumFlowBypass/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-200},{140,200}})));
end Controller;
