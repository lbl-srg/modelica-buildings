within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences;
block DownStart "Sequence for starting stage-down process"

  parameter Integer nChi "Total number of chillers";
  parameter Boolean isParallelChiller=true
    "Flag: true means that the plant has parallel chillers";
  parameter Real chiDemRedFac=0.75
    "Demand reducing factor of current operating chillers"
    annotation (Dialog(group="Demand limit"));
  parameter Modelica.SIunits.Time holChiDemTim=300
    "Time of actual demand less than center percentage of currnet load"
    annotation (Dialog(group="Demand limit"));
  parameter Modelica.SIunits.Time byPasSetTim
    "Time constant for resetting minimum bypass flow"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Modelica.SIunits.VolumeFlowRate minFloSet[nChi]={0.0089,0.0089}
    "Minimum chilled water flow through each chiller"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Modelica.SIunits.VolumeFlowRate maxFloSet[nChi]={0.025,0.025}
    "Maximum chilled water flow through each chiller"
    annotation (Dialog(group="Reset CHW minimum flow setpoint"));
  parameter Modelica.SIunits.Time aftByPasSetTim=60
    "Time after setpoint achieved"
    annotation (Dialog(group="Reset bypass"));
  parameter Real relFloDif=0.025
    "Hysteresis to check if flow achieves setpoint"
    annotation (Dialog(group="Reset bypass"));
  parameter Modelica.SIunits.Time waiTim=30
    "Waiting time after enabling next head pressure control"
    annotation (Dialog(group="Head pressure control"));
  parameter Modelica.SIunits.Time chaChiWatIsoTim=300
    "Time to slowly change isolation valve, should be determined in the field"
    annotation (Dialog(group="Chilled water isolation valve"));
  parameter Modelica.SIunits.Time proOnTim=300
    "Enabled chiller operation time to indicate if it is proven on"
    annotation (Dialog(group="Disable last chiller"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-200,190},{-160,230}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput minOPLR(
    final min=0,
    final max=1,
    final unit="1")
    "Current stage minimum cycling operative partial load ratio"
    annotation (Placement(transformation(extent={{-200,160},{-160,200}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa[nChi](
    final quantity=fill("HeatFlowRate", nChi),
    final unit=fill("W", nChi)) "Current chiller load"
    annotation (Placement(transformation(extent={{-200,130},{-160,170}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,70},{-160,110}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage require one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaChi
    "Index of next enabling chiller"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon[nChi]
    "Chillers head pressure control status"
    annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi)) "Chilled water isolation valve position"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Next disabling chiller when there is any stage up that need one chiller on and another off"
    annotation (Placement(transformation(extent={{-200,-190},{-160,-150}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiDem[nChi](
    final quantity=fill("HeatFlowRate", nChi),
    final unit=fill("W", nChi)) "Chiller demand setpoint"
    annotation (Placement(transformation(extent={{180,130},{200,150}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiHeaCon[nChi]
    "Chiller head pressure control enabling status"
    annotation (Placement(transformation(extent={{180,-30},{200,-10}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatIsoVal[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Chiller chilled water isolation valve position"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChi[nChi]
    "Chiller enabling status"
    annotation (Placement(transformation(extent={{180,-160},{200,-140}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yReaDemLim
    "Release demand limit"
    annotation (Placement(transformation(extent={{180,-190},{200,-170}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand
    chiDemRed(
    final nChi=nChi,
    final chiDemRedFac=chiDemRedFac,
    final holChiDemTim=holChiDemTim) "Reduce chiller demand"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass
    minBypRes(
    final aftByPasSetTim=aftByPasSetTim,
    final relFloDif=relFloDif)
    "Slowly change the minimum flow bypass setpoint"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl
    enaHeaCon(
    final nChi=nChi,
    final thrTimEnb=0,
    final waiTim=waiTim,
    final heaStaCha=true)
    "Enable head pressure control of the chiller being enabled"
    annotation (Placement(transformation(extent={{0,-26},{20,-6}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal
    enaChiIsoVal(
    final nChi=nChi,
    final chaChiWatIsoTim=chaChiWatIsoTim,
    final iniValPos=0,
    final endValPos=1) "Enable chiller chilled water isolation valve "
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller
    disChi(final nChi=nChi, final proOnTim=proOnTim) "Disable last chiller"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint
    minChiWatSet(
    final nChi=nChi,
    final isParallelChiller=isParallelChiller,
    final maxFloSet=maxFloSet,
    final byPasSetTim=byPasSetTim,
    final minFloSet=minFloSet) "Reset minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(final k=false)
    "False constant"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch heaPreCon[nChi] "Logical switch"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiDem[nChi] "Chiller demand"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep4(final nout=nChi)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiWatIsoVal[nChi]
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{140,-80},{160,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));

equation
  connect(chiDemRed.uChiLoa, uChiLoa)
    annotation (Line(points={{-22,175},{-100,175},{-100,150},{-180,150}},
      color={0,0,127}));
  connect(chiDemRed.uChi, uChi)
    annotation (Line(points={{-22,161},{-40,161},{-40,120},{-180,120}},color={255,0,255}));
  connect(con3.y, minChiWatSet.uStaUp)
    annotation (Line(points={{-78,70},{-60,70},{-60,59},{-2,59}}, color={255,0,255}));
  connect(minChiWatSet.uStaDow, uStaDow)
    annotation (Line(points={{-2,41},{-140,41},{-140,210},{-180,210}},
      color={255,0,255}));
  connect(minChiWatSet.uOnOff, uOnOff)
    annotation (Line(points={{-2,43},{-110,43},{-110,20},{-180,20}},
      color={255,0,255}));
  connect(chiDemRed.yChiDemRed, minBypRes.uUpsDevSta)
    annotation (Line(points={{2,166},{20,166},{20,108},{58,108}},
      color={255,0,255}));
  connect(uStaDow, minBypRes.uStaCha)
    annotation (Line(points={{-180,210},{-140,210},{-140,104},{58,104}},
      color={255,0,255}));
  connect(VChiWat_flow, minBypRes.VChiWat_flow)
    annotation (Line(points={{-180,90},{-60,90},{-60,96},{58,96}}, color={0,0,127}));
  connect(minBypRes.yMinBypRes, enaHeaCon.uUpsDevSta)
    annotation (Line(points={{82,100},{100,100},{100,0},{-20,0},{-20,-8},{-2,-8}},
      color={255,0,255}));
  connect(uStaDow, enaHeaCon.uStaCha)
    annotation (Line(points={{-180,210},{-140,210},{-140,-12},{-2,-12}},
      color={255,0,255}));
  connect(enaHeaCon.nexChaChi, nexEnaChi)
    annotation (Line(points={{-2,-20},{-180,-20}}, color={255,127,0}));
  connect(enaHeaCon.uChiHeaCon, uChiHeaCon)
    annotation (Line(points={{-2,-24},{-20,-24},{-20,-50},{-180,-50}},
      color={255,0,255}));
  connect(nexEnaChi, enaChiIsoVal.nexChaChi)
    annotation (Line(points={{-180,-20},{-60,-20},{-60,-92},{-2,-92}},
      color={255,127,0}));
  connect(enaChiIsoVal.uChiWatIsoVal, uChiWatIsoVal)
    annotation (Line(points={{-2,-95},{-100,-95},{-100,-100},{-180,-100}},
      color={0,0,127}));
  connect(enaHeaCon.yEnaHeaCon,enaChiIsoVal.uUpsDevSta)
    annotation (Line(points={{22,-10},{30,-10},{30,-60},{-20,-60},{-20,-105},
      {-2,-105}}, color={255,0,255}));
  connect(uStaDow, enaChiIsoVal.uStaCha)
    annotation (Line(points={{-180,210},{-140,210},{-140,-108},{-2,-108}},
      color={255,0,255}));
  connect(nexEnaChi, disChi.nexEnaChi)
    annotation (Line(points={{-180,-20},{-60,-20},{-60,-141},{-2,-141}},
      color={255,127,0}));
  connect(uStaDow, disChi.uStaDow)
    annotation (Line(points={{-180,210},{-140,210},{-140,-144},{-2,-144}},
      color={255,0,255}));
  connect(enaChiIsoVal.yEnaChiWatIsoVal, disChi.uEnaChiWatIsoVal)
    annotation (Line(points={{22,-94},{40,-94},{40,-120},{-20,-120},{-20,-148},
      {-2,-148}}, color={255,0,255}));
  connect(uChi, disChi.uChi)
    annotation (Line(points={{-180,120},{-40,120},{-40,-152},{-2,-152}},
      color={255,0,255}));
  connect(uOnOff, disChi.uOnOff)
    annotation (Line(points={{-180,20},{-110,20},{-110,-159},{-2,-159}},
      color={255,0,255}));
  connect(disChi.nexDisChi, nexDisChi)
    annotation (Line(points={{-2,-155},{-80,-155},{-80,-170},{-180,-170}},
      color={255,127,0}));
  connect(uStaDow, and2.u1)
    annotation (Line(points={{-180,210},{-140,210},{-140,200},{-102,200}},
      color={255,0,255}));
  connect(and2.y, chiDemRed.uDemLim)
    annotation (Line(points={{-78,200},{-40,200},{-40,179},{-22,179}},
      color={255,0,255}));
  connect(uOnOff, booRep4.u)
    annotation (Line(points={{-180,20},{58,20}}, color={255,0,255}));
  connect(booRep4.y, chiDem.u2)
    annotation (Line(points={{82,20},{120,20},{120,140},{138,140}},
      color={255,0,255}));
  connect(chiDemRed.yChiDem, chiDem.u1)
    annotation (Line(points={{2,174},{120,174},{120,148},{138,148}},
      color={0,0,127}));
  connect(uChiLoa, chiDem.u3)
    annotation (Line(points={{-180,150},{-100,150},{-100,132},{138,132}},
      color={0,0,127}));
  connect(booRep4.y, heaPreCon.u2)
    annotation (Line(points={{82,20},{120,20},{120,-20},{138,-20}},
      color={255,0,255}));
  connect(enaHeaCon.yChiHeaCon, heaPreCon.u1)
    annotation (Line(points={{22,-22},{80,-22},{80,-12},{138,-12}},
      color={255,0,255}));
  connect(uChiHeaCon, heaPreCon.u3)
    annotation (Line(points={{-180,-50},{80,-50},{80,-28},{138,-28}},
      color={255,0,255}));
  connect(booRep4.y, chiWatIsoVal.u2)
    annotation (Line(points={{82,20},{120,20},{120,-70},{138,-70}},
      color={255,0,255}));
  connect(enaChiIsoVal.yChiWatIsoVal, chiWatIsoVal.u1)
    annotation (Line(points={{22,-106},{60,-106},{60,-62},{138,-62}},
      color={0,0,127}));
  connect(uChiWatIsoVal, chiWatIsoVal.u3)
    annotation (Line(points={{-180,-100},{-100,-100},{-100,-78},{138,-78}},
      color={0,0,127}));
  connect(chiDem.y, yChiDem)
    annotation (Line(points={{162,140},{190,140}}, color={0,0,127}));
  connect(heaPreCon.y, yChiHeaCon)
    annotation (Line(points={{162,-20},{190,-20}}, color={255,0,255}));
  connect(chiWatIsoVal.y, yChiWatIsoVal)
    annotation (Line(points={{162,-70},{190,-70}}, color={0,0,127}));
  connect(disChi.yChi, yChi)
    annotation (Line(points={{22,-150},{190,-150}}, color={255,0,255}));
  connect(disChi.yReaDemLim, not1.u)
    annotation (Line(points={{22,-158},{40,-158},{40,-180},{58,-180}},
     color={255,0,255}));
  connect(not1.y, and2.u2)
    annotation (Line(points={{82,-180},{100,-180},{100,-200},{-120,-200},
      {-120,192},{-102,192}}, color={255,0,255}));
  connect(disChi.yReaDemLim, yReaDemLim)
    annotation (Line(points={{22,-158},{120,-158},{120,-180},{190,-180}},
      color={255,0,255}));
  connect(minOPLR, chiDemRed.minOPLR)
    annotation (Line(points={{-180,180},{-110,180},{-110,171},{-22,171}},
      color={0,0,127}));
  connect(uStaDow, chiDemRed.uStaDow)
    annotation (Line(points={{-180,210},{-140,210},{-140,168},{-22,168}},
      color={255,0,255}));
  connect(uOnOff, chiDemRed.uOnOff)
    annotation (Line(points={{-180,20},{-110,20},{-110,165},{-22,165}},
      color={255,0,255}));
  connect(uChi, minChiWatSet.uChi)
    annotation (Line(points={{-180,120},{-40,120},{-40,54},{-2,54}},
      color={255,0,255}));
  connect(nexEnaChi, minChiWatSet.nexEnaChi)
    annotation (Line(points={{-180,-20},{-60,-20},{-60,51},{-2,51}},
      color={255,127,0}));
  connect(nexDisChi, minChiWatSet.nexDisChi)
    annotation (Line(points={{-180,-170},{-80,-170},{-80,49},{-2,49}},
      color={255,127,0}));
  connect(minChiWatSet.yChiWatMinFloSet, minBypRes.VMinChiWat_setpoint)
    annotation (Line(points={{22,50},{40,50},{40,92},{58,92}}, color={0,0,127}));
  connect(chiDemRed.yChiDemRed, minChiWatSet.uSubCha)
    annotation (Line(points={{2,166},{20,166},{20,80},{-20,80},{-20,46},{-2,46}},
      color={255,0,255}));
  connect(con3.y, minChiWatSet.uUpsDevSta)
    annotation (Line(points={{-78,70},{-60,70},{-60,57},{-2,57}},
      color={255,0,255}));

annotation (
  defaultComponentName="staStaDow",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-200},{180,220}})),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-40,6},{40,-6}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,-6},{2,-72}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-72},{-20,-72},{0,-90},{20,-72},{0,-72}},
          lineColor={200,200,200},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,-84},{-58,-96}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="nexDisChi"),
        Text(
          extent={{-98,-62},{-46,-76}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiWatIsoVal"),
        Text(
          extent={{-98,18},{-46,6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="vChiWat_flow"),
        Text(
          extent={{-98,76},{-58,64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="minOPLR"),
        Text(
          extent={{-100,56},{-64,46}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uChiLoa"),
        Text(
          extent={{-102,36},{-74,26}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChi"),
        Text(
          extent={{-98,98},{-64,86}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uStaDow"),
        Text(
          extent={{-100,-2},{-66,-12}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOnOff"),
        Text(
          extent={{-98,-22},{-54,-34}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="nexEnaChi"),
        Text(
          extent={{-98,-44},{-52,-54}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiHeaCon"),
        Text(
          extent={{64,98},{100,88}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiDem"),
        Text(
          extent={{60,6},{96,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiIsoVal"),
        Text(
          extent={{56,58},{98,46}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yChiHeaCon"),
        Text(
          extent={{66,-44},{104,-54}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yChi"),
        Text(
          extent={{54,-82},{96,-94}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yReaDemLim")}),
Documentation(info="<html>
<p>
Block that controls devices at the first step of chiller staging down process.
This development is based on ASHRAE RP-1711 Advanced Sequences of Operation for 
HVAC Systems Phase II – Central Plants and Hydronic Systems (Draft 6 on July 25, 
2019), section 5.2.4.16, item 1 and 2. The sections specifies the first step of 
staging down process.
</p>
<p>
For the stage-down process that requires a smaller chiller being enabled and a
larger chiller being disabled (<code>uOnOff=true</code>): 
</p>
<ol>
<li>
Command operating chilers to reduce demand to 75% (<code>chiDemRedFac</code>) of 
their current load or a percentage equal to current stage minimum cycling operative 
partial load ratio (<code>minOPLR</code>), whichever is greater. Wait until acutal 
demand &lt; 80% of current load up to a maximum of 5 minutes (<code>holChiDemTim</code>) 
before proceeding. This is implemented in block <code>chiDemRed</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ReduceDemand</a>
for more decriptions.
</li>
<li>
Slowly change the minimum chilled water flow setpoint to that approriate for the
stage transition (<code>minChiWatSet</code>). After new setpoint is achieved, wait 
1 minutes (<code>aftByPasSetTim</code>) to allow loop to stabilize (<code>minBypRes</code>). 
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint</a>
and
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.ResetMinBypass</a>
for more decriptions.
</li>
<li>
Enable head pressure control for the chiller being enabled. Wait 30 seconds (<code>waiTim</code>). 
It is implemented in block <code>enaHeaCon</code>, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.HeadControl</a>
for more decriptions.
</li>
<li>
Slowly open chilled water isolation valve of the smaller chiller being enabled.
Determine valve timing <code>chaChiWatIsoTim</code> in the field as that required 
to prevent nuisance trips. 
It is implemented in block <code>enaChiIsoVal</code>, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal</a>
for more decriptions.
</li>
<li>
Start the smaller chiller after its chilled water isolation valve is fully open.
Wait 5 minutes (<code>proOnTim</code>) after the newly enabled chiller to prove that 
it is operating correctly, then shut off the larger chiller and release the demand 
limit (<code>yReaDemLim=true</code>). 
It is implemented in block <code>disChi</code>, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.DisableChiller</a>
for more decriptions.
</li>
</ol>
<p>
For staging down from any other stage (<code>uOnOff=false</code>), just shut off
the last stage chiller. This is implemented in block <code>disChi</code>. 
</p>
</html>", revisions="<html>
<ul>
<li>
September 19, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DownStart;
