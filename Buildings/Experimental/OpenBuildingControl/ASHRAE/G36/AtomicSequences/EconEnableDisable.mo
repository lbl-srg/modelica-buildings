within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconEnableDisable "Economizer enable/disable switch"
  //fixme: add return air damper position and delays, integrate single and multiple

  parameter Real uHigLimCutLow(min=273.15, max=273.15+76.85, unit="K", displayUnit="degC") = ((273.15+23.85) - 1) "An example high limit cutoff, 75degF (23.85degC) - hysteresis delta";
  parameter Real uHigLimCutHig(min=273.15, max=273.15+76.85, unit="K", displayUnit="degC") = (273.15+23.85) "An example high limit cutoff, 75degF (23.85degC)";

  CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-160,70},
            {-120,110}}),      iconTransformation(extent={{-160,70},{-120,110}})));
  CDL.Interfaces.RealOutput yOutDamPosMax(min=0, max=1)
    "Output sets maximum allowable economizer damper position. Fixme: Should this remain as type real? Output can take two values: disable = yOutDamPosMin and enable = yOutDamPosMax."
    annotation (Placement(transformation(extent={{120,-20},{158,18}}),
        iconTransformation(extent={{120,-20},{158,18}})));
  CDL.Interfaces.RealInput uOutDamPosMin(min=0, max=1)
    "Minimal economizer damper position, output from a separate sequence."
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
        iconTransformation(extent={{-160,-100},{-120,-60}})));
  CDL.Interfaces.RealInput uOutDamPosMax(min=0, max=1)
    "Maximum economizer damper position, either 100% or set to a constant value <100% at commisioning."
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
        iconTransformation(extent={{-160,-60},{-120,-20}})));
  CDL.Logical.Switch enableDisable
    "If any of the conditions provided by TOut and FreezeProtectionStatus inputs are violating the enable status, the max outdoor damper position is set to the minimum."
    annotation (Placement(transformation(extent={{82,-20},{102,0}})));
  CDL.Logical.Hysteresis hysTOut(final uLow=uHigLimCutLow, uHigh=uHigLimCutHig)
    "Close damper when TOut is above the uHigh, open it again only when TOut falls down to uLow [fixme this needs to allow for regional dissagregation - sometimes there is a need for enthalpy evaluation as well]"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  //fixme: units for instantiated limits, example TOut limit is 75K, delta = 1K

  CDL.Interfaces.IntegerInput uFreProSta
    "Freeze Protection Status signal, it can be an integer 0 - 3"
    annotation (Placement(transformation(extent={{-160,0},{-120,40}})));
  CDL.Logical.Nor nor
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  CDL.Logical.Greater gre
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  parameter Real k "Freeeze Protection Stage 0";
  CDL.Continuous.Constant freProtStage0(k=0)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
equation
  connect(TOut, hysTOut.u) annotation (Line(points={{-140,90},{-140,90},{-62,90}},
                 color={0,0,127}));
  connect(enableDisable.y, yOutDamPosMax) annotation (Line(points={{103,-10},{
          110,-10},{110,-1},{139,-1}}, color={0,0,127}));
  connect(uOutDamPosMax, enableDisable.u1) annotation (Line(points={{-140,-40},
          {-32,-40},{-32,-2},{80,-2}}, color={0,0,127}));
  connect(uOutDamPosMin, enableDisable.u3) annotation (Line(points={{-140,-80},
          {-32,-80},{-32,-18},{80,-18}}, color={0,0,127}));
  connect(hysTOut.y, nor.u1) annotation (Line(points={{-39,90},{-10,90},{-10,30},
          {18,30}}, color={255,0,255}));
  connect(intToRea.y, gre.u1)
    annotation (Line(points={{-79,20},{-60,20},{-42,20}}, color={0,0,127}));
  connect(nor.u2, gre.y) annotation (Line(points={{18,22},{0,22},{0,20},{-19,20}},
        color={255,0,255}));
  connect(freProtStage0.y, gre.u2) annotation (Line(points={{-79,-10},{-60,-10},
          {-60,12},{-42,12}}, color={0,0,127}));
  connect(uFreProSta, intToRea.u) annotation (Line(points={{-140,20},{-102,20},{
          -102,20}}, color={255,127,0}));
  connect(nor.y, enableDisable.u2) annotation (Line(points={{41,30},{60,30},{60,
          -10},{80,-10}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-120},{120,120}},
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
        extent={{-120,-120},{120,120}},
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
