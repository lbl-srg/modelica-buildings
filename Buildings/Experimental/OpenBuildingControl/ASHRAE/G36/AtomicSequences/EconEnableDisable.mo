within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconEnableDisable "Economizer enable/disable switch"

  parameter Real uHigLimCutLow(min=273.15, max=273.15+76.85, unit="K", displayUnit="degC") = ((273.15+23.85) - 1) "An example high limit cutoff, 75degF (23.85degC) - hysteresis delta";
  parameter Real uHigLimCutHig(min=273.15, max=273.15+76.85, unit="K", displayUnit="degC") = (273.15+23.85) "An example high limit cutoff, 75degF (23.85degC)";

  CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-140,
            120},{-100,160}}), iconTransformation(extent={{-140,120},{-100,160}})));
  CDL.Interfaces.RealOutput yOutDamPosMax(min=0, max=1)
    "Output sets maximum allowable economizer damper position. Fixme: Should this remain as type real? Output can take two values: disable = yOutDamPosMin and enable = yOutDamPosMax."
    annotation (Placement(transformation(extent={{100,40},{138,78}}),
        iconTransformation(extent={{100,40},{138,78}})));
  CDL.Interfaces.RealInput uOutDamPosMin(min=0, max=1)
    "Minimal economizer damper position, output from a separate sequence."
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealInput uOutDamPosMax(min=0, max=1)
    "Maximum economizer damper position, either 100% or set to a constant value <100% at commisioning."
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Logical.Switch assignDamPos
    "If any of the conditions provided by TOut and FreezeProtectionStatus inputs are violating the enable status, the max outdoor damper position is set to the minimum."
    annotation (Placement(transformation(extent={{62,10},{82,30}})));
  CDL.Logical.Hysteresis hysTOut(final uLow=uHigLimCutLow, uHigh=uHigLimCutHig)
    "Close damper when TOut is above the uHigh, open it again only when TOut falls down to uLow [fixme this needs to allow for regional dissagregation - sometimes there is a need for enthalpy evaluation as well]"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  //fixme: units for instantiated limits, example TOut limit is 75K, delta = 1K
  CDL.Interfaces.StatusTypeInput uFreezeProtectionStatus
    annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
  CDL.Logical.EqualStatus compareFreProSig
    "If the signal is other than Stage 0, disable the economizer"
    annotation (Placement(transformation(extent={{-52,90},{-32,110}})));
  CDL.Continuous.ConstantStatus freezeProtectionStage0(final refSta=CDL.Types.Status.FreezeProtectionStage0)
    "Reference freeze protection stage. If the input value is different from stage 0, the outdoor air damper should close."
    annotation (Placement(transformation(extent={{-94,64},{-74,84}})));
  CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{26,70},{46,90}})));
  CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{-18,90},{2,110}})));

equation
  connect(TOut, hysTOut.u) annotation (Line(points={{-120,140},{-114,140},{-62,
          140}}, color={0,0,127}));
  connect(assignDamPos.y, yOutDamPosMax) annotation (Line(points={{83,20},{83,
          20},{90,20},{90,60},{106,60},{106,59},{119,59}},
                                                       color={0,0,127}));
  connect(uOutDamPosMax, assignDamPos.u3) annotation (Line(points={{-120,0},{
          -30,0},{-30,12},{60,12}},
                              color={0,0,127}));
  connect(uOutDamPosMin, assignDamPos.u1) annotation (Line(points={{-120,40},{
          -30,40},{-30,28},{60,28}},
                                 color={0,0,127}));
  connect(uFreezeProtectionStatus, compareFreProSig.uFreProSta) annotation (
      Line(points={{-120,100},{-120,100},{-54,100}},color={255,85,85}));
  connect(compareFreProSig.y, not2.u) annotation (Line(points={{-31,100},{-20,
          100}},     color={255,0,255}));
  connect(not2.y, or2.u2) annotation (Line(points={{3,100},{8,100},{10,100},{10,
          72},{24,72}},
                color={255,0,255}));
  connect(hysTOut.y, or2.u1) annotation (Line(points={{-39,140},{16,140},{16,80},
          {24,80}},                 color={255,0,255}));
  connect(or2.y, assignDamPos.u2) annotation (Line(points={{47,80},{50,80},{52,
          80},{52,20},{60,20}},
                    color={255,0,255}));
  connect(freezeProtectionStage0.yFreProSta, compareFreProSig.uFreProStaRef)
    annotation (Line(points={{-73,74},{-62,74},{-62,92},{-54,92}}, color={255,
          85,85}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-20},{100,160}},
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
          extent={{-94,58},{-24,22}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uOutDamPosMin"),
        Text(
          extent={{-94,18},{-24,-18}},
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
        Line(
          points={{-78,4},{2,4},{2,124}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-94,106},{-76,94}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="uFre"),
        Text(
          extent={{-94,146},{-74,136}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOut"),
        Text(
          extent={{-32,190},{36,166}},
          lineColor={85,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-20},{100,160}},
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
