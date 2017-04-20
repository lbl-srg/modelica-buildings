within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model EconEnableDisable "Economizer enable/disable switch"

  parameter Real uHigLimtCutLow(min=273.15, max=350, unit="K", displayUnit="degC") = (297 - 1) "An example high limit cutoff, 75degF - hysteresis delta";
  parameter Real uHigLimtCutHig(min=273.15, max=350, unit="K", displayUnit="degC") = 297 "An example high limit cutoff, 75degF";

  CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-140,130},
            {-100,170}}),      iconTransformation(extent={{-140,130},{-100,170}})));
  CDL.Interfaces.RealOutput yOutDamPosMax(min=0, max=1)
    "Output sets maximum allowable economizer damper position. Fixme: Should this remain as type real? Output can take two values: disable = yOutDamPosMin and enable = yOutDamPosMax."
    annotation (Placement(transformation(extent={{100,42},{138,80}}),
        iconTransformation(extent={{100,42},{138,80}})));
  CDL.Interfaces.RealInput uOutDamPosMin
    "Minimal economizer damper position, output from a separate sequence."
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput uOutDamPosMax
    "Maximum economizer damper position, either 100% or set to a constant value <100% at commisioning."
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Logical.Switch assignDamPos
    "If any of the conditions provided by TOut and FreezeProtectionStatus inputs are violating the enable status, the max outdoor damper position is set to the minimum."
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Logical.Hysteresis hysTOut(final uLow=uHigLimtCutLow, uHigh=uHigLimtCutHig)
    "Close damper when TOut is above the uHigh, open it again only when TOut falls down to uLow [fixme this needs to allow for regional dissagregation - sometimes there is a need for enthalpy evaluation as well]"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  //fixme: units for instantiated limits, example TOut limit is 75K, delta = 1K
  CDL.Interfaces.StatusTypeInput uFreezeProtectionStatus
    annotation (Placement(transformation(extent={{-140,90},{-100,130}})));
  CDL.Logical.EqualStatus compareFreProSig
    "If the signal is other than Stage 0, disable the economizer"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  CDL.Continuous.ConstantStatus freezeProtectionStage0(final refSta=Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage0)
    "Reference freeze protection stage. If the input value is different from stage 0, the outdoor air damper should close."
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{0,100},{20,120}})));

equation
  connect(TOut, hysTOut.u) annotation (Line(points={{-120,150},{-114,150},{-88,150},
          {-62,150}},
                 color={0,0,127}));
  connect(assignDamPos.y, yOutDamPosMax) annotation (Line(points={{81,10},{81,10},
          {90,10},{90,60},{106,60},{106,61},{119,61}}, color={0,0,127}));
  connect(uOutDamPosMax, assignDamPos.u3) annotation (Line(points={{-120,0},{-30,
          0},{-30,2},{58,2}}, color={0,0,127}));
  connect(uOutDamPosMin, assignDamPos.u1) annotation (Line(points={{-120,40},{-30,
          40},{-30,18},{58,18}}, color={0,0,127}));
  connect(freezeProtectionStage0.y, compareFreProSig.uFreProStaRef) annotation (
     Line(points={{-59,90},{-50,90},{-50,102},{-42,102}}, color={255,85,85}));
  connect(uFreezeProtectionStatus, compareFreProSig.uFreProSta) annotation (
      Line(points={{-120,110},{-120,110},{-42,110}},color={255,85,85}));
  connect(compareFreProSig.y, not2.u) annotation (Line(points={{-19,110},{-10,110},
          {-2,110}}, color={255,0,255}));
  connect(not2.y, or2.u2) annotation (Line(points={{21,110},{30,110},{30,82},{38,
          82}}, color={255,0,255}));
  connect(hysTOut.y, or2.u1) annotation (Line(points={{-39,150},{30,150},{30,90},
          {34,90},{38,90}},         color={255,0,255}));
  connect(or2.y, assignDamPos.u2) annotation (Line(points={{61,90},{60,90},{60,10},
          {58,10}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,180}},
        initialScale=0.1), graphics={
        Rectangle(
          extent={{-100,-40},{100,160}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{2,124},{82,124}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-94,40},{-24,4}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uOutDamPosMin"),
        Text(
          extent={{-94,0},{-24,-36}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uOutDamPosMax"),
        Text(
          extent={{106,114},{176,78}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPosMax"),
        Text(
          extent={{-92,114},{-54,88}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSup"),
        Line(
          points={{-78,4},{2,4},{2,124}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-94,76},{-56,50}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uFre"),
        Text(
          extent={{-94,154},{-56,128}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOut")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-60},{100,180}},
        initialScale=0.1)),
    Documentation(info="<html>      
             <p>
             implementation fixme: 10 min delay
             - pg. 119 - Ret damper position when disabled: before releasing 
             the return air damper to be controled by the minimum air req 
             (EconDamPosLimits): open fully, wait 15 sec MaxOA-P = MinOA-P,
             wait 3 min after that and release ret dam for EconDamPosLimits
             control.
             </p>   
             <p>
             This sequence enables or disables the economizer based on 
             conditions provided in G36 PART5.N.7.           
  Fixme: There might be a need to convert this block in a generic enable-disable
  control block that receives one or more hysteresis conditions, one or more 
  timed conditions, and one or more additional boolean signal conditions. For 
  now, the block is implemented as economizer enable-disable control block, an
  atomic sequence which is a part in the economizer control composite sequence.
  </p>
  <p>
  The economizer enable-disable sequence implements conditions from 
  ASHRAE guidline 36 (G36) as listed on the state machine diagram below. The 
  sequence output is binary, it either sets the economizer damper position to
  its high (yOutDamPosMax) or to its low limit (yOutDamPosMin).
  </p>

<p>
Fixme: Edit conditions based on any additional stakeholder input, e.g. include
space averaged MAT sensor output.
</p>
<p>
Fixme - feature related issues: Delay placement - 10 min delay right before
this block's output should cover this condition, since listed in G36; 
test excluding hysteresis by simply setting the delta parameter to 0. 
Notes: Delay seems to replace hysteresis in practice, 
at least based on our current project partners input.
</p>

<p align=\"center\">
<img alt=\"Image of economizer enable-disable state machine chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconHighLimitLockout.png\"/>
</p>

</html>", revisions="<html>
<ul>
<li>
March 31, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconEnableDisable;
