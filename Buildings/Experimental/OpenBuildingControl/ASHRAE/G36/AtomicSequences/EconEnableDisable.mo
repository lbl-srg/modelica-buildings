within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block EconEnableDisable "Economizer enable/disable switch"
  //fixme: add return air damper position and delays, integrate single and multiple

  parameter Real uHigLimCutLow(min=273.15, max=273.15+76.85, unit="K", displayUnit="degC") = ((273.15+23.85) - 1) "An example high limit cutoff, 75degF (23.85degC) - hysteresis delta";
  parameter Real uHigLimCutHig(min=273.15, max=273.15+76.85, unit="K", displayUnit="degC") = (273.15+23.85) "An example high limit cutoff, 75degF (23.85degC)";
  parameter Boolean fixEnt = true
    "Set to true if there is an enthalpy sensor and the economizer uses fixed enthalpy + fixed dry bulb temperature sensors";

  CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-200,160},
            {-160,200}}),      iconTransformation(extent={{-160,80},{-120,120}})));
  CDL.Interfaces.RealInput uOutDamPosMin(min=0, max=1)
    "Minimal economizer damper position, as calculated in the EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
        iconTransformation(extent={{-160,-80},{-120,-40}})));
  CDL.Interfaces.RealInput uOutDamPosMax(min=0, max=1)
    "Maximum economizer damper position, fixme: connects to output of IO.Hardware.{Comissioning - physicalDamperPositionLimits} block"
    annotation (Placement(transformation(extent={{-200,-50},{-160,-10}}),
        iconTransformation(extent={{-160,-50},{-120,-10}})));
  CDL.Logical.Switch enableDisable
    "If any of the conditions provided by TOut and FreezeProtectionStatus inputs are violating the enable status, the max outdoor damper position is set to the minimum."
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  CDL.Logical.Hysteresis hysOutTem(final uLow=uTemHigLimCutLow, uHigh=
        uTemHigLimCutHig)
    "Close damper when TOut is above the uTemHigh, open it again only when TOut drops to uTemLow [fixme: I'm using the same offset for hysteresis regardless of the region and standard]"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  //fixme: units for instantiated limits, example TOut limit is 75K, delta = 1K

  CDL.Interfaces.IntegerInput uFreProSta = 0
    "Freeze Protection Status signal, it can be an integer 0 - 3"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
        iconTransformation(extent={{-160,0},{-120,40}})));
  CDL.Logical.Nor nor
    annotation (Placement(transformation(extent={{90,100},{110,120}})));
  CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  CDL.Logical.Greater gre
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  CDL.Continuous.Constant freProtStage0(k=0)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  CDL.Interfaces.RealInput hOut(unit="J/kg", displayUnit="J/kg")
    "Outdoor enthalpy" annotation (Placement(transformation(extent={{-200,100},{
            -160,140}}),
                    iconTransformation(extent={{-160,80},{-120,120}})));
  CDL.Logical.Hysteresis hysOutEnt(final uLow=uHigLimCutLow, uHigh=
        uHigLimCutHig)
    "Close damper when hOut is above the uEntHigh, open it again only when hOut drops to uEntLow [fixme: I'm using the same offset for hysteresis regardless of the region and standard]"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  CDL.Interfaces.RealInput uRetDamPosMax(min=0, max=1)
    "Maximum return air damper position as calculated in the EconDamperPositionLimitsMultiZone sequence"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
        iconTransformation(extent={{-160,-50},{-120,-10}})));
  CDL.Interfaces.RealInput uRetDamPhyPosMax(min=0, max=1)
    "Physical or at the comissioning fixed maximum opening of the return air damper. fixme: connects to output of IO.Hardware.{Comissioning - physicalDamperPositionLimits} block"
    annotation (Placement(transformation(extent={{-200,-150},{-160,-110}}),
        iconTransformation(extent={{-160,-50},{-120,-10}})));
  CDL.Interfaces.RealOutput yOutDamPosMax
    "Output sets maximum allowable economizer damper position. Fixme: Should this remain as type real? Output can take two values: disable = yOutDamPosMin and enable = yOutDamPosMax."
    annotation (Placement(transformation(extent={{160,-10},{180,10}}),
        iconTransformation(extent={{-172,-82},{-152,-62}})));
  CDL.Interfaces.RealOutput yRetDamPosMax
    "Output sets the return air damper position, which is affected for a short period of time upon disabling the economizer"
    annotation (Placement(transformation(extent={{160,-110},{180,-90}}),
        iconTransformation(extent={{-172,-82},{-152,-62}})));
  CDL.Logical.Composite.OnOffHold OnOffDelay(changeSignalOffset(displayUnit="min")=
         900) annotation (Placement(transformation(extent={{120,44},{140,64}})));
  CDL.Logical.GreaterEqual greEqu
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  CDL.Logical.GreaterEqual greEqu1
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  CDL.Logical.Timer timer
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  CDL.Logical.Timer timer1
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
  CDL.Logical.Constant fixedEnthalpy(k=fixEnt)
    "Set to true if there is an enthalpy sensor and the economizer uses fixed enthalpy + fixed dry bulb temperature sensors. Defaults to true, set to false if only the outdoor air dry bulb temperature sensor is implemented. [fixme: harmonize with issue #777]"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));

  CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  CDL.Interfaces.RealInput TOutCut(unit="K", displayUnit="degC")
    "Outdoor temperature high limit cutoff [fixme: see #777]" annotation (
      Placement(transformation(extent={{-200,130},{-160,170}}),
        iconTransformation(extent={{-160,80},{-120,120}})));
  CDL.Interfaces.RealInput hOutCut(unit="J/kg", displayUnit="J/kg")
    "Outdoor enthalpy high limit cutoff [fixme: see #777]" annotation (
      Placement(transformation(extent={{-200,70},{-160,110}}),
        iconTransformation(extent={{-160,80},{-120,120}})));
equation
  connect(uOutDamPosMax, enableDisable.u1) annotation (Line(points={{-180,-30},{
          -20,-30},{-20,8},{78,8}},   color={0,0,127}));
  connect(uOutDamPosMin, enableDisable.u3) annotation (Line(points={{-180,-60},{
          0,-60},{0,-8},{78,-8}},       color={0,0,127}));
  connect(intToRea.y, gre.u1)
    annotation (Line(points={{-79,40},{-79,40},{-42,40}}, color={0,0,127}));
  connect(nor.u2, gre.y) annotation (Line(points={{88,102},{0,102},{0,40},{-19,40}},
        color={255,0,255}));
  connect(freProtStage0.y, gre.u2) annotation (Line(points={{-79,10},{-60,10},{-60,
          32},{-42,32}},      color={0,0,127}));
  connect(uFreProSta, intToRea.u) annotation (Line(points={{-180,40},{-156,40},{
          -102,40}}, color={255,127,0}));
  connect(nor.y, enableDisable.u2) annotation (Line(points={{111,110},{120,110},
          {120,112},{130,112},{130,0},{78,0}},
                          color={255,0,255}));
  connect(TOut, hysOutTem.u) annotation (Line(points={{-180,180},{-152,180},{-82,
          180}},                                 color={0,0,127}));
  connect(enableDisable.y, yOutDamPosMax)
    annotation (Line(points={{101,0},{106,0},{170,0}}, color={0,0,127}));
  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-120,-120},{120,120}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-2,60},{78,60}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{132,54},{202,18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPosMax"),
        Line(
          points={{-82,-64},{-2,-64},{-2,60}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-36,160},{32,136}},
          lineColor={85,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-160,-160},{160,200}},
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
