within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging;
package SetPoints
  "Package for boiler plant staging setpoint control sequences"

  package Subsequences "Boiler staging subsequences"

    block CapacityRequirement
      "Heating capacity requirement"

      parameter Real avePer(
        final unit="s",
        final displayUnit="s") = 300
        "Time period for the rolling average";

      Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
        final unit="K",
        final quantity="ThermodynamicTemperature")
        "Hot water supply temperature setpoint"
        annotation (Placement(transformation(extent={{-160,50},{-120,90}}),
          iconTransformation(extent={{-140,50},{-100,90}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
        final unit="K",
        final quantity="ThermodynamicTemperature")
        "Measured hot water return temperature"
        annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
          iconTransformation(extent={{-140,-20},{-100,20}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWat_flow(
        final quantity="VolumeFlowRate",
        final unit="m3/s")
        "Measured hot water flow rate"
        annotation (Placement(transformation(extent={{-160,-90},{-120,-50}}),
          iconTransformation(extent={{-140,-90},{-100,-50}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
        final quantity="Power",
        final unit="W")
        "Hot water heating capacity requirement"
        annotation (Placement(transformation(extent={{120,-20},{160,20}}),
          iconTransformation(extent={{100,-20},{140,20}})));

    protected
      constant Real rhoWat(
        final unit="kg/m3",
        final quantity="Density") = 1000
        "Water density";

      constant Real cpWat(
        final unit="J/(kg.K)",
        final quantity="SpecificHeatCapacity") = 4184
        "Specific heat capacity of water";

      Buildings.Controls.OBC.CDL.Continuous.Max max
        "Ensure negative heating requirement calculation is not passed downstream"
        annotation (Placement(transformation(extent={{90,-10},{110,10}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
        final k=0)
        "Lowest allowed heating requirement"
        annotation (Placement(transformation(extent={{60,24},{80,44}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant density(
        final k=rhoWat)
        "Water density"
        annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant speHeaCap(
        final k=cpWat)
        "Specific heat capacity of water"
        annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

      Buildings.Controls.OBC.CDL.Continuous.Add add2(
        final k1=1,
        final k2=-1)
        "Adder"
        annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

      Buildings.Controls.OBC.CDL.Continuous.MovingMean movMea(
        final delta=avePer)
        "Moving average"
        annotation (Placement(transformation(extent={{60,-16},{80,4}})));

      Buildings.Controls.OBC.CDL.Continuous.Product pro
        "Product"
        annotation (Placement(transformation(extent={{20,-16},{40,4}})));

      Buildings.Controls.OBC.CDL.Continuous.Product pro1
        "Product"
        annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

      Buildings.Controls.OBC.CDL.Continuous.Product pro2
        "Product"
        annotation (Placement(transformation(extent={{-20,-22},{0,-2}})));

    equation
      connect(TRet, add2.u2)
        annotation (Line(points={{-140,0},{-110,0},{-110,34},{-102,34}},
          color={0,0,127}));
      connect(add2.u1, TSupSet)
        annotation (Line(points={{-102,46},{-110,46},{-110,70},{-140,70}},
          color={0,0,127}));
      connect(add2.y, pro.u1)
        annotation (Line(points={{-78,40},{10,40},{10,0},{18,0}},
          color={0,0,127}));
      connect(pro.y, movMea.u)
        annotation (Line(points={{42,-6},{58,-6}},
          color={0,0,127}));
      connect(speHeaCap.y, pro1.u2)
        annotation (Line(points={{-78,-70},{-70,-70},{-70,-56},{-62,-56}},
          color={0,0,127}));
      connect(pro1.y, pro2.u2)
        annotation (Line(points={{-38,-50},{-30,-50},{-30,-18},{-22,-18}},
          color={0,0,127}));
      connect(pro.u2, pro2.y)
        annotation (Line(points={{18,-12},{2,-12}},
          color={0,0,127}));
      connect(pro1.u1, density.y)
        annotation (Line(points={{-62,-44},{-70,-44},{-70,-30},{-78,-30}},
          color={0,0,127}));
      connect(VHotWat_flow, pro2.u1)
        annotation (Line(points={{-140,-70},{-110,-70},{-110,-6},{-22,-6}},
          color={0,0,127}));
      connect(movMea.y, max.u2)
        annotation (Line(points={{82,-6},{88,-6}},
          color={0,0,127}));
      connect(con.y, max.u1)
        annotation (Line(points={{82,34},{86,34},{86,6},{88,6}},
          color={0,0,127}));
      connect(max.y, y)
        annotation (Line(points={{112,0},{140,0}},
          color={0,0,127}));

      annotation (defaultComponentName = "capReq",
        Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
          graphics={
            Rectangle(
              extent={{-100,-100},{100,100}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-120,146},{100,108}},
              lineColor={0,0,255},
              textString="%name"),
            Text(
              extent={{-62,88},{60,-76}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              textString="Load")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-100},{120,100}})),
        Documentation(info="<html>
      <p>
      Calculates heating capacity requirement based on the measured hot water return
      temperature, <code>TRet</code>, calculated hot water supply temperature
      setpoint <code>TSupSet</code>, and the measured hot water flow rate,
      <code>VHotWat_flow</code>.
      <br/> 
      The calculation is according to the draft dated March 23rd, 2020, section
      5.3.3.5 and 5.3.3.6.
      </p>
      <p align=\"center\">
      <img alt=\"Validation plot for CapacityRequirement\"
      src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/CapacityRequirement.png\"/>
      <br/>
      Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.CapacityRequirement\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.CapacityRequirement</a>.
      </p>
      </html>",
          revisions="<html>
      <ul>
      <li>
      May 19, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
    end CapacityRequirement;

    block EfficiencyCondition
      "Efficiency condition used in staging up and down"

      parameter Integer nSta = 5
        "Number of stages in the boiler plant";

      parameter Real perNonConBoi = 0.9
        "Percentage value of stage design capacity at which the efficiency condition
    is satisfied for non-condensing boilers";

      parameter Real perConBoi = 1.5
        "Percentage value of B-Stage minimum at which the efficiency condition is
    satisfied for condensing boilers";

      parameter Real sigDif = 0.1
        "Signal hysteresis deadband"
        annotation (Dialog(tab="Advanced"));

      parameter Real delayQReq(
        final unit="s",
        final displayUnit="s",
        final quantity="Time") = 600
        "Enable delay for heating requirement condition";

      Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uTyp[nSta]
        "Vector of boiler types for all stages"
        annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
          iconTransformation(extent={{-140,-80},{-100,-40}})));

      Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uAvaUp
        "Stage number of next available higher stage"
        annotation (Placement(transformation(extent={{-160,-160},{-120,-120}}),
          iconTransformation(extent={{-140,-110},{-100,-70}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealInput uQReq(
        final unit="W",
        final displayUnit="W",
        final quantity="Power")
        "Heating capacity required"
        annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
          iconTransformation(extent={{-140,70},{-100,110}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealInput uQDes(
        final unit="W",
        final displayUnit="W",
        final quantity="Power")
        "Design heating capacity of current stage"
        annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
          iconTransformation(extent={{-140,40},{-100,80}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealInput uQUpMin(
        final unit="W",
        final displayUnit="W",
        final quantity="Power")
        "Minimum capacity of the next available higher stage"
        annotation (Placement(transformation(extent={{-160,0},{-120,40}}),
          iconTransformation(extent={{-140,10},{-100,50}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotWatFloRat(
        final unit="m3/s",
        final displayUnit="m3/s",
        final quantity="VolumeFlowRate")
        "Measured hot-water flow-rate"
        annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
          iconTransformation(extent={{-140,-20},{-100,20}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealInput uUpMinFloSet(
        final unit="m3/s",
        final displayUnit="m3/s",
        final quantity="VolumeFlowRate")
        "Minimum flow setpoint for the next available higher stage"
        annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
          iconTransformation(extent={{-140,-50},{-100,-10}})));

      Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEffCon
        "Efficiency condition for boiler staging"
        annotation (Placement(transformation(extent={{120,-20},{160,20}}),
          iconTransformation(extent={{100,-20},{140,20}})));

    protected
      Buildings.Controls.OBC.CDL.Continuous.Division div
        "Divider to get relative value of required heating capacity"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

      Buildings.Controls.OBC.CDL.Continuous.Division div1
        "Divider to get relative value of required heating capacity"
        annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

      Buildings.Controls.OBC.CDL.Continuous.Division div2
        "Divider to get relative value of flow-rate"
        annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

      Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
        final uLow=-sigDif,
        final uHigh=0)
        "Hysteresis loop for flow-rate condition"
        annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

      Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
        final k=true)
        "Constant boolean source"
        annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

      Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
        final uLow=perNonConBoi - sigDif,
        final uHigh=perNonConBoi)
        "Hysteresis loop for heating capacity condition of non-condensing boilers"
        annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

      Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
        final uLow=perConBoi - sigDif,
        final uHigh=perConBoi)
        "Hysteresis loop for heating capacity condition of condensing boilers"
        annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

      Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
        final delayTime=delayQReq,
        final delayOnInit=true)
        "Enable delay"
        annotation (Placement(transformation(extent={{0,10},{20,30}})));

      Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
        final delayTime=delayQReq,
        final delayOnInit=true)
        "Enable delay"
        annotation (Placement(transformation(extent={{0,70},{20,90}})));

      Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nSta]
        "Convert integers in stage-type vector to real data-type"
        annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));

      Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
        final nin=nSta)
        "Pick out stage-type for next stage from vector"
        annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));

      Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
        final threshold=1)
        "Check for non-condensing boilers"
        annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));

      Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
        "Switch for heating capacity condition based on stage type"
        annotation (Placement(transformation(extent={{40,40},{60,60}})));

      Buildings.Controls.OBC.CDL.Logical.And and2
        "Logical And"
        annotation (Placement(transformation(extent={{80,-10},{100,10}})));

      Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi1
        "Switch for flow-rate condition"
        annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

      Buildings.Controls.OBC.CDL.Continuous.Add add1(
        final k2=-1)
        "Adder"
        annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

    equation
      connect(div.u2, uQUpMin)
        annotation (Line(points={{-82,14},{-110,14},{-110,20},{-140,20}},
          color={0,0,127}));
      connect(div1.u2, uQDes)
        annotation (Line(points={{-82,74},{-90,74},{-90,70},{-114,70},{-114,100},{-140,100}},
          color={0,0,127}));
      connect(add1.u1, uHotWatFloRat)
        annotation (Line(points={{-102,-34},{-110,-34},{-110,-20},{-140,-20}},
          color={0,0,127}));
      connect(add1.u2, uUpMinFloSet)
        annotation (Line(points={{-102,-46},{-110,-46},{-110,-60},{-140,-60}},
          color={0,0,127}));
      connect(add1.y, div2.u1)
        annotation (Line(points={{-78,-40},{-70,-40},{-70,-44},{-62,-44}},
          color={0,0,127}));
      connect(div2.u2, uUpMinFloSet)
        annotation (Line(points={{-62,-56},{-70,-56},{-70,-60},{-140,-60}},
          color={0,0,127}));
      connect(div2.y, hys.u)
        annotation (Line(points={{-38,-50},{-22,-50}},
          color={0,0,127}));
      connect(div1.y, hys1.u)
        annotation (Line(points={{-58,80},{-42,80}},
          color={0,0,127}));
      connect(div.y, hys2.u)
        annotation (Line(points={{-58,20},{-42,20}},
          color={0,0,127}));
      connect(truDel1.u, hys1.y)
        annotation (Line(points={{-2,80},{-18,80}},
          color={255,0,255}));
      connect(truDel.u, hys2.y)
        annotation (Line(points={{-2,20},{-18,20}},
          color={255,0,255}));
      connect(intToRea.u, uTyp)
        annotation (Line(points={{-102,-100},{-140,-100}},
          color={255,127,0}));
      connect(extIndSig.u, intToRea.y)
        annotation (Line(points={{-62,-100},{-78,-100}},
          color={0,0,127}));
      connect(extIndSig.index, uAvaUp)
        annotation (Line(points={{-50,-112},{-50,-140},{-140,-140}},
          color={255,127,0}));
      connect(greThr.u, extIndSig.y)
        annotation (Line(points={{-22,-100},{-38,-100}},
          color={0,0,127}));
      connect(greThr.y, logSwi.u2)
        annotation (Line(points={{2,-100},{30,-100},{30,50},{38,50}},
          color={255,0,255}));
      connect(truDel.y, logSwi.u3)
        annotation (Line(points={{22,20},{36,20},{36,42},{38,42}},
          color={255,0,255}));
      connect(truDel1.y, logSwi.u1)
        annotation (Line(points={{22,80},{36,80},{36,58},{38,58}},
          color={255,0,255}));
      connect(and2.y, yEffCon)
        annotation (Line(points={{102,0},{140,0}},
          color={255,0,255}));
      connect(logSwi.y, and2.u1)
        annotation (Line(points={{62,50},{70,50},{70,0},{78,0}},
          color={255,0,255}));
      connect(logSwi1.y, and2.u2)
        annotation (Line(points={{62,-30},{70,-30},{70,-8},{78,-8}},
          color={255,0,255}));
      connect(con1.y, logSwi1.u1)
        annotation (Line(points={{2,-10},{36,-10},{36,-22},{38,-22}},
          color={255,0,255}));
      connect(hys.y, logSwi1.u3)
        annotation (Line(points={{2,-50},{36,-50},{36,-38},{38,-38}},
          color={255,0,255}));
      connect(logSwi1.u2, greThr.y)
        annotation (Line(points={{38,-30},{30,-30},{30,-100},{2,-100}},
          color={255,0,255}));
      connect(div.u1, uQReq)
        annotation (Line(points={{-82,26},{-100,26},{-100,60},{-140,60}},
          color={0,0,127}));
      connect(div1.u1, uQReq)
        annotation (Line(points={{-82,86},{-100,86},{-100,60},{-140,60}},
          color={0,0,127}));

    annotation (
      defaultComponentName = "effCon",
      Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={Rectangle(
                    extent={{-100,-100},{100,100}},
                    lineColor={0,0,127},
                    fillColor={255,255,255},
                    fillPattern=FillPattern.Solid),
                  Text(
                    extent={{-120,146},{100,108}},
                    lineColor={0,0,255},
                    textString="%name")}),
      Diagram(
        coordinateSystem(
          preserveAspectRatio=false,
          extent={{-120,-160},{120,120}})),
      Documentation(
        info="<html>
    <p>
    Efficiency condition used in staging up and down for boiler plants with both
    condensing and non-condensing boilers. Implemented according to the
    specification provided in 5.3.3.10, 1711 March 2020 Draft.
    </p>
    <p align=\"center\">
    <img alt=\"State-machine chart for EfficiencyCondition\"
    src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/EfficiencyCondition_stateMachineChart_v2.png\"/>
    <br/>
    State-machine chart for the sequence defined in RP-1711
    </p>
    <p align=\"center\">
    <img alt=\"Validation plot for EfficiencyCondition1\"
    src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/EfficiencyCondition1.png\"/>
    <br/>
    Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.EfficiencyCondition\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.EfficiencyCondition</a> with the next higher stage type as condensing.
    </p>
    <p align=\"center\">
    <img alt=\"Validation plot for EfficiencyCondition2\"
    src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/EfficiencyCondition2.png\"/>
    <br/>
    Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.EfficiencyCondition\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.EfficiencyCondition</a> with the next higher stage type as non-condensing.
    </p>
    </html>",
        revisions="<html>
    <ul>
    <li>
    May 21, 2020, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
    end EfficiencyCondition;

    block FailsafeCondition
      "Failsafe condition used in staging up and down"

      parameter Real delayEna(
        final unit="s",
        final displayUnit="s",
        final quantity="Time") = 900
        "Enable delay";

      parameter Real TDif(
        final unit="K",
        final displayUnit="K",
        final quantity="TemperatureDifference") = 10
        "Required temperature difference between setpoint and measured temperature
    for failsafe condition";

      parameter Real TDifHys(
        final unit="K",
        final displayUnit="K",
        final quantity="TemperatureDifference") = 1
        "Temperature deadband for hysteresis loop"
        annotation (Dialog(tab="Advanced"));

      Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
        final unit="K",
        final displayUnit="K",
        final quantity="ThermodynamicTemperature")
        "Hot water supply temperature setpoint"
        annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
          iconTransformation(extent={{-140,30},{-100,70}})));

      Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
        final unit="K",
        final displayUnit="K",
        final quantity="ThermodynamicTemperature")
        "Measured hot water supply temperature"
        annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
          iconTransformation(extent={{-140,-70},{-100,-30}})));

      Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
        "Failsafe condition for chiller staging"
        annotation (Placement(transformation(extent={{100,-20},{140,20}}),
          iconTransformation(extent={{100,-20},{140,20}})));

      Buildings.Controls.OBC.CDL.Continuous.Add add2(
        final k2=-1,
        y(
        final unit="K",
        final displayUnit="K"))
        "Difference between setpoint and measured temperature"
        annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

    protected
      Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
        final uLow=TDif - TDifHys,
        final uHigh=TDif)
        "Hysteresis deadband to prevent cycling"
        annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

      Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(final delayTime=delayEna,
        final delayOnInit=true)
        "Enable delay"
        annotation (Placement(transformation(extent={{0,-10},{20,10}})));

    equation
      connect(add2.u2, TSup)
        annotation (Line(points={{-82,-6},{-90,-6},{-90,-50},{-120,-50}},
          color={0,0,127}));
      connect(add2.u1, TSupSet)
        annotation (Line(points={{-82,6},{-90,6},{-90,50},{-120,50}},
          color={0,0,127}));
      connect(add2.y, hys.u)
        annotation (Line(points={{-58,0},{-42,0}},
          color={0,0,127}));
      connect(hys.y, truDel.u)
        annotation (Line(points={{-18,0},{-2,0}},
          color={255,0,255}));
      connect(truDel.y, y)
        annotation (Line(points={{22,0},{120,0}},
          color={255,0,255}));

    annotation (defaultComponentName = "faiSafCon",
      Icon(coordinateSystem(extent={{-100,-80},{100,100}}),
        graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-120,146},{100,108}},
            lineColor={0,0,255},
            textString="%name")}),
      Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
      Documentation(info="<html>
    <p>Failsafe condition used in staging up and down, implemented according to
    the specification provided in section 5.3.3.10 1711 March 2020 Draft.
    </p>
    <p align=\"center\">
    <img alt=\"Validation plot for FailsafeCondition\"
    src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/FailsafeCondition.png\"/>
    <br/>
    Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.FailsafeCondition\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation.FailsafeCondition</a>.
    </p>
    </html>",
        revisions="<html>
    <ul>
    <li>
    May 21, 2020, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
    end FailsafeCondition;

    package Validation "Collection of validation models"
      block CapacityRequirement
        "Validation model for CapacityRequirement"

        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.CapacityRequirement
          capReq(final avePer=300)
          "Scenario with sine input for return temperature"
          annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.CapacityRequirement
          capReq1(final avePer=300)
          "Scenario with sine input for supply setpoint temperature"
          annotation (Placement(transformation(extent={{60,40},{80,60}})));

        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.CapacityRequirement
          capReq2(final avePer=300) "Scenario with sine input for flow-rate"
          annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.CapacityRequirement
          capReq3(final avePer=300) "Scenario with sine input for all inputs"
          annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

      protected
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
          final k=333.15)
          "Constant input"
          annotation (Placement(transformation(extent={{-90,70},{-70,90}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
          final amplitude=333.15 - 322.04,
          final freqHz=1/3600,
          final offset=322.04)
          "Sine input"
          annotation (Placement(transformation(extent={{-90,40},{-70,60}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
          final k=1)
          "Constant input"
          annotation (Placement(transformation(extent={{-90,10},{-70,30}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
          final k=322.04)
          "Constant input"
          annotation (Placement(transformation(extent={{10,40},{30,60}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin1(
          final amplitude=333.15 - 322.04,
          final freqHz=1/3600,
          final offset=333.15)
          "Sine input"
          annotation (Placement(transformation(extent={{10,70},{30,90}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
          final k=1)
          "Constant input"
          annotation (Placement(transformation(extent={{10,10},{30,30}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
          final k=333.15)
          "Constant input"
          annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin2(
          final amplitude=1,
          final freqHz=1/3600,
          final offset=1)
          "Sine input"
          annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5(
          final k=322.04)
          "Constant input"
          annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin3(
          final amplitude=333.15 - 322.04,
          final freqHz=2/3600,
          final offset=322.04)
          "Sine input"
          annotation (Placement(transformation(extent={{10,-60},{30,-40}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin4(
          final amplitude=333.15 - 322.04,
          final freqHz=1/3600,
          final offset=333.15)
          "Sine input"
          annotation (Placement(transformation(extent={{10,-30},{30,-10}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin5(
          final amplitude=1,
          final freqHz=3/3600,
          final offset=1)
          "Sine input"
          annotation (Placement(transformation(extent={{10,-90},{30,-70}})));

      equation
        connect(con.y, capReq.TSupSet)
          annotation (Line(points={{-68,80},{-50,80},{-50,57},{-42,57}},
            color={0,0,127}));
        connect(sin.y, capReq.TRet)
          annotation (Line(points={{-68,50},{-42,50}},
            color={0,0,127}));
        connect(con1.y, capReq.VHotWat_flow)
          annotation (Line(points={{-68,20},{-50,20},{-50,43},{-42,43}},
            color={0,0,127}));
        connect(con3.y, capReq1.VHotWat_flow)
          annotation (Line(points={{32,20},{50,20},{50,43},{58,43}},
            color={0,0,127}));
        connect(con4.y, capReq2.TSupSet)
          annotation (Line(points={{-68,-20},{-50,-20},{-50,-43},{-42,-43}},
            color={0,0,127}));
        connect(sin3.y, capReq3.TRet)
          annotation (Line(points={{32,-50},{58,-50}},
            color={0,0,127}));
        connect(con2.y, capReq1.TRet)
          annotation (Line(points={{32,50},{58,50}},
            color={0,0,127}));
        connect(sin1.y, capReq1.TSupSet)
          annotation (Line(points={{32,80},{50,80},{50,57},{58,57}},
            color={0,0,127}));
        connect(con5.y, capReq2.TRet)
          annotation (Line(points={{-68,-50},{-42,-50}},
            color={0,0,127}));
        connect(sin2.y, capReq2.VHotWat_flow)
          annotation (Line(points={{-68,-80},{-50,-80},{-50,-57},{-42,-57}},
            color={0,0,127}));
        connect(sin5.y, capReq3.VHotWat_flow)
          annotation (Line(points={{32,-80},{50,-80},{50,-57},{58,-57}},
            color={0,0,127}));
        connect(sin4.y, capReq3.TSupSet)
          annotation (Line(points={{32,-20},{50,-20},{50,-43},{58,-43}},
            color={0,0,127}));

        annotation(Icon(coordinateSystem(preserveAspectRatio=false),
          graphics={Ellipse(lineColor = {75,138,73},
                            fillColor={255,255,255},
                            fillPattern = FillPattern.Solid,
                            extent={{-100,-100},{100,100}}),
                    Polygon(lineColor = {0,0,255},
                            fillColor = {75,138,73},
                            pattern = LinePattern.None,
                            fillPattern = FillPattern.Solid,
                            points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
          Diagram(coordinateSystem(preserveAspectRatio=false)),
          __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Validation/CapacityRequirement.mos"
              "Simulate and plot"),
          experiment(
            StopTime=7200,
            Interval=1,
            Tolerance=1e-6),
          Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.CapacityRequirement\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.CapacityRequirement</a>.
      </p>
      </html>",       revisions="<html>
      <ul>
      <li>
      May 19, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
      end CapacityRequirement;

      block EfficiencyCondition
        "Validation model for EfficiencyCondition"

        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.EfficiencyCondition
          effCon(
          final nSta=1,
          final perNonConBoi=0.9,
          final perConBoi=1.5,
          final sigDif=0.1,
          final delayQReq=600)
          "Testing efficiency condition for condensing boiler stage type"
          annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.EfficiencyCondition
          effCon1(
          final nSta=1,
          final perNonConBoi=0.9,
          final perConBoi=1.5,
          final sigDif=0.1,
          final delayQReq=600)
          "Testing efficiency condition for non-condensing boiler stage type"
          annotation (Placement(transformation(extent={{110,-10},{130,10}})));

      protected
        Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul(
          final amplitude=1.2*0.1,
          final period=2.5*600,
          final offset=1.5 - 1.1*0.1)
          "Pulse source"
          annotation (Placement(transformation(extent={{-130,110},{-110,130}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul3(
          final amplitude=1.2*0.1,
          final period=5*600,
          final offset=1 - 1.1*0.1)
          "Pulse source"
          annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));

        Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntp[1](
          final k={1})
          "Constant source"
          annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
          final k=1)
          "Constant source"
          annotation (Placement(transformation(extent={{-130,70},{-110,90}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
          final k=1)
          "Constant source"
          annotation (Placement(transformation(extent={{-130,30},{-110,50}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul1(
          final amplitude=1.2*0.1,
          final period=2.5*600,
          final offset=0.9 - 1.1*0.1)
          "Pulse source"
          annotation (Placement(transformation(extent={{10,110},{30,130}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul2(
          final amplitude=1.2*0.1,
          final period=5*600,
          final offset=1 - 1.1*0.1)
          "Pulse source"
          annotation (Placement(transformation(extent={{10,-10},{30,10}})));

        Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntp1[1](
          final k={2})
          "Constant source"
          annotation (Placement(transformation(extent={{10,-90},{30,-70}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
          final k=1)
          "Constant source"
          annotation (Placement(transformation(extent={{10,70},{30,90}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
          final k=1)
          "Constant source"
          annotation (Placement(transformation(extent={{10,30},{30,50}})));

        Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
          final k=1)
          "Constant source"
          annotation (Placement(transformation(extent={{-130,-130},{-110,-110}})));

        Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
          final k=1)
          "Constant source"
          annotation (Placement(transformation(extent={{10,-130},{30,-110}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
          final k=1)
          "Constant source"
          annotation (Placement(transformation(extent={{-130,-50},{-110,-30}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con5(
          final k=1)
          "Constant source"
          annotation (Placement(transformation(extent={{10,-50},{30,-30}})));

      equation
        connect(conIntp.y, effCon.uTyp)
          annotation (Line(points={{-108,-80},{-50,-80},{-50,-6},{-32,-6}},
            color={255,127,0}));
        connect(pul3.y, effCon.uHotWatFloRat)
          annotation (Line(points={{-108,0},{-32,0}},
            color={0,0,127}));
        connect(pul.y, effCon.uQReq)
          annotation (Line(points={{-108,120},{-40,120},{-40,9},{-32,9}},
            color={0,0,127}));
        connect(con.y, effCon.uQDes)
          annotation (Line(points={{-108,80},{-50,80},{-50,6},{-32,6}},
            color={0,0,127}));
        connect(con1.y, effCon.uQUpMin)
          annotation (Line(points={{-108,40},{-60,40},{-60,3},{-32,3}},
            color={0,0,127}));
        connect(conIntp1.y, effCon1.uTyp)
          annotation (Line(points={{32,-80},{90,-80},{90,-6},{108,-6}},
            color={255,127,0}));
        connect(pul2.y, effCon1.uHotWatFloRat)
          annotation (Line(points={{32,0},{108,0}},
            color={0,0,127}));
        connect(pul1.y, effCon1.uQReq)
          annotation (Line(points={{32,120},{100,120},{100,9},{108,9}},
            color={0,0,127}));
        connect(con2.y, effCon1.uQDes)
          annotation (Line(points={{32,80},{90,80},{90,6},{108,6}},
            color={0,0,127}));
        connect(con3.y, effCon1.uQUpMin)
          annotation (Line(points={{32,40},{80,40},{80,3},{108,3}},
            color={0,0,127}));
        connect(conInt.y, effCon.uAvaUp)
          annotation (Line(points={{-108,-120},{-40,-120},{-40,-9},{-32,-9}},
            color={255,127,0}));
        connect(conInt1.y, effCon1.uAvaUp)
          annotation (Line(points={{32,-120},{100,-120},{100,-9},{108,-9}},
            color={255,127,0}));
        connect(con4.y, effCon.uUpMinFloSet)
          annotation (Line(points={{-108,-40},{-60,-40},{-60,-3},{-32,-3}},
            color={0,0,127}));
        connect(con5.y, effCon1.uUpMinFloSet)
          annotation (Line(points={{32,-40},{80,-40},{80,-3},{108,-3}},
            color={0,0,127}));

        annotation(Icon(coordinateSystem(preserveAspectRatio=false,
                                         extent={{-100,-100},{100,100}}),
                   graphics={Ellipse(lineColor = {75,138,73},
                                     fillColor={255,255,255},
                                     fillPattern = FillPattern.Solid,
                                     extent={{-100,-100},{100,100}}),
                             Polygon(lineColor = {0,0,255},
                                     fillColor = {75,138,73},
                                     pattern = LinePattern.None,
                                     fillPattern = FillPattern.Solid,
                                     points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
          Diagram(coordinateSystem(preserveAspectRatio=false,
                                   extent={{-140,-140},{140,140}})),
          experiment(
            StopTime=7200,
            Interval=1,
            Tolerance=1e-6),
          __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Validation/EfficiencyCondition.mos"
            "Simulate and plot"),
          Documentation(info="<html>
      <p>This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.EfficiencyCondition\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.EfficiencyCondition</a>
      </p>
      </html>"));
      end EfficiencyCondition;

      block FailsafeCondition
        "Validation model for FailsafeCondition"

        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
          faiSafCon(
          final delayEna=900,
          final TDif=10,
          final TDifHys=1) "Testing scenario with FailsafeCondition unmet"
          annotation (Placement(transformation(extent={{-40,42},{-20,60}})));

        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
          faiSafCon1(
          final delayEna=900,
          final TDif=10,
          final TDifHys=1) "Testing scenario with FailsafeCondition met"
          annotation (Placement(transformation(extent={{60,42},{80,60}})));

        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
          faiSafCon2(
          final delayEna=900,
          final TDif=10,
          final TDifHys=1)
          "Testing scenario exhibiting lower limit of hysteresis loop in sequence being unmet"
          annotation (Placement(transformation(extent={{-40,-58},{-20,-40}})));

        Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
          faiSafCon3(
          final delayEna=900,
          final TDif=10,
          final TDifHys=1)
          "Testing scenario exhibitng lower limit of hysteresis loop in sequence being met"
          annotation (Placement(transformation(extent={{60,-58},{80,-40}})));

      protected
        Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul(
          final amplitude=-10 + 1,
          final period=2.5*900,
          final offset=80)
          "Pulse input"
          annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul1(
          final amplitude=-10 - 1,
          final period=2.5*900,
          final offset=80)
          "Pulse input"
          annotation (Placement(transformation(extent={{20,20},{40,40}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul2(
          final amplitude=-1,
          final period=2.5*900,
          final offset=80 - 10)
          "Pulse input"
          annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul3(
          final amplitude=-2*1 - 1/10,
          final period=2.5*900,
          final offset=80 - 10 + 1 + 1/10)
          "Pulse input"
          annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
          final k=80)
          "Constant input"
          annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
          final k=80)
          "Constant input"
          annotation (Placement(transformation(extent={{20,60},{40,80}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
          final k=80)
          "Constant input"
          annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
          final k=80)
          "Constant input"
          annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

      equation
        connect(con.y, faiSafCon.TSupSet)
          annotation (Line(points={{-58,70},{-50,70},{-50,55},{-42,55}},
            color={0,0,127}));
        connect(pul.y, faiSafCon.TSup)
          annotation (Line(points={{-58,30},{-50,30},{-50,45},{-42,45}},
            color={0,0,127}));
        connect(con1.y, faiSafCon1.TSupSet)
          annotation (Line(points={{42,70},{50,70},{50,55},{58,55}},
            color={0,0,127}));
        connect(pul1.y, faiSafCon1.TSup)
          annotation (Line(points={{42,30},{50,30},{50,45},{58,45}},
            color={0,0,127}));
        connect(con2.y,faiSafCon2.TSupSet)
          annotation (Line(points={{-58,-30},{-50,-30},{-50,-45},{-42,-45}},
            color={0,0,127}));
        connect(pul2.y,faiSafCon2.TSup)
          annotation (Line(points={{-58,-70},{-50,-70},{-50,-55},{-42,-55}},
            color={0,0,127}));
        connect(con3.y,faiSafCon3.TSupSet)
          annotation (Line(points={{42,-30},{50,-30},{50,-45},{58,-45}},
            color={0,0,127}));
        connect(pul3.y,faiSafCon3.TSup)
          annotation (Line(points={{42,-70},{50,-70},{50,-55},{58,-55}},
            color={0,0,127}));

        annotation (
          Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Ellipse(lineColor = {75,138,73},
                      fillColor={255,255,255},
                      fillPattern = FillPattern.Solid,
                      extent={{-100,-100},{100,100}}),
              Polygon(lineColor = {0,0,255},
                      fillColor = {75,138,73},
                      pattern = LinePattern.None,
                      fillPattern = FillPattern.Solid,
                      points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
          Diagram(coordinateSystem(preserveAspectRatio=false)),
          experiment(
            StopTime=7200,
            Interval=1,
            Tolerance=1e-6),
          Documentation(info="<html>
      <p>This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition</a>
      </p>
      </html>"),
          __Dymola_Commands(file=
             "./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Validation/FailsafeCondition.mos"
             "Simulate and plot"));
      end FailsafeCondition;
    annotation (Icon(graphics={
            Rectangle(
              lineColor={200,200,200},
              fillColor={248,248,248},
              fillPattern=FillPattern.HorizontalCylinder,
              extent={{-100,-100},{100,100}},
              radius=25.0),
            Rectangle(
              lineColor={128,128,128},
              extent={{-100,-100},{100,100}},
              radius=25.0),
            Polygon(
              origin={8,14},
              lineColor={78,138,73},
              fillColor={78,138,73},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}),
              Documentation(info="<html>
          <p>
          This package contains validation models for the classes in
          <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences\">
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences</a>.
          </p>
          <p>
          Note that most validation models contain simple input data
          which may not be realistic, but for which the correct
          output can be obtained through an analytic solution.
          The examples plot various outputs, which have been verified against these
          solutions. These model outputs are stored as reference data and
          used for continuous validation whenever models in the library change.
          </p>
          </html>"));
    end Validation;
    annotation (Icon(graphics={
          Rectangle(
            lineColor={200,200,200},
            fillColor={248,248,248},
            fillPattern=FillPattern.HorizontalCylinder,
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Rectangle(
            lineColor={128,128,128},
            extent={{-100,-100},{100,100}},
            radius=25.0),
          Ellipse(
            origin={10,10},
            fillColor={76,76,76},
            pattern=LinePattern.None,
            fillPattern=FillPattern.Solid,
            extent={{-80.0,-80.0},{-20.0,-20.0}}),
          Ellipse(
            origin={10,10},
            pattern=LinePattern.None,
            fillPattern=FillPattern.Solid,
            extent={{0.0,-80.0},{60.0,-20.0}}),
          Ellipse(
            origin={10,10},
            fillColor={128,128,128},
            pattern=LinePattern.None,
            fillPattern=FillPattern.Solid,
            extent={{0.0,0.0},{60.0,60.0}}),
          Ellipse(
            origin={10,10},
            lineColor={128,128,128},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            extent={{-80.0,0.0},{-20.0,60.0}})}),
          Documentation(info="<html>
          <p>
          This package contains subsequences used in boiler staging control.
          </p>
          </html>"));
  end Subsequences;
  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Text(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          textString="S")}),
    Documentation(info="<html>
    <p>
    This package contains boiler stage setpoint control sequences. The implementation
    is based on section 5.3.3 in ASHRAE RP-1711, Draft on March 23, 2020. </p>
</html>"));
end SetPoints;
